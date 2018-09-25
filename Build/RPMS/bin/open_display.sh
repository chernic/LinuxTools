#!/bin/bash

##
# @file auto_mount_faxpath.sh
# @copyright 版权所有 (C) 广州市聚星源科技有限公司
# @brief  本文件解决以下报错
# 
# [root@cti01 usr]# sudo libreoffice --convert-to pdf 123.doc
# Failed to open display
# convert /home/focustar/icip6prj_totif/bin/usr/123.doc -> /home/focustar/icip6prj_totif/bin/usr/123.pdf using 
# Error: Please reverify input parameters...


# 修订记录 2018-08-30
# @author   陈永亮
# @version  3.00
# @brief 2.240上测试doc转pdf成功
#
##
thistitle=${thistitle:="开启open_display"}

# 非root用户操作则退出
######################################################
function NotRootOut(){
    [ $(id -u) != "0" ] && echo "Error: You must be root to run this script" && exit 0
};NotRootOut;

# 双目录查询并加载系统script
######################################################
function LoadIcip6Scripts(){
    if [ -f /home/focustar/icip6/script/functions/function_log.sh ];then
        . /home/focustar/icip6/script/functions/function_log.sh
    else
        if [ -f ./function_log.sh ];then
            . ./function_log.sh
        else
            echo "Unfound /home/focustar/icip6/script/functions/function_log.sh.  Aborting." >&2; exit 1
        fi
    fi

    if [ -f /home/focustar/icip6/script/functions/function_restore.sh ];then
        . /home/focustar/icip6/script/functions/function_restore.sh
    else
        if [ -f ./function_restore.sh ];then
            . ./function_restore.sh
        else
            echo "Unfound /home/focustar/icip6/script/functions/function_restore.sh.  Aborting." >&2; exit 1
        fi
    fi
};LoadIcip6Scripts;


# 初始化Log日志
######################################################
function ConfigureLog(){
    LogPath=/home/focustar/icip6/log/totif/
    if [ ! -e ${LogPath} ]; then mkdir -p ${LogPath}; fi
    LogFile=${LogPath}/$(basename $0).log
    # restore 源自上面两个sh文件
    restore $LogFile 10240 10
};ConfigureLog;

LOG_INFO "<<<  ${thistitle} 开始 $(basename $0)!" $LogFile;

# 确认whiptail可用
######################################################
function Confirm_whiptail_is_OK(){
    if command -v whiptail >/dev/null 2>&1;then
        LOG_INFO "whiptail is ready!" $LogFile;
    else
        LOG_ERROR "I require whiptail but it's not installed.  Aborting." $LogFile; exit 1
    fi
};Confirm_whiptail_is_OK;

LOG_INFO 即将开始vncserver, 请根据指示输入密码
vncserver

export DISPLAY=localhost:1

xhost +
