#!/bin/bash

##
# @file configure_odbc_for_totif.sh
# @copyright 版权所有 (C) 广州市聚星源科技有限公司
# @brief TOTIF的odbc连接mysql配置
#
# 修订记录 2018-08-29
# @author   陈永亮
# @version  3.00
# @brief 将通用操作函数化
#
##
thistitle=${thistitle:="[为 TOTIF 连接 mysql 配置 odbc]"}

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

LOG_INFO "<<<  $(basename $0) 开始${thistitle} !" $LogFile;

# 确认whiptail可用
######################################################
function Confirm_whiptail_is_OK(){
    if command -v whiptail >/dev/null 2>&1;then
        LOG_INFO "whiptail is ready!" $LogFile;
    else
        LOG_ERROR "I require whiptail but it's not installed.  Aborting." $LogFile; exit 1
    fi
};Confirm_whiptail_is_OK;


StepCount=7
# 交互:输入和确认Odbc配置信息
######################################################
function OdbcIniInfo(){
    dPathOdbcFile="/etc/odbc.ini"
    # 本服务器odbc.ini所在目录
    ########################################################################
    PathOdbcFile=$(whiptail --title "设置 0 / ${StepCount} 本服务器odbc.ini所在目录" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with UTF-8 !!!

    请输入 本服务器odbc.ini所在目录 
    默认[${dPathOdbcFile}]
    " 12 80 "${dPathOdbcFile}" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var0 本服务器odbc.ini所在目录:${PathOdbcFile}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi
    
    if [ ! -e "${dPathOdbcFile}" ]; then
        LOG_ERROR "根据你提供的路径, 找不到文件 ${dPathOdbcFile}, 请确认已经安装 unixODBC " $LogFile;
        LOG_ERROR "或尝试 yum install unixODBC" $LogFile;
        exit
    fi

    dDataSource="FOCUS_TOTIF"
    # DataSource(DSN)
    ########################################################################
    DataSource=$(whiptail --title "设置 1 / ${StepCount} 数据源名称(DSN)" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with UTF-8 !!!

    请输入 数据源名称(DSN)
    默认[${dDataSource}]
    " 12 80 "${dDataSource}" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var1 数据源名称(DSN):${DataSource}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dDriver="MySQL1 ODBC 5.1 Driver"
    dDriverx64="MySQL ODBC 5.1 Driver x64"
    # Driver(Driver)
    ########################################################################
    Driver=$(whiptail --title "设置 2 / ${StepCount} odbc驱动(Driver)" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with UTF-8 !!!

    请输入 odbc驱动(Driver)
    默认[${dDriver}]
    默认[${dDriverx64}]
    " 12 80 "${dDriverx64}" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var2 odbc驱动(Driver):${Driver}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dDatabase="ICIP6"
    # Database(DATABASE)
    ########################################################################
    Database=$(whiptail --title "设置 3 / ${StepCount} 数据库(DATABASE)" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with UTF-8 !!!

    请输入 数据库(DATABASE)
    默认[${dDatabase}]
    " 12 80 "${dDatabase}" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var3 数据库(Driver):${Database}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi
    
    dServer="192.168.2.240"
    # Server(SERVER)
    ########################################################################
    Server=$(whiptail --title "设置 4 / ${StepCount} 数据库所在服务器IP(SERVER)" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with UTF-8 !!!

    请输入 数据库所在服务器IP(SERVER)
    默认[${dServer}]
    " 12 80 "${dServer}" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var4 本服务器IP(Driver):${Server}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dUserName="root"
    # UserName(UID)
    ########################################################################
    UserName=$(whiptail --title "设置 5 / ${StepCount} 用户名(UID)" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with UTF-8 !!!

    请输入 用户名(UID)
    默认[${dUserName}]
    " 12 80 "${dUserName}" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var5 用户名(UID):${UserName}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

    dPassword="focustar"
    # Password(PWD)
    ########################################################################
    Password=$(whiptail --title "设置 6 / ${StepCount} 密码(PWD)" \
    --inputbox "\
    PLEASE RUN THIS SHELL SCRIPT with UTF-8 !!!

    请输入 密码(PWD)
    默认[${dPassword}]
    " 12 80 "${dPassword}" 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        LOG_INFO "Var6 密码(PWD):${Password}" $LogFile;
    else
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi

};OdbcIniInfo;

# CHARSET="UTF8"
CHARSET="gbk"
# CLIENTCHARSET="UTF8"
CLIENTCHARSET="gbk"

function FaxInfoMakeSure(){
    ########################################################################
    $(whiptail --title "设置 7 / $StepCount 确认" \
    --yes-button "确定(Start)"  --no-button "退出(Exit)" \
    --yesno "\
    
    [${DataSource}]
    Description     = ODBC 5.1 Connect to icip6 for FOCUS_TOTIF
    Driver          = ${Driver}
    DATABASE        = ${Database}
    SERVER          = ${Server}
    UID             = ${UserName}
    PWD             = ${Password}
    CHARSET         = ${CHARSET}
    client charset  = ${CLIENTCHARSET}
    
    以上配置将添加或修改到${PathOdbcFile}
    是否确认?
    " 21 100 3>&1 1>&2 2>&3)

    exitstatus=$?
    if [ $exitstatus != 0 ]; then
        LOG_WARN "${thistitle}取消." $LogFile;
        exit
    fi
}
FaxInfoMakeSure


IsTagExisted(){
    test -e $1 || return -1
    test -n "$(grep -n '^\['$2'\]' $1)" && return 0 || return 1
}

AppendTagOne(){

cat >> $1 <<EOF
`printf %-16s "$2"`= $3
EOF

LOG_WARN "Append `printf %-16s "$2"` = $3" $LogFile;

}

AppendTag(){
LOG_WARN "AppendTag $2 to $1" $LogFile;

cat >> $1 <<EOF
[${DataSource}]
EOF

AppendTagOne $1 "Description"     "ODBC 5.1 Connect to icip6 for FOCUS_TOTIF"
AppendTagOne $1 "Driver"          "${Driver}"
AppendTagOne $1 "DATABASE"        "${Database}"
AppendTagOne $1 "SERVER"          "${Server}"
AppendTagOne $1 "UID"             "${UserName}"
AppendTagOne $1 "PWD"             "${Password}"
AppendTagOne $1 "CHARSET"         "${CHARSET}"
AppendTagOne $1 "client charset"  "${CHARSET}"

cat >> $1 <<EOF

EOF
}

ChangeTagOne(){
    LOG_WARN "Update `printf %-16s "$3"` = $4" $LogFile;
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    sed -i  $ss",/$3/ s/$3.*/`printf %-16s "$3"`= $4/" $1
}
ChangeTags(){
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    ChangeTagOne  $1  $2  "Description"     "ODBC 5.1 Connect to icip6 for FOCUS_TOTIF"
    ChangeTagOne  $1  $2  "Driver"          "${Driver}"
    ChangeTagOne  $1  $2  "DATABASE"        "${Database}"
    ChangeTagOne  $1  $2  "SERVER"          "${Server}"
    ChangeTagOne  $1  $2  "UID"             "${UserName}"
    ChangeTagOne  $1  $2  "PWD"             "${Password}"
    ChangeTagOne  $1  $2  "CHARSET"         "${CHARSET}"
    ChangeTagOne  $1  $2  "client charset"  "${CHARSET}"
}

if $(IsTagExisted  ${PathOdbcFile} ${DataSource}) ;then
    LOG_WARN " #    交互配置程序, 正在初始化 - [更新] ODBC 的配置信息" $LogFile;
    ChangeTags  ${PathOdbcFile}  ${DataSource}
else
    LOG_WARN " #    交互配置程序, 正在初始化 - [增加] ODBC 的配置信息 $PathOdbcFile" $LogFile;
    AppendTag   ${PathOdbcFile}
fi

exit



isql -v FOCUS_TOTIF root focustar
