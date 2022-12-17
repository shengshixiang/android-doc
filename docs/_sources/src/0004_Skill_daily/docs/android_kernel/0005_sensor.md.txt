# 高通捉取see架构sensor 初始化log

## 安装qxdm工具

* 高通工具，不能外发

## 加初始化 读固件id log

```
void qmi8658_get_chip_info(void)
{
 unsigned char revision_id = 0x00;
 unsigned char firmware_id[3];
 unsigned char uuid[6];
 unsigned int uuid_low, uuid_high;

 qmi8658_read_reg(Qmi8658Register_Revision, &revision_id, 1);
 qmi8658_read_reg(Qmi8658Register_firmware_id, firmware_id, 3);
 qmi8658_read_reg(Qmi8658Register_uuid, uuid, 6);
 uuid_low = (unsigned int)((unsigned int)(uuid[2]<<16)|(unsigned int)(uuid[1]<<8)|(uuid[0]));
 uuid_high = (unsigned int)((unsigned int)(uuid[5]<<16)|(unsigned int)(uuid[4]<<8)|(uuid[3]));
 //qmi8658_log("VS ID[0x%x]\n", revision_id);
 qmi8658_log("*FW ID[%d %d %d] Revision;0x%x\n", firmware_id[2], firmware_id[1],firmware_id[0],revision_id);
 qmi8658_log("*UUID[0x%x %x]\n", uuid_high ,uuid_low);
}
```