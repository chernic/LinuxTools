#!/bin/bash

##
# @file auto_mount_faxpath.sh
# @copyright 版权所有 (C) 广州市聚星源科技有限公司
# @brief  
#
# 修订记录 2018-08-30
# @author   陈永亮
# @version  3.00
# @brief 2.240上 测试doc转pdf 成功
#
##
thistitle=${thistitle:="测试doc转pdf"}

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

FileInput="ConvertThisDOC2Pdf.doc"
FileOutPut="ConvertThisDOC2Pdf.pdf"

if [ -e "${FileOutPut}" ]; then
    rm "ConvertThisDOC2Pdf.pdf"
fi 

if [ -e "${FileInput}" ]; then
    LOG_WARN "文件已准备 ${FileInput}" $LogFile;
fi 

LOG_WARN "export HOME=/tmp && libreoffice --headless --convert-to pdf ${FileInput} --outdir . " $LogFile;
export HOME=/tmp && libreoffice --headless --convert-to pdf ${FileInput} --outdir . 

if [ -e "${FileOutPut}" ]; then
    LOG_WARN "文件已生成 ${FileOutPut}" $LogFile;
    echo 
    LOG_WARN "文件转换环境可用" $LogFile;
else
    echo 
    LOG_ERROR "文件转换环境不可用, 请运行 ./open_display.sh" $LogFile;
    LOG_ERROR "若不成功请联系开发者, 并附带/home/focustar/icip6/log/totif/下的日志" $LogFile;
    LOG_ERROR "或尝试运行 yum install libreoffice" $LogFile;
fi 
