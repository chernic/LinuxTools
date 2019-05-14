#!/bin/sh

# @Chernic : 重启samba
# @changelog
## 2019-05-14 Chernic <chernic AT qq.com>
#- 减少 永久关闭setenforce v2
## 2019-05-07 Chernic <chernic AT qq.com>
#- 减少 chkconfig --list 
#- 增加 ip6tables / set +x
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加changelog


set -x
service smb restart; 
service nmb restart;
chkconfig smb on
chkconfig nmb on
set +x
echo


set -x
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables off
set +x
echo


chkconfig --list nmb 
chkconfig --list smb 
chkconfig --list iptables
chkconfig --list ip6tables
echo


set -x
# 临时关闭setenforce
setenforce 0
/usr/sbin/sestatus -v
set +x
echo


set -x
# 永久关闭setenforce
sed -i "s@SELINUX=enforcing@SELINUX=disabled@g"  /etc/selinux/config
set +x
cat /etc/selinux/config | grep "^SELINUX="
echo

