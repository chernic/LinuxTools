#!/bin/bash

##
# @file auto_mount_faxpath.sh
# @copyright 版权所有 (C) 广州市聚星源科技有限公司
# @brief  自动挂载 传真转换前文件/临时文件/传真转换后文件 等目录。
#
# 修订记录 2018-09-21
# @author   陈永亮
# @version  3.00
# @brief 传真路径挂载配置
#
##
thistitle=${thistitle:="传真路径挂载配置"}

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
    LogPath=/home/focustar/icip6/log/totif/iso/
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

StepCount=6
function FaxPathMountInfo(){
    dSrcIP="192.168.2.240"
    # 挂载源IP地址
    ########################################################################
    SrcIP=$(whiptail --title "设置 1 / $StepCount 挂载来源IP地址" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 挂载源IP地址
    默认[${dSrcIP}]
    " 12 80 ${dSrcIP} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "1 挂载来源IP地址:${SrcIP}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dSrcPath="/home/focustar/200_svn_icip6prj_totif/iso"
    # 挂载来源目录
    ########################################################################
    SrcPath=$(whiptail --title "设置 2 / $StepCount 挂载来源目录" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 挂载来源目录
    默认[${dSrcPath}]
    " 12 80 ${dSrcPath} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "2 挂载来源目录:${SrcPath}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dDstIP="192.168.2.177"
    # 挂载目标IP地址
    ########################################################################
    DstIP=$(whiptail --title "设置 3 / $StepCount 挂载目的IP地址" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 挂载目的IP地址
    默认[${dDstIP}]
    " 12 80 ${dDstIP} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "2 挂载目的IP地址:${DstIP}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dDstPath="/iso/iso"
    # 挂载目标目录
    ########################################################################
    DstPath=$(whiptail --title "设置 2 / $StepCount 挂载来源目录" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 挂载来源目录
    默认[${dDstPath}]
    " 12 80 ${dDstPath} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "2 挂载来源目录:${DstPath}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi
};FaxPathMountInfo;

function FaxInfoMakeSure(){
    $(whiptail --title "设置 5 / $StepCount 确认" \
    --yes-button "确定(Start)"  --no-button "退出(Exit)" \
    --yesno "\
    1 挂载源IP地址    : ${dSrcIP}
    2 挂载来源目录    : ${dSrcPath}
    3 挂载目标IP地址  : ${dDstIP}
    4 挂载目标目录    : ${dDstPath}

    是否确认${thistitle}?
    " 17 100 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi
};FaxInfoMakeSure;

__auto_mount() {
  local host=$1
  local remote_dir=$2
  local local_dir=$3

  if [ -e $local_dir ]; then
    if [ ! -d $local_dir ]; then exit -1; fi
    umount $local_dir
  else
    mkdir -p $local_dir
  fi

  mount -t nfs $host:$remote_dir $local_dir
  local rv=$?
  #if [ $rv -ne 0 ]; then echo "mount -t nfs $host:$remote_dir $local_dir fail"; fi
  if [ $rv -eq 0 ]; then
    echo "mount -t nfs $host:$remote_dir $local_dir";
    LOG_INFO "mount -t nfs $host:$remote_dir $local_dir" $LogFile;
  else
    echo "mount -t nfs $host:$remote_dir $local_dir fail";
    LOG_ERROR "mount -t nfs $host:$remote_dir $local_dir fail" $LogFile;
  fi

  return $rv
}

LOG_INFO "<<< start auto_mount.sh " $LogFile

__auto_mount "${dSrcIP}" "${dSrcPath}" "${dDstPath}"

# umount: /iso/iso: not mounted
# mount: wrong fs type, bad option, bad superblock on 192.168.2.240:/home/focustar/200_svn_icip6prj_totif/iso,
       # missing codepage or helper program, or other error
       # (for several filesystems (e.g. nfs, cifs) you might
       # need a /sbin/mount.<type> helper program)
       # In some cases useful info is found in syslog - try
       # dmesg | tail  or so
# mount -t nfs 192.168.2.240:/home/focustar/200_svn_icip6prj_totif/iso /iso/iso fail

# https://yq.aliyun.com/articles/120155

