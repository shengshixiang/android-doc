# 新服务器搭建编译环境

* 在95服务器亲测通过

## 安装android 编译环境

* sudo apt-get install git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig

* 可以参考 Android官网,https://source.android.com/docs/setup/build/initializing

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