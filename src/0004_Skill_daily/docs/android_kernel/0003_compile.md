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