# 概要

camera log太多,一下子就堆满了log

所以需要控制输出

# pax camera log控制

* persist.vendor.camera.enablelog 1

    pax定制了控制输出log开关, 设置1 ,打开log

# 原生log定义

* ./UM.9.15/vendor/qcom/proprietary/camx/src/settings/common/camxsettings.xml

# 打开log方法

## setprop

```
adb shell setprop persist.vendor.camera.logInfoMask  0x82         //使能info等级中的HAL和sensor log
adb shell setprop persist.vendor.camera.logVerboseMask  0x82    //使能verbose log等级中的HAL和sensor log
adb shell setprop vendor.debug.camera.overrideLogLevels   0x1f   //使能chi-cdk中的log
killall android.hardware.camera.provider@2.4-service_64 
```

其中，logVerboseMask定义在vendor/qcom/proprietary/camx/src/settings/g_camxsettings.h，也可以改成
UINT64                  logConfigMask;                      ///< Mask of which per frame/request config logs are output
UINT64                  logCoreCfgMask;                    ///< Mask of which core config logs are output
UINT64                  logDumpMask;                      ///< Mask of which Dump logs are output
UINT64                  logEntryExitMask;                   ///< Mask of which entry/exit logs are output
UINT64                  logInfoMask;                        ///< Mask of which info logs are output
UINT64                  logPerfInfoMask;                    ///< Mask of which perf info logs are output
UINT64                  logVerboseMask;                    ///< Mask of which verbose logs are output
UINT64                  logWarningMask;                    ///< Mask of which warning logs are output

## vendor/etc/camera/camxoverridesettings.txt

```
adb shell "mkdir vendor/etc/camera"
adb shell "echo logVerboseMask=xxx >> vendor/etc/camera/camxoverridesettings.txt"
重启机器，或者重启服务即可：
adb shell "killall android.hardware.camera.provider@2.4-service_64"
```

* vendor/qcom/proprietary/camx/src/utils/camxtypes.h

```
static const CamxLogGroup CamxLogGroupAFD           = (static_cast<UINT64>(1) << 0);    ///< AFD     0x1
static const CamxLogGroup CamxLogGroupSensor        = (static_cast<UINT64>(1) << 1);    ///< Sensor   0x2
static const CamxLogGroup CamxLogGroupTracker       = (static_cast<UINT64>(1) << 2);    ///< Tracker   0x4
static const CamxLogGroup CamxLogGroupISP           = (static_cast<UINT64>(1) << 3);    ///< ISP      0x8
static const CamxLogGroup CamxLogGroupPProc         = (static_cast<UINT64>(1) << 4);    ///< Post Processor  0x10
static const CamxLogGroup CamxLogGroupMemMgr        = (static_cast<UINT64>(1) << 5);    ///< MemMgr      0x20
static const CamxLogGroup CamxLogGroupPower     = (static_cast<UINT64>(1) << 6);  ///< Power (clock, bandwidth related)
static const CamxLogGroup CamxLogGroupHAL           = (static_cast<UINT64>(1) << 7);    ///< HAL            0x80
static const CamxLogGroup CamxLogGroupJPEG          = (static_cast<UINT64>(1) << 8);    ///< JPEG          0x100
static const CamxLogGroup CamxLogGroupStats         = (static_cast<UINT64>(1) << 9);    ///< Stats            0x200
static const CamxLogGroup CamxLogGroupCSL           = (static_cast<UINT64>(1) << 10);   ///< CSL           0x400
static const CamxLogGroup CamxLogGroupApp           = (static_cast<UINT64>(1) << 11);   ///< Application      0x800
static const CamxLogGroup CamxLogGroupUtils         = (static_cast<UINT64>(1) << 12);   ///< Utilities           0x1000
static const CamxLogGroup CamxLogGroupSync          = (static_cast<UINT64>(1) << 13);   ///< Sync           0x2000
static const CamxLogGroup CamxLogGroupMemSpy        = (static_cast<UINT64>(1) << 14);   ///< MemSpy      0x4000
static const CamxLogGroup CamxLogGroupFormat        = (static_cast<UINT64>(1) << 15);   ///< Format         0x8000
static const CamxLogGroup CamxLogGroupCore          = (static_cast<UINT64>(1) << 16);   ///< Core        0x10000
static const CamxLogGroup CamxLogGroupHWL           = (static_cast<UINT64>(1) << 17);   ///< HWL       0x20000
static const CamxLogGroup CamxLogGroupChi           = (static_cast<UINT64>(1) << 18);   ///< CHI         0x40000
static const CamxLogGroup CamxLogGroupDRQ           = (static_cast<UINT64>(1) << 19);   ///< DRQ       0x80000
static const CamxLogGroup CamxLogGroupFD            = (static_cast<UINT64>(1) << 20);   ///< FD         0x100000
static const CamxLogGroup CamxLogGroupIQMod         = (static_cast<UINT64>(1) << 21);   ///< IQ module  0x200000
static const CamxLogGroup CamxLogGroupLRME          = (static_cast<UINT64>(1) << 22);   ///< LRME     0x400000
static const CamxLogGroup CamxLogGroupCVP           = (static_cast<UINT64>(1) << 22);   ///< CVP       0x400000
static const CamxLogGroup CamxLogGroupNCS           = (static_cast<UINT64>(1) << 23);   ///< NCS       0x800000
static const CamxLogGroup CamxLogGroupMeta          = (static_cast<UINT64>(1) << 24);   ///< Metadata  0x1000000
static const CamxLogGroup CamxLogGroupAEC           = (static_cast<UINT64>(1) << 25);   ///< AEC     0x2000000
static const CamxLogGroup CamxLogGroupAWB           = (static_cast<UINT64>(1) << 26);   ///< AWB    0x4000000
static const CamxLogGroup CamxLogGroupAF            = (static_cast<UINT64>(1) << 27);   ///< AF       0x8000000
static const CamxLogGroup CamxLogGroupSWP           = (static_cast<UINT64>(1) << 28);   ///< SW Process
static const CamxLogGroup CamxLogGroupHist          = (static_cast<UINT64>(1) << 29);   ///< Histogram Process
static const CamxLogGroup CamxLogGroupBPS           = (static_cast<UINT64>(1) << 30);   ///< BPS     0x40000000
static const CamxLogGroup CamxLogGroupDebugData     = (static_cast<UINT64>(1) << 31);   ///< Debug-Data Framework -
                                                           ///  3A Debug-Data & Tuning-metadata    0x80000000
```

* 例子

```
echo logVerboseMask=0x8>> /vendor/etc/camera/camxoverridesettings.txt  // 使能ISP的log
echo logVerboseMask=0x80>> /vendor/etc/camera/camxoverridesettings.txt  // 使能HAL的log
echo logVerboseMask=0x88>> /vendor/etc/camera/camxoverridesettings.txt  // 同时使能ISP和HAL的log
使能chi-cdk中的log等级：
echo overrideLogLevels=0x1F >> vendor/etc/camera/camxoverridesettings.txt
打开DRQ的log：
echo logDRQEnable=TRUE >> /vendor/etc/camera/camxoverridesettings.txt
```