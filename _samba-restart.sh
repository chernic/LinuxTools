#!/bin/sh

# @brief 重启samba
# @changelog
## 2018-09-12 Chernic <chenyongl AT focustar.net>
#- 增加changelog

service smb restart; 
service nmb restart;

chkconfig smb on

service iptables stop
chkconfig iptables off
setenforce 0
