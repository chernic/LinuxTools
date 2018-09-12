#!/bin/bash

# @brief 将FreeSWITCH目录增加权限, 以使samba可访问

# changelog
## 2018-09-12 Chernic <chenyongl AT focustar.net>
- 增加changelog

##
# @file configure_odbc_for_totif.sh
# @copyright 版权所有 (C) 广州市聚星源科技有限公司
# @brief 将FreeSWITCH目录增加权限, 以使samba可访问
#
# 修订记录 2018-09-12
# @author   陈永亮
# @version  1.00
#

##
# vim /etc/samba/smb.conf 
# [freeswitch]
        # path = /usr/local/freeswitch-1.4.26/
        # comment = freeswitch
        # browseable = yes
        # writable = yes
# ;       valid users = %S
# ;       valid users = MYDOMAIN\%S

usermod -aG freeswitch focustar; 

id focustar;

chmod 775 /usr/local/freeswitch-1.4.26/;
ll /usr/local/

chmod 775 /usr/local/freeswitch-1.4.26/conf;
ll /usr/local/freeswitch-1.4.26/

