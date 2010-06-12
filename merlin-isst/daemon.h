/*
 * This file is included by all C source files used exclusively by
 * the merlin daemon
 */
#ifndef INCLUDE_daemon_h__
#define INCLUDE_daemon_h__

#include "shared.h"
#include <netdb.h>
#include <limits.h>
#include "net.h"
#include "status.h"
#include "sql.h"

extern int use_database;
extern int mrm_db_update(merlin_event *pkt);
extern unsigned long int instance_id;

#endif
