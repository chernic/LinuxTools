#!/bin/sh

StepCount=7
source  ./$0.conf

AppendTags2odbc(){
LOG_WARN "AppendTag $2 to $1" $LogFile;

cat >> $1 <<EOF

[${DataSource}]
EOF

AppendTagOne $1 "Description"     "ODBC 5.1 Connect to icip6 for FOCUS_TOTIF"
AppendTagOne $1 "Driver"          "${Driver}"
AppendTagOne $1 "DATABASE"        "${Database}"
AppendTagOne $1 "SERVER"          "${Server}"
AppendTagOne $1 "UID"             "${UserName}"
AppendTagOne $1 "PWD"             "${Password}"
AppendTagOne $1 "CHARSET"         "${CHARSET}"
AppendTagOne $1 "client charset"  "${CHARSET}"

cat >> $1 <<EOF

EOF
}
ChangeTags2odbc(){
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    ChangeTagOne  $1  $2  "Description"     "ODBC 5.1 Connect to icip6 for FOCUS_TOTIF"
    ChangeTagOne  $1  $2  "Driver"          "${Driver}"
    ChangeTagOne  $1  $2  "DATABASE"        "${Database}"
    ChangeTagOne  $1  $2  "SERVER"          "${Server}"
    ChangeTagOne  $1  $2  "UID"             "${UserName}"
    ChangeTagOne  $1  $2  "PWD"             "${Password}"
    ChangeTagOne  $1  $2  "CHARSET"         "${CHARSET}"
    ChangeTagOne  $1  $2  "client charset"  "${CHARSET}"
}

PathOdbcFile="./etc/odbc.ini"  
DataSource="FOCUS_TOTIF"
Driver="MySQL1 ODBC 5.1 Driver111111111111111111111"
Database="ICIP6"
Server="192.168.2.240"
UserName="root"
Password="focustar"
CHARSET="gbk"           # CHARSET="UTF8"
CLIENTCHARSET="gbk"     # CLIENTCHARSET="UTF8"
if $(IsTagExisted  ${PathOdbcFile} ${DataSource}) ;then
    echo "[更新] ODBC 的配置信息 $PathOdbcFile"
    ChangeTags2odbc  ${PathOdbcFile}  ${DataSource}
else
    echo "[增加] ODBC 的配置信息 $PathOdbcFile"
    AppendTags2odbc   ${PathOdbcFile}
fi


GLOBALAppendTags2SmbConf(){
LOG_WARN "AppendTag $2 to $1" $LogFile;

cat >> $1 <<EOF

[${FatherPath}]
EOF

AppendTagOne $1 "	comment"       "${Smb_Comment}"
AppendTagOne $1 "	path"          "${Smb_Path}"
AppendTagOne $1 "	browseable"    "${Smb_Browseable}"
AppendTagOne $1 "	writable"      "${Smb_Writable}"
AppendTagOne $1 "	veto files"    "${Smb_Veto_files}"
AppendTagOne $1 ";	valid users"   "${Smb_Valid_users}"

cat >> $1 <<EOF

EOF
}
ChangeTags2SmbConf(){
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    ChangeTagOne  $1  $2  "	comment"       "${Smb_Comment}"
    # ChangeTagOne  $1  $2  "    path"          "${Smb_Path}"
    # ChangeTagOne  $1  $2  "    browseable"    "${Smb_Browseable}"
    # ChangeTagOne  $1  $2  "    writable"      "${Smb_Writable}"
    # ChangeTagOne  $1  $2  "    veto files"    "${Smb_Veto_files}"
    # ChangeTagOne  $1  $2  ";   valid users"   "${Smb_Valid_users}"
}
ChangeOrAppendTags2SmbConf(){
    ss=$(grep -n '^\['$2'\]' $1 | cut -d ':' -f 1)
    ChangeOrAppendOneTag  $1  $2   ";	valid users"   "${Smb_Valid_users}"
    ChangeOrAppendOneTag  $1  $2   "	veto files"    "${Smb_Veto_files}"
    ChangeOrAppendOneTag  $1  $2   "	writable"      "${Smb_Writable}"
    ChangeOrAppendOneTag  $1  $2   "	browseable"    "${Smb_Browseable}"
    ChangeOrAppendOneTag  $1  $2   "	path"          "${Smb_Path}"
    ChangeOrAppendOneTag  $1  $2   "	comment"       "${Smb_Comment}"
}

PathSmbConf="./etc/smb.conf"
FatherPath="chernic"
Smb_Comment="Chernic Directories"
Smb_Path="\/home\/chernic"
Smb_Browseable="yes"
Smb_Writable="yes"
Smb_Veto_files="\/.\*\/"
Smb_Valid_users="@focustar focustar"

# if $(IsTagExisted  ${PathSmbConf} ${FatherPath}) ;then
    echo "[更新] samba 的配置信息 $PathSmbConf"
    ChangeOrAppendTags2SmbConf  ${PathSmbConf}  ${FatherPath}
# else
    # echo "[增加] samba 的配置信息 $PathSmbConf"
    # GLOBALAppendTags2SmbConf   ${PathSmbConf}
# fi
