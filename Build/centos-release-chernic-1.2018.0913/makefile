# @Chernic : centos-release-chernic Build
# @changelog
## 2018-09-13 Chernic <chernic AT qq.com>
#- 增加changelog

prefix                  = ./tmp/etc

prefix_rpmgpg           = $(prefix)/pki/rpm-gpg/
prefix_rpm              = $(prefix)/rpm/
prefix_yum_vars         = $(prefix)/yum/vars/
prefix_yum__repos_d     = $(prefix)/yum.repos.d/

CHMOD_LOG   = chmod -R 777
CHMOD_SDIR  = chmod -R 755

INSTALL = install
INSTALL_PROG = $(INSTALL) -m 777
INSTALL_DATA = $(INSTALL) -m 644

CENTOS_RELEAS      = centos-release
ISSUE              = issue
ISSUE_NET          = issue.net
REDHAT_RELEASE     = redhat-release
SYSTEM_RELEASE     = system-release
SYSTEM_RELEASE_CPE = system-release-cpe

.PHONY: make install clean
make:
	mkdir -p /etc/pki/rpm-gpg/
	mkdir -p /etc/rpm/
	mkdir -p /etc/yum/vars/
	mkdir -p /etc/yum.repos.d/
	# [完成] 安装已准备就绪

install:
	# [开始]
	mkdir -p $(DESTDIR)$(prefix_rpmgpg)
	mkdir -p $(DESTDIR)$(prefix_rpm)
	mkdir -p $(DESTDIR)$(prefix_yum_vars)
	mkdir -p $(DESTDIR)$(prefix_yum__repos_d)

	$(INSTALL_DATA) etc/$(CENTOS_RELEAS)                           $(DESTDIR)$(prefix)/$(CENTOS_RELEAS)
	$(INSTALL_DATA) etc/$(ISSUE)                                   $(DESTDIR)$(prefix)/$(ISSUE)
	$(INSTALL_DATA) etc/$(ISSUE_NET)                               $(DESTDIR)$(prefix)/$(ISSUE_NET)
	$(INSTALL_DATA) etc/$(REDHAT_RELEASE)                          $(DESTDIR)$(prefix)/$(REDHAT_RELEASE)
	$(INSTALL_DATA) etc/$(SYSTEM_RELEASE)                          $(DESTDIR)$(prefix)/$(SYSTEM_RELEASE)
	$(INSTALL_DATA) etc/$(SYSTEM_RELEASE_CPE)                      $(DESTDIR)$(prefix)/$(SYSTEM_RELEASE_CPE)

	$(INSTALL_DATA) etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6           $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6         
	$(INSTALL_DATA) etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-6     $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-6   
	$(INSTALL_DATA) etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Security-6  $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Security-6
	$(INSTALL_DATA) etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Testing-6   $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Testing-6 

	$(INSTALL_DATA) etc/rpm/macros.dist                            $(DESTDIR)$(prefix)/rpm/macros.dist                  
	$(INSTALL_DATA) etc/yum/vars/infra                             $(DESTDIR)$(prefix)/yum/vars/infra                   
	$(INSTALL_DATA) etc/yum.repos.d/CentOS-Base.repo               $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Base.repo     
	$(INSTALL_DATA) etc/yum.repos.d/CentOS-Debuginfo.repo          $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Debuginfo.repo
	$(INSTALL_DATA) etc/yum.repos.d/CentOS-Media.repo              $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Media.repo    
	$(INSTALL_DATA) etc/yum.repos.d/CentOS-Vault.repo              $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Vault.repo    
	$(INSTALL_DATA) etc/yum.repos.d/CentOS-fasttrack.repo          $(DESTDIR)$(prefix)/yum.repos.d/CentOS-fasttrack.repo
	$(INSTALL_DATA) etc/yum.repos.d/CentOS-Netease163.repo         $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Netease163.repo
	$(INSTALL_DATA) etc/yum.repos.d/CentOS-Tsinghua.repo           $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Tsinghua.repo 

clean:
	rm  -f $(DESTDIR)$(prefix)/$(CENTOS_RELEAS)
	rm  -f $(DESTDIR)$(prefix)/$(ISSUE)
	rm  -f $(DESTDIR)$(prefix)/$(ISSUE_NET)
	rm  -f $(DESTDIR)$(prefix)/$(REDHAT_RELEASE)
	rm  -f $(DESTDIR)$(prefix)/$(SYSTEM_RELEASE)
	rm  -f $(DESTDIR)$(prefix)/$(SYSTEM_RELEASE_CPE)

	rm  -f $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
	rm  -f $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Debug-6
	rm  -f $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Security-6
	rm  -f $(DESTDIR)$(prefix)/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Testing-6

	rm  -f $(DESTDIR)$(prefix)/rpm/macros.dist
	rm  -f $(DESTDIR)$(prefix)/yum/vars/infra
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Base.repo
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Debuginfo.repo
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Media.repo
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Vault.repo
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/CentOS-fasttrack.repo
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Netease163.repo
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/CentOS-Tsinghua.repo

cleanall: clean

