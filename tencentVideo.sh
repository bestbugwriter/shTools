#!/bin/bash

if [ $# != 2 ]
then
	echo "usage ./mergetxts.sh tsfiledir dstdir"
fi

#VIDEO_DIR="/Users/$USER/Library/Containers/com.tencent.tenvideo/Data/Library/Application Support/Download/video/ad/"
TXTSFILE="txtsfilelist.txt"
DST_DIR="/Volumes/Seagate\ Backup\ Plus\ Drive/"
#DST_DIR="/Volumes/Untitled/nanian"
VIDEO_DIR=$1
#DST_DIR=$2

copyTsFile()
{
	echo "copyTsFile"
	rm -rf /tmp/txtstmp/*
	find ./ -name \*.ts -exec cp {} /tmp/txtstmp \;
}

countTsFile()
{
	echo "countTsFile"
	TSFILECOUNT=`ls -l /tmp/txtstmp/ | grep "^-" | wc -l`
	echo "generate tx TS file list."
	echo $TSFILECOUNT
}

function genFileList()
{
	echo "genFileList"
	rm $TXTSFILE
	i=0
	while [ $i -lt $TSFILECOUNT ]
	do
		echo "file '$i.ts'" >> $TXTSFILE
		let i++
	done
}

#使用ffmpeg合并下载的ts文件
mergeTsFile()
{
	echo "mergeTsFile"
	ffmpeg -f concat -i $TXTSFILE -c copy $1
}

#合并生成MP4文件
genAMp4File()
{
	echo "genAMp4File"
	copyTsFile
	countTsFile
	cd /tmp/txtstmp/
	genFileList
	mergeTsFile $1
	echo "cp $1 $DST_DIR"
	cp $1 "$DST_DIR"
	rm -rf /tmp/txtstmp/*
	cd -
}

txtsmerge()
{
	j=1
	cd "$VIDEO_DIR"
	for dir in `ls`
	do
		if [ -d "$dir" -a '`ls "$dir"`' != "" ]
		then
			echo "$dir"
			cd "$dir"
			genAMp4File "$j.mp4"
			cd "$VIDEO_DIR"
			let j++
		fi
	done
}

txtsmerge
