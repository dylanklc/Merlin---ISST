<?php

define('ENV_STAGING', '_staging');
define('ENV_RUNNING', '');

class object_indexer
{
    private $idx = array();
    private $ridx = array();

    public function set($type, $name, $id)
    {
        if (!is_numeric($id)) {
            die("\$id not numeric in object_indexer::set\n");
        }
        $id = intval($id);

        if (!isset($this->idx[$type])) {
            $this->idx[$type] = array();
            $this->ridx[$type] = array();
        }

        if (isset($this->ridx[$type][$id]) && $this->ridx[$type][$id] !== $name)
            die("Duplicate \$id in object_indexer::set\n");

        if (isset($this->idx[$type][$name]) && $this->idx[$type][$name] !== $id) {
            print_r($this->idx);
            die("Attempted to change id of $type object '$name' to $id\n");
         }

        $this->ridx[$type][$id] = $name;
        $this->idx[$type][$name] = $id;
        return true;
    }

    public function get($type, $name, $must_exist = false)
    {
        if (!isset($this->idx[$type]) || !isset($this->idx[$type][$name])) {
            if ($must_exist)
                die("Failed to locate a $type object named '$name'\n");

            return false;
        }

        return $this->idx[$type][$name];
    }
}

class nagios_object_importer
{
    public $instance_id = 0;

    public $db_type = 'mysql';
    public $db_host = 'localhost';
    public $db_user = 'merlin';
    public $db_pass = 'merlin';
    public $db_database = 'merlin';
    public $env = ENV_STAGING;
    protected $db = false;

    public $errors = 0;

    public $DEBUG = false;

    # internal object indexing cache
    private $idx; # object_indexer object
    private $base_oid = array();
    private $imported = array();

    # denotes if we're importing status.sav or objects.cache
    private $importing_status = false;

    private $staging_tables = array(
        'command', 'contact_contactgroup', 'contact', 'contactgroup', 
        'custom_vars', 'host_contact', 'host_contactgroup', 'host_hostgroup', 
        'host_parents', 'host', 'hostdependency', 'hostescalation_contact', 
        'hostescalation_contactgroup', 'hostescalation', 'hostgroup', 
        'service_contact', 'service_contactgroup', 'service_servicegroup', 
        'service', 'servicedependency', 'serviceescalation_contact', 
        'serviceescalation_contactgroup', 'serviceescalation', 'servicegroup', 
        'timeperiod_exclude', 'timeperiod'
    );

    private $tables_truncated = false;
    private $tables_to_truncate = array
        ('command',
         'contact',
         'contact_contactgroup',
         'contactgroup',
         'host_contact',
         'host_contactgroup',
         'host_hostgroup',
         'host_parents',
         'hostdependency',
         'hostescalation',
         'hostescalation_contact',
         'hostescalation_contactgroup',
         'hostgroup',
         'service_contact',
         'service_contactgroup',
         'service_servicegroup',
         'servicedependency',
         'serviceescalation',
         'serviceescalation_contact',
         'serviceescalation_contactgroup',
         'servicegroup',
         'timeperiod',
         'timeperiod_exclude',
         'custom_vars',
         );

    # conversion table for variable names
    private $convert = array();
    private $conv_type = array
        ('info' => false, 'program' => 'program_status',
         'programstatus' => 'program_status',
         'hoststatus' => 'host', 'servicestatus' => 'service',
         'contactstatus' => 'contact',
         'hostcomment' => 'comment', 'servicecomment' => 'comment',
         'hostdowntime' => 'scheduled_downtime', 
         'servicedowntime' => 'scheduled_downtime');

    # allowed variables for each object
    private $allowed_vars = array();

    # object relations table used to determine db junction table names etc
    protected $Object_Relation = array();

    public function __construct()
    {
        $this->obj_rel['host'] =
            array('parents' => 'host',
                  'contacts' => 'contact',
                  'contact_groups' => 'contactgroup'
                  );

        $this->obj_rel['hostgroup'] =
            array('members' => 'host');

        $this->obj_rel['service'] =
            array('contacts' => 'contact',
                  'contact_groups' => 'contactgroup',
                  );

        $this->obj_rel['contactgroup'] =
            array('members' => 'contact');

        $this->obj_rel['serviceescalation'] =
            array('contacts' => 'contact',
                  'contact_groups' => 'contactgroup',
                  );

        $this->obj_rel['servicegroup'] =
            array('members' => 'service');

        $this->obj_rel['hostdependency'] =
            array('host_name' => 'host',
                  'dependent_host_name' => 'host',
                  );

        $this->obj_rel['hostescalation'] =
            array('host_name' => 'host',
                  'contact_groups' => 'contactgroup',
                  'contacts' => 'contact',
                  'contact_groups' => 'contactgroup',
                  );

        $this->obj_rel['timeperiod'] =
            array('exclude' => 'timeperiod');
        $this->convert['host'] = array(
            'state_history' => false,
            'normal_check_interval' => 'check_interval',
            'retry_check_interval' => 'retry_interval',
            'modified_host_attributes' => false,
            'modified_service_attributes' => false,
            'modified_attributes' => false,
        );

        $this->convert['service'] = $this->convert['host'];
        $this->convert['contact'] = $this->convert['host'];

        $this->staging_regex = join('|', $this->staging_tables);

    }

    private function get_junction_table_name($obj_type, $v_name)
    {
        $ref_obj_type = $this->obj_rel[$obj_type][$v_name];
        $ret = $obj_type . '_' . $ref_obj_type;

        if($v_name === 'members')
            $ret = $ref_obj_type . '_' . $obj_type;
        elseif($ref_obj_type === $obj_type)
            $ret = $obj_type . '_' . $v_name;

        return $ret;
    }

    private function post_mangle_groups($group, &$obj_list)
    {
        if (empty($obj_list))
            return;

        $ref_type = str_replace('group', '', $group);

        foreach ($obj_list as $obj_key => &$obj) {
            if (!isset($obj['members']))
                continue;

            $ary = split("[\t ]*,[\t ]*", $obj['members']);
            $v_ary = array(); # reset between each loop
            if ($group === 'servicegroup') {
                while ($srv = array_pop($ary)) {
                    $host = array_pop($ary);
                    $v_ary[] = $this->idx->get('service', "$host;$srv");
                }
            }
            else foreach ($ary as $mname) {
                $v_ary[] = $this->idx->get($ref_type, $mname);
            }
            $obj['members'] = $v_ary;
            $this->glue_object($obj_key, $group, $obj);
        }
    }

    private function post_mangle_self_ref($obj_type, &$obj_list)
    {
        if (empty($obj_list))
            return false;

        if ($obj_type === 'host')
            $k = 'parents';
        else
            $k = 'exclude';

        foreach ($obj_list as $id => &$obj) {
            if (!isset($obj[$k]))
                continue;
            $ary = split("[\t ]*,[\t ]*", $obj[$k]);
            $obj[$k] = array();
            foreach ($ary as $v)
                $obj[$k][] = $this->idx->get($obj_type, $v);
        }
    }

    private function post_mangle_service_slave($obj_type, &$obj)
    {
        $srv = $obj['host_name'] . ';' . $obj['service_description'];
        $obj['service'] = $this->idx->get('service', $srv);
        unset($obj['host_name']);
        unset($obj['service_description']);

        if ($obj_type === 'servicedependency') {
            $srv = $obj['dependent_host_name'] . ';' . $obj['dependent_service_description'];
            $obj['dependent_service'] = $this->idx->get('service', $srv);
            unset($obj['dependent_host_name']);
            unset($obj['dependent_service_description']);
        }
    }

    /**
     * Invoked when we encounter a new type of object in objects.cache
     * Since objects are grouped by type in that file, this means we're
     * done entirely parsing the type of objects passed in $obj_type
     */
    private function done_parsing_obj_type_objects($obj_type, &$obj_array)
    {
        if ($obj_type === false || empty($obj_array))
            return true;

        switch ($obj_type) {
         case 'host': case 'timeperiod':
            $this->post_mangle_self_ref($obj_type, $obj_array[$obj_type]);
            $this->glue_objects($obj_array[$obj_type], $obj_type);
            unset($obj_array[$obj_type]);
            # fallthrough, although no-op for timeperiods
         case 'service': case 'contact':
            $group = $obj_type . 'group';
            if (isset($obj_array[$group])) {
                $this->post_mangle_groups($group, $obj_array[$group]);
                unset($obj_array[$group]);
            }
            break;
        }

        return true;
    }

    public function prepare_import()
    {
        # preload object indexes only once per import run
        $this->preload_object_index('host', 'SELECT id, host_name FROM host');
        $this->preload_object_index('service', "SELECT id, CONCAT(host_name, ';', service_description) FROM service");
    }

    public function finalize_import()
    {
        $this->purge_old_objects();
        $this->cache_access_rights();
    }

    private function get_contactgroup_members()
    {
        $result = $this->sql_exec_query
            ("SELECT contact, contactgroup from contact_contactgroup");

        $cg_members = array();
        while ($row = $this->sql_fetch_row($result)) {
            $cg_members[$row[1]][$row[0]] = $row[0];
        }

        return $cg_members;
    }

    private function cache_cg_object_access_rights($cg_members, $otype)
    {
        $query = "SELECT $otype, contactgroup FROM {$otype}_contactgroup";
        $result = $this->sql_exec_query($query);
        $ret = array();
        while ($row = $this->sql_fetch_row($result)) {
            if (empty($cg_members[$row[1]])) {
                echo "Un-cached contactgroup $row[1] assigned to $otype $row[0]\n";
                exit(1);
            }
            $ret[$row[0]] = $cg_members[$row[1]];
        }
        return $ret;
    }

    private function cache_contact_object_access_rights($otype, &$ret)
    {
        $query = "SELECT $otype, contact FROM {$otype}_contact";
        $result = $this->sql_exec_query($query);
        while ($row = $this->sql_fetch_row($result)) {
            $ret[$row[0]][$row[1]] = $row[1];
        }
        return $ret;
    }

    private function write_access_cache($obj_list, $otype)
    {
        foreach ($obj_list as $id => $ary) {
            foreach ($ary as $cid) {
                $query = "INSERT INTO contact_access(contact, $otype) " .
                    "VALUES($cid, $id)";
                $this->sql_exec_query($query);
            }
        }
    }

    public function cache_access_rights()
    {
        $this->sql_exec_query("TRUNCATE contact_access");
        $cg_members = $this->get_contactgroup_members();
        $ary['host'] = $this->cache_cg_object_access_rights($cg_members, 'host');
        $ary['service'] = $this->cache_cg_object_access_rights($cg_members, 'service');
        $this->cache_contact_object_access_rights('host', $ary['host']);
        $this->cache_contact_object_access_rights('service', $ary['service']);
        $this->write_access_cache($ary['host'], 'host');
        $this->write_access_cache($ary['service'], 'service');
    }

    private function preload_object_index($obj_type, $query)
    {
        $this->idx = new object_indexer;
        $result = $this->sql_exec_query($query);
        $idx_max = 1;
        while ($row = $this->sql_fetch_row($result)) {
            if ($this->DEBUG) {
                print "$obj_type name is $row[1]\n";
                if ($row[1] == '') {
                    print_r($row);
                }
            }
            $this->idx->set($obj_type, $row[1], $row[0]);
            if ($row[0] >= $idx_max)
                $idx_max = $row[0] + 1;
        }
        $this->base_oid[$obj_type] = $idx_max;
    }

    private function purge_old_objects()
    {
        foreach ($this->imported as $obj_type => $ids) {
            $query = "DELETE FROM $obj_type WHERE id NOT IN (";
            $query .= join(', ', array_keys($ids)) . ')';
            $result = $this->sql_exec_query($query);
        }
    }

    private function is_allowed_var($obj_type, $k)
    {
        if (!$this->importing_status)
            return true;

        if ($obj_type === 'info')
            return false;

        if (!isset($this->allowed_vars[$obj_type])) {
            $result = $this->sql_exec_query("describe $obj_type");
            if (!$result)
                return false;

            while ($row = $this->sql_fetch_row($result)) {
                $this->allowed_vars[$obj_type][$row[0]] = $row[0];
            }
        }

        return isset($this->allowed_vars[$obj_type][$k]);
    }

    private function mangle_var_name($obj_type, $k)
    {
        if (!$this->importing_status) {
            return $k;
        }

        if ($this->DEBUG) {
            // print "Mangling $obj_type $k\n";
        }

        if (empty($k)) {
            echo("Found empty \$k with obj_type $obj_type\n");
            echo var_dump($k);
            exit(1);
        }

        if (isset($this->convert[$obj_type][$k])) {
            if ($this->DEBUG) {
                // print "Mangle $obj_type $k to {$this->convert[$obj_type][$k]}\n";
            }
            return $this->convert[$obj_type][$k];
        }

        if ($obj_type === 'host') {
            if ($k === 'vrml_image' || $k === '3d_coords')
                return false;
        } elseif ($obj_type === 'program_status') {
            if (substr($k, 0, strlen('enable_')) === 'enable_') {
                return substr($k, strlen('enable_')) . '_enabled';
            }
            switch ($k) {
             case 'normal_check_interval': case 'next_comment_id':
             case 'next_downtime_id': case 'next_event_id':
             case 'next_problem_id': case 'next_notification_id':
                return false;
                break;
            }
        } 
        return $k;
    }

    // pull all objects from objects.cache
    function import_objects_from_cache($object_cache = false)
    {
        $last_obj_type = false;
        $obj_type = false;

        if (!$object_cache)
            $object_cache = '/opt/monitor/var/objects.cache';

        # if we're about to import a status log file, we'll
        # wipe the recently imported objects in case we truncate
        # the tables again, so avoid it if we've already done it once
        if (!$this->tables_truncated) {
            foreach($this->tables_to_truncate as $table)
                $this->sql_exec_query("TRUNCATE $table");
            $this->tables_truncated = true;
        }

        # service slave objects are handled separately
        $service_slaves =
            array('serviceescalation' => 1,
                  'servicedependency' => 1);

        if (!file_exists($object_cache))
            return false;
        else
            $fh = fopen($object_cache, "r");

        if (!$fh)
            return false;

        # fetch 'real' timeperiod variables so we can exclude all
        # others as custom variables
        $result = $this->sql_exec_query('describe timeperiod');
        $tp_vars = array();
        while ($ary = $this->sql_fetch_array($result)) {
            $tp_vars[$ary['Field']] = $ary['Field'];
        }
        unset($result);

        while (!feof($fh)) {
            $line = trim(fgets($fh));

            if (empty($line) || $line{0} === '#')
                continue;

            if (!$obj_type) {
                $obj = array();
                $str = explode(' ', $line, 3);
                if ($str[0] === 'define') {
                    $obj_type = $str[1];
                } else {
                    $obj_type = $str[0];
                }

                if ($obj_type === 'info' || $obj_type === 'program') {
                    $this->importing_status = true;
                }

                if (!empty($this->conv_type[$obj_type])) {
                    $obj_type = $this->conv_type[$obj_type];
                }

                # get rid of objects as early as we can
                if ($obj_type !== $last_obj_type) {
                    if (isset($this->obj_rel[$obj_type]))
                        $relation = $this->obj_rel[$obj_type];
                    else
                        $relation = false;

                    $this->done_parsing_obj_type_objects($last_obj_type, $obj_array);
                    $last_obj_type = $obj_type;
                }
                $obj = array();
                continue;
            }

            // we're inside an object now, so check for closure and tag if so
            $str = preg_split("/[\t=]/", $line, 2);

            // end of object? check type and populate index table
            if ($str[0] === '}') {
                $obj_name = $this->obj_name($obj_type, $obj);
                $obj_key = $this->idx->get($obj_type, $obj_name);
                if (!$obj_key) {
                    $obj_key = 1;
                    if (!isset($this->base_oid[$obj_type])) {
                        $this->base_oid[$obj_type] = 1;
                    }
                    $obj_key = $this->base_oid[$obj_type]++;
                    $obj['is a fresh one'] = true;
                    if ($obj_name) {
                        if ($this->DEBUG) {
                            print "Just parsed $obj_name of type $obj_type\n";
                        }
                        $this->idx->set($obj_type, $obj_name, $obj_key);
                    }
                }

                switch ($obj_type) {
                 case 'host': case 'program_status':
                    if (!isset($obj['parents']))
                        $this->glue_object($obj_key, $obj_type, $obj);
                    break;
                 case 'timeperiod':
                    if (!isset($obj['exclude']))
                        $this->glue_object($obj_key, 'timeperiod', $obj);
                    break;
                 case 'hostgroup': case 'servicegroup': case 'contactgroup':
                    break;
                 default:
                    if (isset($service_slaves[$obj_type]))
                        $this->post_mangle_service_slave($obj_type, $obj);

                    $this->glue_object($obj_key, $obj_type, $obj);
                }
                if ($obj)
                    $obj_array[$obj_type][$obj_key] = $obj;

                $obj_type = $obj_name = false;
                $obj_key++;
                continue;
            }

            $k = $this->mangle_var_name($obj_type, $str[0]);
            if (!$k || !$this->is_allowed_var($obj_type, $k))
                continue;

            # if the variable is set without a value, it means
            # "remove whatever is set in the template", so we
            # do just that. Nagios really shouldn't write these
            # parameters to the objects.cache file, but we need
            # to handle it just the same.
            if (!isset($str[1])) {
                unset($obj[$k]);
                continue;
            }
            $v = $str[1];

            switch ($k) {
             case 'members': case 'parents': case 'exclude':
                $obj[$k] = $v;
                continue;
             case 'contacts': case 'contact_groups':
                $ary = split("[\t ]*,[\t ]*", $v);
                foreach ($ary as $v) {
                    $target_id = $this->idx->get($relation[$k], $v);
                    $v_ary[$target_id] = $target_id;
                }
                $obj[$k] = $v_ary;
                unset($ary); unset($v_ary);
                continue;
             default:
                if ($k{0} === '_' ||
                    ($obj_type === 'timeperiod' && !isset($tp_vars[$k])))
                {
                    $obj['__custom'][$k] = $v;
                    continue;
                }
                if (isset($relation[$k])) {
                    # handle commands specially
                    if ($relation[$k] === 'command' && strpos($v, '!') !== false) {
                        $ary = explode('!', $v);
                        $v = $ary[0];
                        $obj[$k . '_args'] = $ary[1];
                    }
                    $v = $this->idx->get($relation[$k], $v);
                }

                $obj[$k] = $v;
            }
        }

        # mop up any leftovers
        $this->done_parsing_obj_type_objects($last_obj_type, $obj_array);

        if (!empty($obj_array)) {
            echo "obj_array is not empty\n";
            print_r($obj_array);
        }
        assert('empty($obj_array)');

        if (!isset($_SERVER['REMOTE_USER']))  {
            $user = 'local';
        } else {
            $user = $_SERVER['REMOTE_USER'];
        }

        // Update instance ID of all hosts and services with the
        // first poller instance_id in program_status that is running.
        $instance_id_tables = array('host', 'service');

        foreach ($instance_id_tables as $table) {
            $this->sql_exec_query("
                UPDATE {$table} SET instance_id = (
                  SELECT instance_id from program_status
                         WHERE is_running = 1 LIMIT 1
                )
            ");
        }
       
        if (!$this->errors) {
            $this->sql_exec_query("REPLACE INTO gui_action_log (user, action) " .
                           "VALUES('" .
                           mysql_escape_string($user) . "', 'import')");
            return true;
        }

        return false;
    }

    function import_objects_if_new_cache($object_cache = false)
    {
        $import_time = 0;

        if (!$object_cache)
            $object_cache = '/opt/monitor/var/objects.cache';

        $result = $this->sql_exec_query
            ('SELECT UNIX_TIMESTAMP(time) AS time ' .
             'FROM gui_action_log ' .
             'WHERE action="import" ' .
             'ORDER BY time DESC LIMIT 1');

        $row = sql_fetch_row($result);
        if(!empty($row[0])) $import_time = $row[0];

        $cache_time = filemtime($object_cache);
        if($cache_time > $import_time) {
            return($this->import_objects_from_cache($object_cache));
        }

        return(0);
    }

    /**
     * @name    glue_custom_vars
     * @param    object type (string)
     * @param    object id (integer)
     * @param    array (custom variables, k => v style)
     */
    function glue_custom_vars($obj_type, $obj_id, $custom)
    {
        $ret = true;

        if (empty($custom))
            return true;

        $esc_obj_type = $this->sql_escape_string($obj_type);
        $esc_obj_id = $this->sql_escape_string($obj_id);
        $purge_query = 'DELETE FROM custom_vars WHERE ' .
            "obj_type = '$esc_obj_type' AND obj_id = '$esc_obj_id'";

        $result = $this->sql_exec_query($purge_query);
        if (!$custom)
            return $result;

        $base_query = "INSERT INTO custom_vars VALUES('" .
            $esc_obj_type . "','" . $esc_obj_id . "', '";

        foreach ($custom as $k => $v) {
            $query = $base_query . $this->sql_escape_string($k) . "','" .
                $this->sql_escape_string($v) . "')";

            $result = $this->sql_exec_query($query);
            if (!$result)
                $ret = false;
        }

        return $ret;
    }

    private function obj_name($obj_type, $obj)
    {
        if (isset($obj[$obj_type . '_name']))
            return $obj[$obj_type . '_name'];

        if ($obj_type === 'service')
            return "{$obj['host_name']};{$obj['service_description']}";

        return false;
    }

    /**
     * Inserts a single object into the database
     */
    function glue_object($obj_key, $obj_type, &$obj)
    {
        if (isset($this->conv_type[$obj_type]))
            $obj_type = $this->conv_type[$obj_type];

        if ($this->importing_status) {
            # mark hosts and services as pending if they
            # haven't been checked and current_state = 0
            if ($obj_type === 'host' || $obj_type === 'service') {
                if ($obj['current_state'] == 0 && $obj['has_been_checked'] == 0)
                    $obj['current_state'] = 6;
            }
        }

        # Some objects are converted into oblivion when we're
        # importing status.sav. We ignore those here.
        if (!$obj_type) {
            $obj = false;
            return;
        }

        $fresh = isset($obj['is a fresh one']);
        if ($fresh) {
            unset($obj['is a fresh one']);
        }

        if ($obj_type === 'host' || $obj_type === 'service') {
            $obj_name = $this->obj_name($obj_type, $obj);
            if (isset($this->imported[$obj_type][$obj_key]) &&
                $this->imported[$obj_type][$obj_key] !== $obj_name)
            {
                echo "overwriting $obj_type id $obj_key in \$this->imported\n";
                printf("%s -> %s\n", $this->imported[$obj_type][$obj_key], $obj_name);
                print_r($obj);
                exit(0);
            }
            $this->imported[$obj_type][$obj_key] = $this->obj_name($obj_type, $obj);
        }

        if (isset($this->obj_rel[$obj_type])) {
            $spec = $this->obj_rel[$obj_type];
        }

        if ($obj_type === 'program_status') {
            unset($obj['id']);
            /* 
             * ISST - we do not set program status instance information here as
             * with our version there is no guarantee this script will be 
             * running on a poller as it is part of our configuration process 
             * and not any specific poller restart.
             */
        } else {
            $obj['id'] = $obj_key;
        }

        if ($obj_type === 'comment') {
            if (! empty($obj['service_description'])) {
                $obj['comment_type'] = 2;  # include/comments.h
            } else {
                unset($obj['service_description']);
                $obj['comment_type'] = 1;  # include/comments.h
            }
        }

        if ($obj_type === 'scheduled_downtime') {
            if (! empty($obj['service_description'])) {
                $obj['downtime_type'] = 1;  # include/downtime.h
            } else {
                $obj['downtime_type'] = 2;  # include/downtime.h
            }
        }
        
        # stash away custom variables so the normal object
        # handling code doesn't have to deal with it.
        $custom = false;
        if (isset($obj['__custom'])) {
            $custom = $obj['__custom'];
            unset($obj['__custom']);
        }

        # loop every variable in the object
        foreach($obj as $k => $v) {
            if(is_array($v)) {
                # a junction thingie
                unset($obj[$k]);
                $query = false;
                $junction = $this->get_junction_table_name($obj_type, $k);

                # set up the values and insert them
                foreach($v as $junc_part) {
                    $other_obj_type = $spec[$k];

                    # timeperiod_exclude or host_parents
                    if ($other_obj_type === $obj_type)
                        $other_obj_type = $k;

                    $query = "INSERT INTO $junction " .
                        "($obj_type, $other_obj_type) " .
                        "VALUES($obj_key, $junc_part)";
                    $this->sql_exec_query($query);
                }
                continue;
            }

            if (!is_numeric($v)) {
                $obj[$k] = "'" . $this->sql_escape_string($v) . "'";
            }

        }

        if ((!$fresh && ($obj_type === 'host' || $obj_type === 'service'))
            || ($obj_type === 'contact' && $this->importing_status))
        {
            $query = "UPDATE $obj_type SET ";
            $oid = $obj['id'];
            unset($obj['id']);
            $params = array();
            foreach ($obj as $k => $v) {
                $params[] = "$k = $v";
            }
            $query .= join(", ", $params) . " WHERE id = $oid";
        } else {
            # all vars are properly mangled, so let's run the query
            $target_vars = implode(',', array_keys($obj));
            $target_values = implode(',', array_values($obj));
            $query = "REPLACE INTO $obj_type($target_vars) " .
                     "VALUES($target_values)";
        }

        if (!$this->sql_exec_query($query)) {
            $this->errors++;
            return false;
        }

        $this->glue_custom_vars($obj_type, $obj_key, $custom);

        # $obj is passed by reference, so we can release
        # it here now that we're done with it.
        $obj = false;

        return true;
    }

    /**
     * A wrapper for glue_objects
     */
    function glue_objects(&$obj_list, $obj_type)
    {
        # no objects, so no glueing to be done
        if (empty($obj_list))
            return true;

        foreach($obj_list as $obj_key => &$obj)
            $this->glue_object($obj_key, $obj_type, $obj);
    }

    # get an error from the last result
    function sql_error()
    {
        return(mysql_error($this->db));
    }

    # get error number of last result
    function sql_errno()
    {
        return(mysql_errno($this->db));
    }

    # fetch a single row to indexed array
    function sql_fetch_row($resource) {
        return(mysql_fetch_row($resource));
    }

    # fetch a single row to associative array
    function sql_fetch_array($resource) {
        return(mysql_fetch_array($resource, MYSQL_ASSOC));
    }

    function sql_escape_string($string)
    {
        return mysql_real_escape_string($string);
    }

    # execute an SQL query with error handling
    function sql_exec_query($query)
    {
        if(empty($query)) {
            return(false);
        }

        if($this->DEBUG) {
            // print "sql_exec_query: $query\n";
        }
    
        $matches = null;

        if ($this->env == ENV_STAGING) {


            if (preg_match(
                   "/(?:truncate|from|into)\s+({$this->staging_regex})\b/i", 
                   $query, $matches)) {


                $found = $matches[0];
                $replace = $matches[0] . ENV_STAGING;

                if ($this->DEBUG) {
                    print "Doing replacement for staging env: $found -> $replace\n";
                }

                $query = preg_replace("/{$found}/", $replace, $query);
            }

        }

        # workaround for now
        if($this->db === false) {
            $this->gui_db_connect();
        }

        $result = mysql_query($query, $this->db);
        if($result === false) {
            print "sql_exec_query; query failed: " .
                  mysql_error() . "; query: $query\n";
        }

        return($result);
    }

    // fetch complete results of a query with error checking
    // if a table named 'id' exists, resulting array is indexed by it
    function sql_fetch_result($resource)
    {
        $ret = false;
        $id = false;
        $i = 0;

        if(empty($resource)) {
            if($this->DEBUG) echo "SQL ERROR: sql_fetch_result() called with empty resource\n";
            return(false);
        }

        while($row = $this->sql_fetch_array($resource)) {
            $i++;
            if(isset($row['id'])) {
                $id = $row['id'];
                unset($row['id']);
            }
            else $id = $i;

            if(!empty($row)) {
                foreach($row as $k => $v) {
                    if(empty($v) && $v !== 0 && $v !== '0') continue;
                    $ret[$id][$k] = $v;
                }
            }
            else {
                $ret[$id] = false;
            }
        }
        return($ret);
    }

    # connects to and selects database. false on error, true on success
    function gui_db_connect()
    {
        if($this->db_type !== 'mysql') {
            die("Only mysql is supported as of yet.<br />\n");
        }

        $this->db = mysql_connect
            ($this->db_host, $this->db_user, $this->db_pass);

        if ($this->db === false)
            return(false);

        return mysql_select_db($this->db_database);
    }
}
