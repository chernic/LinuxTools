#!/bin/sh

# @Chernic : FreeSWITCH �ȷ�������
# @changelog
## 2018-09-12 Chernic <chernic AT qq.com>
#- ����changelog
#- ��ʱʹ��, �ɽ�һ���޸�

#��ʹ��
chkconfig nmb         on
chkconfig smb         on
chkconfig freeswitch  on
chkconfig mysql       on

service nmb         restart
service smb         restart
service freeswitch  restart
service mysql       restart

service nmb         status
service smb         status
service freeswitch  status
service mysql       status
