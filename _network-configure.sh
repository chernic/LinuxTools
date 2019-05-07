#!/bin/sh
# @Chernic : linux基本网络配置, 给初装的机器配置使用, 常手动配置
# @changelog
## 2019-05-07 Chernic <chernic AT qq.com>
# 防火墙       iptables
# 防火墙       ip6tables
# 防火墙       setenforce
# 默认路由     route
# ntp同步时间  ntpdate
# 调整硬件时间 hwclock
# 管理服务     chkconfig
## 2018-09-29 Chernic <chernic AT qq.com>
#- 增加配置前实现检IP未被占用
#- 增加一些大纲式注释
## 2018-09-13 Chernic <chernic AT qq.com>
#- 强调(必须修改项目)
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加开机启动network
#- 增加对外网的ping测试
#- 增加changelog

echo "you maight not run this but just have a look"
exit 

#########################################################
# 硬件-网络连接-桥接模式(√)

#########################################################
# 尝试ping 看地址是否被占用
ping 192.168.2.180

#########################################################
# 需要按实际情况修改 
DEVICE 
HWADDR 
NETMASK
IPADDR

#########################################################
# 而且根据本公司环境必须配置
GATEWAY   (必须)
DNS1      (必须)
DNS2      (必须)
 cd 
#########################################################
# 检验配置是否成功
chkconfig network on
service network restart
ping mirrors.163.com

vim /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=el64cc
GATEWAY=192.168.2.1


vim /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
HWADDR=00:0C:29:3F:AB:CD:
TYPE=Ethernet
UUID=04f18845-86b3-4ac2-bd6b-ca9a3d8e534f
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.2.180
NETMASK=255.255.255.0
IPV6INIT=no
DNS1=192.168.2.1
DNS2=233.5.5.5

vim /etc/resolv.conf
nameserver 192.168.2.1
nameserver 233.5.5.5

# 2018-11-2 修改完之后要重启. 可能只需重启某些服务即可, 但是...

chkconfig smb on
chkconfig nmb on
service smb restart
service nmb restart


# RHEL6.4 网络配置
# 关闭防火墙
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
setenforce 0


#https://www.cnblogs.com/operationhome/p/10207257.html
# 添加默认路由：
route add default  gw  192.168.2.1
# 添加默认路由：为开启启动
cat /etc/sysconfig/network-scripts/route-eth0
echo "192.168.1.0/24 via 192.168.2.1 dev eth0" > /etc/sysconfig/network-scripts/route-eth0
echo  "" >> /etc/sysconfig/network-scripts/route-eth0


# https://www.cnblogs.com/itxiongwei/p/5556558.html
# 启用ntp自动同步虚拟机时间
yum install -y ntpdate
 # [root@buildTAS TAS]# ntpdate time.nist.gov
# 7 May 11:53:53 ntpdate[15193]: the NTP socket is in use, exiting
service ntpd stop
ntpdate ntp.api.bz
service ntpd start


# 1. 同步时间成功后调整硬件时间
# 2. 执行成功后， 查看系统硬件时间（不出意外的话，现在date和hwclock现实的时间均为internet时间）
hwclock -w
date
hwclock


# 设置以上所有服务
#
chkconfig --level 2345 iptables off 
chkconfig --level 2345 ip6tables off 
chkconfig --level 2345 ntpd on 

chkconfig --list iptables
chkconfig --list ip6tables
chkconfig --list ntpd
