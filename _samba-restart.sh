#!/bin/sh

# @Chernic : 重启samba
# @changelog
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加changelog

service smb restart; 
service nmb restart;

chkconfig smb on
chkconfig nmb on

service iptables stop
chkconfig iptables off
setenforce 0

chkconfig --list
