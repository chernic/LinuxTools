# This is an RPM 'spec' file, for use with the Redhat Package Manager
# to make packages for that distribution.

%define fontdir   %{_datadir}/fonts/freefont

Summary: to Release CentOS-XXX.repo
Name: centos-release-chernic
Version: 2018
Release: 09.13.el6
License: GPL
#URL:
Source: %{name}.tar.gz
Group: centos-release/chernic
BuildRoot: %{_tmppath}/%{name}-root
# Prefix: %{_prefix} = /usr
Prefix: %{_sysconfdir}
Packager: Chernic : chernic AT qq.com
AutoReqProv:no
#Requires:

%description
This package is to Release CentOS-XXX.repo

%description -l zh_CN
本安装包是为了给 RHEL 安装 CentOS-XXX.repo



%package Netease163
Summary: to Release CentOS-Netease163.repo
Group: centos-release/chernic/Netease163
Requires: %{name} = %{version}

%description Netease163
This package is to Release CentOS-Netease163.repo

%description Netease163 -l zh_CN
给 RHEL 安装 CentOS-Netease163.repo



%package Tsinghua
Summary: to Release CentOS-Tsinghua.repo
Group: centos-release/chernic/Tsinghua
Requires: %{name} = %{version}

%description Tsinghua
This package is to Release CentOS-Tsinghua.repo

%description Tsinghua -l zh_CN
给 RHEL 安装 CentOS-Tsinghua.repo



%prep
%setup -q
%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_sysconfdir}
mkdir -p %{buildroot}%{_sysconfdir}/pki/rpm-gpg/
mkdir -p %{buildroot}%{_sysconfdir}/rpm/
mkdir -p %{buildroot}%{_sysconfdir}/yum/vars/
mkdir -p %{buildroot}%{_sysconfdir}/yum.repos.d/
make clean   DESTDIR=%{buildroot}  prefix=%{prefix}
make         DESTDIR=%{buildroot}  prefix=%{prefix}
make install DESTDIR=%{buildroot}  prefix=%{prefix}

%preun
echo

%clean
rm -rf %{buildroot}

%files
%defattr (-, root, root)
%{_sysconfdir}/centos-release
%{_sysconfdir}/issue
%{_sysconfdir}/issue.net
%{_sysconfdir}/redhat-release
%{_sysconfdir}/system-release
%{_sysconfdir}/system-release-cpe
%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-6
%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Security-6
%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Testing-6
%{_sysconfdir}/rpm/macros.dist
%{_sysconfdir}/yum/vars/infra
%{_sysconfdir}/yum.repos.d/CentOS-Base.repo
%{_sysconfdir}/yum.repos.d/CentOS-Debuginfo.repo
%{_sysconfdir}/yum.repos.d/CentOS-Media.repo
%{_sysconfdir}/yum.repos.d/CentOS-Vault.repo
%{_sysconfdir}/yum.repos.d/CentOS-fasttrack.repo

%files Netease163
%defattr (-, root, root)
%{_sysconfdir}/yum.repos.d/CentOS-Netease163.repo

%files Tsinghua
%defattr (-, root, root)
%{_sysconfdir}/yum.repos.d/CentOS-Tsinghua.repo

%changelog
* Fri Sep 14 2018 Chernic <iamchernic AT gmail.com>
- 将版本号改为年份, 那么文件夹一年只改一次
- 修改邮箱地址
* Thu Sep 13 2018 Chernic <iamchernic AT gmail.com>
- 修改完成
