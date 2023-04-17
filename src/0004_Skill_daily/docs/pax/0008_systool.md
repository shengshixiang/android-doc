# README

systool 的使用 

# systool set

* pax_adb systool set time 2017/09/28-13:25:00

* 设置系统属性,pax_adb systool set systprop pax.ctrl.log 1,

* pax_adb  systool set sys.usb.config diag,serial_cdev,rmnet,adb ,设置高通默认端口,!3646633 ,也可以

* pax_adb  systool set sys.usb.config diag,serial_cdev,rmnet,adb ,恢复成默认usb配置

# systool get

* 获取系统属性,pax_adb  systool get systprop pax.ctrl.log

* pax_adb  systool get time

* pax_adb  systool get imei

# systool dump

以下两个配合 pax_adb systool set systprop pax.ctrl.log 1对解决问题应该还是比较有用的

* pax_adb systool dump syslog

* pax_adb systool dump persist-log

* systool remove

* 删除cache下的预装app, 

# help

```
fprintf(stderr,
-            "systool <subcommand>\n"
-            "    subcommand : [control|update|write|set|get|remove|startproc|reboot|test]\n"
-            "\n"
-            "  ---  systool control <command ID>\n"
-            "       For example:\n"
-            "           systool control 1 \n"
-            "           systool control 2 \n"
-            "           systool control 3 \n"
-            "           systool control 4 \n"
-            "           systool control 5 \n"
-            "\n"
-            "  ---  systool update <what> <source file>\n"
-            "       For example:\n"
-            "           systool update os <OTA.zip>\n"
-            "           systool update bootlogo <bootlogo-*.bin>\n"
-            "           systool update resource <resource-*.zip>\n"
-            "           systool update bootanimation <bootanimation.zip>\n"
-            "           systool update monitor <monitor.bin>\n"
-            "           systool update spboot <spboot.bin>\n"
-            "           systool update modem <modem.bin>\n"
-            "           systool update cfg <cfg.ini>\n"
-            "\n"
-            "  ---  systool write <what> <source file>\n"
-            "       For example:\n"
-            "           systool write puk <puk file path>\n"
-            "           systool write apn <apn file path>\n"
-            "           systool write uninstall_whitelist <uninstall_whitelist file path>\n"
-            "           systool write customer-pubkey <customer pubkey file path>\n"
-            "           systool write scan-license <lic.data file path>\n"
-            "           systool write keybox <keybox.data file path>\n"
-            "\n"
-            "  ---  systool set <what> <value> <subvalue>\n"
-            "       For example:\n"
-            "           systool set customer 0xff \n"
-            "           systool set language <language_country> \n"
-            "           systool set time 2017/09/28-13:25:00 \n"
-            "           systool set timezone Asia/Shanghai \n"
-            "           systool set mtp on/off yyyymmdd9876 \n"
-            "           systool set wifi on/off \n"
-            "           systool set sysprop <property-key> <property-value> \n"
-            "           systool set wifissid <none/wpa> <ssid> <password> \n"
-            "           systool set misc-cfg <key> <value> \n"
-            "               --- systool set misc-cfg ethmac 11:22:33:44:55:66 \n"
-            "           systool set wifimac 11:22:33:44:55:66 \n"
-            "           systool set btmac 11:22:33:44:55:66 \n"
-            "           systool set imei <index> 01234567891234 \n"
-            "           systool set sn 0123456789 \n"
-            "           systool set face-activate <licenseKey> \n"
-            "           systool set sgps <BEIDOU/GLONASS/...> # Switch GPS \n"
-            "               --- systool set sgps BEIDOU   # Switch Positioning System to BEIDOU\n"
-            "           systool set exdev-transfer mpos"
-            "           systool set exdev/ext_device usbadb 0/1 #adb switch to exdev"
-            "\n"
-            "  ---  systool get <what> <subkey>\n"
-            "       For example:\n"
-            "           systool get device-info \n"
-            "           systool get sysver \n"
-            "           systool get isNewScannerActive \n"
-            "           systool get sysprop <property key> \n"
-            "           systool get misc-cfg <key> \n"
-            "               --- systool get misc-cfg ethmac \n"
-            "           systool get wifimac\n"
-            "           systool get btmac\n"
-            "           systool get imei <index>\n"
-            "\n"
-            "  ---  systool remove <what> <subkey> \n"
-            "       For example:\n"
-            "           systool remove datas  \n"
-            "           systool remove rki  \n"
-            "           systool remove package <package name> \n"
-            "           systool remove uninstall_whitelist \n"
-            "           systool remove persist-app <apk path> \n"
-            "           systool remove unsigned-apps \n"
-            "           systool remove network-settings \n"
-            "                   NOTE: Internal Use Only. \n"
-            "           systool remove misc-cfg \n"
-            "           systool remove scanner_active_flag \n"
-            "\n"
-            " ---  systool install <type> <source file> \n"
-            "      For example:\n"
-            "          systool install app <apk path> \n"
-            "                  ---> same as 'pm install -r *.apk' \n"
-            "          systool install persist-app <apk path> \n"
-            "                  ---> install persist app - not affacted by factory reset. \n"
-            "          systool install preinstall <apk dir> \n"
-            "                  NOTE: Internal Use Only. \n"
-            "                  ---> install all the apks under 'dir' directory. \n"
-            "\n"
-            "  ---  systool startproc <what> <arg1> <arg2> \n"
-            "       For example:\n"
-            "           systool startproc Activity <packageName> <ActivityName> \n"
-            "           systool startproc Activity action <ActionName> \n"
-            "\n"
-            "  ---  systool reboot \n"
-            "  ---  systool sync \n"
-            "\n"
-            "  ---  systool dump <what> \n"
-            "       For example:\n"
-            "           systool dump puk \n"
-            "           systool dump puk /system/etc/PAX.puk \n"
-            "           systool dump customer-pubkey \n"
-            "           systool dump syslog \n"
-            "           systool dump persist-log \n"
-            "      "
-            "\n"
-            "\n\n"
```
