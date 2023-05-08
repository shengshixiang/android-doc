# README

工作备忘

# mantis 回复模板

* [修改提交]bbe475be6510c696ac2ee1d9a3a982b7125f8451
* [提交日期]2023-02-03
* [验证版本]2023-02-03之后的版本
* [修改方案]

# 专利备注

## 一种减少被通知打扰的方法

* 前提,目前手机通知音,一般都是静音,勿扰统一设置,如果设置勿扰,就会把所有通知都设置成不响铃状态,容易把一些非打扰信息也过滤了

* 本文介绍一种分类管理通知音的方法

* 举例,来电响铃.

联系人A组是重要人物, 手机设置勿扰模式,A正常响铃

联系人B组是正常惯性系,手机设置勿扰模式,希望小声音响铃

其他联系人是归类为打扰任务,手机设置勿扰模式,不响铃.

### 应用场景

* 午休的时候,如果不设置勿扰,就会被骚扰电话打扰. 如果设置勿扰,就会过滤掉一些重要人物联系,忽略紧急事件

# 项目

## M9200

### 谢连雄

* m9200 安全启动
* m9200 串口压力测试sam卡
* camera num
* 休眠唤醒,打印机使用不了
* 添加nfc功能到gms分支
    > OK

* ap添加授权功能
    > OK

* ap 写入exsn
    > OK

## A6650

### 赖庆雄

* pci 运行验签

### 谢连雄

* mantis bug修复
* 工厂测试自动关机
* 工厂测试ped 不弹出,弹出来不能输入
* 请把每个项目的PCI和EMV编译方法,写到readme
* 没有gms包,功耗32ma,整机
* v03板子验证efuse,接着烧录google key
* 运行验签vbmeta.img
* maxstore把AP唤醒(未亮屏，所以SP没有被唤醒)
* 去掉谷歌应用,使用android原生
* 不安装 google play

* 寄两台机器给郭庆锐,调试maxstore,调试neptune
    > 浙江省 杭州市 滨江区 火炬大道 581号  三维大厦B座8楼
    > 郭庆锐
    > 135 6717 8410

* 熔丝后,wifi打不开

* debug版本打开调试串口
    > OK

* ota升级,用的fingerprint来生成cache文件,所以cache文件需要重新清理一下
    > OK

* ++-- 启动计算器
    > OK

* 定制modem
    > OK

* 添加v03v04 dts
    > OK

* pci定制删除验签不过的apk,js文件
    > OK

* fct没有usb端口
    > OK

* pci 新增删除未签名脚本文件需求
    > OK

* 开fuse,pci样机需要
    > OK,要先熔丝,在烧录google key

* 新屏添加进authinfo 的dts,接收屏亮回调
    > OK

* 运行验签,换地方,untrusted app不能有 systoold的selinux权限
    > OK

* L2 认证 耗时确认
    > OK

* EM机器,确认去掉com.android.nfc,android.hardware.nfc@1.2-service
    > OK

* 开机按音量键,进不了单板测试模式
    > OK

* protims维护
    > OK

* 工厂生产流量问题,参考M8
    > OK

* 去掉自动旋转
    > OK

* 谷歌服务找不到
    > OK

* 功耗问题,剩下胡连聪PN5190
    > OK

* 触发后,开机弹出触发界面之前, launcher界面的图标,还可以操作一下
    > OK

* 新版本nfc不能用
    > OK

* user版本,logkit捉取不了 kernel log
    > OK

* 煲机测试,15小时左右,camera卡死
    > OK

* 鸿展漏电 lcd,2ma
    > OK

### 吴港南

* 耳机mic

* mantis问题

* 偏压ic漏电6ma
    > ok

### 傅博晨

* ESIM

* Logkit,user版本 打不开
    > OK

* systool 根据pn备注,把EEA信息写入nv分区
    > OK

* pci 蓝牙 openssl问题修改
    > OK

* google key重复写
    > OK

### 罗振辉

* TP 双击唤醒
* TP效果,mantis bug
* 科莱屏确认功耗

* 扫码camera效果,还没有参数
    > 有一板

* 后摄效果
    > 有一板
* 前摄效果
    > 有一板
* 后副摄效果
    > 有一板
* 扫码Zebra效果
    > 斑马他们自己调,有问题提

* 开机红外灯亮,新板子
    > ok

### 单亮亮

* otg耳机,按键没有反应

### 唐云华

* em扫码,概率性打开失败
    > OK

### 屈明月

* pci认证

### 郭侥

* 互联互通