#!/bin/sh

# @Chernic : vmware 虚拟机启动报错：Could not open /dev/vmmon
# @changelog
## 2018-09-13 Chernic <chernic AT qq.com>
#- 增加开机启动加载vmmon模块
#- via https://blog.csdn.net/gsying1474/article/details/40684071
#- from https://communities.vmware.com/message/2442783
#- 增加changelog



# [root@cti01 TAS]# ls -l /lib/modules/3.18.0-kali1-amd64/misc
################################################################
# vmblock.ko
# vmci.ko
# vmmin.ko
# vmmon.ko
# vmnet.ko
# vsock.ko

# [root@cti01 TAS]# modprobe vmmon
# [root@cti01 TAS]# vmware-modconfig --console --install-all
################################################################
# Virtual machine monitor                                 [确定]
# Virtual machine communication interface                 [确定]
# VM communication interface socket family                [确定]  vsock.ko
# Blocking file system                                    [确定]
# Virtual ethernet                                        [确定]
# VMware Authentication Daemon                            [确定]
# Shared Memory Available                                 [确定]

# [root@cti01 TAS]# ll /dev/vmmon
################################################################
# crw-rw---- 1 root root 10, 165 9月  13 09:36 /dev/vmmon

echo "tar vmmon.tar"
cd /tmp
tar xvf /usr/lib/vmware/modules/source/vmmon.tar

echo "make vmmon.ko"
cd vmmon-only/
make

echo "copy vmmon.ko"
cp vmmon.ko /lib/modules/2.6.32-504.el6.x86_64/misc/vmmon.ko
modprobe vmmon


cat > /etc/sysconfig/modules/vmmon.modules  <<EOF
#! /bin/sh
/sbin/modinfo -F filename vmmon > /dev/null 2>&1
if [ $? -eq 0 ]; then
    /sbin/modprobe vmmon
fi

EOF



# [root@cti01 TAS]# vmware-modconfig --console --install-all
# [AppLoader] GLib does not have GSettings support.
# Stopping VMware services:
   # VMware Authentication Daemon                            [确定]
   # VM communication interface socket family                [确定]
   # Virtual machine communication interface                 [确定]
   # Virtual machine monitor                                 [确定]
   # Blocking file system                                    [确定]
# Using kernel build system.
# make: Entering directory `/tmp/modconfig-9kjQZx/vmmon-only'
# /usr/bin/make -C /lib/modules/2.6.32-696.el6.x86_64/build/include/.. SUBDIRS=$PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= modules
# make[1]: Entering directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/linux/driver.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/linux/driverLog.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/linux/hostif.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/apic.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/comport.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/cpuid.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/hashFunc.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/memtrack.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/phystrack.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/task.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/common/vmx86.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/vmcore/moduleloop.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/bootstrap/bootstrap.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/bootstrap/monLoader.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmmon-only/bootstrap/monLoaderVmmon.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmmon-only/vmmon.o
  # Building modules, stage 2.
  # MODPOST 1 modules
  # CC      /tmp/modconfig-9kjQZx/vmmon-only/vmmon.mod.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmmon-only/vmmon.ko.unsigned
  # NO SIGN [M] /tmp/modconfig-9kjQZx/vmmon-only/vmmon.ko
# make[1]: Leaving directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
# /usr/bin/make -C $PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= postbuild
# make[1]: Entering directory `/tmp/modconfig-9kjQZx/vmmon-only'
# make[1]: “postbuild”是最新的。
# make[1]: Leaving directory `/tmp/modconfig-9kjQZx/vmmon-only'
# cp -f vmmon.ko ./../vmmon.o
# make: Leaving directory `/tmp/modconfig-9kjQZx/vmmon-only'

# Using kernel build system.
# make: Entering directory `/tmp/modconfig-9kjQZx/vmnet-only'
# /usr/bin/make -C /lib/modules/2.6.32-696.el6.x86_64/build/include/.. SUBDIRS=$PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= modules
# make[1]: Entering directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/driver.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/hub.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/userif.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/netif.o
# 在包含自 include/linux/pci.h：61 的文件中，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/compat_netdevice.h：27，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/netif.c：43:
# include/linux/pci_ids.h:2177:1: 警告：“PCI_VENDOR_ID_VMWARE”重定义
# 在包含自 /tmp/modconfig-9kjQZx/vmnet-only/net.h：38 的文件中，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/vnetInt.h：26，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/netif.c：42:
# /tmp/modconfig-9kjQZx/vmnet-only/vm_device_version.h:56:1: 警告：这是先前定义的位置
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/bridge.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/procfs.o
# 在包含自 /tmp/modconfig-9kjQZx/vmnet-only/net.h：38 的文件中，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/vnetInt.h：26，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/bridge.c：53:
# /tmp/modconfig-9kjQZx/vmnet-only/vm_device_version.h:56:1: 警告：“PCI_VENDOR_ID_VMWARE”重定义
# 在包含自 include/linux/pci.h：61 的文件中，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/compat_netdevice.h：27，
                 # 从 /tmp/modconfig-9kjQZx/vmnet-only/bridge.c：52:
# include/linux/pci_ids.h:2177:1: 警告：这是先前定义的位置
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/smac_compat.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/smac.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/vnetEvent.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmnet-only/vnetUserListener.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmnet-only/vmnet.o
  # Building modules, stage 2.
  # MODPOST 1 modules
  # CC      /tmp/modconfig-9kjQZx/vmnet-only/vmnet.mod.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmnet-only/vmnet.ko.unsigned
  # NO SIGN [M] /tmp/modconfig-9kjQZx/vmnet-only/vmnet.ko
# make[1]: Leaving directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
# /usr/bin/make -C $PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= postbuild
# make[1]: Entering directory `/tmp/modconfig-9kjQZx/vmnet-only'
# make[1]: “postbuild”是最新的。
# make[1]: Leaving directory `/tmp/modconfig-9kjQZx/vmnet-only'
# cp -f vmnet.ko ./../vmnet.o
# make: Leaving directory `/tmp/modconfig-9kjQZx/vmnet-only'

# Using kernel build system.
# make: Entering directory `/tmp/modconfig-9kjQZx/vmblock-only'
# /usr/bin/make -C /lib/modules/2.6.32-696.el6.x86_64/build/include/.. SUBDIRS=$PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= modules
# make[1]: Entering directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/block.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/control.o
# /tmp/modconfig-9kjQZx/vmblock-only/linux/control.c: 在函数‘ExecuteBlockOp’中:
# /tmp/modconfig-9kjQZx/vmblock-only/linux/control.c:285: 警告：从不兼容的指针类型赋值
# /tmp/modconfig-9kjQZx/vmblock-only/linux/control.c:296: 警告：传递‘putname’的第 1 个参数时在不兼容的指针类型间转换
# include/linux/fs.h:2192: 附注：需要类型‘struct filename *’，但实参的类型为‘char *’
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/dentry.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/file.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/filesystem.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/inode.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/module.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/stubs.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmblock-only/linux/super.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmblock-only/vmblock.o
  # Building modules, stage 2.
  # MODPOST 1 modules
  # CC      /tmp/modconfig-9kjQZx/vmblock-only/vmblock.mod.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmblock-only/vmblock.ko.unsigned
  # NO SIGN [M] /tmp/modconfig-9kjQZx/vmblock-only/vmblock.ko
# make[1]: Leaving directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
# /usr/bin/make -C $PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= postbuild
# make[1]: Entering directory `/tmp/modconfig-9kjQZx/vmblock-only'
# make[1]: “postbuild”是最新的。
# make[1]: Leaving directory `/tmp/modconfig-9kjQZx/vmblock-only'
# cp -f vmblock.ko ./../vmblock.o
# make: Leaving directory `/tmp/modconfig-9kjQZx/vmblock-only'

# Using kernel build system.
# make: Entering directory `/tmp/modconfig-9kjQZx/vmci-only'
# /usr/bin/make -C /lib/modules/2.6.32-696.el6.x86_64/build/include/.. SUBDIRS=$PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= modules
# make[1]: Entering directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/linux/driver.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/linux/vmciKernelIf.o
# 在包含自 /tmp/modconfig-9kjQZx/vmci-only/linux/driver.c：60 的文件中:
# /tmp/modconfig-9kjQZx/vmci-only/./shared/vm_device_version.h:56:1: 警告：“PCI_VENDOR_ID_VMWARE”重定义
# 在包含自 include/linux/pci.h：61 的文件中，
                 # 从 /tmp/modconfig-9kjQZx/vmci-only/./shared/compat_pci.h：27，
                 # 从 /tmp/modconfig-9kjQZx/vmci-only/linux/driver.c：49:
# include/linux/pci_ids.h:2177:1: 警告：这是先前定义的位置
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciContext.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciDatagram.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciDoorbell.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciDriver.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciEvent.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciHashtable.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciQPair.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciQueuePair.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciResource.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/common/vmciRoute.o
  # CC [M]  /tmp/modconfig-9kjQZx/vmci-only/driverLog.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmci-only/vmci.o
  # Building modules, stage 2.
  # MODPOST 1 modules
  # CC      /tmp/modconfig-9kjQZx/vmci-only/vmci.mod.o
  # LD [M]  /tmp/modconfig-9kjQZx/vmci-only/vmci.ko.unsigned
  # NO SIGN [M] /tmp/modconfig-9kjQZx/vmci-only/vmci.ko
# make[1]: Leaving directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
# /usr/bin/make -C $PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= postbuild
# make[1]: Entering directory `/tmp/modconfig-9kjQZx/vmci-only'
# make[1]: “postbuild”是最新的。
# make[1]: Leaving directory `/tmp/modconfig-9kjQZx/vmci-only'
# cp -f vmci.ko ./../vmci.o
# make: Leaving directory `/tmp/modconfig-9kjQZx/vmci-only'


# Using kernel build system.
# make: Entering directory `/tmp/modconfig-9kjQZx/vsock-only'
# /usr/bin/make -C /lib/modules/2.6.32-696.el6.x86_64/build/include/.. SUBDIRS=$PWD SRCROOT=$PWD/. \
	  # MODULEBUILDDIR= modules
# make[1]: Entering directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
  # CC [M]  /tmp/modconfig-9kjQZx/vsock-only/linux/af_vsock.o
  # CC [M]  /tmp/modconfig-9kjQZx/vsock-only/linux/notify.o
  # CC [M]  /tmp/modconfig-9kjQZx/vsock-only/linux/notifyQState.o
  # CC [M]  /tmp/modconfig-9kjQZx/vsock-only/linux/stats.o
  # CC [M]  /tmp/modconfig-9kjQZx/vsock-only/linux/util.o
  # CC [M]  /tmp/modconfig-9kjQZx/vsock-only/linux/vsockAddr.o
  # CC [M]  /tmp/modconfig-9kjQZx/vsock-only/driverLog.o
  # LD [M]  /tmp/modconfig-9kjQZx/vsock-only/vsock.o
  # Building modules, stage 2.
  # MODPOST 1 modules
  # CC      /tmp/modconfig-9kjQZx/vsock-only/vsock.mod.o
  # LD [M]  /tmp/modconfig-9kjQZx/vsock-only/vsock.ko.unsigned
  # NO SIGN [M] /tmp/modconfig-9kjQZx/vsock-only/vsock.ko
# make[1]: Leaving directory `/usr/src/kernels/2.6.32-696.el6.x86_64'
# /usr/bin/make -C $PWD SRCROOT=$PWD/. \
    # MODULEBUILDDIR= postbuild
# make[1]: Entering directory `/tmp/modconfig-9kjQZx/vsock-only'
# make[1]: “postbuild”是最新的。
# make[1]: Leaving directory `/tmp/modconfig-9kjQZx/vsock-only'
# cp -f vsock.ko ./../vsock.o
# make: Leaving directory `/tmp/modconfig-9kjQZx/vsock-only'


# Starting VMware services:
   # Virtual machine monitor                                 [确定]
   # Virtual machine communication interface                 [确定]
   # VM communication interface socket family                [确定]
   # Blocking file system                                    [确定]
   # Virtual ethernet                                        [确定]
   # VMware Authentication Daemon                            [确定]
   # Shared Memory Available                                 [确定]
