# 概要

新项目带上nfc pn7160,需要调试pn7160,记录一下调试过程

# 关键字

nfc porting,nfc调试,nfc移植

# 参考文档

AN13189_PN7160 Android porting guide.pdf

# PN7160 参考电压

类型|PN553/PN80T、PN557/PN81T|PN7160
:--|:--|:--
VBAT|2.8~5.5V|2.8~5.5V
VDD(UP)|3.1~5.8V|2.8~5.8V
VDD(PAD)|1.65~1.95V,typical 1.8V|1.65~1.95V，typical 1.8V,3.0~3.6V，typical 3.3V
VDD(GPIO)|1.65~1.95V，typical 1.8V| NA
VDD_TX|Configurations using TXLDO| Configurations using TXLDO
Vi(RXP,RXN)|input voltage 20mV~VDDA-0.05V,RF level detector 5.5~15mVNFC level detector 8~23mV| input voltage 20mV~VDDA-0.05V,RF level detector 5.5~15mV NFC level detector 8~23mV
Ro(TX1,TX2)|0.65~1.4Ω, typical 0.9Ω| 0.65~1.4Ω, typical 0.9Ω

# 驱动

* 可以参考porting guide 下载一下驱动,注意硬件是用iic还是spi做通讯

由于已经有项目用过pn7160,所以直接从其他项目挪过来.还有dtb.编译顺利通过

* 根据原理图,配置gpio,iic

    * VDD(PAD) <- LCD1_3V3_MIPI <- S_VCC_TP_3V3 <- GPIO_45 <- VPH_PWR

    * iic <- S_TP_I2C_SCL,S_TP_I2C_SDA <- GPIO_29,GPIO_28 <- qupv3_se7_i2c

    * IRQ NFC <- S_LCD_TP_INT <- GPIO_82

    * VEN NFC <- S_LCD_TP_RST <- GPIO_116

    * DWL REQ NFC <- S_DSI_TE_COM <- GPIO_81

    * Vbat <- VPH_PWR

# 编译

* 文件没有编译到,打印的错误,全部不出log

原因是sc138_defconfig定义的CONFIG_PAX_NFC_SUPPORT=y ,需要在nfc这个目录的kconfig里面包含

# 修改

* android/kernel/msm-4.14/arch/arm64/configs/vendor/sc138_defconfig

```
+# [FEATURE]-Add-begin by starmenxie@hotmail.com, 20230916, for pn7160 nfc
+CONFIG_PAX_NFC_SUPPORT=y
+CONFIG_NFC_PN7160_DEVICES=y
+# [FEATURE]-Add-end by starmenxie@hotmail.com, 20230916, for pn7160 nfc
```

* kernel/msm-4.14/drivers/misc/pax/nfc/Kconfig

```
#
# Nxp Nci protocol (I2C) devices
#

config PAX_NFC_SUPPORT
    tristate "PAX NFC SUPPORT"
    default n
    help
        Enable PAX NFC SUPPORT

config NFC_PN7160_DEVICES
    bool "Nxp PN7160 NCI protocol driver (I2C) devices"
    default n
    ---help---
      You'll have to say Y if your computer contains an I2C device that
      you want to use under Linux.

      You can say N here if you don't have any SPI connected to your computer.

source "drivers/misc/pax/nfc/pn7160/Kconfig"
```

* kernel/msm-4.14/drivers/misc/pax/Makefile

```
# [feature]-add-begin by starmenxie@hotmail.com, 20230916, for NFC PN7160
obj-$(CONFIG_PAX_NFC_SUPPORT) += nfc/
# [feature]-add-end by starmenxie@hotmail.com, 20230916, for NFC PN7160
```

* kernel/msm-4.14/drivers/misc/pax/nfc/pn7160/Kconfig

根据原理设计,配置使用默认的iic通讯

```
--- a/android/kernel/msm-4.14/drivers/misc/pax/nfc/pn7160/Kconfig
+++ b/android/kernel/msm-4.14/drivers/misc/pax/nfc/pn7160/Kconfig
@@ -4,7 +4,7 @@
 
 config NXP_NFC_I2C
        tristate "NFC I2C Slave driver for NXP-NFCC"
-       depends on I2C
+       default y
        help
          This enables the NFC driver for PN71xx based devices.
          This is for I2C connected version. NCI protocol logic
```

# log

log显示 gpio nxp,pn7160-power request失败,发现smtouchxx5468@2E 跟这个tp共用一路,

先把tp注释掉,定位一下原因

```
[   10.662720] ############The pn7160 dts start to initliaze!############
[   10.666392] IR MCE Keyboard/mouse protocol handler initialized
[   10.673005] OK selecting active state
[   10.676291] IR XMP protocol handler initialized
[   10.681002] nfc_parse_dt: irq 82
[   10.700363] iommu: Adding device 5a00000.qcom,vidc:non_secure_cb to group 16
[   10.702162] gpio_request nfc_power_gpio ret:-16 
[   10.711465] iommu: Adding device 5a00000.qcom,vidc:secure_bitstream_cb to group 17
[   10.711909] gpio_direction_output nfc_power_gpio ret:0 
[   10.721449] iommu: Adding device 5a00000.qcom,vidc:secure_pixel_cb to group 18
[   10.727142] nfc_parse_dt: 82, 116, 81
[   10.736883] iommu: Adding device 5a00000.qcom,vidc:secure_non_pixel_cb to group 19
[   10.739803] ############The pn7160 dts is ready!############
[   10.740025] configure_gpio: unable to request nfc gpio [116]
[   10.752665] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_cb1 to group 20
[   10.752760] CAM-SMMU cam_smmu_populate_sids:2115 __debug cnt = 6, cb->name: :vfe sid [0] = 1056\x0a,
[   10.756470] nfc_i2c_dev_probe: unable to request nfc reset gpio [116]
[   10.764282] CAM-SMMU cam_smmu_populate_sids:2115 __debug cnt = 6, cb->name: :vfe sid [1] = 1057\x0a,
[   10.770178] nfc_i2c_dev_probe: probing not successful, check hardware
[   10.779535] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_cb2 to group 21
[   10.783952] nxp,pn7160: probe of 2-0028 failed with error -16
[   10.794076] CAM-SMMU cam_smmu_populate_sids:2115 __debug cnt = 3, cb->name: :cpp sid [0] = 2048\x0a,
[   10.834862] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_cb4 to group 22
[   10.853215] CAM-SMMU cam_smmu_populate_sids:2115 __debug cnt = 3, cb->name: :jpeg_enc0 sid [0] = 2080\x0a,
```

* kernel/msm-4.14/arch/arm64/boot/dts/qcom/pax_l1450/trinket-idp.dtsi

发现单独把qupv3_se7_i2c 添加status = "disabled"; 还是跑进去了.估计其他节点把这个qupv3_se7_i2c 打开了.所以把smtouchxx5468@2E 节点添加 status = "disabled"; 再试试

```
&qupv3_se7_i2c {
    status = "disabled";

    lt7911@2b {
        compatible = "lt,lt7911";
        reg = <0x2b>;
        lt7911,irq_pin = <&tlmm 91 0>;
        lt7911,en_pin = <&tlmm 44 0>;
        lt7911,reset_pin = <&tlmm 103 0>;
        lt7911,lcd_reset_pin = <&tlmm 97 0>;
        lt7911,lcd_power_pin = <&tlmm 43 0>;
        lt7911,cfg_name = "lt7911_2b_L1450_cfg.bin";
        lt7911,pwr_on_rst = <1>;
    };  
    
    smtouchxx5468@2E{ 
    status = "disabled";
    compatible = "chipsemi,chsc_cap_touchxx5468"; 
    reg = <0x2E>;   
    interrupt-parent = <&tlmm>; 
    interrupts = <82 0x2008>;
    chipsemi,vdd-ctrl = "GPIO";
    chipsemi,vdd-gpio = <&tlmm 45 0>; 
    chipsemi,int-gpio = <&tlmm 82 0x2008>; 
    chipsemi,rst-gpio = <&tlmm 116 0x0>; 
    pinctrl-names = "pmx_ts_active","pmx_ts_suspend","pmx_ts_release";  
    pinctrl-0 = <&chsc_reset_active &chsc_int_active>;
    pinctrl-1 = <&chsc_reset_active &chsc_int_active>;
    pinctrl-2 = <&chsc_reset_active &chsc_int_active>;
    };

};
```

# vendor porting

* 添加nxp vendor库libpn7160_fw.so相关,还有libnfc-nci.conf,libnfc-nxp.conf 根据项目具体配置,

    git clone https://github.com/NXPNFCLinux/nxpnfc_android11.git ${ANDROID_BUILD_TOP}/vendor/nxp/nfc

# 协议栈 porting

根据porting guid还有,具体的patch合入

* AROOT_frameworks_base.patch

* AROOT_frameworks_native.patch

* AROOT_hardware_nxp_nfc.patch

* AROOT_packages_apps_Nfc.patch

* AROOT_system_nfc.patch

* AROOT_vendor_nxp_frameworks.patch

* 还有调用编译配置

```
diff --git a/android/device/qcom/qssi/BoardConfig.mk b/android/device/qcom/qssi/BoardConfig.mk
index 62ca5adff1..e0238f408d 100644
--- a/android/device/qcom/qssi/BoardConfig.mk
+++ b/android/device/qcom/qssi/BoardConfig.mk
@@ -176,3 +176,6 @@ DIRECTED_RECOVERY_SNAPSHOT := true
 DIRECTED_RAMDISK_SNAPSHOT := true
 
 -include vendor/qcom/vsdk-configs/snapshot_modules/*/*.mk
+
+#For PN7160
+include vendor/nxp/nfc/BoardConfigNfc.mk
diff --git a/android/device/qcom/qssi/qssi.mk b/android/device/qcom/qssi/qssi.mk
index 830a7ee07a..5e7add2bee 100755
--- a/android/device/qcom/qssi/qssi.mk
+++ b/android/device/qcom/qssi/qssi.mk
@@ -311,3 +311,6 @@ $(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/*.mk)
 $(call inherit-product-if-exists, paxdroid/device/paxdroid.mk)
 $(call inherit-product-if-exists, vendor/paxsz/paxbuild.mk)
 #[FEATURE]-Add-END by starmenxie@hotmail.com, 2021/11/25, for paxdroid
+
+#include NFC PN7160
+$(call inherit-product-if-exists, vendor/nxp/nfc/device-nfc.mk)
diff --git a/android/device/qcom/sc138/BoardConfig.mk b/android/device/qcom/sc138/BoardConfig.mk
index 8d7d187d5c..c626008bd7 100755
--- a/android/device/qcom/sc138/BoardConfig.mk
+++ b/android/device/qcom/sc138/BoardConfig.mk
@@ -326,3 +326,6 @@ BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
 -include vendor/qcom/defs/board-defs/vendor/*.mk
 #################################################################################
 include device/qcom/sepolicy_vndr/SEPolicy.mk
+
+#For PN7160
+#include vendor/nxp/nfc/BoardConfigNfc.mk
diff --git a/android/device/qcom/sc138/sc138.mk b/android/device/qcom/sc138/sc138.mk
index 0091afdc08..ad3d58feac 100755
--- a/android/device/qcom/sc138/sc138.mk
+++ b/android/device/qcom/sc138/sc138.mk
@@ -448,3 +448,6 @@ PRODUCT_PACKAGES += modem-version
  # [FEATURE]-Add-END by 
 
  PRODUCT_PACKAGES += lt7911_upgrade
+
+#include NFC PN7160
+$(call inherit-product-if-exists, vendor/nxp/nfc/device-nfc.mk)
```

# 测试

To further test NFC reader functionality, NFC TagInfo by NXP and NFC TagWriter by NXP are 2 applications
available for free from Google Play store.

可以下载两个应用测试nfc功能

* NFC TagInfo

* NFC TagWriter

# 问题点

* B卡不识别

    因为天线匹配不对,换了天线就正常识别B卡

* log显示gpio_request nfc_power_gpio ret:-16

    因为tp占用了gpio45资源,注册失败没有释放,释放后就OK

    ```
    --- a/android/kernel/msm-4.14/drivers/input/touchscreen/goodix_gt9xx_sub/gt9xx_sub.c
    +++ b/android/kernel/msm-4.14/drivers/input/touchscreen/goodix_gt9xx_sub/gt9xx_sub.c
    @@ -1924,6 +1924,10 @@ static int gt9xx_sub_power_deinit(struct goodix_ts_data *ts)
            if (ts->vcc_i2c)
                    regulator_put(ts->vcc_i2c);
    
    +    if (gpio_is_valid(ts->pdata->power_gpio)) {
    +        gpio_free(ts->pdata->power_gpio);
    +    }
    +
            return 0;
    }
    ```

* android/kernel/msm-4.14/arch/arm64/boot/dts/qcom/pax_l1450/trinket-idp.dtsi

    dtbo设置pinctrl 不会导致gpio_request失败

    ```
    set_state = pinctrl_lookup_state(pinctrl,"nfc_active");
    ret = pinctrl_select_state(pinctrl,set_state);
    	nfc_power_gpio = of_get_named_gpio(np, "nxp,pn7160-power", 0);
	if ((gpio_is_valid(nfc_power_gpio))) {
		ret = gpio_request(nfc_power_gpio, "nfc_power");
		pr_info("gpio_request nfc_power_gpio ret:%d \n",ret);
		if(ret < 0){
		}else{
			ret = gpio_direction_output(nfc_power_gpio, 1);
			pr_info("gpio_direction_output nfc_power_gpio ret:%d \n",ret);
		}
	}else{
		pr_err("%s: not control nfc power gpio,\n", __func__);
	}
    ```