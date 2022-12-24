# 新服务器搭建编译环境

* 在145服务器亲测通过

## 安装android 编译环境

* sudo apt-get install git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig

* 可以参考 [Android官网](https://source.android.com/docs/setup/build/initializing)

## 安装 libxml-simple-perl

* sudo apt-get install libxml-simple-perl

## 安装 libssl-dev

* sudo apt-get install libssl-dev

## 安装高通 llvm

* llvm_qcom_4.0.2.tar.gz 在 file/llvm_qcom_4.0.2.tar.gz

* 解压llvm到对应的/opt/Qualcomm/Snapdragon-llvm/

* 注意各个目录的用户组跟用户权限,可以参考可以编译的服务器

* drwxr-xr-x 3 root root 4096 Sep  2 09:38 Qualcomm

* drwxr-xr-x 3 root root 4096 Sep  2 09:40 Snapdragon-llvm

* drwxrwxr-x 15 root root 4096 Dec 25  2020 4.0.2

## 安装签名环境

* 从已有服务器 copy /etc/pax_sign/

* -rwxr--r-- 1 root root 3348 Sep  4 02:04 androidClient.pem

* -rw-r--r-- 1 root root  108 Sep  2 09:05 sign.conf 

## 添加服务器签名权限

* 如果是新服务器,需要把ip添加到加密服务器备案,不然加密服务器不允许新服务器签名

* 这一步具体问领导

## 安装rar

* sudo apt-get install rar

## 安装pyton 2.7.17

高通编译xbl用到python 2.7

* sudo apt install python2-minimal

* cd /usr/bin

* ln -s python2 ./python

## gcc版本

Ubuntu 20.04,版本默认装了gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1),版本太高,很多warnning变成error,编译不过.

需要降级成gcc 7.5

> gcc -v

### 安装gcc 7.5

* sudo apt install gcc-7 g++-7

*  配置每一个版本，并且设置了优先级
```
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9 --slave /usr/bin/gcov gcov /usr/bin/gcov-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gcov gcov /usr/bin/gcov-7
```

* 修改默认版本

> sudo update-alternatives --config gcc

* gcc -v,确认

## ubuntu 20.04 编译kernel报错
```
In file included from /ssd/fubc/a6650_3/UM.9.15/kernel/msm-4.19/scripts/mod/modpost.c:21:
In file included from /ssd/fubc/a6650_3/UM.9.15/kernel/msm-4.19/scripts/mod/modpost.h:7:
In file included from /usr/include/x86_64-linux-gnu/sys/stat.h:446:
In file included from /usr/include/x86_64-linux-gnu/bits/statx.h:31:
In file included from /ssd/fubc/a6650_3/UM.9.15/kernel/msm-4.19/include/uapi/linux/stat.h:5:
In file included from /ssd/fubc/a6650_3/UM.9.15/kernel/msm-4.19/include/uapi/linux/types.h:14:
In file included from /ssd/fubc/a6650_3/UM.9.15/kernel/msm-4.19/include/uapi/linux/posix_types.h:5:
/ssd/fubc/a6650_3/UM.9.15/kernel/msm-4.19/include/uapi/linux/stddef.h:2:10: fatal error: 'linux/compiler_types.h' file not found
#include <linux/compiler_types.h>
         ^~~~~~~~~~~~~~~~~~~~~~~~
1 warning and 1 error generated.
make[4]: *** [scripts/Makefile.host:107: scripts/mod/modpost.o] Error 1
make[4]: *** Waiting for unfinished jobs....
```

* compiler_types.h 明明在 UM.9.15/kernel/msm-4.19/include/linux/compiler_types.h

* 看到编译log 有包含路径, /usr/include/x86_64-linux-gnu/, 把compiler_types.h 拷贝过去
    > -rw-r--r-- 1 root root 8930 Dec 24 06:11 /usr/include/x86_64-linux-gnu/linux/compiler_types.h

* 验证编译通过


## 安装 expect

* 取sp os的时候,脚本用到了expect,所以要安装

* sudo apt-get install expect

## python2 安装 paramiko

签名sp os需要用到paramiko

* wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
    > 已经下载在files下

* sudo python2 get-pip.py

* pip2 install paramiko