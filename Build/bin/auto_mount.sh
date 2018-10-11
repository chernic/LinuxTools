#!/bin/bash

##
# @file auto_mount.sh
# @copyright 版权所有 (C) 广州市聚星源科技有限公司
# @brief  自动挂载录音/留言等目录。
# 
# 修订记录 
# @author   张泽钊
# @date 2017-05-03
# @brief First Version.
# 
##

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


LogPath=/home/focustar/icip6/log/auto_mount
if [ ! -e ${LogPath} ]; then mkdir -p ${LogPath}; fi
LogFile=${LogPath}/auto_mount.log
restore $LogFile 10240 10

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

#__auto_mount "192.168.227.55" "/home/ehang/prd/icip_record" "/home/ehang/prd/icip_record"; 

#__auto_mount "192.168.227.55" "/home/ehang/prd/leaveword" "/home/ehang/prd/leaveword"; 

LOG_INFO "<<< start auto_mount.sh " $LogFile;

lockfile="/home/ehang/prd/icip_record/I am 192.168.227.55"
if [ ! -e "$lockfile" ]; then
  LOG_WARN "Can't find mount lockfile:$lockfile" $LogFile;
  __auto_mount "192.168.227.55" "/home/ehang/prd/icip_record" "/home/ehang/prd/icip_record"; 
fi

lockfile="/home/ehang/prd/leaveword/I am 192.168.227.55"
if [ ! -e "$lockfile" ]; then
  LOG_WARN "Can't find mount lockfile:$lockfile" $LogFile;
  __auto_mount "192.168.227.55" "/home/ehang/prd/leaveword" "/home/ehang/prd/leaveword"; 
fi

LOG_INFO ">>> end auto_mount.sh " $LogFile;

