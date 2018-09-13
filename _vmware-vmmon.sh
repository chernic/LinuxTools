#!/bin/sh

# @Chernic : vmware 虚拟机启动报错：Could not open /dev/vmmon
# @changelog
## 2018-09-13 Chernic <chernic AT qq.com>
#- 增加changelog
#- via https://blog.csdn.net/gsying1474/article/details/40684071
#- from https://communities.vmware.com/message/2442783

echo "tar vmmon.tar"
cd /tmp
tar xvf /usr/lib/vmware/modules/source/vmmon.tar

echo "make vmmon.ko"
cd vmmon-only/
make

echo "copy vmmon.ko"
cp vmmon.ko /lib/modules/2.6.32-504.el6.x86_64/misc/vmmon.ko
modprobe vmmon
