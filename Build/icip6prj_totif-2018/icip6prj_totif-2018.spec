Summary: icip6prj_totif 
Name: icip6prj_totif
Version: 2018
Release: 9.18.el6.focustar
License: GPL
URL: http://www.focustar.net
Source: %{name}.tar.gz
Group: FOCUSTAR/Chernic
BuildRoot: %{_tmppath}/%{name}-root
# Prefix: %{_prefix} = /usr
Prefix: /home/focustar/icip6prj_totif
Packager: Chernic : chernic AT qq.com
AutoReqProv:no

Requires: libreoffice-base >= 4.3.7.2
Requires: libreoffice-calc >= 4.3.7.2
Requires: libreoffice-draw >= 4.3.7.2
Requires: libreoffice-impress >= 4.3.7.2
Requires: libreoffice-writer >= 4.3.7.2
Requires: libreoffice-core >= 4.3.7.2
Requires: libreoffice-headless >= 4.3.7.2
Requires: libreoffice-opensymbol-fonts >= 4.3.7.2
Requires: libreoffice-ure >= 4.3.7.2
Requires: libreoffice-sdk >= 4.3.7.2


Requires: glibc >= 2.12
Requires: nss-softokn-freebl >= 3.14.3
Requires: ghostscript-devel = 8.70
Requires: ImageMagick-devel >= 6.7
Requires: ImageMagick-c++-devel >= 6.7

%description
This package is a tool to Install Totif

%prep
%setup -q
%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{prefix}
mkdir -p %{buildroot}/usr/local/sbin
make clean   DESTDIR=%{buildroot}  prefix=%{prefix}
make         DESTDIR=%{buildroot}  prefix=%{prefix}
make install DESTDIR=%{buildroot}  prefix=%{prefix}

%preun
[ -f /etc/init.d/focustar_totif ] && service focustar_totif stop
echo

%clean
rm -rf %{buildroot}

%files
%{prefix}
/etc/init.d/focustar_totif
/usr/local/chernix/ghostscript

%changelog
* Tue Sep 18 2018 Chernic <chernic AT qq.com>
- 增肌 LibreOffice 依赖说明
- 限定 ghostscript-devel 依赖版本
- 关闭 focustar_totif 前先检测是否存在该脚本
* Fri Sep 14 2018 Chernic <chernic AT qq.com>
- 增加 ghostscript-devel 依赖说明
- 增加 ImageMagick-devel 依赖说明
- 增加 ImageMagick-c++-devel 依赖说明
- 将版本号改为年份, 那么文件夹一年只改一次
* Tue Jul 4 2018 Chernic <chernic AT qq.com>
- 修改完成, open display
* Fri Jul 28 2017 Chernic <chernic AT qq.com>
- 增加支持png/jpeg/bmp/gif的转换
- 增加支持ssh-scp拷贝文件到远程服务器
* Fri Jul 28 2017 Chernic <chernic AT qq.com>
- Add chernix/ghostscript otherwise it may get error.
* Tue Apr 20 2017 Chernic <chernic AT qq.com>
- UpdateAll
* Tue Apr 9 2015 Chernic <chernic AT qq.com>
- initialize the first spec file
- Change Name to focustar_totif
