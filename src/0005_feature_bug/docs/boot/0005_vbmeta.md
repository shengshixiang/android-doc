# avbtool

本文调试 介绍avbtool 命令使用

# vbmeta 拆解命令

* ./QSSI.12/external/avb/avbtool info_image --image A6650_emmc_download_images/vbmeta.img

Minimum libavb version:   1.0
Header Block:             256 bytes
Authentication Block:     576 bytes
Auxiliary Block:          3584 bytes
Public key (sha1):        2597c218aae470a130f61162feaae70afd97f011
Algorithm:                SHA256_RSA4096
Rollback Index:           0
Flags:                    0
Rollback Index Location:  0
Release String:           'avbtool 1.2.0'
Descriptors:
    Chain Partition descriptor:
      Partition Name:          vbmeta_system
      Rollback Index Location: 2
      Public key (sha1):       cdbb77177f731920bbe0a0f94f84d9038ae0617d
    Prop: com.android.build.vendor.fingerprint -> 'PAX/bengal/bengal:11/RKQ1.220116.001/pax04062014:userdebug/release-keys'
    Prop: com.android.build.vendor.os_version -> '11'
    Prop: com.android.build.vendor.security_patch -> '2022-01-01'
    Prop: com.android.build.vendor.security_patch -> '2022-01-01'
    Prop: com.android.build.recovery.fingerprint -> 'PAX/bengal/bengal:11/RKQ1.220116.001/pax04062014:userdebug/release-keys'
    Prop: com.android.build.boot.fingerprint -> 'PAX/bengal/bengal:11/RKQ1.220116.001/pax04062014:userdebug/release-keys'
    Prop: com.android.build.boot.os_version -> '11'
    Prop: com.android.build.boot.security_patch -> '2022-01-01'
    Prop: com.android.build.boot.security_patch -> '2022-01-01'
    Prop: com.android.build.dtbo.fingerprint -> 'PAX/bengal/bengal:11/RKQ1.220116.001/pax04062014:userdebug/release-keys'
    Hash descriptor:
      Image Size:            18812928 bytes
      Hash Algorithm:        sha256
      Partition Name:        boot
      Salt:                  0c423e900bacfe7fcc947cdf5bb0e6d1da939e885efac59ae348caffbdff6677
      Digest:                5d7f0e284baa4cca5247bce1c339c9485d9c545d67b91dc33631cefc8d652f05
      Flags:                 0
    Hash descriptor:
      Image Size:            405203 bytes
      Hash Algorithm:        sha256
      Partition Name:        dtbo
      Salt:                  75d654631007b3b18d5ddf6a0f7a0cc36212628f457c8ebdfe012c43b660abc5
      Digest:                96669b267768bdf4ab1ac933c61f0427bd22534f08a7cdf982c9a653b2d05957
      Flags:                 0
    Hash descriptor:
      Image Size:            26640384 bytes
      Hash Algorithm:        sha256
      Partition Name:        recovery
      Salt:                  534b1ca0db362cf23d65a1f30f7e2b05292bf47756c17a941b643d195dff51eb
      Digest:                53c5bf32286dfa2425e68cfbaa9360d7c0897a6dc7f108205a9687a23b0e41f4
      Flags:                 0
    Hashtree descriptor:
      Version of dm-verity:  1
      Image Size:            633401344 bytes
      Tree Offset:           633401344
      Tree Size:             4997120 bytes
      Data Block Size:       4096 bytes
      Hash Block Size:       4096 bytes
      FEC num roots:         2
      FEC offset:            638398464
      FEC size:              5054464 bytes
      Hash Algorithm:        sha1
      Partition Name:        vendor
      Salt:                  ccad6a9441546c3d184660a6461e0c9c014c7801a883ccfd37361bdb70798e84
      Root Digest:           893110f3b8faaad49228406538fc6df34236e6da
      Flags:                 0

* ./QSSI.12/external/avb/avbtool info_image --image A6650_emmc_download_images/vbmeta_system.img

Minimum libavb version:   1.0
Header Block:             256 bytes
Authentication Block:     320 bytes
Auxiliary Block:          2432 bytes
Public key (sha1):        cdbb77177f731920bbe0a0f94f84d9038ae0617d
Algorithm:                SHA256_RSA2048
Rollback Index:           1675209600
Flags:                    0
Rollback Index Location:  0
Release String:           'avbtool 1.2.0'
Descriptors:
    Prop: com.android.build.system_ext.fingerprint -> 'qti/qssi/qssi:12/SKQ1.220119.001/pax04061829:userdebug/release-keys'
    Prop: com.android.build.system_ext.os_version -> '12'
    Prop: com.android.build.system_ext.security_patch -> '2023-02-01'
    Prop: com.android.build.product.fingerprint -> 'qti/qssi/qssi:12/SKQ1.220119.001/pax04061829:userdebug/release-keys'
    Prop: com.android.build.product.os_version -> '12'
    Prop: com.android.build.product.security_patch -> '2023-02-01'
    Prop: com.android.build.product.security_patch -> '2023-02-01'
    Prop: com.android.build.system.fingerprint -> 'qti/qssi/qssi:12/SKQ1.220119.001/pax04061829:userdebug/release-keys'
    Prop: com.android.build.system.os_version -> '12'
    Prop: com.android.build.system.security_patch -> '2023-02-01'
    Prop: com.android.build.system.security_patch -> '2023-02-01'
    Hashtree descriptor:
      Version of dm-verity:  1
      Image Size:            1190277120 bytes
      Tree Offset:           1190277120
      Tree Size:             9379840 bytes
      Data Block Size:       4096 bytes
      Hash Block Size:       4096 bytes
      FEC num roots:         2
      FEC offset:            1199656960
      FEC size:              9486336 bytes
      Hash Algorithm:        sha256
      Partition Name:        product
      Salt:                  15cc879075dea1e3516d424641c79fa169460b9863b2b784702b8130368ee4fe
      Root Digest:           0fa6057276a3fb4236a189b01f0ce20e7aac5b71bea35c65bb418fd600e0553d
      Flags:                 0
    Hashtree descriptor:
      Version of dm-verity:  1
      Image Size:            1201618944 bytes
      Tree Offset:           1201618944
      Tree Size:             9465856 bytes
      Data Block Size:       4096 bytes
      Hash Block Size:       4096 bytes
      FEC num roots:         2
      FEC offset:            1211084800
      FEC size:              9576448 bytes
      Hash Algorithm:        sha256
      Partition Name:        system
      Salt:                  25de0caae5d850e89c86fcf490ecefd2a8eea9633da6371ec4931257955fc8dc
      Root Digest:           9bbf77b08e6c6cb298b35a695e55b0bef3644bdcc18866c7668abaf402719a8f
      Flags:                 0
    Hashtree descriptor:
      Version of dm-verity:  1
      Image Size:            571621376 bytes
      Tree Offset:           571621376
      Tree Size:             4509696 bytes
      Data Block Size:       4096 bytes
      Hash Block Size:       4096 bytes
      FEC num roots:         2
      FEC offset:            576131072
      FEC size:              4554752 bytes
      Hash Algorithm:        sha256
      Partition Name:        system_ext
      Salt:                  15cc879075dea1e3516d424641c79fa169460b9863b2b784702b8130368ee4fe
      Root Digest:           e8d4d095beaca5c7fbee2e5084760beeedd406e7233ac29c681d01d005572790
      Flags:                 0

* ./QSSI.12/external/avb/avbtool -h

usage: avbtool [-h]
               {generate_test_image,version,extract_public_key,make_vbmeta_image,add_hash_footer,append_vbmeta_image,add_hashtree_footer,erase_footer,zero_hashtree,extract_vbmeta_image,resize_image,info_image,verify_image,print_partition_digests,calculate_vbmeta_digest,calculate_kernel_cmdline,set_ab_metadata,make_atx_certificate,make_atx_permanent_attributes,make_atx_metadata,make_atx_unlock_credential}
               ...

optional arguments:
  -h, --help            show this help message and exit

subcommands:
  {generate_test_image,version,extract_public_key,make_vbmeta_image,add_hash_footer,append_vbmeta_image,add_hashtree_footer,erase_footer,zero_hashtree,extract_vbmeta_image,resize_image,info_image,verify_image,print_partition_digests,calculate_vbmeta_digest,calculate_kernel_cmdline,set_ab_metadata,make_atx_certificate,make_atx_permanent_attributes,make_atx_metadata,make_atx_unlock_credential}
    generate_test_image
                        Generates a test image with a known pattern for
                        testing: 0x00 0x01 0x02 ... 0xff 0x00 0x01 ...
    version             Prints version of avbtool.
    extract_public_key  Extract public key.
    make_vbmeta_image   Makes a vbmeta image.
    add_hash_footer     Add hashes and footer to image.
    append_vbmeta_image
                        Append vbmeta image to image.
    add_hashtree_footer
                        Add hashtree and footer to image.
    erase_footer        Erase footer from an image.
    zero_hashtree       Zero out hashtree and FEC data.
    extract_vbmeta_image
                        Extracts vbmeta from an image with a footer.
    resize_image        Resize image with a footer.
    info_image          Show information about vbmeta or footer.
    verify_image        Verify an image.
    print_partition_digests
                        Prints partition digests.
    calculate_vbmeta_digest
                        Calculate vbmeta digest.
    calculate_kernel_cmdline
                        Calculate kernel cmdline.
    set_ab_metadata     Set A/B metadata.
    make_atx_certificate
                        Create an Android Things eXtension (ATX) certificate.
    make_atx_permanent_attributes
                        Create Android Things eXtension (ATX) permanent
                        attributes.
    make_atx_metadata   Create Android Things eXtension (ATX) metadata.
    make_atx_unlock_credential
                        Create an Android Things eXtension (ATX) unlock
                        credential.

* ./QSSI.12/external/avb/avbtool append_vbmeta_image -h

xielx@u295:~/ssdCode/a6650_1$ ./QSSI.12/external/avb/avbtool append_vbmeta_image -h
usage: avbtool append_vbmeta_image [-h] [--image IMAGE] --partition_size
                                   PARTITION_SIZE
                                   [--vbmeta_image VBMETA_IMAGE]

optional arguments:
  -h, --help            show this help message and exit
  --image IMAGE         Image to append vbmeta blob to
  --partition_size PARTITION_SIZE
                        Partition size
  --vbmeta_image VBMETA_IMAGE
                        Image with vbmeta blob to append
