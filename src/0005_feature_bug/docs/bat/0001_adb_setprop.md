# 检测新设备插入,执行adb命令

工厂耦合测试,需要自动化切换高通口.

所以需要写一个bat脚本,不断轮询adb devices,检测到devices id不一样,就执行所需要的adb命令

# 修改方法

```
@echo off

title A6650_calbration

set old_id=invalue
set current_id=invalue
set loop_count=0

:loop

set /a loop_count = %loop_count%+1

echo ===========powerby xielx,20230412,query if new device insert,%loop_count% time=============

rem 读取adb device -l 的每行的第一个,第二个元素
rem for /f "tokens=1,2" %%a in ('adb devices -l') do (
for /f "tokens=1,2" %%a in ('pax_adb devices -l') do (
    if "%%b" == "device" set current_id=%%a
)

if "%old_id%" == "%current_id%" (
    echo "no new device insert"
) else (
    echo "new device insert = %current_id%"
    set old_id=%current_id%
    rem echo adb shell setprop sys.usb.config diag,serial_cdev,rmnet,adb
    rem adb shell setprop sys.usb.config diag,serial_cdev,rmnet,adb
    echo "pax_adb systool set sys.usb.config diag,serial_cdev,rmnet,adb"
    pax_adb systool set sys.usb.config diag,serial_cdev,rmnet,adb
)

rem 输出空行,即换行
echo.

rem 5s 后循环
timeout /t 5 > nul

goto loop

pause
```
