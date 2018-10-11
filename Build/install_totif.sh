#!/bin/sh

# @Chernic : 增加samba的常用路径
# @changelog
## 2018-09-28 Chernic <chernic AT qq.com>

ProjectName="icip6_totif"
ProjectShort="totif"

# 非root用户操作则退出
######################################################
function NotRootOut(){
    [ $(id -u) != "0" ] && echo "Error: You must be root to run this script" && exit 0
};NotRootOut;

#{{ modified by zhao at 2018-10-01 begin!
#  -- 修复安装时出现“Unfound /home/focustar/icip6/script/functions/function_log.sh.  Aborting.”的问题

## 双目录查询并加载系统script
#######################################################
#function LoadIcip6Scripts(){
#    if [ -f /home/focustar/icip6/script/functions/function_log.sh ];then
#        . /home/focustar/icip6/script/functions/function_log.sh
#    else
#        if [ -f ./function_log.sh ];then
#            . ./function_log.sh
#        else
#            echo "Unfound /home/focustar/icip6/script/functions/function_log.sh.  Aborting." >&2; exit 1
#        fi
#    fi
#
#    if [ -f /home/focustar/icip6/script/functions/function_restore.sh ];then
#        . /home/focustar/icip6/script/functions/function_restore.sh
#    else
#        if [ -f ./function_restore.sh ];then
#            . ./function_restore.sh
#        else
#            echo "Unfound /home/focustar/icip6/script/functions/function_restore.sh.  Aborting." >&2; exit 1
#        fi
#    fi
#};LoadIcip6Scripts;
#
#LogPath=/home/focustar/icip6/log/${ProjectShort}/
## 初始化Log日志
#######################################################
#function ConfigureLog(){
#    if [ ! -e ${LogPath} ]; then mkdir -p ${LogPath}; fi
#    LogFile=${LogPath}/${ProjectName}-$(basename $0).log
#    # restore 源自上面两个sh文件
#    restore $LogFile 10240 10
#};ConfigureLog;

#加载日志函数
if [ -z "$IS_LOADED_LOG_FUNC" ]; then
  LocalDir=`pwd`;
  source "${LocalDir}/log.sh";
  echo "load log function:${IS_LOADED_LOG_FUNC}!"
fi

if [ -z "$LogFile" ]; then
  LocalDir=`pwd`;
  LogPath="${LocalDir}/log";
  if [ ! -e ${LogPath} ]; then mkdir -p ${LogPath}; fi
  LogFile=${LogPath}/${ProjectName}-$(basename $0).log
  echo "" > LogFile
fi

#}} modified by zhao at 2018-10-01 end!


IS_SUPPORT_CN=${IS_SUPPORT_CN:=false}

# 根据系统判断目录
arch=$(uname -m)
ver=$(uname -r | cut -d. -f4)
path=totif.${ver}.${arch}

if [ -d ./${path:=totif.xxx} ]; then
    cd ./${path:=totif.xxx};
    echo "running ${path:=totif.xxx}/install.sh"
    #sh ./install.sh
    source ./install.sh
    cd ..;
else
    if ($IS_SUPPORT_CN); then
        LOG_ERROR  "totif 安装失败: 找不到目录 ./${path:=totif.xxx} !" $LogFile;
    else
        LOG_ERROR  "totif install failed: ./${path:=totif.xxx} no exist!" $LogFile;
    fi
fi

# yum -y install samba-client cifs-utils
