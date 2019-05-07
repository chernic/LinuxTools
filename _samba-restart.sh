#!/bin/sh

# @Chernic : 重启samba
# @changelog
## 2019-05-07 Chernic <chernic AT qq.com>
#- 减少 chkconfig --list 
#- 增加 ip6tables / set +x
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加changelog

service smb restart; 
service nmb restart;

chkconfig smb on
chkconfig nmb on

set -x
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off
setenforce 0
set +x

chkconfig --list nmb 
chkconfig --list smb 
chkconfig --list iptables
chkconfig --list ip6tables
