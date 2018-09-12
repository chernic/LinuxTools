#!/bin/sh

# @Chernic : FreeSWITCH 等服务重启
# @changelog
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加changelog
#- 临时使用, 可进一步修改

#请使用
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
