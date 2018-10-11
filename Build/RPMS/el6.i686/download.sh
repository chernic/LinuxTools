#!/bin/sh

# @Chernic : 增加samba的常用路径
# @changelog
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加changelog
#- 未开始编写脚本

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



echo " " | tee -a $LogFile;
LOG_WARN "Step 0.1" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "Check yum" $LogFile;
command -v yum  | tee -a $LogFile;
if [ $? != 0 ]; then
   LOG_ERROR  "无法找到 指令 yum, 请先配置好yum !!!" $LogFile;
   exit
fi
#######################################################################################################



echo " " | tee -a $LogFile;
LOG_WARN "Step 0.2" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "yum clean all" $LogFile;
yum clean all | tee -a $LogFile;
LOG_WARN "yum repolist | grep repolist | cut  -d' ' -f2" $LogFile;
sumrepo=$( yum repolist | grep repolist | cut  -d' ' -f2| sed 's@,@@g' );
echo "grep repolist = ${sumrepo}" | tee -a $LogFile;
if ! [[ ${sumrepo} -gt 0 ]]; then
    LOG_ERROR  "请先配置好yum源 !!!"                                                $LogFile;
    echo " " | tee -a $LogFile;
    LOG_ERROR  "[离线安装] 请按以下步骤"                                             $LogFile;
    LOG_ERROR  "1  配置使用光盘作为yum软件安装源"                                     $LogFile;
    echo " " | tee -a $LogFile;
    LOG_ERROR  "[在线安装] 请按以下步骤"                                             $LogFile;
    LOG_ERROR  "1  确保外网网络可用  "                                               $LogFile;
    LOG_ERROR  "2  自行配置yum源或使用一下指令安装yum源  "                             $LogFile;
    LOG_ERROR  "   yum localinstall centos-release-chernic-2018-*.rpm  "           $LogFile;
    LOG_ERROR  "   yum localinstall centos-release-chernic-Netease163-*.rpm  "     $LogFile;
    LOG_ERROR  "3  必要时手工检查 yum源的repo文件, Disable不必要的yum 源"              $LogFile;
    LOG_ERROR  "   repo文件 位于 /etc/yum.repo/ 目录下面  "                          $LogFile;
    exit
    # 若 DNS  错误  sumrepo=空    ret=1;  => 会报错   ERROR
    # 若 REPO 错误  sumrepo=空    ret=1;  => 会报错   ERROR
    # 若 可用       sumrepo=19226 ret=0;  => 不报错
fi
#######################################################################################################




echo " " | tee -a $LogFile;
LOG_WARN "Step 1" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;
LOG_WARN "yum -y localinstall createrepo" $LogFile;
yum -y localinstall createrepo-*.rpm | tee -a $LogFile;
if [ $? != 0 ]; then
   LOG_ERROR  "Fail to install createrepo" $LogFile;
   exit
fi
#######################################################################################################



echo " " | tee -a $LogFile;
LOG_WARN "Step 2" $LogFile;
LOG_WARN "----------------------------------------------------------------------------------" $LogFile;

LOG_WARN "yum -y install icip6prj_totif" $LogFile;
yum --nogpgcheck localinstall icip6prj_totif-*.rpm --downloadonly --downloaddir=.
if [ $? != 0 ]; then
   LOG_ERROR  "Fail to install icip6prj_totif" $LogFile;
   exit
fi
#######################################################################################################
