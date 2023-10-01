# 概要

jenkins的一些知识,搭建

# 关键词

jenkins

# jenkins配置文件

* /etc/default/jenkins

jenkins代码路径等

# jenkins 编译配置

* A6650

```
#!/bin/bash

unset ASSIGN_PAXDROID_GIT
unset ASSIGN_SP_GIT

#rm old package
rm -rf $LICHEE_OUTDIR/PayDroid_10.0_Cedar_V17*
rm -rf $PROJECT_OUTDIR/*

#参数：tag/commit -b，中间都是以空格区分
#tag：      拉取指定的tag标记代码，如：tag PayDroid_V1.11.0021_20210622
#commit:    拉取指定的commit代码，如：commit 507dabea7d
#-b：       需要切换的分支，如：-b release
#使用：
#export ASSIGN_PAXDROID_GIT="tag PayDroid_V1.11.0021_20210622 -b release"
#export ASSIGN_SP_GIT="commit 507dabea7d"
#
#如果屏蔽不使用默认拉取各自msater分支最新代码
#
#拉取指定的Paxdroid代码
export ASSIGN_PAXDROID_GIT="commit a15a1a69745608581c7a15a20fb4f75db61fa369 -b A35_release"
#拉取指定的sp代码
export ASSIGN_SP_GIT="commit a273de8273d9d99662667a5d37e9c28d2a44ffe0 -b A35_release"

./clean.sh

./build-all.sh release

if [ $? -ne 0 ];then
    echo "build android failed! exit $?"
        exit 1
fi

#Pack packages
./pack.sh release
if [ $? -ne 0 ];then
    echo "pack failed! exit $?"
        exit 1
fi
```

# AF6

* jenkins config配置

```
#!/bin/bash
ANDROID_DIR_JENKINS=${PWD}
PROJECT_OUTDIR_JENKINS=${ANDROID_DIR_JENKINS}/output
COMPILE_TODAY_JENKINS=$(date +%Y%m%d)

./selfbuild_unisoc_user --clean
if [ $? -ne 0 ];then
    echo "clean error $?"
    exit 1
fi

./selfbuild_unisoc_user
if [ $? -ne 0 ];then
    echo "build error $?"
    exit 1
fi

#Backup jenkins file to 95 server
SRC_PATH="$PROJECT_OUTDIR_JENKINS/$COMPILE_TODAY_JENKINS"
DES_PATH=/HDD01/android-dailybuild/13_UIS8581E_A12/release/
DES_ADD=liush@172.16.2.95
DES_PASSWORD=liush123

/usr/bin/expect <<EOF
set timeout 1800
spawn bash -c "scp -r $SRC_PATH $DES_ADD:$DES_PATH"
expect {
	"yes/no*" {send "yes\n"; exp_continue  }
	"password:" {send "${DES_PASSWORD}\n";}
}
expect eof
```

* jenkins邮件没有trigger

默认配置是jenkins失败才发,需要改一下