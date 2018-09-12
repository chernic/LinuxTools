#!/bin/sh

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

