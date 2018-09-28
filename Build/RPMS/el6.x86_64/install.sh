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



LOG_WARN "<<<  安装 ${ProjectName}" | tee $LogFile;


LOG_WARN "" $LogFile;
LOG_WARN "Step 0.1" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "Check yum" $LogFile;
command -v yum;
if [ $? != 0 ]; then
   LOG_ERROR  "无法找到yum, 请先配置好yum" $LogFile;
   exit
else
   echo ""
fi
#######################################################################################################
exit 

LOG_WARN "" $LogFile;
LOG_WARN "Step 0.2" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "yum repolist | grep repolist | cut  -d' ' -f2" $LogFile;
yum repolist | grep repolist | cut  -d' ' -f2
if [ $? != 0 ]; then
   LOG_ERROR  "请先为系统[CentOS]使用光盘作为yum软件安装源" $LogFile;
   exit
fi
#######################################################################################################
exit


LOG_WARN "" $LogFile;
LOG_WARN "Step 1" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "yum -y localinstall createrepo" $LogFile;
yum -y localinstall createrepo-*.rpm | tee -a $LogFile;
if [ $? != 0 ]; then
   LOG_ERROR  "Fail to install createrepo" $LogFile;
   exit
fi
#######################################################################################################



LOG_WARN "" $LogFile;
LOG_WARN "Step 2" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
yum info chernic-release >/dev/null 2>&1 ; 
if [ $? = 0 ]; then
   LOG_WARN "yum -y remove chernic-release" $LogFile;
   yum -y remove chernic-release >/dev/null 2>&1
fi

LOG_WARN "yum -y localinstall chernic-release" $LogFile;
yum -y localinstall chernic-release-*.rpm | tee -a $LogFile;
if [ $? != 0 ]; then
   LOG_ERROR  "Fail to install chernic-release" $LogFile;
   exit
fi
#######################################################################################################



LOG_WARN "" $LogFile;
LOG_WARN "Step 3" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "createrepo -v ." $LogFile;
createrepo -v . | tee -a $LogFile;
if [ $? != 0 ]; then
   LOG_ERROR  "Fail to create repo" $LogFile;
   exit
fi

#yum clean all;yum makecache;yum repolist;
REPO=chernic-release.repo
if [ -f /etc/yum.repos.d/${REPO} ];then
    LOG_INFO "sed /etc/yum.repos.d/${REPO} : " $LogFile;
    LOG_WARN "  baseurl=file://$(pwd) " $LogFile;
    sed -i "s@^baseurl.*@baseurl=file://$(pwd)@"    /etc/yum.repos.d/${REPO}

    LOG_INFO "sed /etc/yum.repos.d/${REPO} : " $LogFile;
    LOG_WARN "  enabled=1" $LogFile;
    sed -i "s@^enabled.*@enabled=1@"                /etc/yum.repos.d/${REPO}
fi

yum repolist | tee -a $LogFile;
#######################################################################################################



LOG_WARN "" $LogFile;
LOG_WARN "Step 4" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;

LOG_WARN "yum -y install icip6prj_totif" $LogFile;
yum -y localinstall icip6prj_totif-*.rpm | tee -a $LogFile;
if [ $? != 0 ]; then
   LOG_ERROR  "Fail to install icip6prj_totif" $LogFile;
   exit
fi
#######################################################################################################



LOG_WARN "" $LogFile;
LOG_WARN "Step 5" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
if [ -f /etc/yum.repos.d/${REPO} ];then
    LOG_INFO "sed /etc/yum.repos.d/${REPO} : " $LogFile;
    LOG_WARN "  enabled=0" $LogFile;
    sed -i "s@^enabled.*@enabled=0@"    /etc/yum.repos.d/${REPO}
fi
#######################################################################################################
yum repolist | tee -a $LogFile;