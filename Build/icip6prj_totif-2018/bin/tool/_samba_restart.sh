#!/bin/sh

service smb restart; 
service nmb restart;
service iptables stop
setenforce 0