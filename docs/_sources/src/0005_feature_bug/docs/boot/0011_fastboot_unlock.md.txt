# 概要

烧录efuse机器后,很多操作都需要fastboot unlock

介绍一下fastboot unlock的流程

# 关键字

unlock

# unlock 与 unlock_critical 区别

在看代码过程中,还会看到有 unlock 跟 unlock_critical 两种操作

暂时没有仔细去看具体区别,当时看起来 unlock_critical 只是需要更新bootloader的话,需要打开

# oem unlock

想要 fastboot flashing unlock,要先进入开发者选项,打开oem unlock

如果没打开,直接输入fastboot flashing unlock ,就会提示如下

```
Flashing Unlock is not allowed
```

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/FastbootLib/FastbootCmds.c

就会被 IsAllowUnlock 拦住

```
STATIC VOID
SetDeviceUnlock (UINT32 Type, BOOLEAN State)
{
  BOOLEAN is_unlocked = FALSE;
  char response[MAX_RSP_SIZE] = {0};
  EFI_STATUS Status;

  if (Type == UNLOCK)
    is_unlocked = IsUnlocked ();
  else if (Type == UNLOCK_CRITICAL)
    is_unlocked = IsUnlockCritical ();
  if (State == is_unlocked) {
    AsciiSPrint (response, MAX_RSP_SIZE, "\tDevice already : %a",
                 (State ? "unlocked!" : "locked!"));
    FastbootFail (response);
    return;
  }

  /* If State is TRUE that means set the unlock to true */
  if (State && !IsAllowUnlock) {
    FastbootFail ("Flashing Unlock is not allowed\n");
    return;
  }
}
```

从如下代码可以看到,oem unlock的状态,是保存在 frp里面

```
STATIC EFI_STATUS
ReadAllowUnlockValue (UINT32 *IsAllowUnlock)
{
  EFI_STATUS Status;
  EFI_BLOCK_IO_PROTOCOL *BlockIo = NULL;
  EFI_HANDLE *Handle = NULL;
  UINT8 *Buffer;

  Status = PartitionGetInfo ((CHAR16 *)L"frp", &BlockIo, &Handle);
  if (Status != EFI_SUCCESS)
    return Status;

  if (!BlockIo)
    return EFI_NOT_FOUND;

  Buffer = AllocateZeroPool (BlockIo->Media->BlockSize);
  if (!Buffer) {
    DEBUG ((EFI_D_ERROR, "Failed to allocate memory for unlock value \n"));
    return EFI_OUT_OF_RESOURCES;
  }

  Status = BlockIo->ReadBlocks (BlockIo, BlockIo->Media->MediaId,
                                BlockIo->Media->LastBlock,
                                BlockIo->Media->BlockSize, Buffer);
  if (Status != EFI_SUCCESS)
    goto Exit;

  /* IsAllowUnlock value stored at the LSB of last byte*/
  *IsAllowUnlock = Buffer[BlockIo->Media->BlockSize - 1] & 0x01;

Exit:
  FreePool (Buffer);
  return Status;
}
```

# fastboot flashing unlock

如下图,输入命令后,提示UNLOCK THE BOOTLOADER,选中后,按power键

![0011_0001](images/0011_0001.png)

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/BootLib/UnlockMenu.c

可以看到,通过`UnlockMenuShowScreen` 函数,显示 UNLOCK THE BOOTLOADER

通过MenuKeysDetectionInit检测按键按入

```
STATIC MENU_MSG_INFO mUnlockMenuMsgInfo[] = {
    {{"<!>"}, BIG_FACTOR, BGR_RED, BGR_BLACK, COMMON, 0, NOACTION},
    {{"\n\nBy unlocking the bootloader, you will be able to install "
      "custom operating system on this phone. "
      "A custom OS is not subject to the same level of testing "
      "as the original OS, and can cause your phone "
      "and installed applications to stop working properly.\n"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     COMMON,
     0,
     NOACTION},
    {{"\nSoftware integrity cannot be guaranteed with a custom OS, "
      "so any data stored on the phone while the bootloader "
      "is unlocked may be at risk. "},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     COMMON,
     0,
     NOACTION},
    {{"To prevent unauthorized access to your personal data, "
      "unlocking the bootloader will also delete all personal "
      "data on your phone.\n"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     COMMON,
     0,
     NOACTION},
    {{"\nPress the Volume keys to select whether to unlock the bootloader, "
      "then the Power Button to continue.\n\n"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     COMMON,
     0,
     NOACTION},
    {{"__________"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     LINEATION,
     0,
     NOACTION},
    {{"DO NOT UNLOCK THE BOOTLOADER"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     OPTION_ITEM,
     0,
     RESTART},
    {{"__________"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     LINEATION,
     0,
     NOACTION},
    {{"UNLOCK THE BOOTLOADER"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     OPTION_ITEM,
     0,
     RECOVER},
    {{"__________"},
     COMMON_FACTOR,
     BGR_WHITE,
     BGR_BLACK,
     LINEATION,
     0,
     NOACTION},
};
```

```
STATIC EFI_STATUS
UnlockMenuShowScreen (OPTION_MENU_INFO *OptionMenuInfo,
                      INTN Type,
                      BOOLEAN Value)
{
  EFI_STATUS Status = EFI_SUCCESS;
  UINT32 Location = 0;
  UINT32 Height = 0;
  UINT32 i = 0;
  UINT32 j = 0;
  UINT32 MaxLine = 0;

  ZeroMem (&OptionMenuInfo->Info, sizeof (MENU_OPTION_ITEM_INFO));

  if (Value) {
    OptionMenuInfo->Info.MsgInfo = mUnlockMenuMsgInfo;
    MaxLine = ARRAY_SIZE (mUnlockMenuMsgInfo);
  } else {
    OptionMenuInfo->Info.MsgInfo = mLockMenuMsgInfo;
    MaxLine = ARRAY_SIZE (mLockMenuMsgInfo);
  }

  for (i = 0; i < MaxLine; i++) {
    if (OptionMenuInfo->Info.MsgInfo[i].Attribute == OPTION_ITEM) {
      if (j < UNLOCK_OPTION_NUM) {
        OptionMenuInfo->Info.OptionItems[j] = i;
        j++;
      }
    }
    OptionMenuInfo->Info.MsgInfo[i].Location = Location;
    Status = DrawMenu (&OptionMenuInfo->Info.MsgInfo[i], &Height);
    if (Status != EFI_SUCCESS)
      return Status;
    Location += Height;
  }

  if (Type == UNLOCK) {
    OptionMenuInfo->Info.MenuType = DISPLAY_MENU_UNLOCK;
    if (!Value)
      OptionMenuInfo->Info.MenuType = DISPLAY_MENU_LOCK;
  } else if (Type == UNLOCK_CRITICAL) {
    OptionMenuInfo->Info.MenuType = DISPLAY_MENU_UNLOCK_CRITICAL;
    if (!Value)
      OptionMenuInfo->Info.MenuType = DISPLAY_MENU_LOCK_CRITICAL;
  }

  OptionMenuInfo->Info.OptionNum = UNLOCK_OPTION_NUM;

  /* Initialize the option index */
  OptionMenuInfo->Info.OptionIndex = UNLOCK_OPTION_NUM;

  return Status;
}
```

```
EFI_STATUS
DisplayUnlockMenu (INTN Type, BOOLEAN Value)
{
  EFI_STATUS Status = EFI_SUCCESS;
  OPTION_MENU_INFO *OptionMenuInfo;

  if (IsEnableDisplayMenuFlagSupported ()) {
    OptionMenuInfo = &gMenuInfo;
    DrawMenuInit ();

    /* Initialize the last menu type */
    OptionMenuInfo->LastMenuType = OptionMenuInfo->Info.MenuType;

    Status = UnlockMenuShowScreen (OptionMenuInfo, Type, Value);
    if (Status != EFI_SUCCESS) {
      DEBUG ((EFI_D_ERROR, "Unable to show %a menu on screen: %r\n",
              Value ? "Unlock" : "Lock", Status));
      return Status;
    }

    MenuKeysDetectionInit (OptionMenuInfo);
    DEBUG ((EFI_D_VERBOSE, "Creating unlock keys detect event\n"));
  } else {
    DEBUG ((EFI_D_INFO, "Display menu is not enabled!\n"));
    Status = EFI_NOT_STARTED;
  }

  return Status;
}
```

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/BootLib/MenuKeysDetection.c

    * 通过MenuKeysHandler 回调按键调用

    * SCAN_SUSPEND 就是power键按下后,回调``MenuPagesAction[MenuInfo->Info.MenuType].Enter_Action_Func (MenuInfo);``

        从 PAGES_ACTION 的定义 Enter_Action_Func 可以看到,最终调用 PowerKeyFunc

    * PowerKeyFunc 的作用, 记录了      Reason = MenuInfo->Info.MsgInfo[OptionItem].Action;就是对应菜单的 RECOVER

        然后调用 UpdateDeviceStatus (MenuInfo, Reason);

    * UpdateDeviceStatus 执行了两个函数 

        * ResetDeviceUnlockStatus (MsgInfo->Info.MenuType);

        * RebootDevice (RECOVERY_MODE);

```
/**
  Create a event and timer to detect key's status
  @param[in] mMenuInfo    The option menu info.
  @retval EFI_SUCCESS     The entry point is executed successfully.
  @retval other           Some error occurs when executing this entry point.
 **/
EFI_STATUS EFIAPI
MenuKeysDetectionInit (IN VOID *mMenuInfo)
{
  EFI_STATUS Status = EFI_SUCCESS;
  OPTION_MENU_INFO *MenuInfo = mMenuInfo;

  if (IsEnableDisplayMenuFlagSupported ()) {
    StartTimer = GetTimerCountms ();

    /* Close the timer and event firstly */
    if (CallbackKeyDetection) {
      gBS->SetTimer (CallbackKeyDetection, TimerCancel, 0);
      gBS->CloseEvent (CallbackKeyDetection);
    }

    /* Create event for handle key status */
    Status =
        gBS->CreateEvent (EVT_TIMER | EVT_NOTIFY_SIGNAL, TPL_CALLBACK,
                          MenuKeysHandler, MenuInfo, &CallbackKeyDetection);
    DEBUG ((EFI_D_VERBOSE, "Create keys detection event: %r\n", Status));

    if (!EFI_ERROR (Status) && CallbackKeyDetection)
      StartKeyDetectTimer ();
  }
  return Status;
}
```

```
/**
  Handle key detection's status
  @param[in] Event      The event of key's detection.
  @param[in] Context    The parameter of key's detection.
  @retval EFI_SUCCESS   The entry point is executed successfully.
  @retval other         Some error occurs when executing this entry point.
 **/
STATIC VOID EFIAPI
MenuKeysHandler (IN EFI_EVENT Event, IN VOID *Context)
{
  UINT64 TimerDiff;
  EFI_STATUS Status = EFI_SUCCESS;
  OPTION_MENU_INFO *MenuInfo = Context;
  UINT32 CurrentKey = SCAN_NULL;
  STATIC UINT32 LastKey = SCAN_NULL;
  STATIC UINT64 KeyPressStartTime;

  if (MenuInfo->Info.TimeoutTime > 0) {
    TimerDiff = GetTimerCountms () - StartTimer;
    if (TimerDiff > (MenuInfo->Info.TimeoutTime) * 1000) {
      ExitMenuKeysDetection ();
      if ((MenuInfo->Info.MenuType == DISPLAY_MENU_EIO) ||
          ((MenuInfo->Info.MsgInfo->Action == POWEROFF) &&
           ((MenuInfo->Info.MenuType == DISPLAY_MENU_YELLOW) ||
            (MenuInfo->Info.MenuType == DISPLAY_MENU_ORANGE))))
        ShutdownDevice ();
      return;
    }
  }

  Status = GetKeyPress (&CurrentKey);
  if (Status != EFI_SUCCESS && Status != EFI_NOT_READY) {
    DEBUG ((EFI_D_ERROR, "Error reading key status: %r\n", Status));
    goto Exit;
  }

  /* Initialize the key press start time when the key is pressed or released */
  if (LastKey != CurrentKey)
    KeyPressStartTime = GetTimerCountms ();

  /* Check whether there is user key action that needed to do.
   * There is key pressed currently. SCAN_NULL means there is no keystroke
   * data available. Treat SCAN_NULL as a special key.
   * If there is any key pressed above KEY_HOLD_TIME_MS time. Do action
   * If the current key is SCAN_NULL, it means the key is released. if the last
   * key is not NULL then do action or do nothing.
   */
  TimerDiff = GetTimerCountms () - KeyPressStartTime;
  if (TimerDiff > KEY_HOLD_TIME_MS || CurrentKey == SCAN_NULL) {
    switch (LastKey) {
    case SCAN_UP:
      if (MenuPagesAction[MenuInfo->Info.MenuType].Up_Action_Func != NULL)
        MenuPagesAction[MenuInfo->Info.MenuType].Up_Action_Func (MenuInfo);
      break;
    case SCAN_DOWN:
      if (MenuPagesAction[MenuInfo->Info.MenuType].Down_Action_Func != NULL)
        MenuPagesAction[MenuInfo->Info.MenuType].Down_Action_Func (MenuInfo);
      break;
    case SCAN_SUSPEND:
      if (MenuPagesAction[MenuInfo->Info.MenuType].Enter_Action_Func != NULL)
        MenuPagesAction[MenuInfo->Info.MenuType].Enter_Action_Func (MenuInfo);
      break;
    default:
      break;
    }
    KeyPressStartTime = GetTimerCountms ();
  }

  LastKey = CurrentKey;
  StartKeyDetectTimer ();
  return;

Exit:
  ExitMenuKeysDetection ();
  return;
}
```

```
/* Device's action when the volume or power key is pressed
 * Up_Action_Func:   The device's action when the volume up key is pressed
 * Down_Action_Func: The device's action when the volume down key is pressed
 * Enter_Action_Func: The device's action when the power up key is pressed
 */
typedef struct {
  Keys_Action_Func Up_Action_Func;
  Keys_Action_Func Down_Action_Func;
  Keys_Action_Func Enter_Action_Func;
} PAGES_ACTION;
```

```
STATIC PAGES_ACTION MenuPagesAction[] = {
        [DISPLAY_MENU_UNLOCK] =
            {
                MenuVolumeUpFunc, MenuVolumeDownFunc, PowerKeyFunc,
            },
        [DISPLAY_MENU_UNLOCK_CRITICAL] =
            {
                MenuVolumeUpFunc, MenuVolumeDownFunc, PowerKeyFunc,
            },
        [DISPLAY_MENU_LOCK] =
            {
                MenuVolumeUpFunc, MenuVolumeDownFunc, PowerKeyFunc,
            },
        [DISPLAY_MENU_LOCK_CRITICAL] =
            {
                MenuVolumeUpFunc, MenuVolumeDownFunc, PowerKeyFunc,
            },
        [DISPLAY_MENU_YELLOW] =
            {
                NULL, NULL, PowerKeyFunc,
            },
        [DISPLAY_MENU_ORANGE] =
            {
                NULL, NULL, PowerKeyFunc,
            },
        [DISPLAY_MENU_EIO] =
            {
                NULL, NULL, PowerKeyFunc,
            },
        [DISPLAY_MENU_MORE_OPTION] =
            {
                MenuVolumeUpFunc, MenuVolumeDownFunc, PowerKeyFunc,
            },
        [DISPLAY_MENU_FASTBOOT] =
            {
                MenuVolumeUpFunc, MenuVolumeDownFunc, PowerKeyFunc,
            },
};
```

```
/* Update device's status via select option */
STATIC VOID
PowerKeyFunc (OPTION_MENU_INFO *MenuInfo)
{
  int Reason = -1;
  UINT32 OptionIndex = MenuInfo->Info.OptionIndex;
  UINT32 OptionItem = 0;
  STATIC BOOLEAN IsRefresh;

  switch (MenuInfo->Info.MenuType) {
  case DISPLAY_MENU_YELLOW:
  case DISPLAY_MENU_ORANGE:
    if (!IsRefresh) {
      /* If the power key is pressed for the first time:
       * Update the warning message and recalculate the timeout
       */
      StartTimer = GetTimerCountms ();
      VerifiedBootMenuUpdateShowScreen (MenuInfo);
      IsRefresh = TRUE;
    } else {
      Reason = CONTINUE;
    }
    break;
  case DISPLAY_MENU_EIO:
    Reason = CONTINUE;
    break;
  case DISPLAY_MENU_MORE_OPTION:
  case DISPLAY_MENU_UNLOCK:
  case DISPLAY_MENU_UNLOCK_CRITICAL:
  case DISPLAY_MENU_LOCK:
  case DISPLAY_MENU_LOCK_CRITICAL:
  case DISPLAY_MENU_FASTBOOT:
    if (OptionIndex < MenuInfo->Info.OptionNum) {
      OptionItem = MenuInfo->Info.OptionItems[OptionIndex];
      Reason = MenuInfo->Info.MsgInfo[OptionItem].Action;
    }
    break;
  default:
    DEBUG ((EFI_D_ERROR, "Unsupported menu type\n"));
    break;
  }

  if (Reason != -1) {
    UpdateDeviceStatus (MenuInfo, Reason);
  }
}
```

```
STATIC VOID
UpdateDeviceStatus (OPTION_MENU_INFO *MsgInfo, INTN Reason)
{
  CHAR8 FfbmPageBuffer[FFBM_MODE_BUF_SIZE] = "";
  EFI_STATUS Status = EFI_SUCCESS;
  EFI_GUID Ptype = gEfiMiscPartitionGuid;
  MemCardType CardType = UNKNOWN;

  /* Clear the screen */
  gST->ConOut->ClearScreen (gST->ConOut);

  CardType = CheckRootDeviceType ();

  switch (Reason) {
  case RECOVER:
    if (MsgInfo->Info.MenuType == DISPLAY_MENU_UNLOCK ||
        MsgInfo->Info.MenuType == DISPLAY_MENU_LOCK ||
        MsgInfo->Info.MenuType == DISPLAY_MENU_LOCK_CRITICAL ||
        MsgInfo->Info.MenuType == DISPLAY_MENU_UNLOCK_CRITICAL)
      ResetDeviceUnlockStatus (MsgInfo->Info.MenuType);

    RebootDevice (RECOVERY_MODE);
    break;
  case RESTART:
    RebootDevice (NORMAL_MODE);
    break;
  case POWEROFF:
    ShutdownDevice ();
    break;
  case FASTBOOT:
    RebootDevice (FASTBOOT_MODE);
    break;
  case CONTINUE:
    /* Continue boot, no need to detect the keys'status */
    ExitMenuKeysDetection ();
    break;
  case BACK:
    VerifiedBootMenuShowScreen (MsgInfo, MsgInfo->LastMenuType);
    StartTimer = GetTimerCountms ();
    break;
  case FFBM:
    AsciiSPrint (FfbmPageBuffer, sizeof (FfbmPageBuffer), "ffbm-00");
    if (CardType == NAND) {
      Status = GetNandMiscPartiGuid (&Ptype);
    }
    if (Status == EFI_SUCCESS) {
      WriteToPartition (&Ptype, FfbmPageBuffer, sizeof (FfbmPageBuffer));
    }
    RebootDevice (NORMAL_MODE);
    break;
  case QMMI:
    AsciiSPrint (FfbmPageBuffer, sizeof (FfbmPageBuffer), "qmmi");
    if (CardType == NAND) {
      Status = GetNandMiscPartiGuid (&Ptype);
    }
    if (Status == EFI_SUCCESS) {
      WriteToPartition (&Ptype, FfbmPageBuffer, sizeof (FfbmPageBuffer));
    }
    RebootDevice (NORMAL_MODE);
    break;
  }
}
```

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/BootLib/UnlockMenu.c

    * 先看READ_CONFIG 读取配置

```
/**
  Reset device unlock status
  @param[in] Type    The type of the unlock.
                     [DISPLAY_MENU_UNLOCK]: unlock the device
                     [DISPLAY_MENU_UNLOCK_CRITICAL]: critical unlock the device
                     [DISPLAY_MENU_LOCK]: lock the device
                     [DISPLAY_MENU_LOCK_CRITICAL]: critical lock the device
 **/
VOID
ResetDeviceUnlockStatus (INTN Type)
{
  EFI_STATUS Result;
  DeviceInfo *DevInfo = NULL;

  /* Read Device Info */
  DevInfo = AllocateZeroPool (sizeof (DeviceInfo));
  if (DevInfo == NULL) {
    DEBUG ((EFI_D_ERROR, "Failed to allocate zero pool for device info.\n"));
    goto Exit;
  }

  Result = ReadWriteDeviceInfo (READ_CONFIG, DevInfo, sizeof (DeviceInfo));
  if (Result != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "Unable to Read Device Info: %r\n", Result));
    goto Exit;
  }

  Result = SetDeviceUnlockValue (mUnlockInfo[Type].UnlockType,
                                 mUnlockInfo[Type].UnlockValue);
  if (Result != EFI_SUCCESS)
    DEBUG ((EFI_D_ERROR, "Failed to update the unlock status: %r\n", Result));

Exit:
  if (DevInfo) {
    FreePool (DevInfo);
    DevInfo = NULL;
  }
}
```

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/BootLib/LinuxLoaderLib.c

    * 可以看到,定位xbl的服务,gEfiQcomVerifiedBootProtocolGuid,调用 VBRwDeviceState

```
EFI_STATUS
ReadWriteDeviceInfo (vb_device_state_op_t Mode, void *DevInfo, UINT32 Sz)
{
  EFI_STATUS Status = EFI_INVALID_PARAMETER;
  QCOM_VERIFIEDBOOT_PROTOCOL *VbIntf;

  Status = gBS->LocateProtocol (&gEfiQcomVerifiedBootProtocolGuid, NULL,
                                (VOID **)&VbIntf);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "Unable to locate VB protocol: %r\n", Status));
    return Status;
  }

  Status = VbIntf->VBRwDeviceState (VbIntf, Mode, DevInfo, Sz);
  if (Status != EFI_SUCCESS) {
    DEBUG ((EFI_D_ERROR, "VBRwDevice failed with: %r\n", Status));
    return Status;
  }

  return Status;
}
```

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/QcomModulePkg.dec

这里gEfiQcomVerifiedBootProtocolGuid 跟 xbl的 QcomPkg.dec 对应起来了

```
# VerifiedBoot Protocol
  gEfiQcomVerifiedBootProtocolGuid =    { 0x8e5eff91, 0x21b6, 0x47d3, { 0xaf, 0x2b, 0xc1, 0x5a, 0x1, 0xe0, 0x20, 0xec } } 
```

* A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.inf

```
[Protocols]
   gEfiHash2ProtocolGuid
   gEfiQcomVerifiedBootProtocolGuid         ## Produces 
   gEfiQcomASN1X509ProtocolGuid
   gEfiQcomSecRSAProtocolGuid
#   gQcomRngProtocolGuid                    ##Consumes
   gEfiTzeLoaderProtocolGuid
   gQcomScmProtocolGuid
   gQcomQseecomProtocolGuid
```

* A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/QcomPkg.dec

```
# VerifiedBoot 
  gEfiQcomVerifiedBootProtocolGuid =       { 0x8e5eff91, 0x21b6, 0x47d3, { 0xaf, 0x2b, 0xc1, 0x5a, 0x1, 0xe0, 0x20, 0xec } } 
```

* A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.c

所以abl的VBRwDeviceState 最用调用到 xbl 的QCOM_VB_RWDeviceState

```
// VerifiedBoot Protocol

STATIC QCOM_VERIFIEDBOOT_PROTOCOL QCOMVerifiedBootProtocol = {
    QCOM_VERIFIEDBOOT_PROTOCOL_REVISION, QCOM_VB_RWDeviceState,
    QCOM_VB_DeviceInit, QCOM_VB_SendROT, QCOM_VB_Send_Milestone,
    QCOM_VB_VerifyImage, QCOM_VB_Reset_State, QCOM_VB_Is_Device_Secure,
    QCOM_VB_Get_Boot_State, QCOM_VB_Get_Cert_FingerPrint};

EFI_STATUS
EFIAPI
VerifiedBootDxeEntryPoint(IN EFI_HANDLE ImageHandle,
                          IN EFI_SYSTEM_TABLE *SystemTable)
{
  EFI_STATUS Status;
  EFI_HANDLE Handle = NULL;

  Status = gBS->InstallMultipleProtocolInterfaces(
      &Handle, &gEfiQcomVerifiedBootProtocolGuid,
      (VOID **)&QCOMVerifiedBootProtocol, NULL);

  return Status;
}
```

* A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/QcomModulePkg/Include/Protocol/EFIVerifiedBoot.h

VBRwDeviceState 这个对应abl的Status = VbIntf->VBRwDeviceState (VbIntf, Mode, DevInfo, Sz);

```
/** @cond */
/* Protocol declaration.  */
typedef struct _QCOM_VERIFIEDBOOT_PROTOCOL QCOM_VERIFIEDBOOT_PROTOCOL;
/** @endcond */

===========================================================================*/
/** @ingroup
  @par Summary
    Android VERIFIEDBOOT Protocol interface.

  @par Parameters
  @inputprotoparams
*/
struct _QCOM_VERIFIEDBOOT_PROTOCOL {
  UINT64                            Revision;
  QCOM_VB_RW_DEVICE_STATE           VBRwDeviceState;
  QCOM_VB_DEVICE_INIT               VBDeviceInit;
  QCOM_VB_SEND_ROT                  VBSendRot;
  QCOM_VB_SEND_MILESTONE            VBSendMilestone;
  QCOM_VB_VERIFY_IMAGE              VBVerifyImage;
  QCOM_VB_RESET_STATE               VBDeviceResetState;
  QCOM_VB_IS_DEVICE_SECURE          VBIsDeviceSecure;
  QCOM_VB_GET_BOOT_STATE            VBGetBootState;
  QCOM_VB_GET_CERT_FINGERPRINT      VBGetCertFingerPrint;
};

typedef
EFI_STATUS
(EFIAPI *QCOM_VB_RW_DEVICE_STATE )
(
  IN     QCOM_VERIFIEDBOOT_PROTOCOL *This,
  IN     vb_device_state_op_t       op, 
  IN OUT UINT8                      *buf,
  IN     UINT32                     buf_len
);

```

# 流程

上面一步,基本上流程都全通了.重点分析一下 QCOM_VB_RWDeviceState

从abl 调用到xbl 的 QCOM_VB_RWDeviceState

* A6650_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/Drivers/VerifiedBootDxe/VerifiedBootDxe.c

可以看到 ,烧录了efuse的机器,都是从qsee (tee)里面对 keymaster的LK_DEVICE_STATE 操作

如果没有烧录efuse的机器,就是操作devinfo分区

```
EFI_STATUS
QCOM_VB_RWDeviceState(IN QCOM_VERIFIEDBOOT_PROTOCOL *This,
                      IN vb_device_state_op_t op, IN OUT UINT8 *buf,
                      IN UINT32 buf_len)
{

  EFI_STATUS status = EFI_FAILURE;
  UINT8 img_name[MAX_PNAME_LENGTH];
  UINT16 img_label[MAX_LABEL_SIZE];
  BOOLEAN secure_device = FALSE;
  BOOLEAN secure_device_nocheck_rpmb = FALSE;
  BOOLEAN used_devinfo = FALSE;
  UINT32 AppId = 0;
  UINTN VarSize = sizeof(AppId);
  STATIC QCOM_QSEECOM_PROTOCOL *QseeComProtocol;
  VOID *info = NULL;

  if (buf == NULL || buf_len == 0) {
    DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Invalid parameters!\n"));
    status = EFI_INVALID_PARAMETER;
    goto exit;
  }
  if (( status = is_secure_device_nocheck_rpmb (&secure_device_nocheck_rpmb)) != EFI_SUCCESS) {
    DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Cannot read security state with no rpmb check!\n"));
    goto exit;
  }
  /* We use devinfo partition when the device is not secure */
  AsciiStrnCpy((CHAR8 *)img_name, "devinfo", AsciiStrLen("devinfo"));
  if (convert_char8_to_char16(img_name, img_label, AsciiStrLen("devinfo")) != EFI_SUCCESS) {
    status = RETURN_INVALID_PARAMETER;
    goto exit;
  }
  /* A secure device may boot up without enabled rpmb fuse but after calling to keymaster 
     the fuse will be blown and we can perform the actual check for secure device.
  */
  if (secure_device_nocheck_rpmb) {
    status = gBS->LocateProtocol(&gQcomQseecomProtocolGuid, NULL,
                                   (VOID **)&QseeComProtocol);
    if (status != EFI_SUCCESS) {
      DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Cannot locate gQcomQseecomProtocolGuid!\n"));
      goto exit;
    }
    if (keymasterAppId == 0) {
      status = gRT->GetVariable(L"keymaster", &gQcomTokenSpaceGuid, NULL,
                                &VarSize, &AppId);
      if (status != EFI_SUCCESS) {
        status = QseeComProtocol->QseecomStartApp(QseeComProtocol, "keymaster",
                                                  &AppId);
        if (status != EFI_SUCCESS) {
          DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Failed in QseecomStartApp status = %d\n", status));
          goto exit;
        }
      }
      keymasterAppId = AppId;
    }
  }
  switch (op) {
  case WRITE_CONFIG:
    if (secure_device_nocheck_rpmb) {

      km_send_devrw_req wread_req = {0};
      km_send_devrw_rsp wread_rsp = {-1};
      km_send_devrw_req write_req = {0};
      km_send_devrw_rsp write_rsp = {-1};
      info = UncachedAllocatePages(1);
      if (info == NULL) {

        DEBUG((EFI_D_ERROR, "VB: RWDeviceState: mem allocation for write failed!\n"));
        goto exit;
      }
      wread_req.cmd_id = KEYMASTER_READ_LK_DEVICE_STATE;
      wread_req.data = (UINT32)info;
      wread_req.len = PAGE_SIZE;
      status = QseeComProtocol->QseecomSendCmd(
          QseeComProtocol, keymasterAppId, (UINT8 *)&wread_req,
          sizeof(wread_req), (VOID *)&wread_rsp,
          sizeof(wread_rsp));
      if (status != EFI_SUCCESS || wread_rsp.status != 0) {

        /* Check whether the error is caused by using a non-secure device or not.
           For secure device, the RPMB fuse should be blown after 
           invoking KEYMASTER_READ_LK_DEVICE_STATE. Thus, we use actual check for 
           identifying the secure device.
        */
        if ((status = is_secure_device(&secure_device)) != EFI_SUCCESS) {
          DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Cannot read security state!\n"));
          goto exit;
        }
        if (!secure_device) {
		  if ((status = write_partition(img_label, buf, buf_len)) != EFI_SUCCESS) {
		    DEBUG((EFI_D_ERROR, " VB: RWDeviceState: write_partition err! status: %d\n", status));
			status = EFI_FAILURE;
			goto exit;
		  } 
		  used_devinfo = TRUE;
		} else {
            DEBUG((EFI_D_ERROR, "VB: RWDeviceState: wread_req err ! status: %d read status: %d \n", status, wread_rsp.status));
            status = EFI_FAILURE;
            goto exit;
		}
      }
	  else {
        CopyMemS(info, PAGE_SIZE, buf, buf_len);
        write_req.cmd_id = KEYMASTER_WRITE_LK_DEVICE_STATE;
        write_req.data = (UINT32)info;
        write_req.len = PAGE_SIZE;
        status = QseeComProtocol->QseecomSendCmd(
        QseeComProtocol, keymasterAppId, (UINT8 *)&write_req,
        sizeof(write_req), (VOID *)&write_rsp,
        sizeof(write_rsp));
        if (status != EFI_SUCCESS || write_rsp.status != 0) {
         
		  DEBUG((EFI_D_ERROR, "VB: RWDeviceState: write_req err! staus %d write status %d\n", status, write_rsp.status));
          status = EFI_FAILURE;
		  goto exit;
	    }
       
      }
    }  else {
        if ((status = write_partition(img_label, buf, buf_len)) !=
          EFI_SUCCESS) {
          DEBUG((EFI_D_ERROR, " VB: RWDeviceState: write_partition err! status: %d\n", status));
		  goto exit;
        }
	    used_devinfo = TRUE;
    }
    break;
  case READ_CONFIG:
    if (secure_device_nocheck_rpmb) {
      km_send_devrw_req read_req = {0};
      km_send_devrw_rsp read_rsp = {-1};
      info = UncachedAllocatePages(1);
      if (info == NULL) {

        DEBUG((EFI_D_ERROR, "VB: RWDeviceState: mem allocation for read failed!\n"));
        goto exit;
      }
      read_req.cmd_id = KEYMASTER_READ_LK_DEVICE_STATE;
      read_req.data = (UINT32)info;
      read_req.len = PAGE_SIZE;

      status = QseeComProtocol->QseecomSendCmd(
          QseeComProtocol, keymasterAppId, (UINT8 *)&read_req,
          sizeof(read_req), (VOID *)&read_rsp,
          sizeof(read_rsp));

      if (status != EFI_SUCCESS || read_rsp.status != 0) {
	    /* Check whether the error is caused by using a non-secure device or not.
         For secure device, the RPMB fuse should be blown after 
         invoking KEYMASTER_READ_LK_DEVICE_STATE. Thus, we use actual check for 
         identifying the secure device.
        */
        if ((status = is_secure_device(&secure_device)) != EFI_SUCCESS) {
          DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Cannot read security state!\n"));
          goto exit;
        }
        if (!secure_device) {
		  if ((status = read_partition(img_label, buf, buf_len)) != EFI_SUCCESS) {
		    DEBUG((EFI_D_ERROR, " VB: RWDeviceState: read_partition err! status: %d\n", status));
			status = EFI_FAILURE;
			goto exit;
		  } 
		  used_devinfo = TRUE; 		   
		} else {
            DEBUG((EFI_D_ERROR, "VB: RWDeviceState: read_req err ! status: %d read status: %d \n", status, read_rsp.status));
            status = EFI_FAILURE;
            goto exit;
		}
      } else {
        CopyMemS(buf, buf_len, info, PAGE_SIZE);
      }

    } else {
        if ((status = read_partition(img_label, buf, buf_len)) !=
          EFI_SUCCESS) {
          DEBUG((EFI_D_ERROR, " VB: RWDeviceState: read_partition err! status = %x\n", status));
          goto exit;
      }
	   used_devinfo = TRUE;
    }
    break;
  default:
    DEBUG((EFI_D_ERROR, "VB: RWDeviceState: invalid operation op = %x \n", op));
    status = EFI_INVALID_PARAMETER;
    goto exit;
  }
  status = EFI_SUCCESS;
exit:
  if (info) {

    UncachedFreePages(info, 1);
  }
  if (status == EFI_SUCCESS) {
    if (used_devinfo) {
	  DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Succeed using devinfo!\n"));
	} else {
	    DEBUG((EFI_D_ERROR, "VB: RWDeviceState: Succeed using rpmb!\n"));
	}
  }
  return status;
}
```

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/BootLib/DeviceInfo.c

在回归fastboot flashing unlock,实际是调用

    * SetUnlockValue

    * WriteToPartition,这个是写入misc分区 RECOVERY_WIPE_DATA 擦除data

    * 最后通过 WRITE_CONFIG 标志,把unlock 通过xbl 的 qsee 写入keymaster的 KEYMASTER_READ_LK_DEVICE_STATE 标志

```
EFI_STATUS
SetDeviceUnlockValue (UINT32 Type, BOOLEAN State)
{
  EFI_STATUS Status = EFI_SUCCESS;
  struct RecoveryMessage Msg;
  EFI_GUID Ptype = gEfiMiscPartitionGuid;
  MemCardType CardType = UNKNOWN;

  switch (Type) {
  case UNLOCK:
    Status = SetUnlockValue (State);
    break;
  case UNLOCK_CRITICAL:
    Status = SetUnlockCriticalValue (State);
    break;
  default:
    Status = EFI_UNSUPPORTED;
    break;
  }
  if (Status != EFI_SUCCESS)
    return Status;

  Status = ResetDeviceState ();
  if (Status != EFI_SUCCESS) {
    if (Type == UNLOCK)
      SetUnlockValue (!State);
    else if (Type == UNLOCK_CRITICAL)
      SetUnlockCriticalValue (!State);

    DEBUG ((EFI_D_ERROR, "Unable to set the Value: %r", Status));
    return Status;
  }

  gBS->SetMem ((VOID *)&Msg, sizeof (Msg), 0);
  Status = AsciiStrnCpyS (Msg.recovery, sizeof (Msg.recovery),
                          RECOVERY_WIPE_DATA, AsciiStrLen (RECOVERY_WIPE_DATA));
  if (Status == EFI_SUCCESS) {
    CardType = CheckRootDeviceType ();
    if (CardType == NAND) {
      Status = GetNandMiscPartiGuid (&Ptype);
      if (Status != EFI_SUCCESS) {
        return Status;
      }
    }

    Status = WriteToPartition (&Ptype, &Msg, sizeof (Msg));
  }

  return Status;
}
```

```
STATIC EFI_STATUS
SetUnlockValue (BOOLEAN State)
{
  EFI_STATUS Status = EFI_SUCCESS;

  if (IsUnlocked () != State) {
    DevInfo.is_unlocked = State;
    Status = ReadWriteDeviceInfo (WRITE_CONFIG, &DevInfo, sizeof (DevInfo));
    if (Status != EFI_SUCCESS) {
      DEBUG ((EFI_D_ERROR, "Unable set the unlock value: %r\n", Status));
      return Status;
    }
  }

  return Status;
}
```