# README

A6650 项目由于指纹占用了debug 串口,所以就没有log输出

# 打开串口输出方法

* xbl阶段修改

    ```
    diff --git a/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/SerialPortLib/SerialPortShLibImpl.c b/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/SerialPortLib/SerialPortShLibImpl.c
    index 22bd26451d7..462aebfc167 100755
    --- a/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/SerialPortLib/SerialPortShLibImpl.c
    +++ b/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/SerialPortLib/SerialPortShLibImpl.c
    @@ -57,7 +57,7 @@
    STATIC UINT8 *SerialPortBuffer;
    STATIC UINT8 *EnQPtr, *DeQPtr;
    STATIC UINT32 PortBufferSize = 0, ActiveDataSize = 0;
    -#ifdef M9200
    +#if 1//def M9200
    STATIC BOOLEAN NoPortOut = FALSE;
    #else
    STATIC BOOLEAN NoPortOut = TRUE; //wufei close debug uart in xbl//victor m9200 need uart
    diff --git a/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/UartQupv3Lib/UartXBL.c b/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/UartQupv3Lib/UartXBL.c
    index 6b3d8b08cfe..bbe62f9229d 100755
    --- a/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/UartQupv3Lib/UartXBL.c
    +++ b/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Library/UartQupv3Lib/UartXBL.c
    @@ -70,7 +70,7 @@ typedef struct
    
    #define RING_SIZE      256  // size of the ring buffer (must be a power of 2)
    //[feature]-add-begin xielianxiong@paxsz.com,20221202,9200 need debug uart
    -#ifdef M9200
    +#if 1//def M9200
    #define USE_DEBUG_UART 1
    #else
    #define USE_DEBUG_UART 0
    diff --git a/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/XBLLoader/boot_uart.c b/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/XBLLoader/boot_uart.c
    index cbdaf238b36..a8c136d850e 100755
    --- a/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/XBLLoader/boot_uart.c
    +++ b/A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/XBLLoader/boot_uart.c
    @@ -93,7 +93,7 @@ boolean boot_uart_init(void)
    
    do {
        uart_connection_status = uart_is_cable_connected();
    -#ifdef M9200
    +#if 1//def M9200
    #else
        uart_connection_status = FALSE;//wufei close debug uart in xbl 
    #endif
    ```

* kernel修改

    ```
    diff --git a/UM.9.15/kernel/msm-4.19/arch/arm64/configs/vendor/bengal_defconfig b/UM.9.15/kernel/msm-4.19/arch/arm64/configs/vendor/bengal_defconfig
    index e5dd2dd1863..8c0ae20fe09 100755
    --- a/UM.9.15/kernel/msm-4.19/arch/arm64/configs/vendor/bengal_defconfig
    +++ b/UM.9.15/kernel/msm-4.19/arch/arm64/configs/vendor/bengal_defconfig
    @@ -364,7 +364,7 @@ CONFIG_INPUT_UINPUT=y
    # CONFIG_DEVMEM is not set
    CONFIG_SERIAL_MSM_GENI=y
    CONFIG_SERIAL_MSM_GENI_HALF_SAMPLING=y
    -#CONFIG_SERIAL_MSM_GENI_CONSOLE=y
    +CONFIG_SERIAL_MSM_GENI_CONSOLE=y
    CONFIG_TTY_PRINTK=y
    CONFIG_HW_RANDOM=y
    CONFIG_HW_RANDOM_MSM_LEGACY=y
    diff --git a/UM.9.15/vendor/qcom/proprietary/devicetree-4.19/qcom/a6650/scuba.dtsi b/UM.9.15/vendor/qcom/proprietary/devicetree-4.19/qcom/a6650/scuba.dtsi
    index a863fc7f9bd..d7822c14f5b 100755
    --- a/UM.9.15/vendor/qcom/proprietary/devicetree-4.19/qcom/a6650/scuba.dtsi
    +++ b/UM.9.15/vendor/qcom/proprietary/devicetree-4.19/qcom/a6650/scuba.dtsi
    @@ -2646,7 +2646,7 @@
    };
    
    &qupv3_se4_2uart {
    -    status = "disabled";
    +    status = "ok";
    };
    
    &qupv3_se0_i2c {
    ```

# 烧录

* 烧录files 下的 devcfg.mbn, 这个mbn打开了调试串口

* 烧录编译出来的 xbl,xbl_config, boot,dtbo

* 方法如下

    ```
    fastboot flash devcfg_a H:\shareH\software\A6650\debugUart\devcfg.mbn
    fastboot flash devcfg_b H:\shareH\software\A6650\debugUart\devcfg.mbn
    fastboot flash xbl_a H:\shareH\software\A6650\debugUart\xbl_debug.elf
    fastboot flash xbl_b H:\shareH\software\A6650\debugUart\xbl_debug.elf
    fastboot flash xbl_config_a H:\shareH\software\A6650\debugUart\xbl_config_debug.elf
    fastboot flash xbl_config_b H:\shareH\software\A6650\debugUart\xbl_config_debug.elf
    fastboot flash boot_a W:\ssdCode\a6650_2\UM.9.15\out\target\product\bengal\boot.img
    fastboot flash boot_b W:\ssdCode\a6650_2\UM.9.15\out\target\product\bengal\boot.img
    fastboot flash dtbo_a W:\ssdCode\a6650_2\UM.9.15\out\target\product\bengal\dtbo.img
    fastboot flash dtbo_b W:\ssdCode\a6650_2\UM.9.15\out\target\product\bengal\dtbo.img
    fastboot reboot
    ```