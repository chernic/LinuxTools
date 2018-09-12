#!/bin/sh

# @brief linux基本网络配置, 给初装的机器配置使用, 常手动配置
# @changelog
## 2018-09-12 Chernic <chenyongl AT focustar.net>
#- 增加changelog

echo "you maight not run this but just have a look"
exit 

# 硬件-网络连接-桥接模式(√)

只需要按实际情况修改 
DEVICE 
HWADDR 
NETMASK
IPADDR

/etc/sysconfig/network
NETWORKING=yes
HOSTNAME=el64cc
GATEWAY=192.168.2.1


/etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
HWADDR=00:0C:29:3F:AB:CD
TYPE=Ethernet
UUID=04f18845-86b3-4ac2-bd6b-ca9a3d8e534f
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.2.197
NETMASK=255.255.255.0
IPV6INIT=no
DNS1 192.168.2.1
DNS2=233.5.5.5


/etc/resolv.conf
nameserver 192.168.2.1
nameserver 233.5.5.5
