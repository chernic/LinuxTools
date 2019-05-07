https://mirrors.tuna.tsinghua.edu.cn/centos/6/isos/i386/CentOS-6.10-i386-bin-DVD1.iso

#!/bin/sh

# @Chernic : linux基本网络配置, 给初装的机器配置使用, 常手动配置
# @changelog
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
# 先关闭防火墙
/etc/init.d/iptables stop
/etc/init.d/ip6tables stop
chkconfig iptables off 
chkconfig ip6tables off 
chkconfig --level 2345 iptables off 
chkconfig --level 2345 ip6tables off 


setenforce 0

#https://www.cnblogs.com/operationhome/p/10207257.html
# 添加默认路由：
route add default  gw  192.168.2.1

cat /etc/sysconfig/network-scripts/route-eth0

echo "192.168.1.0/24 via 192.168.2.1 dev eth0" > /etc/sysconfig/network-scripts/route-eth0
echo  "" >> /etc/sysconfig/network-scripts/route-eth0
