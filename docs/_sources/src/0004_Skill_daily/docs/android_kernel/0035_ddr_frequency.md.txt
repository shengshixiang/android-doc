# 查看ddr频率

## mtk平台

### EMMC

* adb shell cat /sys/kernel/debug/mmc0/clock

### DDR

* adb shell cat /sys/bus/platform/drivers/emi_clk_test/read_dram_data_rate

## 高通平台

### EMMC

* cat /sys/kernel/debug/mmc0/clock

### DDR

debug版本

* cat /sys/kernel/debug/clk/measure_only_mccc_clk/clk_measure