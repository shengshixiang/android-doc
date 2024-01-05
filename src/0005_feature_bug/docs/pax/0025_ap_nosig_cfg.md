# 概要

下载配置文件不验签,展锐,android 12平台

# 方法

* sp

sp要下载不验签的sp boot,跟sp os

* idh.code/bsp/bootloader/u-boot15/pax/pax.c

```
--- a/idh.code/bsp/bootloader/u-boot15/pax/pax.c
+++ b/idh.code/bsp/bootloader/u-boot15/pax/pax.c
@@ -707,6 +707,7 @@ int pax_download_handle(int type, const char *name, void *data, unsigned long lo
           sz = sz-1;
         }
 
+/* victor do not verify
         printf("cfg2 len %llu\n",sz);
         if(0!=pax_security_verify_image(data,(unsigned int)sz)){
             return -2;
@@ -724,6 +725,7 @@ int pax_download_handle(int type, const char *name, void *data, unsigned long lo
           lcd_printf("cfg model error\n");
           return -1;
         }
+*/
         if(0!=pax_download_cfg(data, (unsigned int)sz, type))
             return -1;
```

* idh.code/bsp/bootloader/u-boot15/pax/security.c

```
--- a/idh.code/bsp/bootloader/u-boot15/pax/security.c
+++ b/idh.code/bsp/bootloader/u-boot15/pax/security.c
@@ -87,6 +87,7 @@ static int GetImageInfo(unsigned char *addr, unsigned int size, struct image_sig
 
 int pax_security_verify_image(unsigned char *addr, unsigned int size)
 {
+/*
     int ret;
     unsigned char digest[32], buf[1024];
     struct image_signature_t image;
@@ -120,6 +121,7 @@ int pax_security_verify_image(unsigned char *addr, unsigned int size)
         lcd_printf( "VerifyImage error Signature not match\n");
         return -4;
     }
+*/
     return 0;
 }
```

# 修改方案2

也可以将验签函数,直接返回0

* idh.code/bsp/bootloader/u-boot15/pax/security.c

```
--- a/idh.code/bsp/bootloader/u-boot15/pax/security.c
+++ b/idh.code/bsp/bootloader/u-boot15/pax/security.c
@@ -87,6 +87,9 @@ static int GetImageInfo(unsigned char *addr, unsigned int size, struct image_sig
 
 int pax_security_verify_image(unsigned char *addr, unsigned int size)
 {
+#if 1
+    return 0;
+#else
     int ret;
     unsigned char digest[32], buf[1024];
     struct image_signature_t image;
@@ -121,10 +124,14 @@ int pax_security_verify_image(unsigned char *addr, unsigned int size)
         return -4;
     }
     return 0;
+#endif
 }
 
 int pax_security_verify_image_ex(unsigned char *addr, unsigned int size, unsigned char *digest)
 {
+#if 1
+    return 0;
+#else
     int ret;
     unsigned char buf[1024];
     struct image_signature_t image;
@@ -155,4 +162,5 @@ int pax_security_verify_image_ex(unsigned char *addr, unsigned int size, unsigne
         return -4;
     }
     return 0;
+#endif
 }
```