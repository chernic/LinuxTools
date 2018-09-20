# @Chernic : chernic-release Build
# @changelog
## 2018-09-13 Chernic <chernic AT qq.com>
#- 增加changelog

prefix                  = ./tmp/etc
prefix_yum__repos_d     = $(prefix)/yum.repos.d/

INSTALL = install
INSTALL_DATA = $(INSTALL) -m 644

.PHONY: make install clean
make:
	mkdir -p /etc/yum.repos.d/
	# [完成] 安装已准备就绪

install:
	# [开始]
	mkdir -p $(DESTDIR)$(prefix_yum__repos_d)

	$(INSTALL_DATA) chernic-release         $(DESTDIR)$(prefix)/chernic-release
	$(INSTALL_DATA) chernic-release.repo    $(DESTDIR)$(prefix)/yum.repos.d/chernic-release.repo

clean:
	rm  -f $(DESTDIR)$(prefix)/etc/chernic-release
	rm  -f $(DESTDIR)$(prefix)/yum.repos.d/chernic-release.repo

cleanall: clean

