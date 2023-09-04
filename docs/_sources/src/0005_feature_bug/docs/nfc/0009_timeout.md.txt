# 概要

B卡 发送命令超时

# 代码

```
public static void  NfcB_FUN1(Tag tag){
		//byte[]txbuf1 = new byte[20];
		byte[]txbuf1 = new byte[13];
		byte[]txbuf2 = new byte[5];
		byte[] recvBuf = new byte[512];
		txbuf1[0] = 0x00;
		txbuf1[1] = (byte)0xa4;
		txbuf1[2] = 0x04;
		txbuf1[3] = 0x00;
		//txbuf1[4] = 0x0e;
		txbuf1[4] = 0x07;
		String StringAPDU = "1PAY.SYS.DDF01";
		byte[] byteAPDU = DateUtils.atohex(StringAPDU);
		System.arraycopy(byteAPDU, 0, txbuf1, 5, byteAPDU.length);
		//System.arraycopy("1PAY.SYS.DDF01".getBytes(), 0, txbuf1, 5,
				//"1PAY.SYS.DDF01".getBytes().length);
		//txbuf1[19] = 0x00;
		txbuf1[12] = 0x00;

		mNfcB = NfcB.get(tag);
		if(mNfcB != null){
			Log.d(LOG_TAG,"NfcB_FUN1,mNfcB != null");
			sendmessage("ApplicationData: "+ DateUtils.ByteArrayToHexString(mNfcB.getApplicationData())+"\n");
			sendmessage(String.format("ProtocolInfo: %s\n", DateUtils.ByteArrayToHexString(mNfcB.getProtocolInfo())));
			sendmessage(String.format("MaxTransceiveLength: %d\n", mNfcB.getMaxTransceiveLength()));
			try {
				mNfcB.connect();
			} catch (IOException e) {
				e.printStackTrace();
				sendmessage(String.format("connect fail:%s\n",e.getMessage()));
			}
			//SystemClock.sleep(2000);
			if(mNfcB.isConnected()){
				//选择主文件
				try {
					recvBuf =  mNfcB.transceive(txbuf1);
					byte statusWord1[] = {recvBuf[recvBuf.length - 2], recvBuf[recvBuf.length - 1]};
					if(!Arrays.equals(SELECT_OK, statusWord1)) {
						sendmessage("read data again statusWord is not correct\n");
					}
				} catch (IOException e) {
					e.printStackTrace();
					sendmessage(String.format("transceive(select MF) fail:%s\n",e.getMessage()));
				}

```

# log

```
07-15 10:56:49.152   889  6216 D NxpHal  : write successful status = 0x0
07-15 10:56:49.152   889  6213 D NxpTml  : PN54X - I2C Read successful.....
07-15 10:56:49.152   889  6213 D NxpNciR : len =   6 > 600603010001
07-15 10:56:49.152   889  6213 D NxpTml  : PN54X - Posting read message.....
07-15 10:56:49.152   889  6216 D NxpHal  : read successful status = 0x0
07-15 10:56:49.152   889  6216 D NfccPowerTracker: NfccPowerTracker::ProcessNtf: Enter
07-15 10:56:49.153   889  6213 D NxpTml  : PN54X - Read requested.....
07-15 10:56:49.153   889  6213 D NxpTml  : PN54X - Invoking I2C Read.....
07-15 10:56:49.142     0     0 E nfc nRead: CORE_CONN_CREDITS_NTF              600603010001
07-15 10:56:49.150     0     0 I __afe_port_start: port id: 0xb030
07-15 10:56:49.150     0     0 I afe_find_cal_topo_id_by_port: port id: 0xb030, dev_acdb_id: 14
07-15 10:56:49.150     0     0 I afe_find_cal_topo_id_by_port: top_id:1000ff01 acdb_id:14 afe_port_id:0xb030
07-15 10:56:49.150     0     0 I afe_get_cal_topology_id: port_id = 0xb030 acdb_id = 14 topology_id = 0x1000ff01 cal_type_index=8 ret=0
07-15 10:56:49.152     0     0 I afe_send_port_topology_id: AFE set topology id 0x1000ff01  enable for port 0xb030 ret 0
07-15 10:56:49.152     0     0 I send_afe_cal_type: cal_index is 0
07-15 10:56:49.152     0     0 I send_afe_cal_type: dev_acdb_id[170] is 14
07-15 10:56:49.152     0     0 I afe_find_cal: cal_index 0 port_id 0xb030 port_index 170
07-15 10:56:49.152     0     0 I afe_find_cal: acdb_id 14 dev_acdb_id 14 sample_rate 48000 afe_sample_rates 48000
07-15 10:56:49.152     0     0 I afe_find_cal: cal block is a match, size is 6604
07-15 10:56:49.152     0     0 I send_afe_cal_type: Sending cal_index cal 0
07-15 10:56:49.152     0     0 I afe_send_hw_delay: port_id 0xb030 rate 48000 delay_usec 474 status 0
07-15 10:56:49.188   599  5052 E audio_hw_extn: audio_extn_perf_lock_release: Perf lock release error 
07-15 10:56:49.188   599  5052 D audio_hw_primary: start_output_stream: exit
07-15 10:56:49.314   651 12930 D vendor.qti.vibrator: Notifying on complete
07-15 10:56:49.315   651   651 D vendor.qti.vibrator: QTI Vibrator off
07-15 10:56:49.365     0     0 I PAX_BMS : CHG [online: 1, type: 4, vol: 5000000, cur: 500000, time: 16930], BAT [present: 1, status: 1, vol: 4339000, cur: 105000, resistance: 0, temp: 310, soc: 100], OTHER [skin_temp: 0, chg_vote: 0x0, notify_code: 0x0],
07-15 10:56:49.727   920  3521 E transport: tid:0xfd121cb0, trans_send(239) error:send package failed
07-15 10:56:49.728  3245  3567 W PaxSPManager/SetApTimeService: ++++++++++sp time millis = -126259199272
07-15 10:56:49.728  3245  3567 W PaxSPManager/SetApTimeService: year = 1966 month=0  day=1  hour=0  minute=0   second=0
07-15 10:56:50.060   599   599 D audio_hw_primary: out_set_parameters: enter: usecase(1: low-latency-playback) kvpairs: suspend_playback=true
07-15 10:56:50.071   599   599 D audio_hw_primary: out_set_parameters: enter: usecase(1: low-latency-playback) kvpairs: suspend_playback=false
07-15 10:56:50.075   599  2359 D audio_hw_primary: out_set_parameters: enter: usecase(1: low-latency-playback) kvpairs: suspend_playback=true
07-15 10:56:50.086   599  2359 D audio_hw_primary: out_set_parameters: enter: usecase(1: low-latency-playback) kvpairs: suspend_playback=false
07-15 10:56:50.090   599  2359 D audio_hw_primary: out_set_parameters: enter: usecase(1: low-latency-playback) kvpairs: suspend_playback=true
07-15 10:56:50.101   599  2359 D audio_hw_primary: out_set_parameters: enter: usecase(1: low-latency-playback) kvpairs: suspend_playback=false
07-15 10:56:50.140   599   599 D audio_hw_primary: out_set_parameters: enter: usecase(1: low-latency-playback) kvpairs: suspend_playback=true
07-15 10:56:50.151  3304  4059 E libnfc_nci: [ERROR:NativeNfcTag.cpp(1038)] nativeNfcTag_doTransceive: wait response timeout
07-15 10:56:50.154 12881 12881 W System.err: android.nfc.TagLostException: Tag was lost.
07-15 10:56:50.155 12881 12881 W System.err: 	at android.nfc.TransceiveResult.getResponseOrThrow(TransceiveResult.java:48)
07-15 10:56:50.155 12881 12881 W System.err: 	at android.nfc.tech.BasicTagTechnology.transceive(BasicTagTechnology.java:154)
07-15 10:56:50.156 12881 12881 W System.err: 	at android.nfc.tech.NfcB.transceive(NfcB.java:115)
07-15 10:56:50.156 12881 12881 W System.err: 	at nfc.pax.com.nfctest.Utils.Util.NfcB_FUN1(Util.java:634)
```

# 分析

看起来是 nativeNfcTag_doTransceive: wait response timeout

从log可以看到,B卡默认 timeout是1000ms,并且NfcB.java默认没有设置tiemout的接口,NfcA.java就有

```
行 51988: 07-13 19:04:02.769  3466  5799 I libnfc_nci: [INFO:NativeNfcTag.cpp(979)] nativeNfcTag_doTransceive: enter; raw=1; timeout = 1000
行 52024: 07-13 19:04:03.769  3466  5799 E libnfc_nci: [ERROR:NativeNfcTag.cpp(1038)] nativeNfcTag_doTransceive: wait response timeout
```

* QSSI.12/frameworks/base/core/java/android/nfc/tech/NfcA.java

```
* @param timeout timeout value in milliseconds
*/
public void setTimeout(int timeout) {
    try {
        int err = mTag.getTagService().setTimeout(TagTechnology.NFC_A, timeout);
        if (err != ErrorCodes.SUCCESS) {
            throw new IllegalArgumentException("The supplied timeout is not valid");
        }   
    } catch (RemoteException e) {
        Log.e(TAG, "NFC service dead", e); 
    }   
}   
```

* 尝试把延时加到到10s,还是没有作用,最后还是卡在iic读取数据

mmm packages/apps/Nfc/nci/jni/

刷入 qssi\system\lib64\libnfc_nci_jni.so

```
--- a/QSSI.12/packages/apps/Nfc/nci/jni/NfcTag.cpp
+++ b/QSSI.12/packages/apps/Nfc/nci/jni/NfcTag.cpp
@@ -1513,7 +1513,9 @@ bool NfcTag::isDynamicTagId() {
 *******************************************************************************/
 void NfcTag::resetAllTransceiveTimeouts() {
   mTechnologyTimeoutsTable[TARGET_TYPE_ISO14443_3A] = 618;   // NfcA
-  mTechnologyTimeoutsTable[TARGET_TYPE_ISO14443_3B] = 1000;  // NfcB
+//[feature]-modify-begin by xielianxiong@paxsz.com,20230719,for NfcB timeout ,default 1000
+  mTechnologyTimeoutsTable[TARGET_TYPE_ISO14443_3B] = 10000;  // NfcB
+//[feature]-modify-end by xielianxiong@paxsz.com,20230719,for NfcB timeout ,default 1000
   mTechnologyTimeoutsTable[TARGET_TYPE_ISO14443_4] = 618;    // ISO-DEP
   mTechnologyTimeoutsTable[TARGET_TYPE_FELICA] = 255;        // Felica
   mTechnologyTimeoutsTable[TARGET_TYPE_V] = 1000;            // NfcV
```

* log

```
07-13 19:21:48.191  3487  4098 I libnfc_nci: [INFO:nfa_rw_act.cc(2920)] nfa_rw_handle_op_req: op=0x05
07-13 19:21:48.191  3487  4098 I libnfc_nci: [INFO:nfa_sys_ptim.cc(156)] nfa_sys_ptim_stop_timer 0x7af85f8108
07-13 19:21:48.191  3487  4098 I libnfc_nci: [INFO:nfa_sys_ptim.cc(163)] ptim timer stop
07-13 19:21:48.191  3487  4098 I libnfc_nci: [INFO:nfa_rw_act.cc(211)] Stopped presence check timer (if started)
07-13 19:21:48.191  3487  4098 I libnfc_nci: [INFO:nfc_ncif.cc(175)] nfc_ncif_send_data :0, num_buff:1 qc:0
07-13 19:21:48.192  3487  4098 I libnfc_nci: [INFO:NfcAdaptation.cc(784)] NfcAdaptation::HalWrite
07-13 19:21:48.192   920   920 D NfccPowerTracker: NfccPowerTracker::ProcessCmd: Enter, Received len :16
07-13 19:21:48.192   920  3943 D NxpTml  : PN54X - Write requested.....
07-13 19:21:48.192   920  3943 D NxpTml  : PN54X - Invoking I2C Write.....
07-13 19:21:48.201   920  3943 D NxpNciX : len =  16 > 00000D00A4040007FFFFFFFFFDDF0100
07-13 19:21:48.202   920  3943 D NxpTml  : PN54X - I2C Write successful.....
07-13 19:21:48.202   920  3943 D NxpTml  : PN54X - Posting Fresh Write message.....
07-13 19:21:48.202   920  3943 D NxpTml  : PN54X - Tml Writer Thread Running................
07-13 19:21:48.202   920  3945 D NxpHal  : write successful status = 0x0
07-13 19:21:48.192     0     0 E nfc write: DATA:                              00000D00A4040007FFFFFFFFFDDF0100
07-13 19:21:48.203     0     0 E nfc nRead: CORE_CONN_CREDITS_NTF              600603010001
07-13 19:21:48.210   920  3942 D NxpTml  : PN54X - I2C Read successful.....
07-13 19:21:48.210   920  3942 D NxpNciR : len =   6 > 600603010001
07-13 19:21:48.210   920  3942 D NxpTml  : PN54X - Posting read message.....
07-13 19:21:48.210   920  3945 D NxpHal  : read successful status = 0x0
07-13 19:21:48.211   920  3945 D NfccPowerTracker: NfccPowerTracker::ProcessNtf: Enter
07-13 19:21:48.211  3487  3937 I libnfc_nci: [INFO:gki_buffer.cc(307)] GKI_getbuf 0xb400007c124b38a0 36:40
07-13 19:21:48.212  3487  4098 I libnfc_nci: [INFO:nfc_ncif.cc(482)] victor,NFC received ntf gid:0
07-13 19:21:48.212  3487  4098 I libnfc_nci: [INFO:nci_hrcv.cc(128)] nci_proc_core_ntf opcode:0x6
07-13 19:21:48.212  3487  4098 I libnfc_nci: [INFO:nfc_ncif.cc(175)] nfc_ncif_send_data :0, num_buff:1 qc:0
07-13 19:21:48.212   920  3942 D NxpTml  : PN54X - Read requested.....
07-13 19:21:48.212   920  3942 D NxpTml  : PN54X - Invoking I2C Read.....
07-13 19:21:58.192  3487  4216 E libnfc_nci: [ERROR:NativeNfcTag.cpp(1038)] nativeNfcTag_doTransceive: wait response timeout
07-13 19:21:58.192  3487  4216 I libnfc_nci: [INFO:NativeNfcTag.cpp(1113)] nativeNfcTag_doTransceive: exit
07-13 19:21:58.194  5068  5068 D NFC_TEST: mNfcB.transceive IOException
07-13 19:21:58.196  5068  5068 W System.err: android.nfc.TagLostException: Tag was lost.
07-13 19:21:58.197  5068  5068 W System.err: 	at android.nfc.TransceiveResult.getResponseOrThrow(TransceiveResult.java:48)
```

* UM.9.15/hardware/nxp/nfc/pn8x/halimpl/tml/phTmlNfc.cc

看起来是卡在这里,gpTransportObj->Read

mmm hardware/nxp/nfc/pn8x/

刷入 UM.9.15/out/target/product/bengal/vendor/lib64/nfc_nci_nxp.so

```
if (1 == gpphTmlNfc_Context->tReadInfo.bEnable) {
      NXPLOG_TML_D("victor,PN54X - Read requested.....\n");
      /* Set the variable to success initially */
      wStatus = NFCSTATUS_SUCCESS;

      /* Variable to fetch the actual number of bytes read */
      dwNoBytesWrRd = PH_TMLNFC_RESET_VALUE;

      /* Read the data from the file onto the buffer */
      if (NULL != gpphTmlNfc_Context->pDevHandle) {
        NXPLOG_TML_D("PN54X - Invoking I2C Read.....\n");
        dwNoBytesWrRd =
            gpTransportObj->Read(gpphTmlNfc_Context->pDevHandle, temp, 260);
         NXPLOG_TML_D("victor,gpTransportObj->Read end,dwNoBytesWrRd = %d,\n",dwNoBytesWrRd);
        if (-1 == dwNoBytesWrRd) {
```

* UM.9.15/hardware/nxp/nfc/pn8x/halimpl/tml/transport/NfccI2cTransport.cc

上面的gpTransportObj->Read 最终调用到 int NfccI2cTransport::Read(的

```
ret_Read = read((intptr_t)pDevHandle, pBuffer, totalBtyesToRead - numRead);
```

* UM.9.15/kernel/msm-4.19/drivers/misc/pax/nfc/pn7160/i2c_drv.c

最终看到阻塞在wait_event_interruptible,芯片没有给出中断.所以只能咨询一下fae

```
int i2c_read(struct nfc_dev *nfc_dev, char *buf, size_t count, int timeout)
{
        pr_err("victor,wait_event_interruptible begin.\n");
					ret = wait_event_interruptible(
						nfc_dev->read_wq,
						!i2c_dev->irq_enabled);
						pr_err("victor,wait_event_interruptible edn,ret = %d.\n",ret);
}
```

* UM.9.15/vendor/nxp/nfc/hw/pn7160/libnfc-nxp.conf

咨询fae, fae说看到有内部卡模拟命令 211000 ,是否有外部射频场? 默认pn5190 默认打开?

先把卡模拟关掉试试.

len =   3 > 211000 , NFCEE_DISCOVER_CMD 211000 内部模拟卡命令

```
07-20 01:20:42.549   902  5130 D NxpTml  : PN54X - Write requested.....
07-20 01:20:42.549   902  5130 D NxpTml  : PN54X - Invoking I2C Write.....
07-20 01:20:42.550   902  5130 D NxpNciX : len =   3 > 211000
07-20 01:20:42.550   902  5130 D NxpTml  : PN54X - I2C Write successful.....
07-20 01:20:42.550   902  5130 D NxpTml  : PN54X - Posting Fresh Write message.....
07-20 01:20:42.550   902  5130 D NxpTml  : PN54X - Tml Writer Thread Running................
07-20 01:20:42.550   902  5132 D NxpHal  : write successful status = 0x0
07-20 01:20:42.551   902  5129 D NxpTml  : PN54X - I2C Read successful.....
07-20 01:20:42.551   902  5129 D NxpNciR : len =   4 > 41100100
07-20 01:20:42.551   902  5129 D NxpTml  : PN54X - Posting read message.....
07-20 01:20:42.551   902  5132 D NxpHal  : read successful status = 0x0
07-20 01:20:42.553   902  5129 D NxpTml  : PN54X - Read requested.....
07-20 01:20:42.553   902  5129 D NxpTml  : PN54X - Invoking I2C Read.....
07-20 01:20:42.548     0     0 E nfc write: NFCEE_DISCOVER_CMD                 211000
07-20 01:20:42.555   902  5129 D NxpTml  : PN54X - I2C Read successful.....
07-20 01:20:42.555   902  5129 D NxpNciR : len =   4 > 61100100
07-20 01:20:42.555   902  5129 D NxpTml  : PN54X - Posting read message.....
07-20 01:20:42.555   902  5132 D NxpHal  : read successful status = 0x0
07-20 01:20:42.555   902  5132 D NfccPowerTracker: NfccPowerTracker::ProcessNtf: Enter
07-20 01:20:42.550     0     0 E nfc nRead: NFCEE_DISCOVER_RSP                 41100100
07-20 01:20:42.558   902  5129 D NxpTml  : PN54X - Read requested.....
07-20 01:20:42.554     0     0 E nfc nRead: NFCEE_DISCOVER_NTF                 61100100
07-20 01:20:42.558   902  5129 D NxpTml  : PN54X - Invoking I2C Read.....
```

* QSSI.12/packages/apps/Nfc/src/com/android/nfc/NfcService.java

注释掉tag.startPresenceChecking(presenceCheckDelay, callback); 就没有下发 211000指令了.

```
final class NfcServiceHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_NDEF_TAG:
                mLastReadNdefMessage = ndefMsg;

                    //tag.startPresenceChecking(presenceCheckDelay, callback);
                    dispatchTagEndpoint(tag, readerParams);
                    break;
            }
```

* QSSI.12/system/nfc/src/nfc/tags/rw_t4t.cc

看起来是这支文件下发NFC_ISODEPNakPresCheck, 211000,

跟下发211000没有关系, 这个是查看卡是否还在位的消息. nxp的fae一点都不靠谱

```
tNFC_STATUS RW_T4tPresenceCheck(uint8_t option) {
  tNFC_STATUS retval = NFC_STATUS_OK;
  tRW_DATA evt_data;
  bool status;
  NFC_HDR* p_data;

  DLOG_IF(INFO, nfc_debug_enabled) << StringPrintf("%s - %d", __func__, option);
  } else if (option == RW_T4T_CHK_ISO_DEP_NAK_PRES_CHK) {
      if (NFC_ISODEPNakPresCheck() == NFC_STATUS_OK) status = true;
    }
}
```

* QSSI.12/frameworks/base/core/java/android/nfc/tech/BasicTagTechnology.java

应用调用NfcB.connect() 会调用到这支文件的 public void connect() throws IOException {}

```
   @Override
    public void connect() throws IOException {
        try {
            int errorCode = mTag.getTagService().connect(mTag.getServiceHandle(),
                    mSelectedTechnology);

            }
```

* QSSI.12/packages/apps/Nfc/src/com/android/nfc/NfcService.java

然后会调用到 这支文件的 connect

```
final class TagService extends INfcTag.Stub {
        @Override
        public int connect(int nativeHandle, int technology) throws RemoteException {
            NfcPermissions.enforceUserPermissions(mContext);

            TagEndpoint tag = null;

            if (!isNfcEnabled()) {
                return ErrorCodes.ERROR_NOT_INITIALIZED;
            }    

            /* find the tag in the hmap */
            tag = (TagEndpoint) findObject(nativeHandle);
            if (tag == null) {
                return ErrorCodes.ERROR_DISCONNECT;
            }    

            if (!tag.isPresent()) {
                return ErrorCodes.ERROR_DISCONNECT;
            }    
            // Note that on most tags, all technologies are behind a single
            // handle. This means that the connect at the lower levels
            // will do nothing, as the tag is already connected to that handle.
            if (tag.connect(technology)) {
                return ErrorCodes.SUCCESS;
            } else {
                return ErrorCodes.ERROR_DISCONNECT;
            }
        }
        }
```

* QSSI.12/packages/apps/Nfc/nci/src/com/android/nfc/dhimpl/NativeNfcTag.java

接着调用到这里

```
public synchronized boolean connect(int technology) {
         return connectWithStatus(technology) == 0;
}
```

* QSSI.12/packages/apps/Nfc/nci/src/com/android/nfc/dhimpl/NativeNfcTag.java

最后会调用到 nativeNfcTag_doConnect,TargetType 切换不同的switchRfInterface

```
DLOG_IF(INFO, nfc_debug_enabled) << StringPrintf(
        "%s: TargetType=%d, TargetProtocol=%d", __func__,)
```

所以,这个 targetHandle 最终就是对应文件的super第二个参数,QSSI.12/frameworks/base/core/java/android/nfc/tech/

例如 TagTechnology.NFC_B

```
/** @hide */
    public NfcB(Tag tag) throws RemoteException {
        super(tag, TagTechnology.NFC_B);
        Bundle extras = tag.getTechExtras(TagTechnology.NFC_B);
        mAppData = extras.getByteArray(EXTRA_APPDATA);
        mProtInfo = extras.getByteArray(EXTRA_PROTINFO);
    }   
```

```
static jint nativeNfcTag_doConnect(JNIEnv*, jobject, jint targetHandle) {
  DLOG_IF(INFO, nfc_debug_enabled)
      << StringPrintf("%s: targetHandle = %d", __func__, targetHandle);
  int i = targetHandle;
  NfcTag& natTag = NfcTag::getInstance();
  int retCode = NFCSTATUS_SUCCESS;

  if (i >= NfcTag::MAX_NUM_TECHNOLOGY) {
    LOG(ERROR) << StringPrintf("%s: Handle not found", __func__);
    retCode = NFCSTATUS_FAILED;
    goto TheEnd;
  }

  if (natTag.getActivationState() != NfcTag::Active) {
    LOG(ERROR) << StringPrintf("%s: tag already deactivated", __func__);
    retCode = NFCSTATUS_FAILED;
    goto TheEnd;
  }

  #if (NXP_EXTNS == TRUE)
  sCurrentConnectedHandle = targetHandle;
  if (sCurrentConnectedTargetProtocol == NFC_PROTOCOL_T3BT) {
    goto TheEnd;
  }
#endif

  sCurrentConnectedTargetType = natTag.mTechList[i];
  sCurrentConnectedTargetProtocol = natTag.mTechLibNfcTypes[i];
  sCurrentConnectedHandle = targetHandle;

  DLOG_IF(INFO, nfc_debug_enabled) << StringPrintf(
        "%s: TargetType=%d, TargetProtocol=%d", __func__,
        sCurrentConnectedTargetType, sCurrentConnectedTargetProtocol);

  if (sCurrentConnectedTargetProtocol != NFC_PROTOCOL_ISO_DEP &&
      sCurrentConnectedTargetProtocol != NFC_PROTOCOL_MIFARE) {
    DLOG_IF(INFO, nfc_debug_enabled) << StringPrintf(
        "%s() Nfc type = %d, do nothing for non ISO_DEP and non Mifare ",
        __func__, sCurrentConnectedTargetProtocol);
    retCode = NFCSTATUS_SUCCESS;
    goto TheEnd;
  }

  if (sCurrentConnectedTargetType == TARGET_TYPE_ISO14443_3A ||
      sCurrentConnectedTargetType == TARGET_TYPE_ISO14443_3B) {

      if (sCurrentConnectedTargetProtocol != NFC_PROTOCOL_MIFARE) {
        DLOG_IF(INFO, nfc_debug_enabled) << StringPrintf(
        "%s: switching to tech: %d need to switch rf intf to frame", __func__,
        sCurrentConnectedTargetType);
        retCode = switchRfInterface(NFA_INTERFACE_FRAME) ? NFA_STATUS_OK
                                                         : NFA_STATUS_FAILED;
      }
  } else if (sCurrentConnectedTargetType == TARGET_TYPE_MIFARE_CLASSIC) {
    retCode = switchRfInterface(NFA_INTERFACE_MIFARE) ? NFA_STATUS_OK
                                                      : NFA_STATUS_FAILED;
  } else {
    retCode = switchRfInterface(NFA_INTERFACE_ISO_DEP) ? NFA_STATUS_OK
                                                       : NFA_STATUS_FAILED;
  }

TheEnd:
  DLOG_IF(INFO, nfc_debug_enabled)
      << StringPrintf("%s: exit 0x%X", __func__, retCode);
  return retCode;
}
```

```
83 public interface TagTechnology extends Closeable {
 84     /**
 85      * This technology is an instance of {@link NfcA}.
 86      * <p>Support for this technology type is mandatory.
 87      * @hide
 88      */
 89     public static final int NFC_A = 1;
 90 
 91     /**
 92      * This technology is an instance of {@link NfcB}.
 93      * <p>Support for this technology type is mandatory.
 94      * @hide
 95      */
 96     public static final int NFC_B = 2;
 97 
 98     /**
 99      * This technology is an instance of {@link IsoDep}.
100      * <p>Support for this technology type is mandatory.
101      * @hide
102      */
103     public static final int ISO_DEP = 3;
```

* QSSI.12/packages/apps/Nfc/nci/jni/NfcJniUtil.h

这里的内容,跟 TagTechnology.java里面一一对应

所以,
NFC_A 对应 TARGET_TYPE_ISO14443_3A
NFC_B 对应 TARGET_TYPE_ISO14443_3B
ISO_DEP 对应 TARGET_TYPE_ISO14443_4

```
 70 /* Name strings for target types. These *must* match the values in
 71  * TagTechnology.java */
 72 #define TARGET_TYPE_UNKNOWN (-1)
 73 #define TARGET_TYPE_ISO14443_3A 1
 74 #define TARGET_TYPE_ISO14443_3B 2
 75 #define TARGET_TYPE_ISO14443_4 3
 76 #define TARGET_TYPE_FELICA 4
 77 #define TARGET_TYPE_V 5
 78 #define TARGET_TYPE_NDEF 6
 79 #define TARGET_TYPE_NDEF_FORMATABLE 7
 80 #define TARGET_TYPE_MIFARE_CLASSIC 8
 81 #define TARGET_TYPE_MIFARE_UL 9
 82 #define TARGET_TYPE_KOVIO_BARCODE 10
```

* QSSI.12/system/nfc/src/nfc/include/nfc_api.h

```
#define NCI_PROTOCOL_UNKNOWN 0x00
#define NCI_PROTOCOL_T1T 0x01
#define NCI_PROTOCOL_T2T 0x02
#define NCI_PROTOCOL_T3T 0x03
#define NCI_PROTOCOL_T5T 0x06
#define NCI_PROTOCOL_ISO_DEP 0x04
#define NCI_PROTOCOL_NFC_DEP 0x05
/**********************************************
 * Proprietary Protocols
 **********************************************/
#if (NXP_EXTNS == TRUE)
#ifndef NCI_PROTOCOL_T3BT
#define NCI_PROTOCOL_T3BT 0x8b
#endif
#endif
```

```
/* Supported Protocols */
#define NFC_PROTOCOL_UNKNOWN NCI_PROTOCOL_UNKNOWN /* Unknown */
/* Type1Tag    - NFC-A            */
#define NFC_PROTOCOL_T1T NCI_PROTOCOL_T1T
/* Type2Tag    - NFC-A            */
#define NFC_PROTOCOL_T2T NCI_PROTOCOL_T2T
/* Type3Tag    - NFC-F            */
#define NFC_PROTOCOL_T3T NCI_PROTOCOL_T3T
/* Type5Tag    - NFC-V/ISO15693*/
#define NFC_PROTOCOL_T5T NFC_PROTOCOL_T5T_(NFC_GetNCIVersion())
#define NFC_PROTOCOL_T5T_(x) \
  (((x) == NCI_VERSION_2_0) ? NCI_PROTOCOL_T5T : NCI_PROTOCOL_15693)
/* Type 4A,4B  - NFC-A or NFC-B   */
#define NFC_PROTOCOL_ISO_DEP NCI_PROTOCOL_ISO_DEP
/* NFCDEP/LLCP - NFC-A or NFC-F       */
#define NFC_PROTOCOL_NFC_DEP NCI_PROTOCOL_NFC_DEP
#define NFC_PROTOCOL_MIFARE NCI_PROTOCOL_MIFARE
#if (NXP_EXTNS == TRUE)
#define NFC_PROTOCOL_T3BT NCI_PROTOCOL_T3BT
#endif
#define NFC_PROTOCOL_ISO15693 NCI_PROTOCOL_15693
#define NFC_PROTOCOL_B_PRIME NCI_PROTOCOL_B_PRIME
#define NFC_PROTOCOL_KOVIO NCI_PROTOCOL_KOVIO
```

```
/* RF Interface type */
#define NFA_INTERFACE_FRAME NFC_INTERFACE_FRAME
#define NFA_INTERFACE_ISO_DEP NFC_INTERFACE_ISO_DEP
#define NFA_INTERFACE_NFC_DEP NFC_INTERFACE_NFC_DEP
#define NFA_INTERFACE_MIFARE NFC_INTERFACE_MIFARE
typedef tNFC_INTF_TYPE tNFA_INTF_TYPE;
```

```
/**********************************************
 * Interface Types
 **********************************************/
#define NFC_INTERFACE_EE_DIRECT_RF NCI_INTERFACE_EE_DIRECT_RF
#define NFC_INTERFACE_FRAME NCI_INTERFACE_FRAME
#define NFC_INTERFACE_ISO_DEP NCI_INTERFACE_ISO_DEP
#define NFC_INTERFACE_NFC_DEP NCI_INTERFACE_NFC_DEP
#define NFC_INTERFACE_MIFARE NCI_INTERFACE_VS_MIFARE
typedef tNCI_INTF_TYPE tNFC_INTF_TYPE;
```

```
/* Definitions for NFC protocol for RW, CE and P2P APIs */
/* Type1Tag - NFC-A */
#define NFA_PROTOCOL_T1T NFC_PROTOCOL_T1T
/* MIFARE/Type2Tag - NFC-A */
#define NFA_PROTOCOL_T2T NFC_PROTOCOL_T2T
/* Felica/Type3Tag - NFC-F */
#define NFA_PROTOCOL_T3T NFC_PROTOCOL_T3T
/* Type 4A,4B - NFC-A or NFC-B */
#define NFA_PROTOCOL_ISO_DEP NFC_PROTOCOL_ISO_DEP
/* NFCDEP/LLCP - NFC-A or NFC-F */
#define NFA_PROTOCOL_NFC_DEP NFC_PROTOCOL_NFC_DEP
/* NFC_PROTOCOL_T5T in NCI2.0 and NFC_PROTOCOL_ISO15693 proprietary in NCI1.0*/
#define NFA_PROTOCOL_T5T NFC_PROTOCOL_T5T
#if (NXP_EXTNS == TRUE)
#define NFA_PROTOCOL_T3BT NFC_PROTOCOL_T3BT
#endif
#define NFA_PROTOCOL_INVALID 0xFF
typedef uint8_t tNFA_NFC_PROTOCOL;
```

* QSSI.12/system/nfc/src/include/nci_defs.h

```
/**********************************************
 * NCI Interface Types
 **********************************************/
#define NCI_INTERFACE_EE_DIRECT_RF 0
#define NCI_INTERFACE_FRAME 1
#define NCI_INTERFACE_ISO_DEP 2
#define NCI_INTERFACE_NFC_DEP 3
#define NCI_INTERFACE_MAX NCI_INTERFACE_NFC_DEP
#define NCI_INTERFACE_EXTENSION_MAX 2
#define NCI_INTERFACE_FIRST_VS 0x80
typedef uint8_t tNCI_INTF_TYPE;
```

```
/**********************************************
 * NCI Interface Types
 **********************************************/
#define NCI_INTERFACE_EE_DIRECT_RF 0
#define NCI_INTERFACE_FRAME 1
#define NCI_INTERFACE_ISO_DEP 2
#define NCI_INTERFACE_NFC_DEP 3
#define NCI_INTERFACE_MAX NCI_INTERFACE_NFC_DEP
#define NCI_INTERFACE_EXTENSION_MAX 2
#define NCI_INTERFACE_FIRST_VS 0x80
typedef uint8_t tNCI_INTF_TYPE;
```

* QSSI.12/system/nfc/src/include/nfc_brcm_defs.h

```
/**********************************************
 * NCI Interface Types
 **********************************************/
#define NCI_INTERFACE_VS_MIFARE NCI_PROTOCOL_MIFARE
#define NCI_INTERFACE_VS_T2T_CE 0x82 /* for Card Emulation side */
```

* QSSI.12/vendor/nxp/opensource/commonsys/packages/apps/Nfc/nci/jni/NativeNfcTag.cpp

```
#define NCI_PROTOCOL_MIFARE 0x80
```

# 解决

对比X4的log,跟A6650 的log,搜索发送的nci指令NxpNciX,发现,对比差异,发现A6650 下210403010401(switchRfInterface(NFA_INTERFACE_FRAME))是不会成功的.

需要下210403010402(switchRfInterface(NFA_INTERFACE_ISO_DEP))才能成功,

下NFA_INTERFACE_ISO_DEP ,读卡速度也有提升.之前读卡速度慢,可能就是下的太多下210403010401,导致寻卡慢

并不清楚,为什么X4,210403010401 也能成功,但是可以确认,X4 下210403010401, apk需要加延时才能成功,估计下210403010401 也是有问题的.

* X4

```
	行 1045: 07-21 19:31:40.737   277  1481 D NxpNciX : len =   4 => 21060101
	行 1111: 07-21 19:31:40.752   277  1481 D NxpNciX : len =   6 => 210403010401
```

* A6650

```
	行 2186: 07-21 20:14:45.642   928  6601 D NxpNciX : len =   4 > 21060101
	行 2236: 07-21 20:14:45.673   928  6601 D NxpNciX : len =   6 > 210403010401
	行 2308: 07-21 20:14:45.839   928  6601 D NxpNciX : len =   4 > 21060101
	行 2359: 07-21 20:14:45.872   928  6601 D NxpNciX : len =   6 > 210403010401
	行 2431: 07-21 20:14:45.937   928  6601 D NxpNciX : len =  23 > 00001400A404000E315041592E5359532E444446303100
	行 2500: 07-21 20:14:46.951   928  6601 D NxpNciX : len =   8 > 0000050084000004
	行 2573: 07-21 20:14:47.968   928  6601 D NxpNciX : len =   4 > 000001C2
	行 2607: 07-21 20:14:47.983   928  6601 D NxpNciX : len =   4 > 21060101
	行 2680: 07-21 20:14:48.026   928  6601 D NxpNciX : len =   6 > 210403010402
```

# 解决方案

* QSSI.12/packages/apps/Nfc/nci/jni/NativeNfcTag.cpp

```
--- a/QSSI.12/packages/apps/Nfc/nci/jni/NativeNfcTag.cpp
+++ b/QSSI.12/packages/apps/Nfc/nci/jni/NativeNfcTag.cpp
@@ -612,7 +612,12 @@ static jint nativeNfcTag_doConnect(JNIEnv*, jobject, jint targetHandle) {
 
   if (sCurrentConnectedTargetType == TARGET_TYPE_ISO14443_3A ||
       sCurrentConnectedTargetType == TARGET_TYPE_ISO14443_3B) {
-
+      //[feature-modify-begin],xielianxiong@paxsz.com,20230728,for A,B card transceive error
+      if(sCurrentConnectedTargetProtocol == NFC_PROTOCOL_ISO_DEP){
+        retCode = switchRfInterface(NFA_INTERFACE_ISO_DEP) ? NFA_STATUS_OK
+                                                           : NFA_STATUS_FAILED;
+      }else
+      //[feature-modify-end],xielianxiong@paxsz.com,20230728,for A,B card transceive error
       if (sCurrentConnectedTargetProtocol != NFC_PROTOCOL_MIFARE) {
         DLOG_IF(INFO, nfc_debug_enabled) << StringPrintf(
         "%s: switching to tech: %d need to switch rf intf to frame", __func__,
```