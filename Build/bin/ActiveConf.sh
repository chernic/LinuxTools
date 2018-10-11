#!/bin/bash
# el6.x86_64

function _ECHO(){ local COLOR; case "$1" in "EROR") test 1 -le "${DEBUG:=4}" || return 1; COLOR='\e[0;31m'; ;; "WARN") test 2 -le "${DEBUG:=4}" || return 2; COLOR='\e[0;33m'; ;; "LOGG") test 3 -le "${DEBUG:=4}" || return 3; COLOR='\e[0;32m'; ;; "INFO") test 4 -le "${DEBUG:=4}" || return 4; COLOR='\e[0m'; ;; *) return 5 ;; esac; echo -e "$COLOR$1\e[0m : $(date '+%Y-%m-%d %H:%M:%S') `printf %-18s "${0##*/}"` $2"; }; function C_ECHOPRAM(){ echo -e "`printf %-18s "${1}"` `printf %-1s "="` `printf %-20s "${2}"`"; }; function C_GET_RUN_PATHS(){ test $0 == "-bash" && __FileNam=. || __FileNam=$0; __RunnDir=$(dirname ${__FileNam:=.}) ; cd ${__RunnDir}; __HomeDir=$(pwd) && cd ".."; __FathDir=$(pwd) && cd ${__HomeDir}; C_ECHOPRAM  "- RunningDir"  "$__RunnDir"; C_ECHOPRAM  "- HomeDir"     "$__HomeDir"; C_ECHOPRAM  "- FatherDir"   "$__FathDir"; }; function C_GET_LOG_FUNCTION(){ if [ -z $IC_LOADED_LOG_FUNC ]; then if [ -e ${__HomeDir}/log.sh ]; then source "${__HomeDir}/log.sh"; echo "load log function : ${IC_LOADED_LOG_FUNC}!"; fi; fi; }; function C_SHOW_HELP(){ local s=" FunctionExported"; C_ECHOPRAM "$s" "C_ECHOWARN"; C_ECHOPRAM "$s" "C_ECHOLOGG"; C_ECHOPRAM "$s" "C_ECHOINFO"; C_ECHOPRAM "$s" "C_GET_RUN_PATHS"; C_ECHOPRAM "$s" "C_GET_LOG_FUNCTION"; }; function C_ECHOEROR() { _ECHO "EROR" "$1"; }; function C_ECHOWARN() { _ECHO "WARN" "$1"; }; function C_ECHOLOGG() { _ECHO "LOGG" "$1"; }; function C_ECHOINFO() { _ECHO "INFO" "$1"; }; 

C_GET_RUN_PATHS






