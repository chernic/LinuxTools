
# @Version    : v0.2.4-26
# @Author     : Chernic.Y.Chen From Focustar
# @EMail      : iamchernic AT gmail.com
# @LastUseDate: 2017-04-26

# /var/www/focustar/totif_initd   => /home/focustar/icip6prj_totif/initd
# /var/www/focustar/totif_client  => /var/www/chernic/svn/icip6/icip6prj_totif/trunk/source/TOTIF_CLIENT/
# /var/www/focustar/totif_service => /var/www/compile/.build/LINUXexample.out/bin/

prefix                  = /home/focustar/icip6prj_totif

prefix_bin              = $(prefix)/bin
prefix_bin_cfg          = $(prefix)/bin/cfg
prefix_bin_log          = $(prefix)/bin/log
prefix_bin_tool         = $(prefix)/bin/tool
prefix_bin_usr          = $(prefix)/bin/usr
prefix_bin_usr_fileinn  = $(prefix)/bin/usr/fileinn
prefix_bin_usr_fileout  = $(prefix)/bin/usr/fileout
prefix_bin_usr_filetmp  = $(prefix)/bin/usr/filetmp
prefix_initd            = $(prefix)/init.d
prefix_lib              = $(prefix)/lib


CHMOD_LOG   = chmod -R 777
CHMOD_SDIR  = chmod -R 755
SDIRS = init.d bin/cfg bin/log bin/tool bin/usr lib
# SDIRS = init.d bin/cfg  bin/log bin/TOTIF_MAIN bin/usr compile inc lib


INSTALL = install
INSTALL_PROG = $(INSTALL) -m 777
INSTALL_DATA = $(INSTALL) -m 644


file_initd   = focustar_totif
DATA_OF_PROG = bin/TOTIFMain
DATA_OF_DEAM = bin/daemonTOTIF

DATA_OF_SERV1 = bin/focustar_libre
DATA_OF_SERV2 = bin/focustar_totif
DATA_OF_LOCAL = bin/localTOTIF

DATA_OF_DATA = ReadMe

.PHONY: make install clean
make:
	# [完成] 安装已准备就绪
	mkdir -p bin/cfg
	mkdir -p bin/log
	mkdir -p bin/tool
	mkdir -p bin/usr
	mkdir -p bin/usr/fileinn
	mkdir -p bin/usr/fileout
	mkdir -p bin/usr/filetmp
	rm -f bin/usr/filetmp/*
	rm -f bin/usr/fileout/*

install: $(SDIRS)
	mkdir -p $(DESTDIR)$(prefix)
	mkdir -p $(DESTDIR)$(prefix_bin)
	mkdir -p $(DESTDIR)$(prefix_bin_cfg)
	mkdir -p $(DESTDIR)$(prefix_bin_log)
	mkdir -p $(DESTDIR)$(prefix_bin_tool)
	mkdir -p $(DESTDIR)$(prefix_bin_usr)
	mkdir -p $(DESTDIR)$(prefix_bin_usr_fileinn)
	mkdir -p $(DESTDIR)$(prefix_bin_usr_fileout)
	mkdir -p $(DESTDIR)$(prefix_bin_usr_filetmp)
	mkdir -p $(DESTDIR)$(prefix_initd)
	mkdir -p $(DESTDIR)$(prefix_lib)

	mkdir -p $(DESTDIR)/etc/init.d/
	mkdir -p $(DESTDIR)/usr/local/chernix/ghostscript/share/ghostscript/

	$(foreach sdir,$(SDIRS), $(shell mkdir -p $(DESTDIR)$(prefix)/$(sdir)/     ;))
	# [完成] 创建目标子目录
	$(foreach sdir,$(SDIRS), $(shell [ ! "`ls -a $(sdir)|grep '^[^.]'|wc -l`" -eq 0 ] && \cp -rf $(sdir)/* $(DESTDIR)$(prefix)/$(sdir)/;))
	# echo "cp -rf $(sdir) $(DESTDIR)$(prefix)/$(sdir)" &&
	# [完成] 拷贝子目录下文件(若存在文件) 至目标子目录
	$(foreach sdir,$(SDIRS), $(shell $(CHMOD_SDIR) $(DESTDIR)$(prefix)/$(sdir)/ ;))
	# [完成] 更改目标子目录及其下权限

	$(CHMOD_LOG)    $(DESTDIR)$(prefix_bin_log)

	$(INSTALL_DATA) $(DATA_OF_DATA) $(DESTDIR)$(prefix)/$(DATA_OF_DATA)

	$(INSTALL_PROG) $(DATA_OF_PROG) $(DESTDIR)$(prefix)/$(DATA_OF_PROG)
	$(INSTALL_PROG) $(DATA_OF_DEAM) $(DESTDIR)$(prefix)/$(DATA_OF_DEAM)
	$(INSTALL_PROG) $(DATA_OF_SERV1) $(DESTDIR)$(prefix)/$(DATA_OF_SERV1)
	$(INSTALL_PROG) $(DATA_OF_SERV2) $(DESTDIR)$(prefix)/$(DATA_OF_SERV2)
	$(INSTALL_PROG) $(DATA_OF_LOCAL) $(DESTDIR)$(prefix)/$(DATA_OF_LOCAL)

	cp -f init.d/$(file_initd)  $(DESTDIR)/etc/init.d/$(file_initd)

	cp -rf /usr/share/ghostscript/8.70/ $(DESTDIR)/usr/local/chernix/ghostscript/share/ghostscript/

clean:
	rm  -f $(DESTDIR)/etc/init.d/$(file_initd)
	rm  -f $(DESTDIR)$(prefix)/$(DATA_OF_DATA)
	rm  -f $(DESTDIR)$(prefix)/$(DATA_OF_PROG)
	rm  -f $(DESTDIR)$(prefix)/$(DATA_OF_DEAM)
	rm  -f $(DESTDIR)$(prefix)/$(DATA_OF_SERV1)
	rm  -f $(DESTDIR)$(prefix)/$(DATA_OF_SERV2)
	rm  -f $(DESTDIR)$(prefix)/$(DATA_OF_LOCAL)
	rm -rf $(DESTDIR)$(prefix_initd)
	rm -rf $(DESTDIR)$(prefix_bin)
	rm -rf $(DESTDIR)$(prefix)


cleanall: clean
	rm -f  $(DESTDIR)$(target_initd)/$(file_initd)
