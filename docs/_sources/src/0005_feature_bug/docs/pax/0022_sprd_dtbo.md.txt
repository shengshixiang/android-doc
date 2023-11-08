# 概要

展锐A12 平台, pax dtbo匹配流程

# 关键字

dtbo,匹配

# 流程

* idh.code/bsp/bootloader/u-boot15/pax/pax.c

获取`pax_product_id`

```
int set_pax_product_id(void)
{
    char main_board[32];
    char port_board[32];
    int main_board_num = 0x00;
    int port_board_num = 0x00;


    if (pax_cfg_get("MAIN_BOARD",main_board,32)>0) {^M
        main_board[3] = '\0';
        main_board_num = simple_strtoul((main_board+1), NULL, 10); 
        printf("main_board_num 0x%x\n", main_board_num);
    }    

    if (pax_cfg_get("PORT_BOARD",port_board,32)>0) {^M
        port_board[3] = '\0';
        port_board_num = simple_strtoul((port_board+1), NULL, 10); 
        printf("port_board_num 0x%x\n", port_board_num);
    }    

    printf("machine_id 0x%x\n", base_info_t->machine_id);

    pax_product_id = ((base_info_t->machine_id & 0xff) << 16)
                    | ((main_board_num & 0xff) << 8)
                    | (port_board_num & 0xff);

    printf("pax cfg ready pax_product_id 0x%x\n",pax_product_id);

    return 0;
}
```

* idh.code/bsp/bootloader/u-boot15/common/loader/loader_nvm.c

```
static int look_for_matching_device_from_dt(char *fdt_temp, dt_img_type dt_type)
{
    ...
    /*match dtbo*/
    if (DTBO_TYPE == dt_type) {
        cell = fdt_getprop(fdt_temp, nodeoffset, "board_id", &len);
        if (cell && len >= sizeof(int))
                dtbo_boardid = fdt32_to_cpu(cell[0]);
        debugf("Find kernel dtbo prop name boardid=0x%x, pax_product_id=0x%x\n", dtbo_boardid, pax_product_id);

        if ((pax_product_id & 0xff0000) == dtbo_boardid) {
            printf("Matches Base_PCBA dtbo(id = 0x%x) in multiple DTBO.\n", dtbo_boardid);
            ret = 1;
            goto end;
        } else if ((pax_product_id & 0xffff00) == dtbo_boardid) {
            printf("Matches Main_PCBA dtbo(id = 0x%x) in multiple DTBO.\n", dtbo_boardid);
            ret = 2;
            goto end;
        } else {
            debugf("This dtbo file is not match\n");
            ret = -1;
            goto end;
        }
    }
    ...
```

* idh.code/bsp/kernel/kernel5.4/arch/arm64/boot/dts/sprd/uis8581e-5h10-overlay-pax-AF6-v00-v00.dts

定义`board_id`

```
    model = "Spreadtrum UIS8581E-5H10 Board";

    compatible = "sprd,uis8581e-5h10", "sprd,uis8581e";

    board_id = <0x7F0000>;
    board_rev = <0x00000000>;

    fragment {
```