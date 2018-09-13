#!/bin/sh
# @Version    : v0.3.9-13
# @Author     : Chernic.Y.Chen From Focustar
# @EMail      : iamchernic AT gmail.com
# @LastUseDate: 2017-04-26
# @LastUseDate: 2018-09-13
# 增加 将rpm包拷到当前目录
# 增加 多rpm包匹配
show_help(){
echo -e "`printf %-16s "Usage          " ` : "${0##*/}"[OPTIONS] [FILE_DIR]"
echo -e "`printf %-16s "[OPTIONS]"       ` What OPTIONS Has Done[FILE_DIR]"
echo
echo -e "`printf %-16s " |H|help)"       ` Show this help and exit."
echo -e "`printf %-16s " |V|version)"    ` Show version and exit."
echo -e "`printf %-16s "v| |visible"     ` Log Visible"
echo
# echo -e "`printf %-16s "G| |DEBUG)"    ` ---- DEBUG=[1/2/3/4]"
echo -e "`printf %-16s "d| |dirname"     ` The Directory to Make Rpms"
echo -e "`printf %-16s "f| |force"       ` Delete All Similar Old Rpms TempFiles"
echo
echo -e "Usage Example : ${0##*/} -d <DIR> "
echo -e "              : ${0##*/} -d icip6prj_totif-1.2017.0901/icip6prj_totif-1.2017.0901-0.1.spec"
echo -e "              : ${0##*/} -d icip6prj_totif-1.2017.0901/icip6prj_totif-1.2017.0901.spec "
echo -e "Usage Example CareFully: ${0##*/} -fnmc -i -d <DIR> "
exit 0
}

TEMP=`getopt -o HVvG:d: --long help,version,visible,DEBUG:,dirname: -- "$@" 2>/dev/null`
[ $? != 0 ] && echo -e "\033[31mERROR: unknown argument! \033[0m\n" && show_help && exit 1
eval set -- "$TEMP"
while :
do
    [ -z "$1" ] && break;
    case "$1" in
        -H|--help)
            show_help; exit 0
            ;;
        -V|--version)
            show_version; exit 0
            ;;
        -v|--visible)
            VERSIBlE_="-v";
            DEBUG=3; shift
            ;;
        -G|--DEBUG)
            DEBUG=$2; shift 2
            ;;
        -d|--dirname)
            DIRAndNAME=$2; shift 2
            ;;
        -f|--force)
            FORCE=1; shift
            ;;
        --)
            shift
            ;;
        *)
            echo -e "\033[31mERROR: unknown argument! \033[0m\n" && show_help && exit 1
            ;;
    esac
done

[ -z "$DIRAndNAME" ] && show_help && exit 1;


# 加载系统参数(不知为什么 CentOS6 需要 ./ )
source  ./build_rpm.conf

[ -z ${_DirName} ] && echo "ERROR : DirName is NULL, EXIT." && exit;

# 清理缓存区
if test 1 == "$FORCE";then
    rm $VERSIBlE_ -fr ${RPMTOP}/BUILD/${_DirName}*
    rm $VERSIBlE_ -f  ${RPMTOP}/RPMS/${SYS_FLAG}/${_Name}-*${_Version}-*.rpm
    rm $VERSIBlE_ -f  ${RPMTOP}/SOURCES/${_Source}
    rm $VERSIBlE_ -f  ${RPMTOP}/SPECS${CcNameSpec}
    rm $VERSIBlE_ -f  ${RPMTOP}/SRPMS/${CcNameSrcRpm}
fi

# 压缩工程目录
tar -zcvf  ${RPMTOP}/SOURCES/${_Source}  ${_DirName}

# 拷贝SPEC文件
if [ -f ${_SpecFile} ];then
    # 先在本目录搜索spec
    cp -f     ${_SpecFile}             ${RPMTOP}/SPECS/${_SpecFile}
elif [ -f ${_DirName}/${_SpecFile} ];then 
    # 再在工程目录搜素 
    cp -f     ${_DirName}/${_SpecFile} ${RPMTOP}/SPECS/${_SpecFile}
fi

# 构建RPM
cd ${RPMTOP}/SPECS && [ -z ${_SpecFile} ] && echo "ERROR : ${_SpecFile} = is NOT exited."

# 我们可以一步步试，先rpmbuild -bp ,再-bc 再-bi 如果没问题，rpmbuild -ba 生成src包与二进制包

# -D, --define='MACRO EXPR' 将 MACRO 宏的值定义为 EXPR
rpmbuild -ba  ${_SpecFile} --define="_topdir ${RPMTOP}"

cd -
cp -v  ${RPMTOP}/RPMS/${SYS_FLAG}/${_Name}-*${_Version}-*.rpm   .

# 可能不能有效删除
# rpm -e icip6prj_totif --noscripts



