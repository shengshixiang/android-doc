# 概要

展锐8581e android 12新项目适配runthos

虽然之前2290 高通 android 12的新项目,适配过runthos,但是但是没有备注,忘记怎么弄了

趁着这次机会,重新备注以下

# 关键字

runthos适配

# clone libspc代码

* paydroidbuild.sh 添加自动化下载libspc代码

* paxdroid/external/pax/lib/librunthosspdev/libspc/

# 配置runthos 宏

* device/uis8581e/uis8581e_a12_dev1.mk

    > CONFIG_RUNTHOS_SP:= true
    > ro.pax.runthOs=true
    > ro.pax.keyboardtype=2

# paxservice没有起来

* external/pax/lib/librunthosspdev/spdev.c

SpdevOpen -> nrf_rpc_init 卡死

# 调试手段

* external/pax/device/include/spdevcomm.h

打开libpaxspdev.so 的DP log,对应文件``external/pax/lib/librunthosspdev/spdev.c``

```
 //#define DP printf
 
 #undef DEBUG
-//#define DEBUG
+#define DEBUG
 #include <android/log.h>
 #define LOGTAG "pax-Spdev"
 ```

* external/pax/lib/libttyapi/runthos/ttyPosApi.c

    * 打开libttyapi.so 串口的DP log

    ```
    -/* #define TAG "ttyPosApi" */
    -/* #include <android/log.h> */
    -/* #define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__); */
    -/* #define DP LOGD */
    -#define DP printf_null
    +#define TAG "ttyPosApi"
    +#include <android/log.h>
    +#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__);
    +#define DP LOGD
    +//#define DP printf_null
    ```

    * 先关闭流控

        ```
         int OpenSerial3(const char *SerialName, int baudrate)
        {
        -       return OpenSerial_ex(SerialName, baudrate, 1);//for OpenSerial3 hw flow control is on
        +       return OpenSerial_ex(SerialName, baudrate, 0);//for OpenSerial3 hw flow control is on
        }
        ```

* ./external/pax/lib/librunthosspdev/libspc/nrf_rpc/platform/android/include/nrf_rpc_log.h

nrf_rpc.c 添加LOGE, push /system/lib64/libpaxspdev.so 验证

```
LOGE("victor","111,Initializing nRF RPC module");
```

* ./external/pax/lib/libpaxapisvr/config/A930RTXConfig.cpp

把波特率改成1.5m,PUSH /system/bin/paxservice 验证

```
--- a/external/pax/lib/libpaxapisvr/config/A930RTXConfig.cpp
+++ b/external/pax/lib/libpaxapisvr/config/A930RTXConfig.cpp
@@ -16,7 +16,8 @@ void A930RTXConfig::initConfig(DevConfig *devConfig)
         {
             strcpy((char*)devConfig->spdevConfig.spDevName,TTY_SPDEV);
         }
-        devConfig->spdevConfig.rate = 3000000;
+//        devConfig->spdevConfig.rate = 3000000;
+        devConfig->spdevConfig.rate = 1500000;
```

# 解决

把波特率改成1500000后,可以通讯,后续等正式板子回来,再看看为什么3M不行