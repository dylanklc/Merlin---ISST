-- MySQL dump 10.11
--
-- Host: localhost    Database: merlin
-- ------------------------------------------------------
-- Server version	5.0.77-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `command`
--

DROP TABLE IF EXISTS `command`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `command` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `command_name` varchar(75) NOT NULL,
  `command_line` blob NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `command_name` (`command_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `command_staging`
--

DROP TABLE IF EXISTS `command_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `command_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `command_name` varchar(75) NOT NULL,
  `command_line` blob NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `command_name` (`command_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `host_name` varchar(255) default NULL,
  `service_description` varchar(255) default NULL,
  `comment_type` int(11) default NULL,
  `entry_time` int(10) default NULL,
  `author` varchar(255) default NULL,
  `comment_data` text,
  `persistent` tinyint(2) default NULL,
  `source` int(11) default NULL,
  `entry_type` int(11) default NULL,
  `expires` int(11) default NULL,
  `expire_time` int(10) default NULL,
  `comment_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `host_comment` (`host_name`),
  KEY `service_comment` (`host_name`,`service_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contact` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `contact_name` varchar(75) default NULL,
  `alias` varchar(160) NOT NULL,
  `host_notifications_enabled` tinyint(1) default NULL,
  `service_notifications_enabled` tinyint(1) default NULL,
  `can_submit_commands` tinyint(1) default NULL,
  `retain_status_information` tinyint(1) default NULL,
  `retain_nonstatus_information` tinyint(1) default NULL,
  `host_notification_period` varchar(75) default NULL,
  `service_notification_period` varchar(75) default NULL,
  `host_notification_options` varchar(15) default NULL,
  `service_notification_options` varchar(15) default NULL,
  `host_notification_commands` text,
  `service_notification_commands` text,
  `email` varchar(60) default NULL,
  `pager` varchar(18) default NULL,
  `address1` varchar(100) default NULL,
  `address2` varchar(100) default NULL,
  `address3` varchar(100) default NULL,
  `address4` varchar(100) default NULL,
  `address5` varchar(100) default NULL,
  `address6` varchar(100) default NULL,
  `last_host_notification` int(10) default NULL,
  `last_service_notification` int(10) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `contact_name` (`contact_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contact_access`
--

DROP TABLE IF EXISTS `contact_access`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contact_access` (
  `contact` int(11) default NULL,
  `host` int(11) default NULL,
  `service` int(11) default NULL,
  KEY `contact` (`contact`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contact_contactgroup`
--

DROP TABLE IF EXISTS `contact_contactgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contact_contactgroup` (
  `contact` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contact_contactgroup_staging`
--

DROP TABLE IF EXISTS `contact_contactgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contact_contactgroup_staging` (
  `contact` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contact_staging`
--

DROP TABLE IF EXISTS `contact_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contact_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `contact_name` varchar(75) default NULL,
  `alias` varchar(160) NOT NULL,
  `host_notifications_enabled` tinyint(1) default NULL,
  `service_notifications_enabled` tinyint(1) default NULL,
  `can_submit_commands` tinyint(1) default NULL,
  `retain_status_information` tinyint(1) default NULL,
  `retain_nonstatus_information` tinyint(1) default NULL,
  `host_notification_period` int(11) default NULL,
  `service_notification_period` int(11) default NULL,
  `host_notification_options` varchar(15) default NULL,
  `service_notification_options` varchar(15) default NULL,
  `host_notification_commands` text,
  `service_notification_commands` text,
  `email` varchar(60) default NULL,
  `pager` varchar(18) default NULL,
  `address1` varchar(100) default NULL,
  `address2` varchar(100) default NULL,
  `address3` varchar(100) default NULL,
  `address4` varchar(100) default NULL,
  `address5` varchar(100) default NULL,
  `address6` varchar(100) default NULL,
  `last_host_notification` int(10) default NULL,
  `last_service_notification` int(10) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `contact_name` (`contact_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contactgroup`
--

DROP TABLE IF EXISTS `contactgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contactgroup` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `contactgroup_name` varchar(75) NOT NULL,
  `alias` varchar(160) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `contactgroup_name` (`contactgroup_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `contactgroup_staging`
--

DROP TABLE IF EXISTS `contactgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `contactgroup_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `contactgroup_name` varchar(75) NOT NULL,
  `alias` varchar(160) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `contactgroup_name` (`contactgroup_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `custom_vars`
--

DROP TABLE IF EXISTS `custom_vars`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `custom_vars` (
  `obj_type` varchar(30) NOT NULL,
  `obj_id` int(11) NOT NULL,
  `variable` varchar(100) default NULL,
  `value` varchar(255) default NULL,
  UNIQUE KEY `objvar` (`obj_type`,`obj_id`,`variable`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `custom_vars_staging`
--

DROP TABLE IF EXISTS `custom_vars_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `custom_vars_staging` (
  `obj_type` varchar(30) NOT NULL,
  `obj_id` int(11) NOT NULL,
  `variable` varchar(100) default NULL,
  `value` varchar(255) default NULL,
  UNIQUE KEY `objvar` (`obj_type`,`obj_id`,`variable`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `db_version`
--

DROP TABLE IF EXISTS `db_version`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `db_version` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `gui_access`
--

DROP TABLE IF EXISTS `gui_access`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `gui_access` (
  `user` varchar(30) NOT NULL,
  `view` tinyint(1) default NULL,
  `view_all` tinyint(1) default NULL,
  `modify_obj` tinyint(1) default NULL,
  `modify_any` tinyint(1) default NULL,
  `delete_obj` tinyint(1) default NULL,
  `delete_all` tinyint(1) default NULL,
  `import` tinyint(1) default NULL,
  `probe` tinyint(1) default NULL,
  `admin` tinyint(1) default NULL,
  PRIMARY KEY  (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `gui_action_log`
--

DROP TABLE IF EXISTS `gui_action_log`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `gui_action_log` (
  `user` varchar(30) NOT NULL,
  `action` varchar(50) NOT NULL,
  `time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host`
--

DROP TABLE IF EXISTS `host`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `host_name` varchar(75) default NULL,
  `alias` varchar(100) NOT NULL,
  `display_name` varchar(100) default NULL,
  `address` varchar(75) NOT NULL,
  `initial_state` varchar(18) default NULL,
  `check_command` text,
  `max_check_attempts` smallint(6) default NULL,
  `check_interval` smallint(6) default NULL,
  `retry_interval` smallint(6) default NULL,
  `active_checks_enabled` tinyint(1) default NULL,
  `passive_checks_enabled` tinyint(1) default NULL,
  `check_period` varchar(75) default NULL,
  `obsess_over_host` tinyint(1) default NULL,
  `check_freshness` tinyint(1) default NULL,
  `freshness_threshold` float default NULL,
  `event_handler` text,
  `event_handler_enabled` tinyint(1) default NULL,
  `low_flap_threshold` float default NULL,
  `high_flap_threshold` float default NULL,
  `flap_detection_enabled` tinyint(1) default NULL,
  `flap_detection_options` varchar(18) default NULL,
  `process_perf_data` tinyint(1) default NULL,
  `retain_status_information` tinyint(1) default NULL,
  `retain_nonstatus_information` tinyint(1) default NULL,
  `notification_interval` mediumint(9) default NULL,
  `first_notification_delay` int(11) default NULL,
  `notification_period` varchar(75) default NULL,
  `notification_options` varchar(15) default NULL,
  `notifications_enabled` tinyint(1) default NULL,
  `stalking_options` varchar(15) default NULL,
  `notes` varchar(255) default NULL,
  `notes_url` varchar(255) default NULL,
  `action_url` varchar(255) default NULL,
  `icon_image` varchar(60) default NULL,
  `icon_image_alt` varchar(60) default NULL,
  `statusmap_image` varchar(60) default NULL,
  `2d_coords` varchar(20) default NULL,
  `3d_coords` varchar(30) default NULL,
  `vrml_image` varchar(60) default NULL,
  `failure_prediction_enabled` tinyint(1) default NULL,
  `problem_has_been_acknowledged` int(10) NOT NULL default '0',
  `acknowledgement_type` int(10) NOT NULL default '0',
  `check_type` int(10) NOT NULL default '0',
  `current_state` int(10) NOT NULL default '6',
  `last_state` int(10) NOT NULL default '0',
  `last_hard_state` int(10) NOT NULL default '0',
  `last_notification` int(10) NOT NULL default '0',
  `plugin_output` text,
  `long_plugin_output` text,
  `performance_data` text,
  `state_type` int(10) NOT NULL default '0',
  `current_attempt` int(10) NOT NULL default '0',
  `check_latency` float default NULL,
  `check_execution_time` float default NULL,
  `is_executing` int(10) NOT NULL default '0',
  `check_options` int(10) NOT NULL default '0',
  `last_host_notification` int(10) default NULL,
  `next_host_notification` int(10) default NULL,
  `next_check` int(10) default NULL,
  `should_be_scheduled` int(10) NOT NULL default '0',
  `last_check` int(10) default NULL,
  `last_state_change` int(10) default NULL,
  `last_hard_state_change` int(10) default NULL,
  `last_time_up` int(10) default NULL,
  `last_time_down` int(10) default NULL,
  `last_time_unreachable` int(10) default NULL,
  `has_been_checked` int(10) NOT NULL default '0',
  `is_being_freshened` int(10) NOT NULL default '0',
  `notified_on_down` int(10) NOT NULL default '0',
  `notified_on_unreachable` int(10) NOT NULL default '0',
  `current_notification_number` int(10) NOT NULL default '0',
  `no_more_notifications` int(10) NOT NULL default '0',
  `current_notification_id` int(10) NOT NULL default '0',
  `check_flapping_recovery_notification` int(10) NOT NULL default '0',
  `scheduled_downtime_depth` int(10) NOT NULL default '0',
  `pending_flex_downtime` int(10) NOT NULL default '0',
  `is_flapping` int(10) NOT NULL default '0',
  `flapping_comment_id` int(10) NOT NULL default '0',
  `percent_state_change` float default NULL,
  `total_services` int(10) NOT NULL default '0',
  `total_service_check_interval` int(10) NOT NULL default '0',
  `modified_attributes` int(10) NOT NULL default '0',
  `current_problem_id` int(10) NOT NULL default '0',
  `last_problem_id` int(10) NOT NULL default '0',
  `max_attempts` int(10) NOT NULL default '1',
  `current_event_id` int(10) NOT NULL default '0',
  `last_event_id` int(10) NOT NULL default '0',
  `process_performance_data` int(10) NOT NULL default '0',
  `last_update` int(10) NOT NULL default '0',
  `timeout` int(10) default NULL,
  `start_time` int(10) default NULL,
  `end_time` int(10) default NULL,
  `early_timeout` smallint(1) default NULL,
  `return_code` smallint(8) default NULL,
  `state_history` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `host_name` (`host_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_contact`
--

DROP TABLE IF EXISTS `host_contact`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_contact` (
  `host` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_contact_staging`
--

DROP TABLE IF EXISTS `host_contact_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_contact_staging` (
  `host` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_contactgroup`
--

DROP TABLE IF EXISTS `host_contactgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_contactgroup` (
  `host` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_contactgroup_staging`
--

DROP TABLE IF EXISTS `host_contactgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_contactgroup_staging` (
  `host` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_hostgroup`
--

DROP TABLE IF EXISTS `host_hostgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_hostgroup` (
  `host` int(11) NOT NULL,
  `hostgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_hostgroup_staging`
--

DROP TABLE IF EXISTS `host_hostgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_hostgroup_staging` (
  `host` int(11) NOT NULL,
  `hostgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_parents`
--

DROP TABLE IF EXISTS `host_parents`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_parents` (
  `host` int(11) NOT NULL,
  `parents` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_parents_staging`
--

DROP TABLE IF EXISTS `host_parents_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_parents_staging` (
  `host` int(11) NOT NULL,
  `parents` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `host_staging`
--

DROP TABLE IF EXISTS `host_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `host_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `host_name` varchar(75) default NULL,
  `alias` varchar(100) NOT NULL,
  `display_name` varchar(100) default NULL,
  `address` varchar(75) NOT NULL,
  `initial_state` varchar(18) default NULL,
  `check_command` text,
  `max_check_attempts` smallint(6) default NULL,
  `check_interval` smallint(6) default NULL,
  `retry_interval` smallint(6) default NULL,
  `active_checks_enabled` tinyint(1) default NULL,
  `passive_checks_enabled` tinyint(1) default NULL,
  `check_period` varchar(75) default NULL,
  `obsess_over_host` tinyint(1) default NULL,
  `check_freshness` tinyint(1) default NULL,
  `freshness_threshold` float default NULL,
  `event_handler` text,
  `event_handler_enabled` tinyint(1) default NULL,
  `low_flap_threshold` float default NULL,
  `high_flap_threshold` float default NULL,
  `flap_detection_enabled` tinyint(1) default NULL,
  `flap_detection_options` varchar(18) default NULL,
  `process_perf_data` tinyint(1) default NULL,
  `retain_status_information` tinyint(1) default NULL,
  `retain_nonstatus_information` tinyint(1) default NULL,
  `notification_interval` mediumint(9) default NULL,
  `first_notification_delay` int(11) default NULL,
  `notification_period` varchar(75) default NULL,
  `notification_options` varchar(15) default NULL,
  `notifications_enabled` tinyint(1) default NULL,
  `stalking_options` varchar(15) default NULL,
  `notes` varchar(255) default NULL,
  `notes_url` varchar(255) default NULL,
  `action_url` varchar(255) default NULL,
  `icon_image` varchar(60) default NULL,
  `icon_image_alt` varchar(60) default NULL,
  `statusmap_image` varchar(60) default NULL,
  `2d_coords` varchar(20) default NULL,
  `3d_coords` varchar(30) default NULL,
  `vrml_image` varchar(60) default NULL,
  `failure_prediction_enabled` tinyint(1) default NULL,
  `problem_has_been_acknowledged` int(10) NOT NULL default '0',
  `acknowledgement_type` int(10) NOT NULL default '0',
  `check_type` int(10) NOT NULL default '0',
  `current_state` int(10) NOT NULL default '6',
  `last_state` int(10) NOT NULL default '0',
  `last_hard_state` int(10) NOT NULL default '0',
  `last_notification` int(10) NOT NULL default '0',
  `plugin_output` text,
  `long_plugin_output` text,
  `performance_data` text,
  `state_type` int(10) NOT NULL default '0',
  `current_attempt` int(10) NOT NULL default '0',
  `check_latency` float default NULL,
  `check_execution_time` float default NULL,
  `is_executing` int(10) NOT NULL default '0',
  `check_options` int(10) NOT NULL default '0',
  `last_host_notification` int(10) default NULL,
  `next_host_notification` int(10) default NULL,
  `next_check` int(10) default NULL,
  `should_be_scheduled` int(10) NOT NULL default '0',
  `last_check` int(10) default NULL,
  `last_state_change` int(10) default NULL,
  `last_hard_state_change` int(10) default NULL,
  `last_time_up` int(10) default NULL,
  `last_time_down` int(10) default NULL,
  `last_time_unreachable` int(10) default NULL,
  `has_been_checked` int(10) NOT NULL default '0',
  `is_being_freshened` int(10) NOT NULL default '0',
  `notified_on_down` int(10) NOT NULL default '0',
  `notified_on_unreachable` int(10) NOT NULL default '0',
  `current_notification_number` int(10) NOT NULL default '0',
  `no_more_notifications` int(10) NOT NULL default '0',
  `current_notification_id` int(10) NOT NULL default '0',
  `check_flapping_recovery_notification` int(10) NOT NULL default '0',
  `scheduled_downtime_depth` int(10) NOT NULL default '0',
  `pending_flex_downtime` int(10) NOT NULL default '0',
  `is_flapping` int(10) NOT NULL default '0',
  `flapping_comment_id` int(10) NOT NULL default '0',
  `percent_state_change` float default NULL,
  `total_services` int(10) NOT NULL default '0',
  `total_service_check_interval` int(10) NOT NULL default '0',
  `modified_attributes` int(10) NOT NULL default '0',
  `current_problem_id` int(10) NOT NULL default '0',
  `last_problem_id` int(10) NOT NULL default '0',
  `max_attempts` int(10) NOT NULL default '1',
  `current_event_id` int(10) NOT NULL default '0',
  `last_event_id` int(10) NOT NULL default '0',
  `process_performance_data` int(10) NOT NULL default '0',
  `last_update` int(10) NOT NULL default '0',
  `timeout` int(10) default NULL,
  `start_time` int(10) default NULL,
  `end_time` int(10) default NULL,
  `early_timeout` smallint(1) default NULL,
  `return_code` smallint(8) default NULL,
  `state_history` varchar(127) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `host_name` (`host_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostdependency`
--

DROP TABLE IF EXISTS `hostdependency`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostdependency` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `host_name` int(11) NOT NULL,
  `dependent_host_name` int(11) NOT NULL,
  `dependency_period` varchar(75) default NULL,
  `inherits_parent` tinyint(1) default NULL,
  `execution_failure_options` varchar(15) default NULL,
  `notification_failure_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostdependency_staging`
--

DROP TABLE IF EXISTS `hostdependency_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostdependency_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `host_name` int(11) NOT NULL,
  `dependent_host_name` int(11) NOT NULL,
  `dependency_period` varchar(75) default NULL,
  `inherits_parent` tinyint(1) default NULL,
  `execution_failure_options` varchar(15) default NULL,
  `notification_failure_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostescalation`
--

DROP TABLE IF EXISTS `hostescalation`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostescalation` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `template` int(11) default NULL,
  `host_name` int(11) NOT NULL,
  `first_notification` int(11) default NULL,
  `last_notification` int(11) default NULL,
  `notification_interval` int(11) default NULL,
  `escalation_period` varchar(75) default NULL,
  `escalation_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostescalation_contact`
--

DROP TABLE IF EXISTS `hostescalation_contact`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostescalation_contact` (
  `hostescalation` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostescalation_contact_staging`
--

DROP TABLE IF EXISTS `hostescalation_contact_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostescalation_contact_staging` (
  `hostescalation` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostescalation_contactgroup`
--

DROP TABLE IF EXISTS `hostescalation_contactgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostescalation_contactgroup` (
  `hostescalation` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostescalation_contactgroup_staging`
--

DROP TABLE IF EXISTS `hostescalation_contactgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostescalation_contactgroup_staging` (
  `hostescalation` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostescalation_staging`
--

DROP TABLE IF EXISTS `hostescalation_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostescalation_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `template` int(11) default NULL,
  `host_name` int(11) NOT NULL,
  `first_notification` int(11) default NULL,
  `last_notification` int(11) default NULL,
  `notification_interval` int(11) default NULL,
  `escalation_period` varchar(75) default NULL,
  `escalation_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostgroup`
--

DROP TABLE IF EXISTS `hostgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostgroup` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `hostgroup_name` varchar(75) default NULL,
  `alias` varchar(160) default NULL,
  `notes` varchar(160) default NULL,
  `notes_url` varchar(160) default NULL,
  `action_url` varchar(160) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `hostgroup_name` (`hostgroup_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hostgroup_staging`
--

DROP TABLE IF EXISTS `hostgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `hostgroup_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `hostgroup_name` varchar(75) default NULL,
  `alias` varchar(160) default NULL,
  `notes` varchar(160) default NULL,
  `notes_url` varchar(160) default NULL,
  `action_url` varchar(160) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `hostgroup_name` (`hostgroup_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `notification` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `notification_type` int(11) default NULL,
  `start_time` int(11) default NULL,
  `end_time` int(11) default NULL,
  `command_name` varchar(255) default NULL,
  `contact_name` varchar(255) default NULL,
  `host_name` varchar(255) default NULL,
  `service_description` varchar(255) default NULL,
  `reason_type` int(11) default NULL,
  `state` int(11) default NULL,
  `output` text,
  `ack_author` varchar(255) default NULL,
  `ack_data` text,
  `escalated` int(11) default NULL,
  `contacts_notified` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `contact_name` (`contact_name`),
  KEY `host_name` (`host_name`),
  KEY `service_name` (`host_name`,`service_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `poller_group_detail`
--

DROP TABLE IF EXISTS `poller_group_detail`;
/*!50001 DROP VIEW IF EXISTS `poller_group_detail`*/;
/*!50001 CREATE TABLE `poller_group_detail` (
  `instance_id` int(10) unsigned,
  `instance_name` varchar(255),
  `is_online` int(4),
  `last_alive` int(10),
  `program_start` int(10),
  `host_ct` bigint(21),
  `host_avg_check_latency` double,
  `host_avg_check_execution_time` double,
  `host_max_check_execution_time` float,
  `host_in_scheduled_downtime` decimal(23,0),
  `host_active_checks` decimal(23,0),
  `host_passive_checks` decimal(23,0),
  `host_up` decimal(23,0),
  `host_down` decimal(23,0),
  `host_unreachable` decimal(23,0),
  `host_pending` decimal(23,0),
  `host_checks_last_minute` decimal(23,0),
  `host_checks_last_5min` decimal(23,0),
  `host_checks_last_15min` decimal(23,0),
  `svc_ct` bigint(21),
  `svc_avg_check_latency` double,
  `svc_avg_check_execution_time` double,
  `svc_max_check_execution_time` float,
  `svc_in_scheduled_downtime` decimal(23,0),
  `svc_active_checks` decimal(23,0),
  `svc_passive_checks` decimal(23,0),
  `svc_ok` decimal(23,0),
  `svc_warning` decimal(23,0),
  `svc_critical` decimal(23,0),
  `svc_unknown` decimal(23,0),
  `svc_pending` decimal(23,0),
  `svc_checks_last_minute` decimal(23,0),
  `svc_checks_last_5min` decimal(23,0),
  `svc_checks_last_15min` decimal(23,0)
) ENGINE=MyISAM */;

--
-- Temporary table structure for view `poller_group_overview`
--

DROP TABLE IF EXISTS `poller_group_overview`;
/*!50001 DROP VIEW IF EXISTS `poller_group_overview`*/;
/*!50001 CREATE TABLE `poller_group_overview` (
  `instance_name` varchar(255),
  `is_running` int(4),
  `is_last_alive` bigint(11),
  `num_hosts` bigint(21),
  `num_services` bigint(21),
  `max_host_state` int(10),
  `max_service_state` int(10)
) ENGINE=MyISAM */;

--
-- Temporary table structure for view `poller_group_summary`
--

DROP TABLE IF EXISTS `poller_group_summary`;
/*!50001 DROP VIEW IF EXISTS `poller_group_summary`*/;
/*!50001 CREATE TABLE `poller_group_summary` (
  `is_running` int(4),
  `poller_count` bigint(21),
  `avg_svc_latency` double
) ENGINE=MyISAM */;

--
-- Temporary table structure for view `poller_host_summary`
--

DROP TABLE IF EXISTS `poller_host_summary`;
/*!50001 DROP VIEW IF EXISTS `poller_host_summary`*/;
/*!50001 CREATE TABLE `poller_host_summary` (
  `instance_id` int(10) unsigned,
  `host_ct` bigint(21),
  `host_avg_check_latency` double,
  `host_avg_check_execution_time` double,
  `host_max_check_execution_time` float,
  `host_in_scheduled_downtime` decimal(23,0),
  `host_active_checks` decimal(23,0),
  `host_passive_checks` decimal(23,0),
  `host_up` decimal(23,0),
  `host_down` decimal(23,0),
  `host_unreachable` decimal(23,0),
  `host_pending` decimal(23,0),
  `host_checks_last_minute` decimal(23,0),
  `host_checks_last_5min` decimal(23,0),
  `host_checks_last_15min` decimal(23,0)
) ENGINE=MyISAM */;

--
-- Temporary table structure for view `poller_service_summary`
--

DROP TABLE IF EXISTS `poller_service_summary`;
/*!50001 DROP VIEW IF EXISTS `poller_service_summary`*/;
/*!50001 CREATE TABLE `poller_service_summary` (
  `instance_id` int(10) unsigned,
  `svc_ct` bigint(21),
  `svc_avg_check_latency` double,
  `svc_avg_check_execution_time` double,
  `svc_max_check_execution_time` float,
  `svc_in_scheduled_downtime` decimal(23,0),
  `svc_active_checks` decimal(23,0),
  `svc_passive_checks` decimal(23,0),
  `svc_ok` decimal(23,0),
  `svc_warning` decimal(23,0),
  `svc_critical` decimal(23,0),
  `svc_unknown` decimal(23,0),
  `svc_pending` decimal(23,0),
  `svc_checks_last_minute` decimal(23,0),
  `svc_checks_last_5min` decimal(23,0),
  `svc_checks_last_15min` decimal(23,0)
) ENGINE=MyISAM */;

--
-- Table structure for table `program_status`
--

DROP TABLE IF EXISTS `program_status`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `program_status` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `instance_id` int(10) unsigned default NULL,
  `instance_name` varchar(255) default NULL,
  `is_running` tinyint(2) default NULL,
  `is_online` tinyint(2) default NULL,
  `last_alive` int(10) default NULL,
  `program_start` int(10) default NULL,
  `pid` int(6) default NULL,
  `daemon_mode` tinyint(2) default NULL,
  `last_command_check` int(10) default NULL,
  `last_log_rotation` int(10) default NULL,
  `enable_notifications` tinyint(2) default NULL,
  `active_service_checks_enabled` tinyint(2) default NULL,
  `passive_service_checks_enabled` tinyint(2) default NULL,
  `active_host_checks_enabled` tinyint(2) default NULL,
  `passive_host_checks_enabled` tinyint(2) default NULL,
  `enable_event_handlers` tinyint(2) default NULL,
  `enable_flap_detection` tinyint(2) default NULL,
  `enable_failure_prediction` tinyint(2) default NULL,
  `process_performance_data` tinyint(2) default NULL,
  `obsess_over_hosts` tinyint(2) default NULL,
  `obsess_over_services` tinyint(2) default NULL,
  `check_host_freshness` tinyint(2) default NULL,
  `check_service_freshness` tinyint(2) default NULL,
  `modified_host_attributes` int(11) default NULL,
  `modified_service_attributes` int(11) default NULL,
  `global_host_event_handler` text,
  `global_service_event_handler` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `program_status_instance_id_index` (`instance_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `report_data`
--

DROP TABLE IF EXISTS `report_data`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `report_data` (
  `id` int(11) NOT NULL auto_increment,
  `timestamp` int(11) NOT NULL default '0',
  `event_type` int(11) NOT NULL default '0',
  `flags` int(11) default NULL,
  `attrib` int(11) default NULL,
  `host_name` varchar(160) default NULL,
  `service_description` varchar(160) default NULL,
  `state` int(2) NOT NULL default '0',
  `hard` int(2) NOT NULL default '0',
  `retry` int(5) NOT NULL default '0',
  `downtime_depth` int(11) default NULL,
  `output` text,
  PRIMARY KEY  (`id`),
  KEY `event_type` (`event_type`),
  KEY `host_name` (`host_name`),
  KEY `host_name_2` (`host_name`,`service_description`),
  KEY `state` (`state`),
  KEY `timestamp` (`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `scheduled_downtime`
--

DROP TABLE IF EXISTS `scheduled_downtime`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `scheduled_downtime` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `downtime_type` int(11) default NULL,
  `host_name` varchar(255) default NULL,
  `service_description` varchar(255) default NULL,
  `entry_time` int(11) default NULL,
  `author` varchar(255) default NULL,
  `comment` text,
  `start_time` int(11) default NULL,
  `end_time` int(11) default NULL,
  `fixed` tinyint(2) default NULL,
  `duration` int(11) default NULL,
  `triggered_by` int(11) default NULL,
  `downtime_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `host_downtime` (`host_name`),
  KEY `service_downtime` (`service_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `host_name` varchar(75) NOT NULL,
  `service_description` varchar(160) NOT NULL,
  `display_name` varchar(160) default NULL,
  `is_volatile` tinyint(1) default NULL,
  `check_command` text,
  `initial_state` varchar(1) default NULL,
  `max_check_attempts` smallint(6) default NULL,
  `check_interval` smallint(6) default NULL,
  `retry_interval` smallint(6) default NULL,
  `active_checks_enabled` tinyint(1) default NULL,
  `passive_checks_enabled` tinyint(1) default NULL,
  `check_period` varchar(75) default NULL,
  `parallelize_check` tinyint(1) default NULL,
  `obsess_over_service` tinyint(1) default NULL,
  `check_freshness` tinyint(1) default NULL,
  `freshness_threshold` int(11) default NULL,
  `event_handler` text,
  `event_handler_enabled` tinyint(1) default NULL,
  `low_flap_threshold` float default NULL,
  `high_flap_threshold` float default NULL,
  `flap_detection_enabled` tinyint(1) default NULL,
  `flap_detection_options` varchar(18) default NULL,
  `process_perf_data` tinyint(1) default NULL,
  `retain_status_information` tinyint(1) default NULL,
  `retain_nonstatus_information` tinyint(1) default NULL,
  `notification_interval` int(11) default NULL,
  `first_notification_delay` int(11) default NULL,
  `notification_period` varchar(75) default NULL,
  `notification_options` varchar(15) default NULL,
  `notifications_enabled` tinyint(1) default NULL,
  `stalking_options` varchar(15) default NULL,
  `notes` varchar(255) default NULL,
  `notes_url` varchar(255) default NULL,
  `action_url` varchar(255) default NULL,
  `icon_image` varchar(60) default NULL,
  `icon_image_alt` varchar(60) default NULL,
  `failure_prediction_enabled` tinyint(1) default NULL,
  `problem_has_been_acknowledged` int(10) NOT NULL default '0',
  `acknowledgement_type` int(10) NOT NULL default '0',
  `host_problem_at_last_check` int(10) NOT NULL default '0',
  `check_type` int(10) NOT NULL default '0',
  `current_state` int(10) NOT NULL default '6',
  `last_state` int(10) NOT NULL default '0',
  `last_hard_state` int(10) NOT NULL default '0',
  `plugin_output` text,
  `long_plugin_output` text,
  `performance_data` text,
  `state_type` int(10) NOT NULL default '0',
  `next_check` int(10) default NULL,
  `should_be_scheduled` int(10) NOT NULL default '0',
  `last_check` int(10) default NULL,
  `current_attempt` int(10) NOT NULL default '0',
  `current_event_id` int(10) NOT NULL default '0',
  `last_event_id` int(10) NOT NULL default '0',
  `current_problem_id` int(10) NOT NULL default '0',
  `last_problem_id` int(10) NOT NULL default '0',
  `last_notification` int(10) default NULL,
  `next_notification` int(10) default NULL,
  `no_more_notifications` int(10) NOT NULL default '0',
  `check_flapping_recovery_notification` int(10) NOT NULL default '0',
  `last_state_change` int(10) default NULL,
  `last_hard_state_change` int(10) default NULL,
  `last_time_ok` int(10) default NULL,
  `last_time_warning` int(10) default NULL,
  `last_time_unknown` int(10) default NULL,
  `last_time_critical` int(10) default NULL,
  `has_been_checked` int(10) NOT NULL default '0',
  `is_being_freshened` int(10) NOT NULL default '0',
  `notified_on_unknown` int(10) NOT NULL default '0',
  `notified_on_warning` int(10) NOT NULL default '0',
  `notified_on_critical` int(10) NOT NULL default '0',
  `current_notification_number` int(10) NOT NULL default '0',
  `current_notification_id` int(10) NOT NULL default '0',
  `check_latency` float default NULL,
  `check_execution_time` float default NULL,
  `is_executing` int(10) NOT NULL default '0',
  `check_options` int(10) NOT NULL default '0',
  `scheduled_downtime_depth` int(10) NOT NULL default '0',
  `pending_flex_downtime` int(10) NOT NULL default '0',
  `is_flapping` int(10) NOT NULL default '0',
  `flapping_comment_id` int(10) NOT NULL default '0',
  `percent_state_change` float default NULL,
  `modified_attributes` int(10) NOT NULL default '0',
  `max_attempts` int(10) NOT NULL default '0',
  `process_performance_data` int(10) NOT NULL default '0',
  `last_update` int(10) NOT NULL default '0',
  `timeout` int(10) default NULL,
  `start_time` int(10) default NULL,
  `end_time` int(10) default NULL,
  `early_timeout` smallint(1) default NULL,
  `return_code` smallint(8) default NULL,
  `state_history` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `service_name` (`host_name`,`service_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_contact`
--

DROP TABLE IF EXISTS `service_contact`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service_contact` (
  `service` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_contact_staging`
--

DROP TABLE IF EXISTS `service_contact_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service_contact_staging` (
  `service` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_contactgroup`
--

DROP TABLE IF EXISTS `service_contactgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service_contactgroup` (
  `service` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_contactgroup_staging`
--

DROP TABLE IF EXISTS `service_contactgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service_contactgroup_staging` (
  `service` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_servicegroup`
--

DROP TABLE IF EXISTS `service_servicegroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service_servicegroup` (
  `service` int(11) NOT NULL,
  `servicegroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_servicegroup_staging`
--

DROP TABLE IF EXISTS `service_servicegroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service_servicegroup_staging` (
  `service` int(11) NOT NULL,
  `servicegroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `service_staging`
--

DROP TABLE IF EXISTS `service_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `service_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `host_name` varchar(75) NOT NULL,
  `service_description` varchar(160) NOT NULL,
  `display_name` varchar(160) default NULL,
  `is_volatile` tinyint(1) default NULL,
  `check_command` text,
  `initial_state` varchar(1) default NULL,
  `max_check_attempts` smallint(6) default NULL,
  `check_interval` smallint(6) default NULL,
  `retry_interval` smallint(6) default NULL,
  `active_checks_enabled` tinyint(1) default NULL,
  `passive_checks_enabled` tinyint(1) default NULL,
  `check_period` varchar(75) default NULL,
  `parallelize_check` tinyint(1) default NULL,
  `obsess_over_service` tinyint(1) default NULL,
  `check_freshness` tinyint(1) default NULL,
  `freshness_threshold` int(11) default NULL,
  `event_handler` text,
  `event_handler_enabled` tinyint(1) default NULL,
  `low_flap_threshold` float default NULL,
  `high_flap_threshold` float default NULL,
  `flap_detection_enabled` tinyint(1) default NULL,
  `flap_detection_options` varchar(18) default NULL,
  `process_perf_data` tinyint(1) default NULL,
  `retain_status_information` tinyint(1) default NULL,
  `retain_nonstatus_information` tinyint(1) default NULL,
  `notification_interval` int(11) default NULL,
  `first_notification_delay` int(11) default NULL,
  `notification_period` varchar(75) default NULL,
  `notification_options` varchar(15) default NULL,
  `notifications_enabled` tinyint(1) default NULL,
  `stalking_options` varchar(15) default NULL,
  `notes` varchar(255) default NULL,
  `notes_url` varchar(255) default NULL,
  `action_url` varchar(255) default NULL,
  `icon_image` varchar(60) default NULL,
  `icon_image_alt` varchar(60) default NULL,
  `failure_prediction_enabled` tinyint(1) default NULL,
  `problem_has_been_acknowledged` int(10) NOT NULL default '0',
  `acknowledgement_type` int(10) NOT NULL default '0',
  `host_problem_at_last_check` int(10) NOT NULL default '0',
  `check_type` int(10) NOT NULL default '0',
  `current_state` int(10) NOT NULL default '6',
  `last_state` int(10) NOT NULL default '0',
  `last_hard_state` int(10) NOT NULL default '0',
  `plugin_output` text,
  `long_plugin_output` text,
  `performance_data` text,
  `state_type` int(10) NOT NULL default '0',
  `next_check` int(10) default NULL,
  `should_be_scheduled` int(10) NOT NULL default '0',
  `last_check` int(10) default NULL,
  `current_attempt` int(10) NOT NULL default '0',
  `current_event_id` int(10) NOT NULL default '0',
  `last_event_id` int(10) NOT NULL default '0',
  `current_problem_id` int(10) NOT NULL default '0',
  `last_problem_id` int(10) NOT NULL default '0',
  `last_notification` int(10) default NULL,
  `next_notification` int(10) default NULL,
  `no_more_notifications` int(10) NOT NULL default '0',
  `check_flapping_recovery_notification` int(10) NOT NULL default '0',
  `last_state_change` int(10) default NULL,
  `last_hard_state_change` int(10) default NULL,
  `last_time_ok` int(10) default NULL,
  `last_time_warning` int(10) default NULL,
  `last_time_unknown` int(10) default NULL,
  `last_time_critical` int(10) default NULL,
  `has_been_checked` int(10) NOT NULL default '0',
  `is_being_freshened` int(10) NOT NULL default '0',
  `notified_on_unknown` int(10) NOT NULL default '0',
  `notified_on_warning` int(10) NOT NULL default '0',
  `notified_on_critical` int(10) NOT NULL default '0',
  `current_notification_number` int(10) NOT NULL default '0',
  `current_notification_id` int(10) NOT NULL default '0',
  `check_latency` float default NULL,
  `check_execution_time` float default NULL,
  `is_executing` int(10) NOT NULL default '0',
  `check_options` int(10) NOT NULL default '0',
  `scheduled_downtime_depth` int(10) NOT NULL default '0',
  `pending_flex_downtime` int(10) NOT NULL default '0',
  `is_flapping` int(10) NOT NULL default '0',
  `flapping_comment_id` int(10) NOT NULL default '0',
  `percent_state_change` float default NULL,
  `modified_attributes` int(10) NOT NULL default '0',
  `max_attempts` int(10) NOT NULL default '0',
  `process_performance_data` int(10) NOT NULL default '0',
  `last_update` int(10) NOT NULL default '0',
  `timeout` int(10) default NULL,
  `start_time` int(10) default NULL,
  `end_time` int(10) default NULL,
  `early_timeout` smallint(1) default NULL,
  `return_code` smallint(8) default NULL,
  `state_history` varchar(127) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `service_name` (`host_name`,`service_description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `servicedependency`
--

DROP TABLE IF EXISTS `servicedependency`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `servicedependency` (
  `id` int(11) NOT NULL auto_increment,
  `service` int(11) NOT NULL,
  `dependent_service` int(11) NOT NULL,
  `dependency_period` varchar(75) default NULL,
  `inherits_parent` tinyint(1) default NULL,
  `execution_failure_options` varchar(15) default NULL,
  `notification_failure_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `servicedependency_staging`
--

DROP TABLE IF EXISTS `servicedependency_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `servicedependency_staging` (
  `id` int(11) NOT NULL auto_increment,
  `service` int(11) NOT NULL,
  `dependent_service` int(11) NOT NULL,
  `dependency_period` varchar(75) default NULL,
  `inherits_parent` tinyint(1) default NULL,
  `execution_failure_options` varchar(15) default NULL,
  `notification_failure_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `serviceescalation`
--

DROP TABLE IF EXISTS `serviceescalation`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `serviceescalation` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `service` int(11) NOT NULL,
  `first_notification` mediumint(9) default NULL,
  `last_notification` mediumint(9) default NULL,
  `notification_interval` mediumint(9) default NULL,
  `escalation_period` varchar(75) default NULL,
  `escalation_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `serviceescalation_contact`
--

DROP TABLE IF EXISTS `serviceescalation_contact`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `serviceescalation_contact` (
  `serviceescalation` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `serviceescalation_contact_staging`
--

DROP TABLE IF EXISTS `serviceescalation_contact_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `serviceescalation_contact_staging` (
  `serviceescalation` int(11) NOT NULL,
  `contact` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `serviceescalation_contactgroup`
--

DROP TABLE IF EXISTS `serviceescalation_contactgroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `serviceescalation_contactgroup` (
  `serviceescalation` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `serviceescalation_contactgroup_staging`
--

DROP TABLE IF EXISTS `serviceescalation_contactgroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `serviceescalation_contactgroup_staging` (
  `serviceescalation` int(11) NOT NULL,
  `contactgroup` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `serviceescalation_staging`
--

DROP TABLE IF EXISTS `serviceescalation_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `serviceescalation_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `service` int(11) NOT NULL,
  `first_notification` mediumint(9) default NULL,
  `last_notification` mediumint(9) default NULL,
  `notification_interval` mediumint(9) default NULL,
  `escalation_period` varchar(75) default NULL,
  `escalation_options` varchar(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `servicegroup`
--

DROP TABLE IF EXISTS `servicegroup`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `servicegroup` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `servicegroup_name` varchar(75) NOT NULL,
  `alias` varchar(160) NOT NULL,
  `notes` varchar(160) default NULL,
  `notes_url` varchar(160) default NULL,
  `action_url` varchar(160) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `servicegroup_name` (`servicegroup_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `servicegroup_staging`
--

DROP TABLE IF EXISTS `servicegroup_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `servicegroup_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `servicegroup_name` varchar(75) NOT NULL,
  `alias` varchar(160) NOT NULL,
  `notes` varchar(160) default NULL,
  `notes_url` varchar(160) default NULL,
  `action_url` varchar(160) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `servicegroup_name` (`servicegroup_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `timeperiod`
--

DROP TABLE IF EXISTS `timeperiod`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `timeperiod` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(10) unsigned NOT NULL default '0',
  `timeperiod_name` varchar(75) NOT NULL,
  `alias` varchar(160) NOT NULL,
  `sunday` varchar(50) default NULL,
  `monday` varchar(50) default NULL,
  `tuesday` varchar(50) default NULL,
  `wednesday` varchar(50) default NULL,
  `thursday` varchar(50) default NULL,
  `friday` varchar(50) default NULL,
  `saturday` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `timeperiod_name` (`timeperiod_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `timeperiod_exclude`
--

DROP TABLE IF EXISTS `timeperiod_exclude`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `timeperiod_exclude` (
  `timeperiod` int(11) NOT NULL,
  `exclude` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `timeperiod_exclude_staging`
--

DROP TABLE IF EXISTS `timeperiod_exclude_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `timeperiod_exclude_staging` (
  `timeperiod` int(11) NOT NULL,
  `exclude` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `timeperiod_staging`
--

DROP TABLE IF EXISTS `timeperiod_staging`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `timeperiod_staging` (
  `id` int(11) NOT NULL auto_increment,
  `instance_id` int(11) NOT NULL default '0',
  `timeperiod_name` varchar(75) NOT NULL,
  `alias` varchar(160) NOT NULL,
  `sunday` varchar(50) default NULL,
  `monday` varchar(50) default NULL,
  `tuesday` varchar(50) default NULL,
  `wednesday` varchar(50) default NULL,
  `thursday` varchar(50) default NULL,
  `friday` varchar(50) default NULL,
  `saturday` varchar(50) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `timeperiod_name` (`timeperiod_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `poller_group_detail`
--

/*!50001 DROP TABLE `poller_group_detail`*/;
/*!50001 DROP VIEW IF EXISTS `poller_group_detail`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`merlin`@`127.0.0.1` SQL SECURITY DEFINER */
/*!50001 VIEW `poller_group_detail` AS select `ps`.`instance_id` AS `instance_id`,`ps`.`instance_name` AS `instance_name`,coalesce(`ps`.`is_online`,0) AS `is_online`,`ps`.`last_alive` AS `last_alive`,`ps`.`program_start` AS `program_start`,`phs`.`host_ct` AS `host_ct`,`phs`.`host_avg_check_latency` AS `host_avg_check_latency`,`phs`.`host_avg_check_execution_time` AS `host_avg_check_execution_time`,`phs`.`host_max_check_execution_time` AS `host_max_check_execution_time`,`phs`.`host_in_scheduled_downtime` AS `host_in_scheduled_downtime`,`phs`.`host_active_checks` AS `host_active_checks`,`phs`.`host_passive_checks` AS `host_passive_checks`,`phs`.`host_up` AS `host_up`,`phs`.`host_down` AS `host_down`,`phs`.`host_unreachable` AS `host_unreachable`,`phs`.`host_pending` AS `host_pending`,`phs`.`host_checks_last_minute` AS `host_checks_last_minute`,`phs`.`host_checks_last_5min` AS `host_checks_last_5min`,`phs`.`host_checks_last_15min` AS `host_checks_last_15min`,`pss`.`svc_ct` AS `svc_ct`,`pss`.`svc_avg_check_latency` AS `svc_avg_check_latency`,`pss`.`svc_avg_check_execution_time` AS `svc_avg_check_execution_time`,`pss`.`svc_max_check_execution_time` AS `svc_max_check_execution_time`,`pss`.`svc_in_scheduled_downtime` AS `svc_in_scheduled_downtime`,`pss`.`svc_active_checks` AS `svc_active_checks`,`pss`.`svc_passive_checks` AS `svc_passive_checks`,`pss`.`svc_ok` AS `svc_ok`,`pss`.`svc_warning` AS `svc_warning`,`pss`.`svc_critical` AS `svc_critical`,`pss`.`svc_unknown` AS `svc_unknown`,`pss`.`svc_pending` AS `svc_pending`,`pss`.`svc_checks_last_minute` AS `svc_checks_last_minute`,`pss`.`svc_checks_last_5min` AS `svc_checks_last_5min`,`pss`.`svc_checks_last_15min` AS `svc_checks_last_15min` from ((`program_status` `ps` left join `poller_host_summary` `phs` on((`phs`.`instance_id` = `ps`.`instance_id`))) left join `poller_service_summary` `pss` on((`pss`.`instance_id` = `ps`.`instance_id`))) */;

--
-- Final view structure for view `poller_group_overview`
--

/*!50001 DROP TABLE `poller_group_overview`*/;
/*!50001 DROP VIEW IF EXISTS `poller_group_overview`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`merlin`@`127.0.0.1` SQL SECURITY DEFINER */
/*!50001 VIEW `poller_group_overview` AS select `ps`.`instance_name` AS `instance_name`,coalesce(`ps`.`is_running`,0) AS `is_running`,coalesce(`ps`.`last_alive`,0) AS `is_last_alive`,count(distinct `h`.`host_name`) AS `num_hosts`,count(distinct `s`.`service_description`) AS `num_services`,max(`h`.`last_state`) AS `max_host_state`,max(`s`.`last_state`) AS `max_service_state` from ((`program_status` `ps` left join `host` `h` on((`ps`.`instance_id` = `h`.`instance_id`))) left join `service` `s` on((`h`.`host_name` = `s`.`host_name`))) group by `ps`.`instance_id` */;

--
-- Final view structure for view `poller_group_summary`
--

/*!50001 DROP TABLE `poller_group_summary`*/;
/*!50001 DROP VIEW IF EXISTS `poller_group_summary`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`merlin`@`127.0.0.1` SQL SECURITY DEFINER */
/*!50001 VIEW `poller_group_summary` AS select coalesce(`ps`.`is_running`,0) AS `is_running`,count(distinct `ps`.`instance_id`) AS `poller_count`,avg(`s`.`check_latency`) AS `avg_svc_latency` from (`program_status` `ps` left join `service` `s` on((`ps`.`instance_id` = `s`.`instance_id`))) where ((`s`.`check_latency` is not null) and (`s`.`check_latency` > 0)) group by `ps`.`is_running` */;

--
-- Final view structure for view `poller_host_summary`
--

/*!50001 DROP TABLE `poller_host_summary`*/;
/*!50001 DROP VIEW IF EXISTS `poller_host_summary`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`merlin`@`127.0.0.1` SQL SECURITY DEFINER */
/*!50001 VIEW `poller_host_summary` AS select `host`.`instance_id` AS `instance_id`,count(0) AS `host_ct`,avg(`host`.`check_latency`) AS `host_avg_check_latency`,avg(`host`.`check_execution_time`) AS `host_avg_check_execution_time`,max(`host`.`check_execution_time`) AS `host_max_check_execution_time`,sum(if((`host`.`scheduled_downtime_depth` > 0),1,0)) AS `host_in_scheduled_downtime`,sum(if(((`host`.`scheduled_downtime_depth` = 0) and (`host`.`active_checks_enabled` > 0)),1,0)) AS `host_active_checks`,sum(((`host`.`scheduled_downtime_depth` = 0) and if((`host`.`passive_checks_enabled` > 0),1,0))) AS `host_passive_checks`,sum(if((`host`.`last_state` = 0),1,0)) AS `host_up`,sum(if((`host`.`last_state` = 1),1,0)) AS `host_down`,sum(if((`host`.`last_state` = 2),1,0)) AS `host_unreachable`,sum(if((`host`.`last_state` = 6),1,0)) AS `host_pending`,sum(if(((`host`.`last_check` + 60) > unix_timestamp()),1,0)) AS `host_checks_last_minute`,sum(if(((`host`.`last_check` + 300) > unix_timestamp()),1,0)) AS `host_checks_last_5min`,sum(if(((`host`.`last_check` + 900) > unix_timestamp()),1,0)) AS `host_checks_last_15min` from `host` group by `host`.`instance_id` */;

--
-- Final view structure for view `poller_service_summary`
--

/*!50001 DROP TABLE `poller_service_summary`*/;
/*!50001 DROP VIEW IF EXISTS `poller_service_summary`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`merlin`@`127.0.0.1` SQL SECURITY DEFINER */
/*!50001 VIEW `poller_service_summary` AS select `service`.`instance_id` AS `instance_id`,count(0) AS `svc_ct`,avg(`service`.`check_latency`) AS `svc_avg_check_latency`,avg(`service`.`check_execution_time`) AS `svc_avg_check_execution_time`,max(`service`.`check_execution_time`) AS `svc_max_check_execution_time`,sum(if((`service`.`scheduled_downtime_depth` > 0),1,0)) AS `svc_in_scheduled_downtime`,sum(if(((`service`.`scheduled_downtime_depth` = 0) and (`service`.`active_checks_enabled` > 0)),1,0)) AS `svc_active_checks`,sum(((`service`.`scheduled_downtime_depth` = 0) and if((`service`.`passive_checks_enabled` > 0),1,0))) AS `svc_passive_checks`,sum(if((`service`.`last_state` = 0),1,0)) AS `svc_ok`,sum(if((`service`.`last_state` = 1),1,0)) AS `svc_warning`,sum(if((`service`.`last_state` = 2),1,0)) AS `svc_critical`,sum(if((`service`.`last_state` = 3),1,0)) AS `svc_unknown`,sum(if((`service`.`last_state` = 6),1,0)) AS `svc_pending`,sum(if(((`service`.`last_check` + 60) > unix_timestamp()),1,0)) AS `svc_checks_last_minute`,sum(if(((`service`.`last_check` + 300) > unix_timestamp()),1,0)) AS `svc_checks_last_5min`,sum(if(((`service`.`last_check` + 900) > unix_timestamp()),1,0)) AS `svc_checks_last_15min` from `service` group by `service`.`instance_id` */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-06-09  0:18:36
