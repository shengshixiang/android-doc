# 概述

项目接usb直接开机,同事反馈有些电脑开机特别慢,慢15s

# 正常LOG

`usb calibrate port open timeout7259,5258,2000`usb相关配置2s

```
[00003867] (sprd_dump): (write_sysdump_before_boot): NO need minidump !!!
[00003874] (sprd_dump): (write_sysdump_before_boot): is_partition_ok : 1 , full_dump_allow : 0 .  !!!
[00003882] (sprd_dump): (write_sysdump_before_boot): NO need full  dump memory !!!
[00003973] hbc:32-mode_chk_af6:ret = 0, io_num_a_level = 1, io_num_b_level = 1.
[00003986] 		regu_ldo 000000009f107b18 (vddusb33) 3300 = 1200 +2100mv (trim=210 step=10000uv)
[00004285] musb-hdrc: peripheral reset irq lost!
[00004635] USB SERIAL CONFIGED
[00006639] usb calibrate port open timeout7259,5258,2000
[00006643] 		regu_ldo 000000009f107b18 (vddusb33) 3300 = 1200 +2100mv (trim=210 step=10000uv)
[00006652] the function is not defined and enters the shutdown charging mode!
[00006668] enter boot mode 2
[00006671] lcd start init time:7291ms
[00006676] [sprdfb][lcd_enable] start flip
[00006697] sprd dual backlight power on. pwm_index=1 pwm_index2=0 brightness=25
[00006704] uboot consume time:6704ms, lcd init consume:33ms, backlight on time:7324ms 
[00006712] sprd_get_vboot_key(): load_buf is 0x000000009efffe00.
[00006717] sprd_get_vboot_key(): sechdr_offset is 0x1299f0.
[00006723] sprd_get_vboot_key(): sechdr_addr is 0x000000009f1297f0.
[00006729] sprd_get_vboot_key(): sechdr_addr: 000000009f1297f0. cert_addr: 000000009f129850. 
[00006737] sprd_get_vboot_key(): sechdr_offset is 0x1299f0, sechdr_addr->cert_offset is 0x129a50.
[00006746] cert_key
[00006747] dumpHex:32 bytes

[00006750] d6a80b223a6b1030bd3add384ad04e78

[00006754] 3caabda67c9ebd0e69d3de8020b0025c
```

# 异常LOG

`usb calibrate configuration timeout,19645,4644,15000` 花费了15s

```
[00003739] is_7s_reset 0x0, systemdump 0x0
[00003743] (sprd_dump): (write_sysdump_before_boot): Check dump info ......
[00003760] Error!common_raw_read(): read size(0x4 + 0x0) overflow the total partition size(0x0)
[00003776] fulldumpdb partition is  not exsit ... mark flag ok 
[00003781] (sprd_dump): (show_check_enable_status_result): ------------------	show_check_enable_status_result 	------------------ .
[00003793] (sprd_dump): (show_check_enable_status_result): full_dump_enable : 1 .
[00003800] (sprd_dump): (show_check_enable_status_result): mini_dump_enable : 1 .
[00003807] (sprd_dump): (show_check_enable_status_result): full_dump_allow  : 0 .
[00003815] (sprd_dump): (show_check_enable_status_result): mini_dump_allow  : 0 .
[00003822] (sprd_dump): (show_check_enable_status_result): reset_mode       : (0)-(undefind mode) .
[00003830] (sprd_dump): [00003833] Error!sysdump_save_extend_information(): sysdumpdb:  Not exception mode .do nothing 
(sprd_dump): [00003842] Error!add_uboot_log_to_section(): add section: bootloader_last_log failed!!
(sprd_dump): (write_sysdump_before_boot): is_partition_ok : 1 , mini_dump_allow : 0 .  !!!
[00003861] (sprd_dump): (write_sysdump_before_boot): NO need minidump !!!
[00003867] (sprd_dump): (write_sysdump_before_boot): is_partition_ok : 1 , full_dump_allow : 0 .  !!!
[00003876] (sprd_dump): (write_sysdump_before_boot): NO need full  dump memory !!!
[00003966] hbc:32-mode_chk_af6:ret = 0, io_num_a_level = 1, io_num_b_level = 1.
[00003979] 		regu_ldo 000000009f107b18 (vddusb33) 3300 = 1200 +2100mv (trim=210 step=10000uv)
[00004259] musb-hdrc: peripheral reset irq lost!
[00019020] usb calibrate configuration timeout,19645,4644,15000
[00019025] 		regu_ldo 000000009f107b18 (vddusb33) 3300 = 1200 +2100mv (trim=210 step=10000uv)
[00019033] the function is not defined and enters the shutdown charging mode!
[00019050] enter boot mode 2
[00019052] lcd start init time:19677ms
[00019058] [sprdfb][lcd_enable] start flip
[00019075] sprd dual backlight power on. pwm_index=1 pwm_index2=0 brightness=25
[00019082] uboot consume time:19082ms, lcd init consume:30ms, backlight on time:19707ms 
[00019090] sprd_get_vboot_key(): load_buf is 0x000000009efffe00.
[00019095] sprd_get_vboot_key(): sechdr_offset is 0x1299f0.
[00019101] sprd_get_vboot_key(): sechdr_addr is 0x000000009f1297f0.
[00019107] sprd_get_vboot_key(): sechdr_addr: 000000009f1297f0. cert_addr: 000000009f129850. 
[00019115] sprd_get_vboot_key(): sechdr_offset is 0x1299f0, sechdr_addr->cert_offset is 0x129a50.
[00019123] cert_key
[00019125] dumpHex:32 bytes
```

# 代码

* idh.code/bsp/bootloader/u-boot15/common/loader/calibration_detect.c

`is_timeout` 超过15s

```
int is_timeout(void)
{

    now_time = get_timer_masked();

    if((now_time - start_time)>count_ms)
        return 1;
    else{
        return 0;
    }    
}
int cali_usb_enum(void)
{
    int ret = 0; 
    count_ms = get_cal_enum_ms();
    start_time = get_timer_masked();
    while(!usb_is_configured()){
        ret = is_timeout();
        if(ret == 0)
            continue;
        else{
            printf("usb calibrate configuration timeout,%lu,%lu,%lu\n",now_time,start_time,count_ms);
            return 0;
            }    
        }    
    printf("USB SERIAL CONFIGED\n");

    start_time = get_timer_masked();
    count_ms = get_cal_io_ms();
    while(!usb_is_port_open()){
        ret = is_timeout();
        if(ret == 0)
            continue;
        else{
            printf("usb calibrate port open timeout%lu,%lu,%lu\n",now_time,start_time,count_ms);
            return 0;
            }
        }
    gs_open();
    printf("USB SERIAL PORT OPENED\n");
    return 1;
}
```

* idh.code/bsp/bootloader/u-boot15/include/configs/uis8581e_5h10.h

```
#define CALIBRATE_ENUM_MS 15000
```

* idh.code/bsp/bootloader/u-boot15/drivers/usb/gadget/u_serial.c

`usb_serial_configed` usb没有配置上

```
int usb_is_configured(void)
{
    if(!usb_serial_configed)
        usb_gadget_handle_interrupts();

    return usb_serial_configed;
}

/**
 * gserial_connect - notify TTY I/O glue that USB link is active
 * @gser: the function, set up with endpoints and descriptors
 * @port_num: which port is active
 * Context: any (usually from irq)
 *
 * This is called activate endpoints and let the TTY layer know that
 * the connection is active ... not unlike "carrier detect".  It won't
 * necessarily start I/O queues; unless the TTY is held open by any
 * task, there would be no point.  However, the endpoints will be
 * activated so the USB host can perform I/O, subject to basic USB
 * hardware flow control.
 *
 * Caller needs to have set up the endpoints and USB function in @dev
 * before calling this, as well as the appropriate (speed-specific)
 * endpoint descriptors, and also have set up the TTY driver by calling
 * @gserial_setup().
 *
 * Returns negative errno or zero.
 * On success, ep->driver_data will be overwritten.
 */
int gserial_connect(struct gserial *gser, u8 port_num)
{
    struct gs_port  *port;
        unsigned long   flags;
    int     status;
#if 0
    if (!gs_tty_driver || port_num >= n_ports)
        return -ENXIO;
#else
    if (port_num >= n_ports)
        return -ENXIO;

#endif

    /* we "know" gserial_cleanup() hasn't been called */
    port = ports[port_num].port;

    /* activate the endpoints */
    status = usb_ep_enable(gser->in, gser->in->desc);
    if (status < 0)
        return status;
    gser->in->driver_data = port;

    status = usb_ep_enable(gser->out, gser->out->desc);
    if (status < 0)
        goto fail_out;
    gser->out->driver_data = port;
        /* then tell the tty glue that I/O can work */
    spin_lock_irqsave(&port->port_lock, flags);
    gser->ioport = port;
    port->port_usb = gser;

    /* REVISIT unclear how best to handle this state...
     * we don't really couple it with the Linux TTY.
     */
    gser->port_line_coding = port->port_line_coding;

    /* REVISIT if waiting on "carrier detect", signal. */

    /* if it's already open, start I/O ... and notify the serial
     * protocol about open/close status (connect/disconnect).
     */
    if (port->open_count) {
        pr_debug("gserial_connect: start ttyGS%d\n", port->port_num);
        gs_start_io(port);
        if (gser->connect)
            gser->connect(gser);
    } else {
        if (gser->disconnect)
            gser->disconnect(gser);
    }
        spin_unlock_irqrestore(&port->port_lock, flags);
    usb_serial_configed = 1;
    return status;

fail_out:
    usb_ep_disable(gser->in);
    gser->in->driver_data = NULL;
    return status;
}
```

# 原因

由于电脑跟终端的匹配有问题,导致一直延时15s