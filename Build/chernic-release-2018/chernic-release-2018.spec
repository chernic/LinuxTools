# This is an RPM 'spec' file, for use with the Redhat Package Manager
# to make packages for that distribution.

Summary: to Release chernic.repo
Name: chernic-release
Version: 2018
Release: 09.30.el6
License: GPL
#URL:
Source: %{name}.tar.gz
Group: centos-release/chernic
BuildRoot: %{_tmppath}/%{name}-root
Prefix: %{_sysconfdir}
Packager: Chernic : chernic AT qq.com
AutoReqProv:no
#Requires:

%description
This package is to Release chernic.repo

%description -l zh_CN
本安装包是为了安装 chernic.repo

%prep
%setup -q
%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_sysconfdir}/yum.repos.d/
make clean   DESTDIR=%{buildroot}  prefix=%{prefix}
make         DESTDIR=%{buildroot}  prefix=%{prefix}
make install DESTDIR=%{buildroot}  prefix=%{prefix}

%preun
echo

%clean
rm -rf %{buildroot}

%files
%defattr (-, focustar, focustar)
%{_sbindir}/chernic-release-disable
%{_sbindir}/chernic-release-enable
%{_sysconfdir}/chernic-release
%{_sysconfdir}/yum.repos.d/chernic-release.repo

%changelog
* Sun Sep 30 2018 Chernic <iamchernic AT gmail.com>
- 增加chernic-release-disable
- 增加chernic-release-enable
* Thu Sep 20 2018 Chernic <iamchernic AT gmail.com>
- 修改完成
