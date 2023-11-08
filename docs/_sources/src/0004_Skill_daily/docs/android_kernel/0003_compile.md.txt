# 编译

## 编译模块

以前都是可以mmm编译模块,比较快.

但是从android 11开始发现,mmm的时候,不能指定模块,特别是多个模块写在同一个Android.mk的时候,编译多个模块特别容易报错.

所以可以使用指定模块编译.make 模块名字

* make libpaxapi 2>&1 | tee libpaxapi.log

# 编译报错

* Wfortify-source

```
/SSD-LV/xielx/m9200/UM.9.15/kernel/msm-4.19/drivers/misc/pax/auth_info/authdownload.c:563:7: warning: 'memcpy' will always overflow; destination buffer has size 232, but size argument is 2044 [-Wfortify-source]
error, forbidden warning: authdownload.c:563
```

# 编译提示缺少make

## ./build.sh: line 6: make: command not found

* sudo apt-get update

* sudo apt-get install gcc automake autoconf libtool make

## sphinx-build: not found

* sudo apt install python3-pip

* pip3 install Sphinx

## Could not import extension myst_parser (exception: No module named 'myst_parser')

* pip3 install myst_parser

## no theme named 'sphinx_rtd_theme' found

* pip3 install sphinx_rtd_theme

## ./scripts/build.sh: line 146: cmake: command not found

* sudo apt install cmake

# 编译技能

* get_build_var TARGET_PRODUCT

可以获取定义的变量,输出变量

    > 输出,uis8581e_5h10_Natv

* get_prop_value system ro.system.build.tags

可以获取定义的属性值,输出属性值

    > 输出,release-keys

自己添加实现

```
function get_prop_value()
{
    if [ $1 == system ];then
        grep "^\s*$2\s*=" $ANDROID_PRODUCT_OUT/system/build.prop|sed "s/^\s*$2\s*=\s*//"
    elif [ $1 == vendor ];then
        grep "^\s*$2\s*=" $ANDROID_PRODUCT_OUT/vendor/build.prop|sed "s/^\s*$2\s*=\s*//"
    elif [ $1 == default ];then
        grep "^\s*$2\s*=" $ANDROID_PRODUCT_OUT/root/default.prop|sed "s/^\s*$2\s*=\s*//"
    fi
}
```

# 编译runthos

## 已经合入ssh密钥,clone一直提示输入密码

* vim ~/.ssh/config

```
Host 172.16.2.83
PubkeyAcceptedKeyTypes=+ssh-rsa
```

## cmake: command not found

* https://cmake.org/download/

把cmake-3.21.1-linux-x86_64.tar.gz 解压到/opt/cmake,并添加环境变量

* vim ~/.bashrc

```
export PATH=$PATH:/opt/cmake/bin
```

## Invalid BOARD; see above.

找不到2101配置

```
-- Application: /mnt/e/runthos/vendor/apps/sp_module
-- Zephyr version: 2.7.1 (/mnt/e/runthos/staging/zephyr-zephyr-v2.7.1), build: A3700_Uniphiz_11.0.0_Fir_V21.1.00_Release-1450-g82e739d2af6d
-- Found Python3: /usr/bin/python3.10 (found suitable exact version "3.10.12") found components: Interpreter
-- Board: sp_mh2101
No board named 'sp_mh2101' found.

Please choose one of the following boards:
```

python3.8 因为服务器问题一直安装不上,所以直接用可以编译的服务器,搞个账号编译,不在本地编译