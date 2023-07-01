# 本文简介

介绍一些pax的一些简单功能跟属性定义

# persist.system.No.DebugIcon

setprop persist.system.No.DebugIcon true, 桌面不显示 Debug图标,不管调试态与否

# pax.ctrl.log

setprop pax.ctrl.log 1 , 打开一些pax的log开关

# pax_adb syslog

pax_adb syslog > log.txt  , 有时候不能授权,不能用adb logcat ,可以用该命令捉到一些log,可能不全