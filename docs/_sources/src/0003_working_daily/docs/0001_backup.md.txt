# README

工作备忘

# mantis 回复模板

* [修改Title]bbe475be6510c696ac2ee1d9a3a982b7125f8451
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

## AF6

### 谢连雄

* usb开机

    > OK

```
没有电池就把关机充电去掉就可以，没有其他影响，这样关机状态下接上USB就可以直接正常开机
1.在get_mode_from_charger里把charge_mode改为normal_mode
2.去掉uboot中对sprdfgu_late_init的调用
```

## M9200

### 谢连雄

* 身份证nfc

* nfc读卡慢
    > Ok

* m9200 安全启动
    > OK

* m9200 串口压力测试sam卡
    > 跟测试部确认,ICC_INT_STR测试通过
    > TestTime:2023-04-29 00:59:45
    > MODEL:M9200
    > SN:2870000091
    > SDK:
    > VER:Uniphiz_12.0.0_Kapok_V25.1.00_20230428
    > 单个通道连续测试:Slot=2 TotalCnt=50000, FailCnt=0, SuccessRate=100%
    > CaseExecTime:20373s

* at命令
    > OK

* 属性显示pci问题
    > OK

* camera num
    > OK

* sn号,有一位显示乱码
    > 最新软件没有复现

* 添加nfc功能到gms分支
    > OK

* 休眠唤醒,打印机使用不了
    > OK

* ap添加授权功能
    > OK

* ap 写入exsn
    > OK

## A6650

### 谢连雄

* mantis bug修复

* 祝晶提出的 get sysver需要显示菜单
    > 文杰

* syslog大小 改为300M
    > OK

* 5,6,7 3个月补丁
    > OK

* 删除高通feedback
    > OK

* 指纹速度,tp resume
    > SystemUI,keygurad跳过了一些流程,tp的先不用修改

* 休眠唤醒运行验签有问题
    > 压力测试一个星期,没有问题

* rtc进度,关机电流
    > 没有开rtc 漂移检测功能

* 7月7日 提测V04
    > systool 测试,删除通话记录等
    > Esim测试,新的配置文件
    > EM 4+64新模块,新的配置文件
    > Ftest测试
    > 单板测试

* EM 4+64 模块调试
    > OK

* 清除客制化信息授权,恢复logo
    > Ok

* 蔡海涛 nfc属性
    > OK

* 李斌实验室 通过LD_PRELOAD链接三方库文件执行hook正常的系统调用 安全问题
    > OK

* pci version要根据pn号来
    > OK

* 安全补丁
    > OK

* 客户资源包,放出谷歌商店,谷歌地图
    > Ok,apk安装还需要使用

* EM 屏漏电2ma
    > OK

* STK3311 光感
    > 结构在处理

* 网络同步时间,没有及时写到sp
    > 确认OK

* SE“获取POS应用信息”无反应，重启后正常 问题确认
    > 用万鑫工具,测试多次,没有复现

* 运行验签vbmeta.img
    > OK

* 文档对功能
    > https://haniu.paxsz.com:8443/view/2199#5ZWG55So6K6+5aSHL+WxnuaApw==
    > 以安排对应同事排队检查

* 没有gms包,功耗32ma,整机
    > 工厂量产回来的机器12ma

* sdcard 文件系统 预留空间
    > OK

* 工厂测试ped 不弹出,弹出来不能输入
    > OK

* 确认休眠sp是否会下电
    > 不会下电

* 耦合自动化脚本测试失败
    > 需要工厂工具 授权,0x02
    > 或者固件调试态
    > 或者L0状态

* 确认煲机 sp是否正常
    > OK

* 寄两台机器给郭庆锐,调试maxstore,调试neptune
    > 浙江省 杭州市 滨江区 火炬大道 581号  三维大厦B座8楼
    > 郭庆锐
    > 135 6717 8410
    > 已安排

* 寄3台机器,给陈晓键,适配互联互通,honeybee,petunia,walkie talkie
    > 深圳市南山区科丰路特发信息港B栋1楼
    > 陈晓键
    > 13686842416
    > 已安排

* 去掉谷歌应用,使用android原生
    > OK

* 熔丝后,wifi打不开
    > OK

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

* usb进水检测

* 亮屏降低充电电流

* charger船运模式,验证关机电流

* mantis问题

* 开机概率性出现耳机图标
    > OK

* 时间久,读id读错
    > OK

* 偏压ic漏电6ma
    > ok

* 耳机mic
    > OK

### 傅博晨

* 资源包安装完成重启

* posapi 访问usb
    > OK

* neripass接口测试
    > ok

* neptune接口测试
    > ok

* 文档 framework检查
    > ok

* google key 查询
    > OK

* !55555= google key重启没效
    > OK

* Logkit,user版本 打不开
    > OK

* systool 根据pn备注,把EEA信息写入nv分区
    > OK

* pci 蓝牙 openssl问题修改
    > OK

* google key重复写
    > OK

### 罗振辉

* cancelPedInput接口功能

* 动态扫码成功率不高

* 斑马大循环测试 成功概率低

* 后摄需要优化

* mantis bug

* 程序切换前后摄卡住
    > OK

* TP 休眠不了,不断报read data 中断
    > OK

* tp双击唤醒失败
    > OK

* camera id property
    > OK

* EM 机型,第一次打开扫码,红外灯亮的很慢
    > OK

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

* 光感 LCD亮度曲线

* 单板测试闪一下
    > OK

* 新光感
    > OK

* 指南针转不动
    > OK

* 抬起唤醒成功率不高
    > OK

### 屈明月

* 调试态授权后,ped输入不了

* edc应用ped 位置不对

* 工厂工具授权后,ped输入不了

* mantis bug

* ped 密码键盘不消失
    > OK

* 休眠唤醒,会发ped指令问题
    > OK

* security version 显示空
    > OK

### 郭侥

* mantis bug

* 白名单检查

* 同步网络时间,并且第一时间写进sp
    > OK

### 郭嘉纯

* mantis bug

* 设置颜色显示去掉

* 高通feedback功能去掉

* android beam功能去掉

* gms model name显示兼容

* 文档设置检查
    > OK

* 默认锁屏 none
    > OK

* 双击唤醒
    > OK

### 肖人涛

* 客户资源包,客户apk

* 文档 ota功能确认

* modem version显示空
    > ok

* !55555= 客户资源包版本号
    > OK

### 陈嘉科

* wifi唤醒

* mantis bug

* gps ,bt ,wifi property
    > OK

### 兰小泉

* mantis bug

* 桌面图标显示不对

* 新camera 没有后副摄

### 宋志豪

* mantis bug

* pax_adb systool get sysver, esim功能相关

* Esim
    > OK

* 文档1.9 通信检查
    > OK

* pax_adb.exe systool remove datas 去删除通话记录 这个功能
    > OK

### 唐云华

* 扫码设置项

* 休眠时间不准
    > OK

### 段祖光

* 隐藏状态栏

* 隐藏导航栏