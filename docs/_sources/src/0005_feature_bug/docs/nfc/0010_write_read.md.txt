# 概要

测试部,提bug,说压力测试 读写 M卡,成功率低

# 测试代码

```
//读写文件性能测试
	public static void MifareClassic_PER1(Tag tag){
		int sectorCount = 0;
		int totalblockCount = 0;
		int i = 0,j = 0,bCount = 0,bIndex = 0,k = 0,OkCnt = 0;
		int sectorIndex = 1;
		int blockIndex = 4;
		long time = 0;
		boolean auth = false;
		boolean isEndBlock = false;
		byte[] readValue = new byte[8];
		byte Pwd[] = new byte[6];
		byte blkValue[] = new byte[8];

		mMifareClassic = MifareClassic.get(tag);
		if(mMifareClassic != null){
			try {
				mMifareClassic.connect();
			} catch (IOException e) {
				e.printStackTrace();
				sendmessage(String.format("connect fail:%s\n",e.getMessage()));
			}
			if(mMifareClassic.isConnected()) {
				//sendmessage(String.format("Type :%d\n", mMifareClassic.getType()));
				//totalblockCount = mMifareClassic.getBlockCount();//返回MIFARE Classic块的总数
				//sendmessage(String.format("共有%d个块\n", totalblockCount));
				//sendmessage(String.format("存储空间：%dB\n", mMifareClassic.getSize()));

				//sectorCount = mMifareClassic.getSectorCount();//返回MIFARE Classic扇区的数量
				//sendmessage(String.format("共有%d个扇区\n", sectorCount));
				try {
					auth = mMifareClassic.authenticateSectorWithKeyA(sectorIndex, MifareClassic.KEY_NFC_FORUM);
				} catch (IOException e) {
					e.printStackTrace();
					sendmessage("authenticateSectorWithKeyA fail\n");
				}
				sendmessage(String.format("循环测试开始\n"));
				for (i= 0; i < 200; i++) {
					//sendmessage(String.format("测试第%d次,\n",i));
					Log.d(LOG_TAG,"MifareClassic_PER1 i = "+i+",sectorIndex = "+sectorIndex);
					/*
					try {
						auth = mMifareClassic.authenticateSectorWithKeyA(sectorIndex, MifareClassic.KEY_NFC_FORUM);
					} catch (IOException e) {
						e.printStackTrace();
						sendmessage("authenticateSectorWithKeyA fail\n");
					}
					if(auth){
						Log.d(LOG_TAG,"MifareClassic_PER1 auth "+auth);
						//sendmessage(String.format("[%d]认证成功\n",sectorIndex));
					} else{
						try {
							Log.d(LOG_TAG,"MifareClassic_PER1 m1Auth begin ");
							auth = m1Auth(mMifareClassic, sectorIndex);
						} catch (IOException e) {
							Log.d(LOG_TAG,"MifareClassic_PER1 m1Auth IOException ");
							e.printStackTrace();
							sendmessage(String.format("[%d]m1Auth Fail\n",sectorIndex));
							continue;
						}
					}
					*/
					//返回给定扇区中的块数
					//bCount = mMifareClassic.getBlockCountInSector(sectorIndex);
					//返回给定扇区的第一个块
					//bIndex = mMifareClassic.sectorToBlock(sectorIndex);
					//sendmessage(String.format("bCount:%d，bIndex:%d\n",bCount,bIndex));

					Arrays.fill(blkValue,(byte) Math.abs(new Random().nextInt(0xFF)));
					c1 = Calendar.getInstance();
					try {
						Log.d(LOG_TAG,"MifareClassic_PER1 writeBlock begin blkValue ["+i+"] = "+Arrays.toString(blkValue));
						mMifareClassic.writeBlock(blockIndex, blkValue);
						//sendmessage(String.format("写入成功 Block:%d data:%s\n",blockIndex,DateUtils.ByteArrayToHexString(blkValue)));
					} catch (IOException e) {
						Log.d(LOG_TAG,"MifareClassic_PER1 writeBlock IOException ");
						e.printStackTrace();
						sendmessage("writeBlock fail\n");
					}
					//SystemClock.sleep(200);
					try {
						readValue = mMifareClassic.readBlock(blockIndex);
						Log.d(LOG_TAG,"MifareClassic_PER1 readBlock end, readValue["+i+"] = "+Arrays.toString(readValue));
					} catch (IOException e) {
						Log.d(LOG_TAG,"MifareClassic_PER1 readBlock IOException ");
						e.printStackTrace();
						sendmessage("readBlock fail\n");
					}
					c2 = Calendar.getInstance();
					time += c2.getTimeInMillis() - c1.getTimeInMillis();

					//sendmessage(String.format("Read Succes Block:%d data:%s\n",blockIndex,DateUtils.ByteArrayToHexString(readValue)));
					if (DateUtils.memcmp(blkValue, readValue, 16) == 0) {
						Log.d(LOG_TAG,"MifareClassic_PER1 the "+i+" time success ");
						OkCnt++;
					}else{
						Log.d(LOG_TAG,"MifareClassic_PER1 the "+i+" time failed ");
					}
					Log.d(LOG_TAG,"MifareClassic_PER1 OkCnt = "+OkCnt+",bIndex = "+bIndex);
					bIndex++;
				}
			}
			Log.d(LOG_TAG,"MifareClassic_PER1 mMifareClassic close begin ");
			try {
				mMifareClassic.close();
			} catch (IOException e) {
				Log.d(LOG_TAG,"MifareClassic_PER1 mMifareClassic close IOException ");
				e.printStackTrace();
				sendmessage("close fail\n");
			}
			sendmessage(String.format("Test End,time = %d，OkCnt = %d\n",time,OkCnt));
		}
	}
```

* QSSI.12/frameworks/base/core/java/android/nfc/tech/MifareClassic.java

```
public void writeBlock(int blockIndex, byte[] data) throws IOException {
        validateBlock(blockIndex);
        checkConnected();
        if (data.length != 16) {
            throw new IllegalArgumentException("must write 16-bytes");
        }   

        byte[] cmd = new byte[data.length + 2]; 
        cmd[0] = (byte) 0xA0; // MF write command
        cmd[1] = (byte) blockIndex;//这个是4
        System.arraycopy(data, 0, cmd, 2, data.length);

        transceive(cmd, false);
    }   
```

* 驱动对应的写入顺序

```
07-24 18:54:26.173   903  3890 D NxpNciX : len =   6 > 00000310A004
07-24 18:54:26.172     0     0 E nfc write: DATA:                              00000310A004
07-24 18:54:26.176   903  3890 D NxpNciX : len =  20 > 00001110C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
07-24 18:54:26.175     0     0 E nfc write: DATA:                              00001110C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0

```

# log

```
07-24 18:54:26.175   903   903 D NfccPowerTracker: NfccPowerTracker::ProcessCmd: Enter, Received len :20
07-24 18:54:26.175   903  3890 D NxpTml  : PN54X - Write requested.....
07-24 18:54:26.175   903  3890 D NxpTml  : PN54X - Invoking I2C Write.....
07-24 18:54:26.176   903  3890 D NxpNciX : len =  20 > 00001110C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
07-24 18:54:26.176   903  3890 D NxpTml  : PN54X - I2C Write successful.....
07-24 18:54:26.176   903  3890 D NxpTml  : PN54X - Posting Fresh Write message.....
07-24 18:54:26.176   903  3890 D NxpTml  : PN54X - Tml Writer Thread Running................
07-24 18:54:26.176   903  3892 D NxpHal  : write successful status = 0x0
07-24 18:54:26.176   903   903 D NfccPowerTracker: NfccPowerTracker::ProcessCmd: Enter, Received len :8
07-24 18:54:26.176   903  3890 D NxpTml  : PN54X - Write requested.....
07-24 18:54:26.176   903  3890 D NxpTml  : PN54X - Invoking I2C Write.....
07-24 18:54:26.175     0     0 E nfc write: DATA:                              00001110C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
07-24 18:54:26.176     0     0 E nfc write: DATA:                              0000051000000000
07-24 18:54:26.176     0     0 W i2c_write: irq high during write, wait
07-24 18:54:26.179     0     0 W i2c_write: irq high during write, wait
07-24 18:54:26.183     0     0 W i2c_write: irq high during write, wait
07-24 18:54:26.186     0     0 W i2c_write: irq high during write, wait
07-24 18:54:26.189     0     0 W i2c_write: irq high during write, wait
07-24 18:54:26.192   903  3890 D NxpNciX : len =   8 > 0000051000000000
07-24 18:54:26.192   903  3890 D NxpTml  : PN54X - I2C Write successful.....
07-24 18:54:26.192   903  3890 D NxpTml  : PN54X - Posting Fresh Write message.....
07-24 18:54:26.192   903  3890 D NxpTml  : PN54X - Tml Writer Thread Running................
07-24 18:54:26.192   903  3892 D NxpHal  : write successful status = 0x0
07-24 18:54:26.193   903   903 D NxpHal  : Response timer started
07-24 18:54:26.193   903   903 D NxpHal  : Waiting after ext cmd sent
07-24 18:54:26.193   903  3889 D NxpTml  : PN54X - I2C Read successful.....
07-24 18:54:26.193   903  3889 D NxpNciR : len =   6 > 600603010001
07-24 18:54:26.193   903  3889 D NxpTml  : PN54X - Posting read message.....
07-24 18:54:26.193   903  3892 D NxpHal  : read successful status = 0x0
07-24 18:54:26.193   903  3892 D NfccPowerTracker: NfccPowerTracker::ProcessNtf: Enter
07-24 18:54:26.193   903  3889 D NxpTml  : PN54X - Read requested.....
07-24 18:54:26.193   903  3889 D NxpTml  : PN54X - Invoking I2C Read.....
07-24 18:54:26.194   903  3889 E NxpTml  : Read _>>>>> Empty packet recieved !!
07-24 18:54:26.194   903  3889 D NxpTml  : PN54X - I2C Read successful.....
07-24 18:54:26.194   903  3889 D NxpNciR : len =   3 > 0A1400
07-24 18:54:26.194   903  3889 D NxpTml  : PN54X - Posting read message.....
07-24 18:54:26.194   903  3892 D NxpHal  : read successful status = 0x0
07-24 18:54:26.194   903  3889 D NxpTml  : PN54X - Read requested.....
07-24 18:54:26.194   903  3889 D NxpTml  : PN54X - Invoking I2C Read.....
07-24 18:54:26.192     0     0 W i2c_write: allow after maximum wait
07-24 18:54:26.193     0     0 E nfc nRead: CORE_CONN_CREDITS_NTF              600603010001
07-24 18:54:26.193     0     0 E nfc nRead: DATA:                              0A1400
07-24 18:54:26.198   903  3889 D NxpTml  : PN54X - I2C Read successful.....
07-24 18:54:26.198     0     0 E nfc nRead: DATA:                              008D8D600603010001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
07-24 18:54:26.199   903  3889 D NxpNciR : len = 144 > 008D8D600603010001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
07-24 18:54:26.199   903  3889 D NxpTml  : PN54X - Posting read message.....
```

# 分析

从log可以看到,最后一次的时候,报i2c_write: irq high during write, wait

最后,超过最长时间,就允许他写下去

```
if (retry_cnt == MAX_WRITE_IRQ_COUNT &&
			     gpio_get_value(nfc_gpio->irq)) {
			pr_warn("%s: allow after maximum wait\n", __func__);
		}
```

所以数据太快,芯片中断还没处理完,就继续写,导致后续读写数据都乱了,全部读取DATA 00000210B2

# 解决

把延时加大也不行,涉及到中间层有一些多线程 读写问题

* UM.9.15/hardware/nxp/nfc/pn8x/halimpl/mifare/NxpMfcReader.cc

```
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

# 结论

最后发现是,M卡的nci命令长度位,跟数据为不匹配,跟 0011_m_increment.md 这一篇文章原因一样.

修改后,就算出错了,,后面也可以重新正常.

原来是,出错了,就一直出错.