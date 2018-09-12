#!/bin/bash

# @Chernic : 清除yum缓存
# @changelog
## 2018-09-12 Chernic <chenyongl AT focustar.net>
#- 增加changelog


yum clean all;yum makecache;yum repolist;
