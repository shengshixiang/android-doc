# 概要

不论是酷达威,还是智码讯付,都需要根据终端的属性,例如wifi,imei等信息,激活扫码

# 智码讯付

* pax_adb systool write scan-license  D:\lic.data, 其实也是执行了push操作

* pax_adb push lic.data /cache/data/license/

* pax_adb push lic.data  /data/resource/public/

* pax_adb systool startproc Activity com.pax.paxscansactivate com.pax.paxscansactivate.FactoryTestActivity
    > 这个是cp到/cache/data/license/的意思

* pax_adb systool get sysprop persist.pax.scan.flag 查看是否返回true

# 酷达威

* pax_adb push hdcrt.lic  /data/resource/public/

* pax_adb push hdcrt.lic /cache/data/license/

* pax_adb systool startproc Activity com.pax.paxscansactivate com.pax.paxscansactivate.FactoryTestActivity

* pax_adb systool get sysprop persist.pax.scan.flag