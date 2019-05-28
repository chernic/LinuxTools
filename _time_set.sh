#!/bin/bash


echo "## 查看本地时间"
date "+%Y-%m-%d %H:%M:%S"                           //查看本地

echo "## 查看硬件时间"
hwclock --show  "+%Y-%m-%d %H:%M:%S"

hwclock --set --date `date "+%Y-%m-%d %H:%M:%S"`    //设置硬件时间
hwclock  --hctosys                                  //设置系统时间

# 同步系统时间到硬件时间 
#####################################################################
# 通常 系统时间慢于硬件时间, 同步这个即可
clock -w                                            //和硬件时间同步


# hwclock --set --date '2019-05-28  17:40:00'