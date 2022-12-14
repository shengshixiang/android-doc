# bug描述

> 0044049: A6650 PED写入所有密钥，并使用各密钥进行相应的运算失败

# 分析

## 复现问题,安装paydroidtester,PED_S_GENERAL->PED
* 先跑 	PED_INT_FUN4 用例,看看情况,复测成功
* PedCalcAes_FUN4,复测pass
* PedErase_FUN1  ,复测pass
* TrsysGenRsaKey_FUN3,复测失败,捉log看下
    * 对比 A35测试OK
    * 对比 A3700失败
    * 经查,runthos 没有实现 Spdev_PedInjectRsaKey  方法
    * A35 的 monitor 有实现,所以A35没有问题,A3700有问题

* pedAesMacCalcsession_FUN1 这一题A3700也是测试不过,提示一样的-301错误.相信也是同样runthos没有实现方法问题
* pedInjectKeyBlock_FUN1,复测pass
* pedWriteCipherKey_FUN1,复测失败,跟A3700一样,相信也是runthos没有实现相关方法

