#!/bin/sh

# @Chernic : createlocalrepo.sh
# @changelog
## 2018-09-30 Chernic <chernic AT qq.com>
#  同时支持el6.i686和el6.x86_64
#  错误先写到错误文件, 再从中读取

ProjectName="icip6_totif"
ProjectShort="totif"
LogPath=/home/focustar/icip6/log/${ProjectShort}/

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
    if [ ! -e ${LogPath} ]; then mkdir -p ${LogPath}; fi
    LogFile=${LogPath}/${ProjectName}-$(basename $0).log
    LogError=${LogPath}/${ProjectName}-$(basename $0).error.log
    # restore 源自上面两个sh文件
    restore $LogFile 10240 10
};ConfigureLog;

# 获取系统版本
getSystemFlag(){
    sys_ver=$(uname -r | cut -d. -f4)
    sys_arch=$(uname -m)

    case "${sys_ver}.${sys_arch}" in
      el5.i*86) # i386 i686
        system_flag="el5.i386"
        ;;
      el5.x86_64)
        system_flag="el5.x86_64"
        ;;
      el6.i*86)# i386 i686
        system_flag="el6.i686"
        ;;
      el6.x86_64)
        system_flag="el6.x86_64"
        ;;
      *)
        echo "Error: This system version is not supported : ${sys_ver}"
        echo "Error: This system arch    is not supported : ${sys_arch}"
        exit 0
        ;;
    esac
}

# 检查命令
Checkcommand(){
    command -v "$1" >>  $LogFile;
    # 此命令支持空输入, 不必再次检查
    if [ $? != 0 ]; then
      return 1
    fi
    return 0
}


LOG_INFO "" $LogFile;
LOG_INFO "" $LogFile;
LOG_INFO "<<<  安装 ${ProjectName}" $LogFile;

rungetSystemFlag(){
    LOG_INFO "" $LogFile;
    LOG_INFO " ********************************************************" $LogFile;
    LOG_INFO " * getSystemFlag" $LogFile;
    LOG_INFO " *" $LogFile;
    getSystemFlag;
};
rungetSystemFlag;

LOG_INFO "${sys_ver}" $LogFile;
LOG_INFO "${sys_arch}" $LogFile;
LOG_INFO "${system_flag}" $LogFile;

runCheckcommandyum(){
    LOG_INFO "" $LogFile;
    LOG_INFO " ********************************************************" $LogFile;
    LOG_INFO " * Checkcommand yum" $LogFile;
    LOG_INFO " *" $LogFile;
    Checkcommand yum;
    if [ $? != 0 ]; 
    then 
        LOG_ERROR "yum is not installed" $LogFile; 
        exit 0;
    fi
};
runCheckcommandyum;

runCheckcommandcreaterepo(){
    cat /dev/null > $LogError;
    LOG_INFO "" $LogFile;
    LOG_INFO " ********************************************************" $LogFile;
    LOG_INFO " * Checkcommand createrepo" $LogFile;
    LOG_INFO " * Checkcommand createrepo" $LogError;
    LOG_INFO " *" $LogFile;
    Checkcommand createrepo; 
    if [ $? != 0 ];
    then
        yum -y localinstall createrepo-*${sys_ver}.noarch.rpm >> $LogFile 2> $LogError; ret=$?;
        if [ -s $LogError ];
        then
            LOG_ERROR "yum -y localinstall createrepo" $LogFile > /dev/null;
            LOG_ERROR "yum -y localinstall createrepo" $LogError;
            cat $LogError
            exit 
        fi

        if [ $ret != 0 ]; then
           LOG_ERROR  "Fail to install createrepo" $LogFile;
           exit 0
        fi
    fi
};
runCheckcommandcreaterepo;

runlocalinstallchernic_release(){
    cat /dev/null > $LogError;
    LOG_INFO "" $LogFile;
    LOG_INFO " ********************************************************" $LogFile;
    LOG_INFO " * yum -y localinstall chernic-release" $LogFile;
    LOG_INFO " *" $LogFile;
        yum -y localinstall chernic-release-*${system_flag}.rpm >> $LogFile 2> $LogError; ret=$?;
        if [ -s $LogError ];
        then
            LOG_ERROR "yum -y localinstall chernic-release" $LogFile > /dev/null;
            LOG_ERROR "yum -y localinstall chernic-release" $LogError;
            cat $LogError
            exit 
        fi
        
        if [ $ret != 0 ]; then
           LOG_ERROR "yum -y localinstall chernic-release" $LogFile  > /dev/null;
           exit
        fi
};
runlocalinstallchernic_release;

sedchernic_release_repo(){
    #yum clean all;yum makecache;yum repolist;
    REPO=chernic-release.repo
    if [ -f /etc/yum.repos.d/${REPO} ];then
        LOG_INFO "sed /etc/yum.repos.d/${REPO} : " $LogFile;
        LOG_WARN "  baseurl=file://$(pwd)/${system_flag} " $LogFile;
        sed -i "s@^baseurl.*@baseurl=file://$(pwd)/${system_flag}@"    /etc/yum.repos.d/${REPO}

        LOG_INFO "sed /etc/yum.repos.d/${REPO} : " $LogFile;
        LOG_WARN "  enabled=1" $LogFile;
        sed -i "s@^enabled.*@enabled=1@"                /etc/yum.repos.d/${REPO}
    fi
};
sedchernic_release_repo;
yum repolist


####### ERROR LIST
# [2018-09-30 03:05:11][error]: yum -y localinstall chernic-release
# Cannot add package chernic-release-2018-09.20.el6.x86_64.rpm to transaction. Not a compatible architecture: x86_64
# [2018-09-30 03:05:11][error]: yum -y localinstall chernic-release
