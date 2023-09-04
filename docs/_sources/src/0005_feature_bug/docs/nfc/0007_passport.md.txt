# 概要

同事反馈,nfc读取护照要10几秒,其他正常项目4到5s,2G+16G

对比同平台,另外一个机器,5-6s,4+64G

# 复测

安装同事发的apk,IDReader_V1.03.00_20230706_debug.apk,

```
07-04 12:54:33.209  6412  6412 D dockit:RfOcrActivity.doStartNFC(Line:252): NFC start........
07-04 12:54:45.784  6412  6412 D dockit:RfOcrActivity$MyHandler.handleMessage(Line:433): NFC end........
```

# 卡片类型

从log的 NxpNci: Mode = B Passive Poll,看到是B卡

```
07-04 12:54:33.181   876  5689 D NxpHal  : NxpNci: RF Interface = ISO-DEP
07-04 12:54:33.181   876  5689 D NxpHal  : NxpNci: Protocol = ISO-DEP
07-04 12:54:33.181   876  5689 D NxpHal  : NxpNci: Mode = B Passive Poll
```

# 分析

对比6s的机器,发现log里面只有两行

```
	行 55650: 07-15 11:27:12.158  5659  5659 D dockit:RfOcrActivity.doStartNFC(Line:252): NFC start........
	行 58551: 07-15 11:27:18.325  5659  5659 D dockit:RfOcrActivity$MyHandler.handleMessage(Line:433): NFC end........
```

当时12s的机器,log里面,有很多debug版本,才会打印的log

```
	行 23466: 07-14 22:54:52.819  5709  5709 D dockit:RfOcrActivity.doStartNFC(Line:252): NFC start........
	行 23634: 07-14 22:54:52.993  3343  5594 E libnfc_nci: [ERROR:nfc_ncif.cc(440)] victor NFC,nfc_debug_enabled = 1,
	行 23635: 07-14 22:54:52.993  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(441)] victor,NFC received rsp gid:1
	行 23647: 07-14 22:54:53.004  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(482)] victor,NFC received ntf gid:1
	行 23696: 07-14 22:54:53.149  3343  5594 E libnfc_nci: [ERROR:nfc_ncif.cc(440)] victor NFC,nfc_debug_enabled = 1,
	行 23697: 07-14 22:54:53.149  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(441)] victor,NFC received rsp gid:1
	行 23708: 07-14 22:54:53.157  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(482)] victor,NFC received ntf gid:1
	行 23749: 07-14 22:54:53.301  3343  5594 E libnfc_nci: [ERROR:nfc_ncif.cc(440)] victor NFC,nfc_debug_enabled = 1,
	行 23750: 07-14 22:54:53.301  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(441)] victor,NFC received rsp gid:1
	行 23756: 07-14 22:54:53.309  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(482)] victor,NFC received ntf gid:1
	行 23797: 07-14 22:54:53.358  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(482)] victor,NFC received ntf gid:0
	行 30075: 07-14 22:55:04.681  3343  5594 E libnfc_nci: [ERROR:nfc_ncif.cc(440)] victor NFC,nfc_debug_enabled = 1,
	行 30076: 07-14 22:55:04.681  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(441)] victor,NFC received rsp gid:1
	行 30094: 07-14 22:55:04.695  3343  5594 I libnfc_nci: [INFO:nfc_ncif.cc(482)] victor,NFC received ntf gid:1
	行 30126: 07-14 22:55:04.752  5709  5709 D dockit:RfOcrActivity$MyHandler.handleMessage(Line:433): NFC end........
```

* QSSI.12/system/nfc/src/nfc/nfc/nfc_ncif.cc

可以看到,在源码里面,DLOG_IF(INFO, nfc_debug_enabled) 只有,nfc_debug_enabled =1 ,才会打印 victor,NFC received rsp gid 这些.

所以同事应该是一个用debug版本测试,一个用user版本测试

```
     case NCI_MT_RSP:
+      LOG(ERROR) << StringPrintf("victor NFC,nfc_debug_enabled = %d,",nfc_debug_enabled);
       DLOG_IF(INFO, nfc_debug_enabled)
-          << StringPrintf("NFC received rsp gid:%d", gid);
+          << StringPrintf("victor,NFC received rsp gid:%d", gid);
       oid = ((*p) & NCI_OID_MASK);
       p_old = nfc_cb.last_hdr;
       NCI_MSG_PRS_HDR0(p_old, old_mt, pbf, old_gid);
@@ -479,7 +480,7 @@ bool nfc_ncif_process_event(NFC_HDR* p_msg) {
 
     case NCI_MT_NTF:
       DLOG_IF(INFO, nfc_debug_enabled)
-          << StringPrintf("NFC received ntf gid:%d", gid);
+          << StringPrintf("victor,NFC received ntf gid:%d", gid);
       switch (gid) {
         case NCI_GID_CORE: /* 0000b NCI Core group */
           nci_proc_core_ntf(p_msg);
```

# 验证

不同机型的两台机器,两台都刷debug版本,两台都刷user版本

发现,两台机器的debug版本都是12s左右

两台机器的user版本都是6s左右

所以推论正确