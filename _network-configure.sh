# 硬件-网络连接-桥接模式(√)

/etc/sysconfig/network
NETWORKING=yes
HOSTNAME=el64cc
GATEWAY=192.168.2.1


/etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
HWADDR=00:0C:29:3F:AB:CD
BOOTPROTO="static"
IPADDR=192.168.2.197
NETMASK=255.255.255.0
IPV6INIT="no"
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE=Ethernet
UUID=04f18845-86b3-4ac2-bd6b-ca9a3d8e534f
DNS1=233.5.5.5
DNS2=233.6.6.6


/etc/resolv.conf
nameserver 233.5.5.5
nameserver 233.6.6.6
