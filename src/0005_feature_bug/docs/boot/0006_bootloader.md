# README

测试提出,Firmare Download Mode字体显示不全,太靠下

# 解决方法

* FastbootMenu.c,mFastbootOptionTitle[] 显示的字符串
```
{{"Firmware Download Mode"},
     COMMON_FACTOR,
     BGR_YELLOW,
     BGR_BLACK,
     ALIGN_MIDDLE,
     0,
     RESTART},
```

* UpdateFastbootOptionItem,draw 字符串
```
//[FEATURE]-Add-BEGIN by xielianxiong@paxsz.com, 2022/05/18, for fastboot display
  Height = ( GetResolutionHeight () - EFI_GLYPH_HEIGHT*2 )/3*2;
  SetMenuMsgInfo (FastbootLineInfo, "", COMMON_FACTOR,
                  mFastbootOptionTitle[OptionItem].FgColor,
                  mFastbootOptionTitle[OptionItem].BgColor, COMMON, Location,
                  NOACTION);
  //SetMenuMsgInfo (FastbootLineInfo, "__________", COMMON_FACTOR,
                  //mFastbootOptionTitle[OptionItem].FgColor,
                  //mFastbootOptionTitle[OptionItem].BgColor, LINEATION, Location,
                  //NOACTION);
//[FEATURE]-Add-end by xielianxiong@paxsz.com, 2022/05/18, for fastboot display
  Status = DrawMenu (FastbootLineInfo, &Height);
```