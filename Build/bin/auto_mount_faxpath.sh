#!/bin/bash

##
# @file auto_mount_faxpath.sh
# @copyright 版权所有 (C) 广州市聚星源科技有限公司
# @brief  自动挂载 传真转换前文件/临时文件/传真转换后文件 等目录。
#
# 修订记录 2018-08-29
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


StepCount=6
######################################################
function FaxPathMountInfo(){
    dIpBSSV="10.101.70.221"
    # BS坐席服务器本地IP地址
    ########################################################################
    IpBSSV=$(whiptail --title "设置 1 / $StepCount BS坐席服务器本地IP地址" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 BS坐席服务器本地IP地址
    默认[${dIpBSSV}]
    " 12 80 ${dIpBSSV} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var1 BS 坐席服务器本地IP地址:${IpBSSV}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dIpCTI1="10.101.70.223"
    # CTI1服务器本地IP地址
    ########################################################################
    IpCTI1=$(whiptail --title "设置 2 / $StepCount CTI1服务器本地IP地址" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 CTI1服务器本地IP地址
    默认[${dIpCTI1}]
    " 12 80 ${dIpCTI1} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var2 CTI1   服务器本地IP地址:${IpCTI1}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dIpCTI2="10.101.70.224"
    # CTI2服务器本地IP地址
    ########################################################################
    IpCTI2=$(whiptail --title "设置 3 / $StepCount CTI2服务器本地IP地址" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 CTI2服务器本地IP地址
    默认[${dIpCTI2}]
    " 12 80 ${dIpCTI2} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var3 CTI2   服务器本地IP地址:${IpCTI2}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dIpCTI="10.101.70.225"
    # CTI服务器通用本地IP地址
    ########################################################################
    IpCTI=$(whiptail --title "设置 4 / $StepCount CTI服务器通用本地IP地址" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 CTI服务器通用本地IP地址
    默认[${dIpCTI}]
    " 12 80 ${dIpCTI} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var4 CTI服务器通用本地IP地址:${IpCTI}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dPathFaxReivSend="/home/focustar/apache-tomcat-6.0.37/webapps/FaxReivSend/"
    # 传真文件接收发送目录
    ########################################################################
    PathFaxReivSend=$(whiptail --title "设置 5 / $StepCount 传真文件接收发送目录" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with XShell(UTF-8) !!!

    请输入 传真文件接收发送目录
    默认[${dPathFaxReivSend}]
    " 12 80 ${dPathFaxReivSend} 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var5 传真文件接收发送目录:${PathFaxReivSend}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

}
FaxPathMountInfo

function FaxInfoMakeSure(){
    ########################################################################
    $(whiptail --title "设置 6 / $StepCount 确认" \
    --yes-button "确定(Start)"  --no-button "退出(Exit)" \
    --yesno "\
    Var1 BS 坐席服务器本地IP地址:${IpBSSV}
    Var2 CTI1   服务器本地IP地址:${IpCTI1}
    Var3 CTI2   服务器本地IP地址:${IpCTI2}
    Var4 CTI服务器通用本地IP地址:${IpCTI}
    Var5 传真文件接收发送目录   :${PathFaxReivSend}

    是否确认${thistitle}?
    " 17 100 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi
}
FaxInfoMakeSure

function ChangeKamailio(){
    while true
    do
        option_string=' # "退出(EXIT)"'
        [ -f ${KAMAILIO_initD} ]     && option_string=''${option_string}' 1'${STATE_KinitD}'    "'目标的目录:${KAMAILIO_initD}'"'
        [ -f ${KAMAILIO_LOCAL} ]     && option_string=''${option_string}' 2'${STATE_KLOCAL}'    "'当前的目录:${KAMAILIO_LOCAL}'"'

        OPTION=$( whiptail --title "修改kamailio服务" --nocancel --menu "\
        选择你想修改的文件
        ( \${dir_of_kamailio4} = ${dir_of_kamailio4} )
        ( \${dir_of_kamailio5} = ${dir_of_kamailio5} )
" 18 80 8 ${option_string} 3>&1 1>&2 2>&3 )

        case ${OPTION} in
            "1[已修改]");;
            "2[已修改]");;
            1)
                STATE_KinitD="[已修改]";;
            2)
                STATE_KLOCAL="[已修改]";;
            *)
                LOG_WARN "${thistitle} 取消." $LogFile;
                break
            ;;
        esac
    done
}

ChangeKamailio

LOG_WARN "${thistitle} 完成." $LogFile;

exit

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

#__auto_mount "192.168.227.55" "${PathFaxReivSend}" "${PathFaxReivSend}";

LOG_INFO "<<< start auto_mount.sh " $LogFile;

lockfile="/home/ehang/prd/icip_record/I am 192.168.227.55"
if [ ! -e "$lockfile" ]; then
  LOG_WARN "Can't find mount lockfile:$lockfile" $LogFile;
  __auto_mount "192.168.227.55" "${PathFaxReivSend}" "${PathFaxReivSend}";
fi
