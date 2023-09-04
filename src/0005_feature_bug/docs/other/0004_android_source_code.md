# 概要

介绍下载安卓源码,由于很多情况,并不需要下载全套android源码,只需要下载特定某些模块源码

下面列一下方法

# 网址

* https://android.googlesource.com/

进入网址,找到需要的仓库地址,例如 frameworks/base

点击,platform/frameworks/base 链接

* git clone https://android.googlesource.com/platform/frameworks/base

得到clone地址,直接下载

# 使用清华源替换

由于安卓源码使用谷歌地址,很慢,所以使用清华源替换

直接使用https://mirrors.tuna.tsinghua.edu.cn/git/AOSP/ 替换掉https://android.googlesource.com/ 内容

所以clone地址变成

* git clone https://mirrors.tuna.tsinghua.edu.cn/git/AOSP/platform/frameworks/base

提示报错

```
Cloning into 'base'...
fatal: unable to access 'https://mirrors.tuna.tsinghua.edu.cn/git/AOSP/platform/frameworks/base/': server certificate verification failed. CAfile: none CRLfile: none
```

* 解决方法

```
git config --global http.sslverify false
git config --global https.sslverify false
```

提示正常下载,速度1M多,原生的才100多KB

```
Cloning into 'base'...
remote: Enumerating objects: 6010375, done.
Receiving objects:   1% (112408/6010375), 38.79 MiB | 1.65 MiB/s
```

# 下载报错

```
Cloning into 'Settings'...
remote: Enumerating objects: 928094, done.
error: RPC failed; curl 56 GnuTLS recv error (-9): Error decoding the received TLS packet.
fatal: the remote end hung up unexpectedly
fatal: early EOF
fatal: index-pack failed
```

* 解决

```
sudo apt install gnutls-bin
git config --global http.postBuffer 2097152000 //增加至2GB缓存
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999
```