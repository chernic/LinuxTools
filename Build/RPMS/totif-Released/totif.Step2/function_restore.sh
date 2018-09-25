#!/bin/bash

#文件转储（内部调用）
#参数：
#  $1 -- 文件
#  $2 -- 当前的索引
#  $3 -- 文件大小（单位：K）
#  $4 -- 文件索引最大值(备份文件个数)
function restore_internal {
	local file=$1
	local index=$2
	local size=$3
	local max_index=$4
	if [ -z "$file" ] || [ -z "$index" ] || [ -z "$size" ] || [ -z "$max_index" ]; then return 1; fi

	#echo "file:$file index:$index size:${size}K max_index:$max_index"
	
	expr $index + 10 > /dev/null 2>&1
	if [ $? -ne 0 ]; then return 9; fi

	index=`expr $index + 0`

	expr $size + 10 > /dev/null 2>&1
	if [ $? -ne 0 ]; then return 19; fi

	size=`expr $size + 0`
	
	expr $max_index + 10 > /dev/null 2>&1
	if [ $? -ne 0 ]; then return 29; fi
	
	max_index=`expr $max_index + 0`
	
	local bak_index=`expr $index + 1`
	local bak_file="$file.$bak_index"
	#echo "bak_file:$bak_file"

	if [ -e "$file" ]; then
		local cur_size=`du -k $file | awk '{print $1}'`
		#echo "file:$file cur_size:${cur_size}K"
		if [ $cur_size -gt $size ]; then
			if [ -e "$bak_file" ]; then
				if [ $bak_index -ge $max_index ]; then
					rm -f "$bak_file"
				else
					restore_internal $file $bak_index $size $max_index;
					local rv=$?
					if [ $rv -ne 0 ]; then echo "restore fail. error:$rv"; exit $rv; fi
				fi
			fi
			
			if [ $index -eq 0 ]; then
				mv -f $"$file" "$bak_file"
				touch $file
			else
				local old_file="$file.$index"
				if [ -e "$old_file" ]; then 
					mv -f "$old_file" "$bak_file"
				fi
			fi
			
		fi
	fi

	return 0
}

#文件转储（外部接口）
#参数：
#  $1 -- 文件
#  $2 -- 文件大小（单位：K）
#  $3 -- 备份文件个数
function restore {
	restore_internal $1 0 $2 $3
}

