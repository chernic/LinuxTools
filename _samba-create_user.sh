#!/bin/sh

# @brief 为samba增加用户
# @changelog
## 2018-09-12 Chernic <chenyongl AT focustar.net>
#- 增加changelog

yum install samba
yum install samba-client

smbclient -L //192.168.1.101 -Ufocustar
# Enter focustar's password: 
# session setup failed: NT_STATUS_LOGON_FAILURE


groupadd focustar


useradd focustar -g focustar
# useradd：focustar 组已经存在 - 如果您想将此用户加入到该组，请使用 -g 参数。


pdbedit -a -u focustar
