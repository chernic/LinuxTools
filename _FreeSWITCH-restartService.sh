#!/bin/sh
#«Î π”√
chkconfig nmb         on
chkconfig smb         on
chkconfig freeswitch  on
chkconfig mysql       on

service nmb         restart
service smb         restart
service freeswitch  restart
service mysql       restart

service nmb         status
service smb         status
service freeswitch  status
service mysql       status
