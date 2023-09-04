# 软件版本发布流程

pax 使用PLM 发布版本,PLM一点都不人性化,记录一下发布版本步骤.提测版本也是同一个流程

# 关键字

* PLM,释放版本,发布版本

# 版本号管理

* 正式版本不带T

* 带T版本是用于试产,T0,T1,T2,T几 代表在info工程改动单,查到的第几个版本,每释放一个版本,版本号都要加1

![0007_0037](images/0007_0037.png)

# 修改记录

使用gitchangelog_164.py 生成软件记录 Uniphiz_12.0.0_Ginkgo软件维护记录.xlsx

## 首版软件

* 先命名一个空的excel表,命名格式,Paydroid(Uniphiz)_安卓版本(12.0.0)_平台代号+软件维护记录.xlsx

    * Uniphiz_12.0.0_Ginkgo软件维护记录.xlsx

* 把 gitchangelog_164.py 跟 Uniphiz_12.0.0_Ginkgo软件维护记录.xlsx 放在服务器代码根目录

* git log,记录第一笔提交,到最后一笔提交的commit id,还有 版本号(生成的paydroid包自带),运行下面命令,生成记录

    * python3 gitchangelog_164.py 61af930e026ea4de64aae9bf424385074fbe9aaf..9ced01cac96077860de001f0f4e4d3fa01bbac5a -ef Uniphiz_12.0.0_Ginkgo软件维护记录.xlsx -paxver V23.1.00T0 -paxmodel A6650 -paxproduct A6650

## 后续软件

* 先把上次的excel表Uniphiz_12.0.0_Ginkgo软件维护记录.xlsx,还有 gitchangelog_164.py 拷贝到代码目录

* 记录上次的commit id,到这次软件的commit id,还有版本号+时间,不然会覆盖excel表,运行下面命令,生成记录

    * python3 gitchangelog_164.py 19c6dc33c79a9ee6b751f68310996807b49d5b16..9ced01cac96077860de001f0f4e4d3fa01bbac5a -ef Uniphiz_12.0.0_Ginkgo软件维护记录.xlsx -paxver V23.1.00T0_20230119 -paxmodel A6650 -paxproduct A6650

* 然后修改生成xlx的一些不对的信息

    * AP_VER: PayDroid_12.0.0_Ginkgo_V23.1.00T1_20230512_Release.paydroid

# 上传软件

* 打开PLM系统,info首页有链接

* 打开PLM存储库,找对应平台的文件夹(PayDroid 12.0 Ginkgo QCM2290),没有的话可以找项目管理的人创建,然后上传对应软件到对应目录,一般都有以下目录,没有的话找项目管理的人创建

    * Android OS

    * Modem

    * SP_OS

    * SP_Boot

    ![0007_0001.png](images/0007_0001.png)

* 上传Android os

    * 点击上图的 Android OS,进入如下图,点击下图的新建代码

        ![0007_0002.png](images/0007_0002.png)

    * 选择目标代码,下一步

        ![0007_0003.png](images/0007_0003.png)
    
    * 选择paydroid包,填入版本号,commit id等信息

        ![0007_0004.png](images/0007_0004.png)

    * 如果有上传过同样的版本号的话,会弹出提示,点击确定

        ![0007_0005.png](images/0007_0005.png)

    * 点击完成,等待上传

        ![0007_0006.png](images/0007_0006.png)

    * 上传完成,点击确定

        ![0007_0007.png](images/0007_0007.png)

    * 点击刚才的版本,开始上传修改记录等附件

        ![0007_0008.png](images/0007_0008.png)

    * 点击更多属性

        ![0007_0009.png](images/0007_0009.png)
    
    * 上传修改记录excel表,ota包等属性

        ![0007_0010.png](images/0007_0010.png)

        ![0007_0011.png](images/0007_0011.png)

        ![0007_0012.png](images/0007_0012.png)

    * 继续添加更多附件,ota包,vmlinux

        ![0007_0013.png](images/0007_0013.png)

    * 点击保存等待

        ![0007_0014.png](images/0007_0014.png)

    * 点击检入

        ![0007_0015.png](images/0007_0015.png)

    * 重新上传paydroid包,估计是系统bug

        ![0007_0016.png](images/0007_0016.png)

* 上传 dragonboard,就是fac包,工厂贴片软件

    ![0007_0017.png](images/0007_0017.png)

    * 上传fac包,步骤跟之前类似,省略一些.

        ![0007_0018.png](images/0007_0018.png)

* 上传sp boot,sp monitor,modem ,步骤与之前类似.sp boot,monitor 解压paydroid包获得, sp commit id,sp monitor文件名称自带

    ![0007_0019.png](images/0007_0019.png)

# 修改已经上传的软件

* 如果需要修改已经上传的软件,选择检出与编辑

    ![0007_0024.png](images/0007_0024.png)

* 按照提示重新选择paydroid包等附件

    ![0007_0025.png](images/0007_0025.png)

* 最后选择检入

    ![0007_0026.png](images/0007_0026.png)

# 提交目标代码

* 主页,提交目标代码

    ![0007_0020.png](images/0007_0020.png)

* 选择对应人员,分类,完成任务,填写备注.

    ![0007_0021.png](images/0007_0021.png)

# 编写升级记录

* 编写中英文的版本升级记录, 放到邮件附件.

    ![0007_0022.png](images/0007_0022.png)

    ![0007_0023.png](images/0007_0023.png)

# 邮件通知测试部,可以测试

修改记录记得附上附件

![0007_0027.png](images/0007_0027.png)

# 一些额外文件

不一定是必须的

## ap commit id

* edfd45f8c947dfb8a5c7ece3a5000e51ebc7f76c,[Title]:应用研发部反馈USB通讯问题

* git log c975ade1b21..edfd45f8c94 > A6650_V04_ap_commit_log.txt

* python3 gitchangelog_164.py c975ade1b21eb51ef6a316f34b91c5f2544b0473..edfd45f8c947dfb8a5c7ece3a5000e51ebc7f76c -ef Paydroid_12.0.0_Ginkgo软件维护记录.xlsx -paxver V23.1.00T2_20230720 -paxmodel A6650 -paxproduct A6650

## sp boot commit id

* runthos-sp-boot-chunfen-1.0.00.ddafd142R_SIG.bin

* git log cfe6ab76..ddafd142 > ../A6650_V04_sp_boot_commit_log.txt

## sp os commit id

* runthos-sp-chunfen-1.0.03.94e8016fR.bin

* git log c2839271..94e8016f > ../A6650_V04_sp_os_commit_log.txt

## 平台化paxdroid commit id

* 9a5f08976b23fd48354b8b5c8581a9f5570bab1c, 合并分支 'cherry-pick-e4160398' 到 'paxdroid_runthos2.7',[Title]: ATM系列机型增加支持扩展支付设备(如D135)的选项

* git log 3dbcb64c..9a5f0897 > A6650_V04_paxdroid_commit_log.txt

* python3 gitchangelog_164.py 3dbcb64c155e1c0901fe92c07527cc5846b7408a..9a5f08976b23fd48354b8b5c8581a9f5570bab1c -ef Paydroid_12.0.0_Ginkgo平台化软件维护记录.xlsx -paxver V23.1.00T2_20230720 -paxmodel A6650 -paxproduct A6650

## libspc commit id

* 69a736a70800b0e02e1f21e1c8c3b47256b3f125,合并分支,[Title]:增加标签打印获取纸张模式接口

* git log 2403a836c424cab5cc604c7838ff7d5b29f4fa82..69a736a70800b0e02e1f21e1c8c3b47256b3f125 > ~/A6650_V04_libspc_commit_log.txt

# 填写如下文件

* A6650版本升级记录.docx

* A6650 Version Update Records.docx

* 还有自测试报告

# 软件被驳回后,处理流程

* 先找到被驳回的是哪个版本

    ![0007_0028.png](images/0007_0028.png)

* 检出和编辑

    ![0007_0029.png](images/0007_0029.png)

* 上传文件和重新检入

    ![0007_0030.png](images/0007_0030.png)

* 确定

    由于plm有bug,需要重新选一次,确定一次

    ![0007_0031.png](images/0007_0031.png)

* 路由菜单

    ![0007_0032.png](images/0007_0032.png)

* 点击软件驳回,请修改

    ![0007_0033.png](images/0007_0033.png)

* 填写备注,完成任务

    这里引用图标错误,不过大概就是完成任务

    ![0007_0036.png](images/0007_0036.png)

* 提交任务

    ![0007_0035.png](images/0007_0035.png)

* 完成任务

    ![0007_0036.png](images/0007_0036.png)