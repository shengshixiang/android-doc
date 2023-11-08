# 添加验签vbmeta功能

由于目前的android系统,保证了vbmeta的安全,就保证了android 其他固件的安全(不包括xbl,abl,等,这些是使用fuse签名验签的).

但是由于直接替换原生系统的密钥对,并且公司的私钥又要不开源,所以比较复杂,所以还不如尝试在vbmeta尾巴添加签名数据来保证安全.

在abl阶段添加代码去验签vbmeta.

# 分析原生vbmeta验签

原生的abl在avb_slot_verify.c会对vbmeta 还有vbmeta_system做一些处理,所以只要在对应地方,加上pax的验签就可以了.

* UM.9.15/bootable/bootloader/edk2/QcomModulePkg/Library/avb/libavb/avb_slot_verify.c

```
static AvbSlotVerifyResult load_and_verify_vbmeta(
    AvbOps* ops,
    const char* const* requested_partitions,
    const char* ab_suffix,
    AvbSlotVerifyFlags flags,
    bool allow_verification_error,
    AvbVBMetaImageFlags toplevel_vbmeta_flags,
    int rollback_index_location,
    const char* partition_name,
    size_t partition_name_len,
    const uint8_t* expected_public_key,
    size_t expected_public_key_length,
    AvbSlotVerifyData* slot_data,
    AvbAlgorithmType* out_algorithm_type) {
  char full_partition_name[PART_NAME_MAX_SIZE];
  AvbSlotVerifyResult ret;
  AvbIOResult io_ret;

  vbmeta_ret =
      avb_vbmeta_image_verify(vbmeta_buf, vbmeta_num_read, &pk_data, &pk_len);

//[feature]-add-begin starmenxie@hotmail.com,20230531 for runtime verify vbmeta
  DEBUG((EFI_D_ERROR, "verify %a pax sign begin,\n",partition_name));
  if((Avb_StrnCmp(partition_name, "vbmeta", avb_strlen("vbmeta")) == 0 ) ||
   (Avb_StrnCmp(partition_name, "vbmeta_system", avb_strlen("vbmeta_system")) == 0 )){
      int vbmeta_realsize ;
      uint8_t* p ;
      int i = 0 ;
      int find = 0;
      unsigned char flag[SIGN_FLAG_LENGTH] = SIGN_FLAG;
      for(vbmeta_realsize = 0,p = vbmeta_buf;vbmeta_realsize < VBMETA_MAX_SIZE - SIGN_FLAG_LENGTH + 1 ;vbmeta_realsize++,p++){
        if(i == SIGN_FLAG_LENGTH) {
            find = 1;
            break;
        }
        if(*p == 0) {
            i = 0;
            continue;
        }
        if(*p == flag[i]){
            i++; 
        }    
        else{
            i = 0; 
        }    
      }

      if(find != 1 || verify_pax_image(vbmeta_buf,vbmeta_realsize,0)){
        vbmeta_ret = AVB_VBMETA_VERIFY_RESULT_OK_NOT_SIGNED;
        DEBUG((EFI_D_ERROR, "verify %a pax sign error,find = %d,\n",partition_name,find));
      }else{
        DEBUG((EFI_D_ERROR, "verify %a pax sign ok,\n",partition_name));
      }
  }
//[feature]-add-begin starmenxie@hotmail.com,20230531 for runtime verify vbmeta

  switch (vbmeta_ret) {
    case AVB_VBMETA_VERIFY_RESULT_OK:
      avb_assert(pk_data != NULL && pk_len > 0);
      break;

    case AVB_VBMETA_VERIFY_RESULT_OK_NOT_SIGNED:
    case AVB_VBMETA_VERIFY_RESULT_HASH_MISMATCH:
    case AVB_VBMETA_VERIFY_RESULT_SIGNATURE_MISMATCH:
      ret = AVB_SLOT_VERIFY_RESULT_ERROR_VERIFICATION;
      avb_errorv(full_partition_name,
                 ": Error verifying vbmeta image: ",
                 avb_vbmeta_verify_result_to_string(vbmeta_ret),
                 "\n",
                 NULL);
      if (!allow_verification_error) {
        goto out;
      }
      break;

    }
```

# 需要注意的地方

* vbmeta跟vbmeta system是固定64KB,编译出来远远不够64KB,所以直接在vbmeta 末尾添加公司的签名数据,是可以的

* 原生读取的vbmeta 的头,有对应的地址偏移等信息,所以对vbmeta末尾追加数据是没有问题的

* 另外一点,如果刷入了带末尾签名的vbmeta, 再刷入同一个不带签名的vbmeta,这时候验签是可以通过的,因为第一把刷入带签名数据的vbmeta,签名信息还保留在分区里面,没有被第二次刷入的vbmeta所覆盖.意思是fastboot flash 只会刷入对应大小,不会对超过的数据做处理