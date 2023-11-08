# 概要

需要用到配置文件,调试参数,所以配置文件一直签名就很麻烦

# 状态

展锐android12 平台,pax init 在sp init 之前,pax init就会解释分区的配置文件,所以没签名的话,配置文件就解释不了

并且不可以通过固件调试态的状态去判断是否验签, 因为固件调试太,在sp init才会去初始化

# 流程

* idh.code/bsp/bootloader/u-boot15/board/spreadtrum/uis8581e_5h10/uis8581e_5h10.c

初始化 `pax_init`

```
int board_late_init(void)
{

 boot_mode_t boot_role;
        extern chipram_env_t* get_chipram_env(void);
        chipram_env_t* cr_env = get_chipram_env();
        boot_role = cr_env->mode;

#ifndef CONFIG_SPRD_VEHICLE
    boot_pwr_check();
    pax_init();

#if !defined(CONFIG_FPGA)
#ifdef CONFIG_NAND_BOOT
    //extern int nand_ubi_dev_init(void);
    nand_ubi_dev_init();
    debugf("nand ubi init OK!\n");
#endif
    battery_init();
    debugf("CHG init OK!\n");
#endif

#endif
    board_keypad_init();

    return 0;
}
```

* bsp/bootloader/u-boot15/common/cmd_cboot.c

初始化 `sp_init`

```
int do_cboot(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    volatile int i;
    boot_mode_enum_type bootmode = CMD_UNDEFINED_MODE;
    CBOOT_MODE_ENTRY boot_mode_array[CMD_MAX_MODE] ={0};
    chipram_env_t* cr_env;
    uint8_t spl_status = 0;

    if(argc > 2)
        return CMD_RET_USAGE;

    if(is_pax_ready){
        printf("pax_init err , enter fastboot\r\n");^M
        fastboot_mode();^M
    }^M 
^M
    sp_init();

#if defined(CONFIG_UBOOT_HWFEATURE) && defined(CONFIG_SOC_QOGIRL6)
    if (check_phase_version_process() == -1) {
        lcd_printf("bad combination can not boot\n");
        while(1);
    }   
#endif

#ifdef CONFIG_AUTOLOAD_MODE
    autoload_mode();
#endif
```

# 解决方法

* idh.code/bsp/bootloader/u-boot15/pax/pax.c

去掉下载验签

```
--- a/idh.code/bsp/bootloader/u-boot15/pax/pax.c
+++ b/idh.code/bsp/bootloader/u-boot15/pax/pax.c
@@ -582,7 +582,7 @@ int pax_download_handle(int type, const char *name, void *data, unsigned long lo
                }
 
                printf("cfg2 len %llu\n",sz);
-               if (0 != pax_security_verify_image(data, (unsigned int)sz)) {
+               if (authinfo.FirmDebugStatus == 0 && 0 != pax_security_verify_image(data, (unsigned int)sz)) {
                    return -2;
                }
```

* idh.code/bsp/bootloader/u-boot15/pax/cfg.c 

去掉开机验签

```
+++ b/idh.code/bsp/bootloader/u-boot15/pax/cfg.c
@@ -1048,6 +1048,7 @@ int pax_cfg_init(void)
     int i;
     int ret,retval;
     int returnval = 0;
+    POS_AUTH_INFO *p_authinfo;
 
     puts("pax cfg init\n");
 
@@ -1063,14 +1064,19 @@ int pax_cfg_init(void)
     if (retval > 0) {
         len = retval + 16;
         printf("pax_cfg_init len =%d\n",len);
-        ret = pax_security_verify_image(tbuf,len);
-        printf("pax_cfg_init pax_security_verify_image ret =%d\n",ret);
-        if (ret != 0) {
-            lcd_printf( "ERROR config verify fail\n");
-            printf( "ERROR config verify fail\n");
-            return -2;
+        p_authinfo = pax_get_authinfo();
+        printf( "victor,pax_get_authinfo begin,p_authinfo = 0x%p\n",p_authinfo);
+        if(p_authinfo != NULL && p_authinfo->FirmDebugStatus == 0){
+            printf( "victor,p_authinfo->FirmDebugStatus = %d,\n",p_authinfo->FirmDebugStatus);
+        }else{
+            ret = pax_security_verify_image(tbuf,len);
+            printf("pax_cfg_init pax_security_verify_image ret =%d\n",ret);
+            if (ret != 0 ) {
+                lcd_printf( "ERROR config verify fail\n");
+                printf( "ERROR config verify fail\n");
+                return -2;
+            }
         }
-
         retval = base64encode(tbuf,len,cfgfile_base64,sizeof(cfgfile_base64));
         printf("pax_cfg_init base64encode retval =%d\n",retval);
         cfgfile_base64[retval] = 0;
```