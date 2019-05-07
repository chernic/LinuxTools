#!/bin/sh

# @Chernic : 为samba增加用户
# @changelog
## 2019-05-07 Chernic <chernic AT qq.com>
# 不再修改focustar等用户
# 增加中断要修改chernic 密码
## 2018-10-26 Chernic <chernic AT qq.com>
#- 增加log
#- 增加定量修改/etc/samba/smb.conf
## 2018-10-19 Chernic <chernic AT qq.com>
#- 免密码输入
## 2018-09-26 chernic 加到focustar用户组(优化)
#- 隐藏文件
## 2018-09-26 Chernic <chernic AT qq.com>
#- 增加对/home/focustar的权限的修改
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加changelog

IS_LOADED_LOG_FUNC=true;
# @brief    写日志到文件。
# @param1    LogLevel（字符串）    日志级别（字符串）
# @param2    LogContext（字符串） 日志内容
# @param3    LogFile（字符串）     日志文件
# @return    无
function Log2File(){
    local LogLevel=$1;
    local LogCtx=$2;
    local LogFile=$3;

    local LogTime="$(date '+%Y-%m-%d %H:%M:%S')";

    #local LogStr="[${LogTime}][${LogLevel}]: ${LogCtx}"; 
    #if [ "$LogFile" = "" ]; then
    #    echo "${LogStr}";
    #else
    #    echo "${LogStr}" >> "${LogFile}";
    #fi

    if [ "$LogFile" != "" ]; then
        echo "[${LogTime}][${LogLevel}]: ${LogCtx}" >> "${LogFile}";
    fi

    if [ -t 1 ]; then

        #定义颜色的变量
        local RED_COLOR='\E[1;31m'  #红
        local GREEN_COLOR='\E[1;32m' #绿
        local YELOW_COLOR='\E[1;33m' #黄
        #local BLUE_COLOR='\E[1;34m'  #蓝
        #local PINK_COLOR='\E[1;35m'  #粉红
        local RES='\E[0m'
    
        if [ "$LogLevel" == "error" -o "$LogLevel" == "fatal" ]; then 
            echo -e "[${LogTime}][${RED_COLOR}${LogLevel}${RES}]: ${RED_COLOR}${LogCtx}${RES}";
        elif [ "$LogLevel" == "warn" ]; then 
            echo -e "[${LogTime}][${YELOW_COLOR}${LogLevel}${RES}]: ${YELOW_COLOR}${LogCtx}${RES}";
        else 
            if [ "$LogFile" == "" ]; then echo -e "[${LogTime}][${GREEN_COLOR}${LogLevel}${RES}]: ${GREEN_COLOR}${LogCtx}${RES}"; fi
            #echo -e "[${LogTime}][${GREEN_COLOR}${LogLevel}${RES}]: ${GREEN_COLOR}${LogCtx}${RES}";
        fi
    else
        if [ "$LogLevel" == "error" -o "$LogLevel" == "fatal" ]; then 
            echo -e "[${LogTime}][${LogLevel}]: ${LogCtx}";
        elif [ "$LogLevel" == "warn" ]; then 
            echo -e "[${LogTime}][${LogLevel}]: ${LogCtx}";
        else 
            if [ "$LogFile" == "" ]; then echo -e "[${LogTime}][${LogLevel}]: ${LogCtx}"; fi
        fi
    fi
}
function LOG_INFO(){
    Log2File "info" "$1" "$2";
}
function LOG_WARN(){
    Log2File "warn" "$1" "$2";
}
function LOG_ERROR(){
    Log2File "error" "$1" "$2";
}
function LOG_FATAL(){
    Log2File "fatal" "$1" "$2";
}
function LoadLogFile(){
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
  echo "" > $LogFile
fi
};LoadLogFile;
IsTagExisted(){
    test -e $1 || return 1
    test -n "$(grep -n '^\['$2'\]' $1)" && return 0 || return 1
}
AppendTagOne(){

cat >> $1 <<EOF
`printf %-16s "$2"`= $3
EOF

LOG_WARN "GobalAppend `printf %-16s "$2"` = $3" $LogFile;

}
ChangeTagOne(){
    LOG_WARN "Update `printf %-16s "$3"` = $4" $LogFile;
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    sd=$(sed -n "$ss, /^\[.*\]/=" $1 | tail -n 1)
    # 从目标标签, 到下一个标签
    sed -i  ${ss}","${sd}" s/$3.*/`printf %-16s "$3"`= $4/" $1
}
ChangeOrAppendOneTag(){
    ss=$(grep -n '^\['$2'\]' $1 | tail -n 1 | cut -d ':' -f 1)                             # 先搜索是否有标签
    sd=$(sed -n "$ss, /^\[.*\]/=" $1 | tail -n 1)                              # 搜不到标签后标签, 则自动等于行末
    [ -z $ss ]  && LOG_ERROR "$2 is not found in $1. EXIT!" $LogFile && exit 1

    # $3 之后增加一个空格, 以完全匹配
    sed -n "${ss},${sd}p" $1 | grep  "$3 .*" > /dev/null                       # 在检查是否有子项
    if [ $? == 0 ];then
        LOG_WARN "Change `printf %-16s "$3"` = $4" $LogFile;                   # 有则改之
        sed -i  ${ss}","${sd}"  s/$3 .*/`printf %-16s "$3"`= $4/" $1
    else
        LOG_WARN "Append `printf %-16s "$3"` = $4" $LogFile;                   # 无则加勉(加在主标签后面)
        sed -i  ${ss}","${sd}"  s/^\[$2\]/\[$2\]\n`printf %-16s "$3"`= $4/" $1
    fi
}
GLOBALAppendTags2SmbConf(){
LOG_WARN "AppendTag $2 to $1" $LogFile;

cat >> $1 <<EOF

[${FatherPath}]
EOF

AppendTagOne $1 "	comment"       "${Smb_Comment}"
AppendTagOne $1 "	path"          "${Smb_Path}"
AppendTagOne $1 "	browseable"    "${Smb_Browseable}"
AppendTagOne $1 "	writable"      "${Smb_Writable}"
AppendTagOne $1 "	veto files"    "${Smb_Veto_files}"
AppendTagOne $1 ";	valid users"   "${Smb_Valid_users}"

cat >> $1 <<EOF

EOF
}
ChangeTags2SmbConf(){
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    ChangeTagOne  $1  $2  "	comment"       "${Smb_Comment}"
    # ChangeTagOne  $1  $2  "    path"          "${Smb_Path}"
    # ChangeTagOne  $1  $2  "    browseable"    "${Smb_Browseable}"
    # ChangeTagOne  $1  $2  "    writable"      "${Smb_Writable}"
    # ChangeTagOne  $1  $2  "    veto files"    "${Smb_Veto_files}"
    # ChangeTagOne  $1  $2  ";   valid users"   "${Smb_Valid_users}"
}
ChangeOrAppendTags2SmbConf(){
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    ChangeOrAppendOneTag  $1  $2   ";	valid users"   "${Smb_Valid_users}"
    ChangeOrAppendOneTag  $1  $2   "	veto files"    "${Smb_Veto_files}"
    ChangeOrAppendOneTag  $1  $2   "	writable"      "${Smb_Writable}"
    ChangeOrAppendOneTag  $1  $2   "	browseable"    "${Smb_Browseable}"
    ChangeOrAppendOneTag  $1  $2   "	path"          "${Smb_Path}"
    ChangeOrAppendOneTag  $1  $2   "	comment"       "${Smb_Comment}"
}

YumInstallSamba(){
    yum -y install samba
    yum -y install samba-client
    # smbclient -L //192.168.1.101 -Ufocustar
    # Enter focustar's password: 
    # session setup failed: NT_STATUS_LOGON_FAILURE
}; 
YumInstallSamba

Adduser(){
    # groupadd focustar
    # useradd -g    focustar focustar     # 组已经存在 - 如果您想将此用户加入到该组，请使用 -g 参数。
    # usermod -a -G focustar focustar     # 把用户添加进入某个组(s）
    chmod 776 /home/focustar

    groupadd chernic
    useradd -g    chernic  chernic      # 组已经存在 - 如果您想将此用户加入到该组，请使用 -g 参数。
    usermod -a -G focustar chernic      # 把用户添加进入某个组(s）
    chmod 777 /home/chernic
    touch /home/chernic/ReadMe
    
    passwd chernic
}; 
# Adduser


PathSmbConf="/etc/samba/smb.conf"
FatherPath="chernic"
Smb_Comment="Chernic Directories"
Smb_Path="/home/chernic"
Smb_Browseable="yes"
Smb_Writable="yes"
Smb_Veto_files="\/.\*\/"
Smb_Valid_users="@focustar focustar"

if $(IsTagExisted  ${PathSmbConf} ${FatherPath}) ;then
    echo "[更新] samba 的配置信息 $PathSmbConf"
    ChangeOrAppendTags2SmbConf  ${PathSmbConf}  ${FatherPath}
else
    echo "[增加] samba 的配置信息 $PathSmbConf"
    GLOBALAppendTags2SmbConf   ${PathSmbConf}
fi

FatherPath="www"
Smb_Comment="www Directories"
Smb_Path="/var/www"
if $(IsTagExisted  ${PathSmbConf} ${FatherPath}) ;then
    echo "[更新] samba 的配置信息 $PathSmbConf"
    ChangeOrAppendTags2SmbConf  ${PathSmbConf}  ${FatherPath}
else
    echo "[增加] samba 的配置信息 $PathSmbConf"
    GLOBALAppendTags2SmbConf   ${PathSmbConf}
fi

FatherPath="etc"
Smb_Comment="etc Directories"
Smb_Path="/etc"
chmod +rwx /etc
if $(IsTagExisted  ${PathSmbConf} ${FatherPath}) ;then
    echo "[更新] samba 的配置信息 $PathSmbConf"
    ChangeOrAppendTags2SmbConf  ${PathSmbConf}  ${FatherPath}
else
    echo "[增加] samba 的配置信息 $PathSmbConf"
    GLOBALAppendTags2SmbConf   ${PathSmbConf}
fi

Mypdbedit(){
    #   [root@tas-compile home]# pdbedit -h
    #   Usage: [OPTION...]
    ### -t, --password-from-stdin          get password from standard in
    user_passwd=focustar
    echo ""
    echo "------- 增加 samba 用户 focustar  并设置密码 focustar"
    echo -e "$user_passwd\n$user_passwd" | pdbedit -t -a -u focustar

    user_passwd=chernic
    echo ""
    echo "------- 增加 samba 用户 chernic  并设置密码 chernic"
    echo -e "$chernic\n$chernic" | pdbedit -t -a -u chernic

    echo ""
    echo "------- 列出所有 samba 用户"
    pdbedit -L
};
Mypdbedit

[ -f _samba-restart.sh ] && sh _samba-restart.sh

echo "已完成以下操作"
echo "* 安装Samba"
echo "* [更新] samba 的配置信息 focustar"
echo "* [更新] samba 的配置信息 chernic"
echo "* [更新] samba 的配置信息 etc"
echo "* [增加] samba 用户 focustar"
echo "* [增加] samba 用户 chernic"
echo "* [重启] nmb "
echo "* [重启] samba "
