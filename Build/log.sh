#!/bin/bash

IS_LOADED_LOG_FUNC=true;

# @function    Log2File
# @brief    写日志到文件。
# @param1    LogLevel（字符串）    日志级别（字符串）
# @param2    LogContext（字符串） 日志内容
# @param3    LogFile（字符串）     日志文件
# @return    无
function Log2File()
{
    local LogLevel=$1;
    local LogCtx=$2;
    local LogFile=$3;

    local LogTime="$(date '+%Y-%m-%d %H:%M:%S')";

    #local LogStr="[${LogTime}][${LogLevel}]: ${LogCtx}"; 
    #if [ "$LogFile" = "" ]; then
    #    echo "${LogStr}";
    #else
    #    echo "${LogStr}" >> "${LogFile}";
    #fi

    if [ "$LogFile" != "" ]; then
        echo "[${LogTime}][${LogLevel}]: ${LogCtx}" >> "${LogFile}";
    fi

    if [ -t 1 ]; then

        #定义颜色的变量
        local RED_COLOR='\E[1;31m'  #红
        local GREEN_COLOR='\E[1;32m' #绿
        local YELOW_COLOR='\E[1;33m' #黄
        #local BLUE_COLOR='\E[1;34m'  #蓝
        #local PINK_COLOR='\E[1;35m'  #粉红
        local RES='\E[0m'
    
        if [ "$LogLevel" == "error" -o "$LogLevel" == "fatal" ]; then 
            echo -e "[${LogTime}][${RED_COLOR}${LogLevel}${RES}]: ${RED_COLOR}${LogCtx}${RES}";
        elif [ "$LogLevel" == "warn" ]; then 
            echo -e "[${LogTime}][${YELOW_COLOR}${LogLevel}${RES}]: ${YELOW_COLOR}${LogCtx}${RES}";
        else 
            if [ "$LogFile" == "" ]; then echo -e "[${LogTime}][${GREEN_COLOR}${LogLevel}${RES}]: ${GREEN_COLOR}${LogCtx}${RES}"; fi
            #echo -e "[${LogTime}][${GREEN_COLOR}${LogLevel}${RES}]: ${GREEN_COLOR}${LogCtx}${RES}";
        fi
    else
        if [ "$LogLevel" == "error" -o "$LogLevel" == "fatal" ]; then 
            echo -e "[${LogTime}][${LogLevel}]: ${LogCtx}";
        elif [ "$LogLevel" == "warn" ]; then 
            echo -e "[${LogTime}][${LogLevel}]: ${LogCtx}";
        else 
            if [ "$LogFile" == "" ]; then echo -e "[${LogTime}][${LogLevel}]: ${LogCtx}"; fi
        fi
    fi
}

# @function    LOG_INFO,LOG_WARN,LOG_ERROR
# @brief     按指定级别写日志到文件。
# @param1    LogContext（字符串） 日志内容
# @param2    LogFile（字符串）     日志文件
# @return    无
function LOG_INFO(){
    Log2File "info" "$1" "$2";
}
function LOG_WARN(){
    Log2File "warn" "$1" "$2";
}
function LOG_ERROR(){
    Log2File "error" "$1" "$2";
}
function LOG_FATAL(){
    Log2File "fatal" "$1" "$2";
}

