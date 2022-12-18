# 高通xbl兼容屏

公司方案,使用了新的id屏定义,旧的id没有做兼容,导致旧屏不亮

导致调试不方便,现在需要把旧屏也加进去.

# 分析

* MDPPlatformLib.c

> 高通屏id相关定义在以下路径
Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/SocPkg/AgattiPkg/Library/MDPPlatformLib/MDPPlatformLib.c

* uefiPanelList

> 定义了屏id寄存器,预期id等属性
```
typedef struct {
  uint8  uCmdType;  // data type for panel ID DSI read
  uint32 uTotalRetry; // number of retry if DSI read fails
  PlatformPanelIDCommandInfo panelIdCommands[PLATFORM_PANEL_ID_MAX_COMMANDS]; // commands for panel ID and expected readback
  uint32 uLaneRemapOrder; // Lane remap order
  int8 *psPanelCfg; // pointer to the panel configuration
  uint32 uPanelCfgSize; // size of panel configuration data
  MDPPlatformPanelType eSelectedPanel;// index of the selected panel
  uint32 uFlags;// flags to set clock config for now, can set other config in future
} PlatformDSIDetectParams;
```

```
{
    0x06, 												 // uCmdType
    0x05, 												 // total number of retry on failures
      {
        {{0xDA, 0x00},                                       // address to read ID1
          {0x2E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}     // expected readback
        },
        {{0xDB, 0x00},                                       // address to read ID2
          {0xB9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}     // expected readback
        },
        {{0xDC, 0x00},                                       // address to read ID3
          {0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}     // expected readback
        }
     },
      0,													 // Lane remap order {0, 1, 2, 3}
      NULL, 					// psPanelCfg (panel configuration)
      0,			 // uPanelCfgSize
      MDPPLATFORM_PANEL_ILI7807S_1080P_VIDEO,				  // eSelectedPanel
      0 													 // uFlags
    }
```

* MDPPlatformConfigure

    > 在该函数里面做id匹配

* DynamicDSIPanelDetection

    > 在该函数里面做具体的匹配

    * bDumpPanelId = TRUE,打开dump寄存器功能

    ```
    [2022/12/18 11:12:48] 0x00D4   0x00000000 0x00000000 0x00000000 0x00000000 
    [2022/12/18 11:12:48] 0x00D8   0x00000000 0x00000000 0x00000000 0x00000080 
    [2022/12/18 11:12:48] 0x00DC   0x00000000 0x00000000 0x00000000 0x00000000 
    ```

# 总结

以功能为目的,先把旧屏兼容上去,具体原理流程分析,后面有时间在详细分拆