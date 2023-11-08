# 概要

项目用到了展锐的分离式LPDDR4X + emmc flash配置,板子回来,下载失败

提示`gate training window too small`

`LPDDR4X-4GB-FBGA 200ball-CXDB5CCBM-MK-A-CXMT`

V01板子,采用一体式EMCP配置,下载启动都正常

# 关键字

下载失败

# 参考文档

* UIS8581E_DDR客制化指导手册V1.2.pdf

# DRAM自适应配置

*根据硬件设计，软件共定义5个宏

    * LP4_PINMUX_CASE0
    * LP4_PINMUX_CASE1
    * LP4_PINMUX_CASE2
    * LP3_PINMUX_CASE0
    * LP3_PINMUX_CASE1

board_id(gpio87)|board_id(gpio33)|DDR|pinmux
:--|:--|:--|:--
0|0|LPDDR3 eMCP/ Discrete LPDDR3|LP3_PINMUX_CASE0/ LP3_PINMUX_CASE1
1|0|LPDDR4X eMCP|LP4_PINMUX_CASE0
1|0|Discrete LPDDR4|LP4_PINMUX_CASE2
1|0|Discrete LPDDR4X|LP4_PINMUX_CASE1

# DRAM类型自适应

* idh.code/bsp/bootloader/chipram/ddr/ddr_init/init/ddrc/r1p0/ddrc_r1p0_auto_dected.c

```
#if defined(GPIO_DETECT_DRAM_TYPE)
struct ddr_type_t ddr_pinmux_case[4]=
{
/***   gpio_N1  gpio_N0  pinmux_case    ***/
       {0,      0,       LP3_PINMUX_CASE0},
       {0,      1,       LP4_PINMUX_CASE2},
       {1,      0,       LP4_PINMUX_CASE0},
       {1,      1,       LP4_PINMUX_CASE1}
};
void ddr_type_detect(void)
{
        uint32 gpio_n1_val,gpio_n0_val;
        char pinmux_case_detect = 0;
        char i = 0;
    sprd_gpio_request(DRAM_TYPE_DETECT_GPIO_N1);
    sprd_gpio_direction_input(DRAM_TYPE_DETECT_GPIO_N1);
    gpio_n1_val = sprd_gpio_get(DRAM_TYPE_DETECT_GPIO_N1);

#if defined(GPIO_DETECT_DRAM_TYPE_ONE_PIN)
    gpio_n0_val = 0;
#else
    sprd_gpio_request(DRAM_TYPE_DETECT_GPIO_N0);
    sprd_gpio_direction_input(DRAM_TYPE_DETECT_GPIO_N0);
    gpio_n0_val = sprd_gpio_get(DRAM_TYPE_DETECT_GPIO_N0);
#endif

//        pinmux_case_detect = ((gpio_n1_val << 1) & (gpio_n0_val ));
//        ddr_chip_cur.pinmux_case = pinmux_case_detect;

        for(i=0; i<4; i++)
        {
            if((gpio_n1_val == ddr_pinmux_case[i].gpio_1_value) && (gpio_n0_val == ddr_pinmux_case[i].gpio_0_value))
        {
            if((gpio_n1_val == ddr_pinmux_case[i].gpio_1_value) && (gpio_n0_val == ddr_pinmux_case[i].gpio_0_value))
            {
                ddr_chip_cur.pinmux_case = ddr_pinmux_case[i].ddr_pinmux_c;
                break;
            }
        }
        if(4 == i)
        {
        dmc_print_str("gpio read failed\n");
                while(1);
        }
        if(LP3_PINMUX_CASE0  == ddr_chip_cur.pinmux_case)
        {
        ddr_chip_cur.chip_type = DRAM_LPDDR3;
        ddr_chip_cur.io_mode = IO_LP3;
        }
        else if((LP4_PINMUX_CASE0  == ddr_chip_cur.pinmux_case) || (LP4_PINMUX_CASE1  == ddr_chip_cur.pinmux_case))
        {
        ddr_chip_cur.chip_type = DRAM_LPDDR4;
        ddr_chip_cur.io_mode = IO_LP4X;
        }
        else if(LP4_PINMUX_CASE2  == ddr_chip_cur.pinmux_case)
        {
        ddr_chip_cur.chip_type = DRAM_LPDDR4;
        ddr_chip_cur.io_mode = IO_LP4;
        }
}
```

# 问题原因

根据硬件贴片,gpio87 跟gpio 33,都应该要拉高,才能匹配到分离式 DDR4X

但是V02硬件,gpio33 用作了gpio输出,所以需要硬件先改一下

# 解决

硬件把gpio33,跟gpio87引脚配置后,就正常下载