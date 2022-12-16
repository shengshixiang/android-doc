# 高通android 12,see架构sensor修改验证

* 配置int1或者int2,上报模式用polling 等修改

    * 修改UM.9.15/vendor/qcom/proprietary/sensors-see/registry/config/bengal/agatti_qmi8658_0.json源文件

# 验证
```
adb remount
adb push .\agatti_qmi8658_0.json /vendor/etc/sensors/config/
adb shell
rm mnt/vendor/persist/sensors/registry/registry/*
reboot
```

