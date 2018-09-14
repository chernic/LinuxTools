#!/bin/bash

# @Chernic : yum建立远程repo
# @changelog
## 2018-09-12 Chernic <chernic AT qq.com>
#- 增加changelog
#- 增加执行日志记录

thistitle=${thistitle:="yum建立远程repo"}

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

LogPath=/home/focustar/icip6/log/LinuxTools/
# 初始化Log日志
######################################################
function ConfigureLog(){
    if [ ! -e ${LogPath} ]; then mkdir -p ${LogPath}; fi
    LogFile=${LogPath}/$(basename $0).log
    # restore 源自上面两个sh文件
    restore $LogFile 10240 10
};ConfigureLog;

LOG_INFO "<<<" $LogFile;
LOG_INFO "<<<" $LogFile;
LOG_WARN "<<<  [${thistitle}] 开始 $(basename $0)!" | tee $LogFile;

# [root@localhost chernic]# yum info yum
# Loaded plugins: product-id, subscription-manager
# This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
# http://mirrors.163.com/centos/6/os//repodata/repomd.xml: [Errno 14] PYCURL ERROR 22 - "The requested URL returned error: 404 Not Found"
# Trying other mirror.
# Error: Cannot retrieve repository metadata (repomd.xml) for repository: Focustar-Netease163-base. Please verify its path and try again

# This system is not registered to Red Hat Subscription Management.You can use subscription-manager to register.
# 1.卸载RedHat原来的自带的yum包
# 2.下载新的centos的yum包，然后安装
function UpdateYumFromRHEL2CentOS(){
    # 本语句, 如果是RHEL则返回0(因为Packager信息里包含Red Hat), 如果是CentOS则返回1
    rpm -qi yum | grep "Packager" | grep -q "Red Hat";
    if [ $? -ne 0 ] ;then
        # grep return 1, not find Red Hat
        LOG_WARN "检查yum信息, 本操作系统的yum 非 Red Hat"  $LogFile;
    else
        # grep return 0, find Red Hat
        LOG_WARN "检查yum信息, 本操作系统的yum 是 Red Hat"  $LogFile;

        if [ -f /etc/yum.repos.d/rhel-source.repo ];then
            rm -f /etc/yum.repos.d/rhel-source.repo
            LOG_WARN "系统是RHEL, 删除/etc/yum.repos.d/rhel-source.repo" $LogFile;
        fi
    fi
        
        LOG_WARN "卸载以下rpm包 `rpm -aq | grep yum | xargs`" $LogFile;
        rpm -aq | grep yum | xargs rpm -e --nodeps

        LOG_WARN "卸载以下rpm包 `rpm -aq | grep python-urlgrabber | xargs`" $LogFile;
        rpm -aq | grep python-urlgrabber | xargs rpm -e --nodeps
        
        LOG_WARN "卸载以下rpm包 `rpm -aq | grep python-deltarpm | xargs`" $LogFile;
        rpm -aq | grep python-deltarpm | xargs rpm -e --nodeps
        
        LOG_WARN "卸载以下rpm包 `rpm -aq | grep deltarpm | xargs`" $LogFile;
        rpm -aq | grep deltarpm | xargs rpm -e --nodeps
        
        LOG_WARN "卸载以下rpm包 `rpm -aq | grep centos-release | xargs`" $LogFile;
        rpm -aq | grep centos-release | xargs rpm -e --nodeps
        
        # LOG_WARN "卸载以下rpm包 `rpm -aq | grep redhat-release-server | xargs`" $LogFile;
        # rpm -aq | grep redhat-release-server | xargs rpm -e --nodeps

        if [ -f ./yum/RPMS_EL6_x86_64/yum-*el6.centos*.rpm ];then
            cd ./yum/RPMS_EL6_x86_64
                # 安装 centos-release 是为了给yum 提供变量
                rpm -ivh centos-release*.rpm  \
                python-urlgrabber-3.9.1*.rpm  \
                deltarpm-3.5*.rpm  \
                python-deltarpm-3.5*.rpm  \
                yum-metadata-parser-1.1.2*.rpm  \
                yum-plugin-fastestmirror-1.1.30*.rpm  \
                yum-3.2.29*.rpm
            ret=$?
            if [ $? -ne 0 ] ;then
                # 显示还剩几个包未安装
                LOG_ERROR "$ret 个包未安装"  $LogFile;
            else
                LOG_WARN  "所有包 安装完毕"   $LogFile;
                LOG_WARN  "其中redhat-release-server => centos-release" $LogFile;
            fi
            cd -  >/dev/null 2>&1
        else
            LOG_ERROR "目录下没有安装包"  $LogFile;
            exit -1;
        fi
    # fi
};UpdateYumFromRHEL2CentOS;


# [root@localhost RPMS_EL6_x86_64]# rpm -qlp centos-release-6-10.el6.centos.12.3.x86_64.rpm 
# warning: centos-release-6-10.el6.centos.12.3.x86_64.rpm: Header V3 RSA/SHA1 Signature, key ID c105b9de: NOKEY
# /etc/centos-release
# /etc/issue
# /etc/issue.net
# /etc/pki/rpm-gpg
# /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
# /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-6
# /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Security-6
# /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Testing-6
# /etc/redhat-release
# /etc/rpm/macros.dist
# /etc/system-release
# /etc/system-release-cpe
# /etc/yum.repos.d/CentOS-Base.repo
# /etc/yum.repos.d/CentOS-Debuginfo.repo
# /etc/yum.repos.d/CentOS-Media.repo
# /etc/yum.repos.d/CentOS-Vault.repo
# /etc/yum.repos.d/CentOS-fasttrack.repo
# /etc/yum/vars/infra
# /usr/share/doc/centos-release-6
# /usr/share/doc/centos-release-6/EULA
# /usr/share/doc/centos-release-6/GPL
# /usr/share/doc/redhat-release

function UpdateYumRepo(){
    cat > /etc/yum.repos.d/CentOS-6-Focustar.repo  <<EOF
#################################################################################################
# ☆ 网易开源镜像站
#################################################################################################
[Focustar-Netease163-base]
name=Focustar gets CentOS-6-Base    from Netease163(mirrors.163.com)
baseurl=http://mirrors.163.com/centos/6/os/\$basearch/
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6
enabled=1

#released updates 
[Focustar-Netease163-updates]
name=Focustar gets CentOS-6-Updates from Netease163(mirrors.163.com)
baseurl=http://mirrors.163.com/centos/6/updates/\$basearch/
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6
enabled=1

#additional packages that may be useful
[Focustar-Netease163-extras]
name=Focustar gets CentOS-6-Extras  from Netease163(mirrors.163.com)
baseurl=http://mirrors.163.com/centos/6/extras/\$basearch/
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6
enabled=1

#additional packages that extend functionality of existing packages
[Focustar-Netease163-centosplus]
name=Focustar gets CentOS-6-Plus    from Netease163(mirrors.163.com)
baseurl=http://mirrors.163.com/centos/6/centosplus/\$basearch/
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6
enabled=0

#contrib - packages by Centos Users
[Focustar-Netease163-contrib]
name=Focustar gets CentOS-6-Contrib from Netease163(mirrors.163.com)
baseurl=http://mirrors.163.com/centos/6/contrib/\$basearch/
gpgcheck=1
gpgkey=http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6
enabled=0

#################################################################################################
# ☆ 清华大学开源软件镜像站
#################################################################################################
[Focustar-Tsinghua-base]
name=Focustar gets CentOS-6-Base    from Tsinghua(tuna.tsinghua.edu.cn)
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/6/os/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-6
enabled=0

#released updates 
[Focustar-Tsinghua-updates]
name=Focustar gets CentOS-6-Updates from Tsinghua(tuna.tsinghua.edu.cn)
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/6/updates/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-6
enabled=0

#additional packages that may be useful
[Focustar-Tsinghua-extras]
name=Focustar gets CentOS-6-Extras  from Tsinghua(tuna.tsinghua.edu.cn)
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/6/extras/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-6
enabled=0

#additional packages that extend functionality of existing packages
[Focustar-Tsinghua-centosplus]
name=Focustar gets CentOS-6-Plus    from Tsinghua(tuna.tsinghua.edu.cn)
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/6/centosplus/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-6
enabled=0

#contrib - packages by Centos Users
[Focustar-Tsinghua-contrib]
name=Focustar gets CentOS-6-Contrib from Tsinghua(tuna.tsinghua.edu.cn)
baseurl=http://mirrors.tuna.tsinghua.edu.cn/centos/6/contrib/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-6
enabled=0

EOF
    LOG_INFO "为系统增加 /etc/yum.repos.d/CentOS-6-Focustar.repo" $LogFile;
};UpdateYumRepo;

yum clean all;yum makecache;yum repolist;
exit -1

# 签名及加密概念：
# 签名与加密不是一个概念。
# 签名类似于校验码，用于识别软件包是不是被修改过，
# 最常用的的就是我们的GPG及MD5签名，原方使用一定的字符（MD5)或密码(GPG私钥）
# 与软件进行相应的运算并得到一个定长的密钥，。
# 加密是用一定的密钥对原数据进行修改，即使程序在传输中被截获，只要它不能解开密码，
# 就不能对程序进行修改，除非破坏掉文件，那样我们就知道软件被修改过了。

# RPM验证方法：
# 1>验证安装的整个软件包的文件
# rpm -V crontabs-1.10-8
# 2>验证软件包中的单个文件
# rpm -Vf /etc/crontab
# 如果文件没有被修改过，则不输出任何信息。
# 3>验证整个软件包是否被修改过
# rpm -Vp AdobeReader_chs-7.0.9-1.i386.rpm 
# .......T   /usr/local/Adobe/Acrobat7.0/Reader/GlobalPrefs/reader_prefs
# S.5....T   /usr/local/Adobe/Acrobat7.0/bin/acroread
# 4>验证签名
# rpm -K AdobeReader_chs-7.0.9-1.i386.rpm
# AdobeReader_chs-7.0.9-1.i386.rpm: sha1 md5 OK
# 验证结果含意：
# S ：file Size differs
# M ：Mode differs (includes permissions and file type)
# 5 ：MD5 sum differs
# D ：Device major/minor number mis-match
# L ：readLink(2) path mis-match
# U ：User ownership differs
# G ：Group ownership differs
# T ：mTime differs

# [root@cti01 functions]# rpm -qi centos-release
##############################################################################################
# Name        : centos-release               Relocations: (not relocatable)
# Version     : 6                                 Vendor: CentOS
# Release     : 9.el6.12.3                    Build Date: 2017年03月28日 星期二 18时25分08秒
# Install Date: 2017年09月15日 星期五 17时22分52秒      Build Host: c1bm.rdu2.centos.org
# Group       : System Environment/Base       Source RPM: centos-release-6-9.el6.12.3.src.rpm
# Size        : 37364                            License: GPLv2
# Signature   : RSA/SHA1, 2017年03月28日 星期二 18时36分02秒, Key ID 0946fca2c105b9de
# Packager    : CentOS BuildSystem <http://bugs.centos.org>
# Summary     : CentOS release file
# Description :
# CentOS release files

# [root@cti01 functions]# arch
##############################################################################################
# x86_64

