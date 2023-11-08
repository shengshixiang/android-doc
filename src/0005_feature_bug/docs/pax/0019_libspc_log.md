# 概要

有时候需要调试librunthosspdev/libspc/ 的问题,需要打开ap log

# 关键字

libspc log

# 修改方法

```
--- a/external/pax/lib/librunthosspdev/spdev.c
+++ b/external/pax/lib/librunthosspdev/spdev.c
@@ -269,7 +269,8 @@ int updateSpInfo(){
 #define TAG    "spc"
 static int spc_log_cb(void *buf, int len)
 {
-    LOGW(TAG, buf, len);
+    //LOGW(TAG, buf, len);
+    LOGE(TAG, buf, len);
     return 0;
 }
```

# 原理

SpdevOpen 的时候,会把spc_log_cb 传参 spc_log_init

```
int SpdevOpen(void)
{
    int ret; 
    POS_AUTH_INFO *authinfo;

    SpdevPowerSwitch(0);
    usleep(10 * 1000);
    SpdevPowerSwitch(1);

    ret = spdev_serial_open_s();
    if (0 != ret) 
    {    
        DP_ERR("spdev_serial_open_s Error=%d", ret);
        return -ENODEV;
    }    

    spc_log_init(3, spc_log_cb);
    nrf_rpc_log_level_set(3);
    trans_log_level_set(3);

// [FEATURE] Add-BEGIN 
#ifdef CHECK_SP_WORK_STATUS
    spc_hook_set_at_cmd_start(check_sp_work_status, NULL);
#endif
// [FEATURE] Add-END by 

    ret = nrf_rpc_init(spdev_nrf_rpc_err_handler_s);
    if (0 != ret) 
    {    
        DP_ERR("nrf_rpc_init Error=%d", ret);
        return -EINVAL;
    }    

    spc_ap_evt_init();
```