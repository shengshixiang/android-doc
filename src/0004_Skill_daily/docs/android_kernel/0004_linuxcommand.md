# linux 命令

## 设置环境变量

* vim ~/.bashrc

* export PATH=$PATH:/mnt/d/android/sdk/platform-tools

* source ~/.bashrc

## ubuntu 20.04设置阿里源

* sudo vim /etc/apt/sources.list
```
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
```

* sudo apt update

## ubuntu 安装adb

* sudo add-apt-repository ppa:nilarimogard/webupd8
* sudo apt-get update
* sudo apt-get install android-tools-adb

## ubuntu 升级adb

* windows,https://dl.google.com/android/repository/platform-tools-latest-windows.zip

* mac,https://dl.google.com/android/repository/platform-tools-latest-darwin.zip

* https://dl.google.com/android/repository/platform-tools-latest-linux.zip

### 获取历史版本

```
下载链接：https://dl.google.com/android/repository/platform-tools_r[版本]-[系统].zip
版本：platform-tools的版本名称（33.0.1，33.0.0...）
系统：Windwos→windows，Mac→darwin，linux→linux
例如：https://dl.google.com/android/repository/platform-tools_r33.0.1-windows.zip
版本订修记录可查阅地址：https://developer.android.google.cn/studio/releases/platform-tools
```

## ubuntu 安装make
* sudo su -
* sudo apt-get update
* sudo apt-get install make



