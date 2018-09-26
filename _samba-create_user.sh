#!/bin/sh

# @Chernic : 为samba增加用户
# @changelog
## 2018-09-26 Chernic <chernic AT qq.com>
#- 增加对/home/focustar的权限的修改
## 2018-09-12 Chernic <chernic AT qq.com>
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
chmod 766 /home/focustar


groupadd chernic
useradd chernic -g chernic
# useradd：focustar 组已经存在 - 如果您想将此用户加入到该组，请使用 -g 参数。
pdbedit -a -u chernic
chmod 766 /home/chernic


# ============================================================================================================
# ============================================================================================================
# Dependencies Resolved
# ============================================================================================================
 # Package                           Arch               Version                        Repository        Size
# ============================================================================================================
# Installing:
 # samba                             x86_64             3.6.23-51.el6                  base             5.1 M
# Installing for dependencies:
 # avahi-libs                        x86_64             0.6.25-17.el6                  base              55 k
 # cups-libs                         x86_64             1:1.4.2-79.el6                 base             323 k
 # gnutls                            x86_64             2.12.23-22.el6                 base             389 k
 # libjpeg-turbo                     x86_64             1.2.1-3.el6_5                  base             174 k
 # libpng                            x86_64             2:1.2.49-2.el6_7               base             182 k
 # libtalloc                         x86_64             2.1.5-1.el6_7                  base              26 k
 # libtdb                            x86_64             1.3.8-3.el6_8.2                base              40 k
 # libtevent                         x86_64             0.9.26-2.el6_7                 base              29 k
 # libtiff                           x86_64             3.9.4-21.el6_8                 base             346 k
 # perl                              x86_64             4:5.10.1-144.el6               base              10 M
 # perl-Module-Pluggable             x86_64             1:3.90-144.el6                 base              41 k
 # perl-Pod-Escapes                  x86_64             1:1.04-144.el6                 base              33 k
 # perl-Pod-Simple                   x86_64             1:3.13-144.el6                 base             213 k
 # perl-libs                         x86_64             4:5.10.1-144.el6               base             579 k
 # perl-version                      x86_64             3:0.77-144.el6                 base              52 k
 # samba-common                      x86_64             3.6.23-51.el6                  base              10 M
 # samba-winbind                     x86_64             3.6.23-51.el6                  base             2.2 M
 # samba-winbind-clients             x86_64             3.6.23-51.el6                  base             2.0 M

# Transaction Summary
# ============================================================================================================
# Install      19 Package(s)

# Total download size: 32 M
