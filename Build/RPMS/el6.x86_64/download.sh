#!/bin/sh

ProjectName="icip6_totif"
ProjectShort="totif"

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

LogPath=/home/focustar/icip6/log/${ProjectShort}/
# 初始化Log日志
######################################################
function ConfigureLog(){
    if [ ! -e ${LogPath} ]; then mkdir -p ${LogPath}; fi
    LogFile=${LogPath}/${ProjectName}-$(basename $0).log
    # restore 源自上面两个sh文件
    restore $LogFile 10240 10
};ConfigureLog;



LOG_WARN "<<<  下载 ${ProjectName} 所需rpm包" | tee $LogFile;


LOG_WARN "" $LogFile;
LOG_WARN "Step 0.1" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "Check yum" $LogFile;

if [ $? != 0 ]; then
   LOG_ERROR  "无法找到yum, 请先配置好yum" $LogFile;
   exit
fi
#######################################################################################################
exit 

LOG_WARN "" $LogFile;
LOG_WARN "Step 0.2" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "yum -y localinstall createrepo" $LogFile;

if [ $? != 0 ]; then
   LOG_ERROR  "请先为系统[CentOS]使用作为yum软件安装源" $LogFile;
   exit
fi
#######################################################################################################

LOG_WARN "" $LogFile;
LOG_WARN "Step 2" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;

LOG_WARN "yum -y install icip6prj_totif" $LogFile;
yum -y --nogpgcheck localinstall icip6prj_totif-*.rpm | tee -a $LogFile;
if [ $? != 0 ]; then
   LOG_ERROR  "Fail to install icip6prj_totif" $LogFile;
   exit
fi
#######################################################################################################
