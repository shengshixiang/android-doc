# README

fastboot命令介绍

# 命令

* fastboot reboot            #重启⼿机

* fastboot reboot-bootloader    #重启到bootloader模式,其实就是再次进入fastboot

* fastboot -w reboot #清除手机中所有数据然后重启，等同于系统中的“恢复出厂设置”，或Recovery模式的“清空所有数据”操作

* fastboot boot <内核镜像文件名或路径> #临时启动镜像，不会烧录和替换内核文件到存储中,类似于在PC端用U盘启动PE系统

* fastboot oem device-info #输出当前BL锁状态(非MTK)

* fastboot oem lks #输出当前BL锁状态(MTK)

* fastboot oem reboot-recovery #重启进入Recovery模式

* fastboot oem poweroff #拔掉数据线后关机

* fastboot oem lock #重新上BL锁并清空所有数据(需未开启root)

* fastboot oem unlock #解除BL锁并清空所有数据(小米手机必须绑定账号,主动申请解锁,等待7天,使用工具才行)

* fastboot oem edl #进入高通9008模式,无需工程线或主板短接,可无视BL锁线刷
    
    > 需要自己在bootloader实现,fastboot oem rebootedl

* fastboot erase boot    #擦除boot分区(擦了引导就没了,会卡在第一屏,)

* fastboot erase recovery   #擦除recovery分区

* fastboot erase system    #擦除system分区(擦了系统就没了,会卡在第二屏)

* fastboot erase userdata    #擦除userdata分区(可擦,清空数据用)

* fastboot erase cache    #擦除cache分区(可擦,清空数据用)

# fastboot getvar 指令

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/FastbootLib/FastbootCmds.c

```
FastbootPublishVar ("has-slot:boot", "yes");
FastbootPublishVar ("current-slot", CurrentSlotFB);
FastbootPublishVar ("has-slot:system",
FastbootPublishVar ("has-slot:modem",
FastbootPublishVar ("slot-count", SlotCountVar);
FastbootPublishVar (PublishedPartInfo[PtnLoopCount].getvar_size_str,
FastbootPublishVar (PublishedPartInfo[PtnLoopCount].getvar_type_str,
FastbootPublishVar ("kernel", "uefi");
FastbootPublishVar ("max-download-size", MaxDownloadSizeStr);
FastbootPublishVar ("is-userspace", "no");
FastbootPublishVar ("snapshot-update-status", SnapshotMergeState);
FastbootPublishVar ("product", FullProduct);
FastbootPublishVar ("serialno", StrSerialNum);
FastbootPublishVar ("secure", IsSecureBootEnabled () ? "yes" : "no");
FastbootPublishVar ("variant", StrVariant);
FastbootPublishVar ("logical-block-size", LogicalBlkSizeStr);
FastbootPublishVar ("erase-block-size", EraseBlkSizeStr);
FastbootPublishVar ("version-bootloader", DevInfoPtr->bootloader_version);
FastbootPublishVar ("version-baseband", DevInfoPtr->radio_version);
FastbootPublishVar ("battery-voltage", StrBatteryVoltage);
FastbootPublishVar ("battery-soc-ok", StrBatterySocOk);
FastbootPublishVar ("charger-screen-enabled", ChargeScreenEnable);
FastbootPublishVar ("off-mode-charge", ChargeScreenEnable);
FastbootPublishVar ("unlocked", IsUnlocked () ? "yes" : "no");
FastbootPublishVar ("hw-revision", StrSocVersion);
FastbootPublishVar ("parallel-download-flash", "no");
FastbootPublishVar ("parallel-download-flash", "yes");
FastbootPublishVar ("exsn", pax_exsn);
FastbootPublishVar ("check-firmware-ver", VerName);
```

* 获取机器是否熔丝 fastboot getvar secure

# fastboot 设置指令

* fastboot 设置解锁,flashing unlock

```
#ifdef ENABLE_UPDATE_PARTITIONS_CMDS
      {"flash:", CmdFlash},
      {"erase:", CmdErase},
      {"set_active", CmdSetActive},
      {"flashing get_unlock_ability", CmdFlashingGetUnlockAbility},
      {"flashing unlock", CmdFlashingUnlock},
      {"flashing lock", CmdFlashingLock},
#endif
/*
 *CAUTION(CRITICAL): Enabling these commands will allow changes to bootimage.
 */
#ifdef ENABLE_DEVICE_CRITICAL_LOCK_UNLOCK_CMDS
      {"flashing unlock_critical", CmdFlashingUnLockCritical},
      {"flashing lock_critical", CmdFlashingLockCritical},
#endif
/*
 *CAUTION(CRITICAL): Enabling this command will allow boot with different
 *bootimage.
 */
#ifdef ENABLE_BOOT_CMD
      {"boot", CmdBoot},
#endif
      {"oem enable-charger-screen", CmdOemEnableChargerScreen},
      {"oem disable-charger-screen", CmdOemDisableChargerScreen},
      {"oem off-mode-charge", CmdOemOffModeCharger},
      {"oem select-display-panel", CmdOemSelectDisplayPanel},
      {"oem device-info", CmdOemDevinfo},
//[feature]-add-begin xielianxiong@paxsz.com,20220917,for fastboot reboot-edl
      {"oem rebootedl", CmdRebootEdl},
//[feature]-add-begin xielianxiong@paxsz.com,20220917,for fastboot reboot-edl
      {"continue", CmdContinue},
      {"reboot", CmdReboot},
#ifdef DYNAMIC_PARTITION_SUPPORT
      {"reboot-recovery", CmdRebootRecovery},
      {"reboot-fastboot", CmdRebootFastboot},
#ifdef VIRTUAL_AB_OTA
      {"snapshot-update", CmdUpdateSnapshot},
#endif
#endif
      {"reboot-bootloader", CmdRebootBootloader},
      {"getvar:", CmdGetVar},
      {"download:", CmdDownload},
      {"oem display-cmdline", CmdOemDisplayCommandLine},
```