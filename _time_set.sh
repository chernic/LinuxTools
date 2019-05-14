#!/bin/bash

date                                          //查看本地
hwclock --show                                //查看硬件的时间
hwclock --set --date '2018-12-06  10:15:00'   //设置硬件时间
hwclock  --hctosys                            //设置系统时间和硬件时间同步
clock -w                                      //保存时钟
