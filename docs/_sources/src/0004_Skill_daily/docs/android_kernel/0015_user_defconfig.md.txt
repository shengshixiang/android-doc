# 高通编译user,defconfig会变,merge

# device/qcom/kernelscripts/buildkernel.sh

* debugfs_disable()
```
debugfs_disable()
{
    if [ ${TARGET_BUILD_VARIANT} == "user" ]; then
        echo "combining fragments for user build"
        (cd ${KERNEL_DIR} && \
        ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} \
        ./scripts/kconfig/merge_config.sh ./arch/${ARCH}/configs/$DEFCONFIG ./arch/$ARCH/configs/vendor/debugfs.config
        ${MAKE_PATH}make ${MAKE_ARGS} HOSTCFLAGS="${TARGET_INCLUDES}" HOSTLDFLAGS="${TARGET_LINCLUDES}" ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} savedefconfig
        mv defconfig ./arch/${ARCH}/configs/$DEFCONFIG
        ${MAKE_PATH}make mrproper)
    else
        if [[ ${DEFCONFIG} == *"perf_defconfig" ]]; then
        echo "resetting perf defconfig"
        (cd ${KERNEL_DIR} && \
        git checkout arch/$ARCH/configs/$DEFCONFIG)
        fi  
    fi  
}
```

# UM.9.15/kernel/msm-4.19/scripts/kconfig/merge_config.sh

* echo "Value requested for $CFG not in final .config"

```
Value requested for CONFIG_REGMAP_ALLOW_WRITE_DEBUGFS not in final .config
Requested value:  CONFIG_REGMAP_ALLOW_WRITE_DEBUGFS=y
Actual value:     
```
