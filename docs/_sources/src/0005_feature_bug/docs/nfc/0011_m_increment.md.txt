# 概要

测试部提了一笔bug,说nfc m卡充值失败

# 测试用例

看测试用例,是调用MifareClassic.increment 跟 decrement 失败

```
public static void MifareClassic_FUN3(Tag tag) {
		byte BlkValue_W[] = new byte[16], BlkValue_R[] = new byte[16], BlkValue_Temp[] = new byte[16];
		byte BlkNo, UpdateBlkNo;
		int  flag,sectorCount,bCount,bIndex,i,j,ucRet = 0,Cnt,uci,resultMoney,MoneyValueAdd = 1,failCnt = 0;
		boolean auth = false;
		int sectorIndex[] = {1,5};
		int blockIndex[] = {4,20};


		mMifareClassic = MifareClassic.get(tag);
		if(mMifareClassic != null) {
			try {
				mMifareClassic.connect();
			} catch (IOException e) {
				e.printStackTrace();
				sendmessage(String.format("connect fail:%s\n", e.getMessage()));
			}
			if (mMifareClassic.isConnected()) {
				sectorCount = mMifareClassic.getSectorCount();//返回MIFARE Classic扇区的数量
				sendmessage(String.format("共有%d个扇区\n", sectorCount));

				for (i = 0; i < 2; i++) {
					try {
						auth = mMifareClassic.authenticateSectorWithKeyA(sectorIndex[i], MifareClassic.KEY_NFC_FORUM);
					} catch (IOException e) {
						e.printStackTrace();
						sendmessage("authenticateSectorWithKeyA fail\n");
					}
					if (auth) {
						sendmessage(String.format("[%d]认证成功\n", sectorIndex[i]));
					} else {
						try {
							auth = m1Auth(mMifareClassic, sectorIndex[i]);
						} catch (IOException e) {
							e.printStackTrace();
							sendmessage(String.format("[%d]m1Auth Fail\n", sectorIndex));
							return;
						}
					}

					//初始化钱包数据
//                DateUtils.memcpy(BlkValue_W, "01000000", 4);
//                BlkValue_W[4] = (byte) ~BlkValue_W[0];
//                BlkValue_W[5] = (byte) ~BlkValue_W[1];
//                BlkValue_W[6] = (byte) ~BlkValue_W[2];
//                BlkValue_W[7] = (byte) ~BlkValue_W[3];
//                DateUtils.memcpy(BlkValue_W, 8, BlkValue_W, 4);
//                BlkValue_W[12] = BlkValue_W[14] = (byte)bIndex;
//                BlkValue_W[13] = BlkValue_W[15] = (byte) ~bIndex;

					//写初始钱包余额1元钱
					try {
						//初始化钱包数据
						BlkValue_W = m1FormatBlock(blockIndex[i], 1);
						sendmessage(String.format("before write BlkValue_W:%s\n", DateUtils.ByteArrayToHexString(BlkValue_W)));
						mMifareClassic.writeBlock(blockIndex[i], BlkValue_W);
						ucRet = 0;
					} catch (IOException e) {
						e.printStackTrace();
						ucRet = -1;
						sendmessage(String.format("[%d]writeBlock Fail\n", blockIndex[i]));
					}

					if (ucRet == 0) {
						try {
							BlkValue_R = mMifareClassic.readBlock(blockIndex[i]);
						} catch (IOException e) {
							e.printStackTrace();
							sendmessage(String.format("readBlock Fail:%s\n", e.getMessage()));
						}
						sendmessage(String.format("before increment  BlkValue_R:%s\n", DateUtils.ByteArrayToHexString(BlkValue_R)));
						//加1元钱
						//将余额转换为十进制数进行加操作计算出结果，然后再将结果转换为16进制倒序写入到卡中
						try {
							Log.d(LOG_TAG,"m1incvalue begin,blockIndex[i] = "+blockIndex[i]+",MoneyValueAdd = 1");
							m1incvalue(mMifareClassic, blockIndex[i], MoneyValueAdd);
							Log.d(LOG_TAG,"m1incvalue end,");
						} catch (Exception e) {
							e.printStackTrace();
							sendmessage(String.format("[%d]m1incvalue Fail\n",  blockIndex[i]));
						}

						try {
							BlkValue_R = mMifareClassic.readBlock(blockIndex[i]);
							sendmessage(String.format("BlkValue_R:%s\n", DateUtils.ByteArrayToHexString(BlkValue_R)));

//                        byte MoneyValue = (byte)0x01;
//                        DateUtils.memcpy(BlkValue_Temp, BlkValue_W, BlkValue_W.length);
//                        BlkValue_Temp[0] = (byte) (BlkValue_W[0] + MoneyValue);
//                        BlkValue_Temp[4] = (byte) ~BlkValue_Temp[0];
//                        BlkValue_Temp[8] = BlkValue_Temp[0];
//                        if(DateUtils.memcmp(BlkValue_R, BlkValue_Temp, BlkValue_Temp.length) == 0){
//                            sendmessage(String.format("充值成功\n"));
//                        }

							//处理钱包数据，取前四个字节数据转换为10进制
							resultMoney = resolveBlockValue(BlkValue_R);
							if (resultMoney != 2) {
								sendmessage(String.format("充值失败:%d\n", resultMoney));
							} else {
								sendmessage(String.format("充值成功\n"));
							}
						} catch (IOException e) {
							e.printStackTrace();
							sendmessage(String.format("readBlock Fail:%s\n", e.getMessage()));
						}
					}
				}
			}
			try {
				mMifareClassic.close();
			} catch (IOException e) {
				e.printStackTrace();
				sendmessage(String.format("close Fail:%s\n", e.getMessage()));
			}
		}
	}

public static void m1incvalue(MifareClassic mc,int block,int value) {
		// increase the value block by some amount
		try {
			mc.increment(block, value);
		} catch (IOException e) {
			e.printStackTrace();
			sendmessage(String.format("increment Fail:%s\n", e.getMessage()));
		}
		// result is stored in scratch register inside tag; now write result to block
		try {
			mc.transfer(block);
		} catch (IOException e) {
			e.printStackTrace();
			sendmessage(String.format("transfer Fail:%s\n", e.getMessage()));
		}
	}
```

# log

可以看到,我们下的是总共9个指令,除去3个nci 头,还有6个指令,但是log显示,把最后3个数据给丢了.

```
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(785)] NfcAdaptation::HalWrite
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[0] = 0x00,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[1] = 0x00,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[2] = 0x06,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[3] = 0xc1,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[4] = 0x04,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[5] = 0x01,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[6] = 0x00,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[7] = 0x00,
07-29 09:44:41.183  3762  4450 I libnfc_nci: [INFO:NfcAdaptation.cc(790)] victor,p_data[8] = 0x00,

07-29 09:44:41.184   965   965 D NfccPowerTracker: NfccPowerTracker::ProcessCmd: Enter, Received len :6
07-29 09:44:41.184   965   965 D NfccPowerTracker: victor,cmd[0] = 0x00,
07-29 09:44:41.184   965   965 D NfccPowerTracker: victor,cmd[1] = 0x00,
07-29 09:44:41.184   965   965 D NfccPowerTracker: victor,cmd[2] = 0x03,
07-29 09:44:41.184   965   965 D NfccPowerTracker: victor,cmd[3] = 0x10,
07-29 09:44:41.184   965   965 D NfccPowerTracker: victor,cmd[4] = 0xc1,
07-29 09:44:41.184   965   965 D NfccPowerTracker: victor,cmd[5] = 0x04,

07-29 09:44:41.213   965   965 D NfccPowerTracker: NfccPowerTracker::ProcessCmd: Enter, Received len :5
07-29 09:44:41.213   965   965 D NfccPowerTracker: victor,cmd[0] = 0x00,
07-29 09:44:41.213   965   965 D NfccPowerTracker: victor,cmd[1] = 0x00,
07-29 09:44:41.213   965   965 D NfccPowerTracker: victor,cmd[2] = 0x05,
07-29 09:44:41.213   965   965 D NfccPowerTracker: victor,cmd[3] = 0x10,
07-29 09:44:41.213   965   965 D NfccPowerTracker: victor,cmd[4] = 0x01,
```

# 流程

* UM.9.15/hardware/nxp/nfc/pn8x/halimpl/mifare/NxpMfcReader.cc

先去除3位的NCI_HEADER_SIZE(0x00,0x00,0x06),判断第三位,是什么

```
int NxpMfcReader::Write(uint16_t mfcDataLen, const uint8_t* pMfcData) {
  uint16_t mfcTagCmdBuffLen = 0;
  uint8_t mfcTagCmdBuff[MAX_MFC_BUFF_SIZE] = {0};
  NXPLOG_NCIHAL_E("victor,NxpMfcReader::Write,mfcDataLen = %d,MAX_MFC_BUFF_SIZE = %d,NCI_HEADER_SIZE = %d,",mfcDataLen,MAX_MFC_BUFF_SIZE,NCI_HEADER_SIZE);
  if (mfcDataLen > MAX_MFC_BUFF_SIZE) {
    android_errorWriteLog(0x534e4554, "169259605");
    mfcDataLen = MAX_MFC_BUFF_SIZE;
  }
  memcpy(mfcTagCmdBuff, pMfcData, mfcDataLen);
  if (mfcDataLen >= 3) mfcTagCmdBuffLen = mfcDataLen - NCI_HEADER_SIZE;
  BuildMfcCmd(&mfcTagCmdBuff[3], &mfcTagCmdBuffLen);

  mfcTagCmdBuff[2] = mfcTagCmdBuffLen;
  NXPLOG_NCIHAL_E("victor,mfcTagCmdBuffLen = %d,",mfcTagCmdBuffLen);
  mfcDataLen = mfcTagCmdBuffLen + NCI_HEADER_SIZE;
  NXPLOG_NCIHAL_E("victor,NxpMfcReader::Write,mfcDataLen2 = %d,",mfcDataLen);
  int writtenDataLen = phNxpNciHal_write_internal(mfcDataLen, mfcTagCmdBuff);

  NXPLOG_NCIHAL_E("victor mfcTagCmdBuff[4] = 0x%02x,",mfcTagCmdBuff[4]);
  /* send TAG_CMD part 2 for Mifare increment ,decrement and restore commands */
  if (mfcTagCmdBuff[4] == eMifareDec || mfcTagCmdBuff[4] == eMifareInc ||
      mfcTagCmdBuff[4] == eMifareRestore) {
      SendIncDecRestoreCmdPart2(mfcDataLen,pMfcData);
  }
  return writtenDataLen;
}
```

```
void NxpMfcReader::BuildMfcCmd(uint8_t* pData, uint16_t* pLength) {
  uint16_t cmdBuffLen = *pLength;
  memcpy(mMfcTagCmdIntfData.sendBuf, pData, cmdBuffLen);
  mMfcTagCmdIntfData.sendBufLen = cmdBuffLen;

  switch (pData[0]) {
    case eMifareAuthentA:
    case eMifareAuthentB:
      BuildAuthCmd();
      break;
    case eMifareRead16:
      BuildReadCmd();
      break;
    case eMifareWrite16:
      AuthForWrite();
      BuildWrite16Cmd();
      break;
    case eMifareInc:
    case eMifareDec:
      BuildIncDecCmd();
      break;
    default:
      BuildRawCmd();
      break;
  }

  memcpy(pData, mMfcTagCmdIntfData.sendBuf, (mMfcTagCmdIntfData.sendBufLen));
  *pLength = (mMfcTagCmdIntfData.sendBufLen);
  return;
}
```

```
void NxpMfcReader::BuildIncDecCmd() {
  mMfcTagCmdIntfData.sendBufLen = 0x03;  // eMfRawDataXchgHdr + cmd +
                                         // blockaddress
  memmove(mMfcTagCmdIntfData.sendBuf + 1, mMfcTagCmdIntfData.sendBuf,
          mMfcTagCmdIntfData.sendBufLen);
  mMfcTagCmdIntfData.sendBuf[0] = eMfRawDataXchgHdr;
}
```

```
void NxpMfcReader::SendIncDecRestoreCmdPart2(uint16_t mfcDataLen,
                                             const uint8_t* mfcData) {
  NFCSTATUS status = NFCSTATUS_SUCCESS;
  /* Build TAG_CMD part 2 for Mifare increment ,decrement and restore commands*/
  uint8_t incDecRestorePart2[] = {0x00, 0x00, 0x05, (uint8_t)eMfRawDataXchgHdr,
                                  0x00, 0x00, 0x00, 0x00};
  uint8_t incDecRestorePart2Size =
      (sizeof(incDecRestorePart2) / sizeof(incDecRestorePart2[0]));
  NXPLOG_NCIHAL_E("victor,SendIncDecRestoreCmdPart2,mfcDataLen = %d,",mfcDataLen);
  NXPLOG_NCIHAL_E("victor,SendIncDecRestoreCmdPart2,mfcData[3]= 0x%02x,incDecRestorePart2Size = %d,",mfcData[3],incDecRestorePart2Size);

  if (mfcData[3] == eMifareInc || mfcData[3] == eMifareDec) {
    if (incDecRestorePart2Size >= mfcDataLen) {
      incDecRestorePart2Size = mfcDataLen - 1;
      android_errorWriteLog(0x534e4554, "238177877");
    }
    for (int i = 4; i < incDecRestorePart2Size; i++) {
      incDecRestorePart2[i] = mfcData[i + 1];
      NXPLOG_NCIHAL_E("victor,incDecRestorePart2[%d]= 0x%02x,",i,incDecRestorePart2[i]);
    }
  }
  sendRspToUpperLayer = false;
  status = phNxpNciHal_send_ext_cmd(incDecRestorePart2Size, incDecRestorePart2);
  if (status != NFCSTATUS_SUCCESS) {
    NXPLOG_NCIHAL_E("Mifare Cmd for inc/dec/Restore part 2 failed");
  }
  return;
}
```


* UM.9.15/hardware/nxp/nfc/pn8x/halimpl/mifare/NxpMfcReader.h

0xc1 对应 eMifareInc

```
51 typedef enum MifareCmdList {
 52   eMifareRaw = 0x00U,         /* This command performs raw transcations */
 53   eMifareAuthentA = 0x60U,    /* This command performs an authentication with
 54                                        KEY A for a sector. */
 55   eMifareAuthentB = 0x61U,    /* This command performs an authentication with
 56                                        KEY B for a sector. */
 57   eMifareRead16 = 0x30U,      /* Read 16 Bytes from a Mifare Standard block */
 58   eMifareRead = 0x30U,        /* Read Mifare Standard */
 59   eMifareWrite16 = 0xA0U,     /* Write 16 Bytes to a Mifare Standard block */
 60   eMifareWrite4 = 0xA2U,      /* Write 4 bytes. */
 61   eMifareInc = 0xC1U,         /* Increment */
 62   eMifareDec = 0xC0U,         /* Decrement */
 63   eMifareTransfer = 0xB0U,    /* Transfer */
 64   eMifareRestore = 0xC2U,     /* Restore.   */
 65   eMifareReadSector = 0x38U,  /* Read Sector.   */
 66   eMifareWriteSector = 0xA8U, /* Write Sector.   */
 67 } MifareCmdList_t;
```

```
72 typedef enum MfcCmdReqId {
 73   eMfRawDataXchgHdr = 0x10,   /* MF Raw Data Request from DH */
 74   eMfWriteNReq = 0x31,        /* MF N bytes write request from DH */
 75   eMfReadNReq = 0x32,         /* MF N bytes read request from DH */
 76   eMfSectorSelReq = 0x33,     /* MF Block select request from DH */
 77   eMfPlusProxCheckReq = 0x28, /* MF + Prox check request for NFCC from DH */
 78   eMfcAuthReq = 0x40,         /* MFC Authentication request for NFCC from DH */
 79   eInvalidReq                 /* Invalid ReqId */
 80 } MfcCmdReqId_t;
```

* 执行

    * 可以看到,先BuildMfcCmd,发送了mfcTagCmdBuff 0x00,0x00,0x03,0x10,0xc1, 0x04

    * SendIncDecRestoreCmdPart2,对比log,看起来就是图片截断了一些命令数据

        ![0011_0001](images/0011_0001.png)

# 验证

* UM.9.15/hardware/nxp/nfc/pn8x/halimpl/mifare/NxpMfcReader.cc

可以看到,下发了正确的指令后,充值成功,

    ![0011_0002](images/0011_0002.png)

```
07-29 14:37:41.782     0     0 E nfc write: DATA:                              0000051001000000
```

```
--- a/UM.9.15/hardware/nxp/nfc/pn8x/halimpl/mifare/NxpMfcReader.cc
+++ b/UM.9.15/hardware/nxp/nfc/pn8x/halimpl/mifare/NxpMfcReader.cc
@@ -53,8 +53,7 @@ int NxpMfcReader::Write(uint16_t mfcDataLen, const uint8_t* pMfcData) {
   BuildMfcCmd(&mfcTagCmdBuff[3], &mfcTagCmdBuffLen);
 
   mfcTagCmdBuff[2] = mfcTagCmdBuffLen;
-  mfcDataLen = mfcTagCmdBuffLen + NCI_HEADER_SIZE;
-  int writtenDataLen = phNxpNciHal_write_internal(mfcDataLen, mfcTagCmdBuff);
+  int writtenDataLen = phNxpNciHal_write_internal(mfcTagCmdBuffLen+NCI_HEADER_SIZE, mfcTagCmdBuff);
 
   /* send TAG_CMD part 2 for Mifare increment ,decrement and restore commands */
   if (mfcTagCmdBuff[4] == eMifareDec || mfcTagCmdBuff[4] == eMifareInc ||
```
