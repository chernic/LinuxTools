#!/bin/sh

yum install samba

smbclient -L //192.168.1.101 -Ufocustar
# Enter focustar's password: 
# session setup failed: NT_STATUS_LOGON_FAILURE


groupadd focustar


useradd focustar -g focustar
# useradd：focustar 组已经存在 - 如果您想将此用户加入到该组，请使用 -g 参数。


pdbedit -a -u focustar
