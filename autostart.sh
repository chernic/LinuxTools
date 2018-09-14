#!/bin/sh
#chkconfig: 2345 99 99
#description:开机自动启动的脚本程序

### BEGIN INIT INFO
# Provides: autostart.sh
# Required-Start: 
# Required-Stop:  
# Default-Start: 0 1 2 3 4 5 6
# Default-Stop: 0 1 2 3 4 5 6
# Short-Description: start|stop|restart|try-restart|status|force-reload vncserver
# Description: control vncserver which exports your desktop
### END INIT INFO

date '+%Y-%m-%d %H:%M:%S' >> /home/chernic/log/autostart.sh.log
echo ">-------------- autostart.sh start----------------<" >> /home/chernic/log/autostart.sh.log

# 1 加载vmware 模块
/sbin/modprobe modprobe vmmon
echo ">-- modprobe vmmon" >> /home/chernic/log/autostart.sh.log

/usr/bin/vmware-modconfig --console --install-all
echo ">-- vmware-modconfig --console --install-all" >> /home/chernic/log/autostart.sh.log

# @Chernic : 个人开机运行脚本
# @changelog
## 2018-09-14 Chernic <chernic AT qq.com>
#- 由于不可控因素, 特意增加增加此脚本

# 1  因为 service vncserver restart 无法成功启动vnc服务
# 2  所以 chkconfig vncserver off
#    vncserver      	0:关闭	1:关闭	2:关闭	3:关闭	4:关闭	5:关闭	6:关闭
# 3  但是vncserver指令可成功开启一个vnc服务
# 开启vnc服务
/usr/bin/vncserver
echo ">-- vncserver" >> /home/chernic/log/autostart.sh.log

date '+%Y-%m-%d %H:%M:%S' >> /home/chernic/log/autostart.sh.log
echo  "autostart.sh done" >> /home/chernic/log/autostart.sh.log

