#!/bin/sh

service smb restart; 
service nmb restart;

chkconfig smb on

service iptables stop
chkconfig iptables off
setenforce 0
