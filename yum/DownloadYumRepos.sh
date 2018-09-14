#!bin/sh

# yum clean all
# yum makecache


# wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -C /etc/yum.repos.d/CentOS-Base.repo

http://mirrors.163.com/centos/6.9/os/i386/Packages/centos-release-6-9.el6.12.3.i686.rpm  


yum localinstall yum-3.2.29-81.el6.centos.noarch.rpm  yum-plugin-fastestmirror-1.1.30-40.el6.noarch.rpm python-deltarpm-3.5-0.5.20090913git.el6.i686.rpm  python-urlgrabber-3.9.1-11.el6.noarch.rpm deltarpm-3.5-0.5.20090913git.el6.i686.rpm;
