# 熔丝后指纹不识别

高通2290平台,烧录efuse后,指纹不识别,没有菜单

# 解决方案

A6650_Unpacking_Tool/TZ.XF.5.1/trustzone_images/build/ms/bin/FAYAANAA/fs_fp.mbn

签名的ta名字不对,ta 是fs_fp.mbn, 对应应该是 VAR:fs_fp,但是原来是 VAR:fingerpr

```
--- a/A6650_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/config/agatti/agatti_secimage.xml
+++ b/A6650_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/config/agatti/agatti_secimage.xml
@@ -362,7 +362,7 @@
                 <anti_rollback_version>0x00000000</anti_rollback_version>
             </general_properties_overrides>
             <pil_split>true</pil_split>
-            <meta_build_location>$(FILE_TYPE:file_ref, ATTR:pil_split, VAR:fingerpr)</meta_build_location>
+            <meta_build_location>$(FILE_TYPE:file_ref, ATTR:pil_split, VAR:fs_fp)</meta_build_location>
         </image>
```

对应这支文件也需要拷贝一下到tz_path

```
--- a/A6650_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/copy_sc200e_qcm2290_sec_img.py
+++ b/A6650_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/copy_sc200e_qcm2290_sec_img.py
@@ -46,6 +46,7 @@ shutil.copy((secimage_path+"storsec/storsec.mbn"), (tz_app_path+"storsec.mbn"))
 shutil.copy((secimage_path+"tz/tz.mbn"), (tz_path+"tz.mbn"))
 shutil.copy((secimage_path+"sampleapp32/smplap32.mbn"), (tz_path+"smplap32.mbn"))
 shutil.copy((secimage_path+"sampleapp64/smplap64.mbn"), (tz_path+"smplap64.mbn"))
+shutil.copy((secimage_path+"fs_fp/fs_fp.mbn"), (tz_path+"fs_fp.mbn"))
 #shutil.copy((secimage_path+"isdbtmm/isdbtmm.mbn"), (tz_path+"isdbtmm.mbn"))
 #shutil.copy((secimage_path+"widevine/widevine.mbn"), (tz_path+"widevine.mbn"))
 #shutil.copy((secimage_path+"cppf/cppf.mbn"), (tz_path+"cppf.mbn"))
```