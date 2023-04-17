# AIDL

根据package/apps/Nfc的例子,再次分析一下aidl的应用

# 流程

## QSSI.12/packages/apps/Nfc/src/com/android/nfc/NfcService.java

* 生成 nfc服务

根据以下代码,就生成了一个 名字为nfc的server端服务,本质是实现了INfcAdapter.aidl里面的接口

```
public static final String SERVICE_NAME = "nfc";
public class NfcService implements DeviceHostListener {
    NfcAdapterService mNfcAdapter;
    mNfcAdapter = new NfcAdapterService();
    ServiceManager.addService(SERVICE_NAME, mNfcAdapter);
}

final class NfcAdapterService extends INfcAdapter.Stub {
    有一个 getNfcAdapterVendorInterface 的实现
            @Override
        public IBinder getNfcAdapterVendorInterface(String vendor) {
            if(vendor.equalsIgnoreCase("nxp")) {
                return (IBinder) mNxpNfcAdapter;
            } else {
                return null;
            }
        }
}

QSSI.12/frameworks/base/core/java/android/nfc/INfcAdapter.aidl
```

* 在nfc服务基础上,新建了一个nxp的vendor的具体实现

```
mNxpNfcAdapter = new NxpNfcAdapterService();
final class NxpNfcAdapterService extends INxpNfcAdapter.Stub {
    public int doWriteT4tData(byte[] fileId, byte[] data, int length) {
        }

        @Override
        public byte[] doReadT4tData(byte[] fileId) {
        }
}
```

* nxp的T4TDemo apk回调doWriteT4tData

    * T4TFromNfccReaderWriter.java 获取一个 默认的 android NfcAdapter

        ```
        this.mNfcAdapter = NfcAdapter.getDefaultAdapter(cntx);
        this.mNxpNfcAdapter = NxpNfcAdapter.getNxpNfcAdapter(mNfcAdapter);
        ```
    
    * 用默认的NfcAdapter 去获取mNxpNfcAdapter,NxpNfcAdapter.java

        ```
        public static synchronized NxpNfcAdapter getNxpNfcAdapter(NfcAdapter adapter) {
 60         if (!sIsInitialized) {
 61             if (adapter == null) {
 62                 Log.v(TAG, "could not find NFC support");
 63                 throw new UnsupportedOperationException();
 64             }
 65             sService = getServiceInterface();
                //获取nfc服务, 也就是packages/apps/Nfc/src/com/android/nfc/NfcService.java,ServiceManager.addService(SERVICE_NAME, mNfcAdapter);
                //IBinder b = ServiceManager.getService("nfc");

 70             sNxpService = getNxpNfcAdapterInterface();
                //通过nfc服务,获取nxp的adapter,IBinder b = sService.getNfcAdapterVendorInterface("nxp");
                //getNfcAdapterVendorInterface 这个就是 final class NfcAdapterService extends INfcAdapter.Stub {  的aidl回调接口

 75             sIsInitialized = true;
 76         }
 77         nxpAdapter = new NxpNfcAdapter();//new 了一个自己,NxpNfcAdapter.java

 82         return nxpAdapter;
 83     }
        ```

    * T4TFromNfccReaderWriter.java, 调用  mNxpNfcAdapter.doWriteT4tData(fileId, bytes, bytes.length);

        ```
        NxpNfcAdapter.java
        public int doWriteT4tData(byte[] fileId, byte[] data, int length) {
        try {
            return sNxpService.doWriteT4tData(fileId, data, length);
            //回调final class NxpNfcAdapterService extends INxpNfcAdapter.Stub {}的aidl接口
        } catch (RemoteException e) {
            e.printStackTrace();
            attemptDeadServiceRecovery(e);
            return -1; 
        }   
        }   
        ```

# 总结

* 实现一个服务,ServiceManager.addService(SERVICE_NAME, mNfcAdapter);

* 服务要实现aidl的接口

* 获取sService = ServiceManager.getService("nfc");服务

* 然后就是回调aidl的接口sService.getNfcAdapterVendorInterface("nxp");

* 获得 mNxpNfcAdapter 的aidl 接口 final class NxpNfcAdapterService extends INxpNfcAdapter.Stub {}

* 使用mNxpNfcAdapter 回调 aidl的接口 doWriteT4tData

* 所以这里涉及到两次aidl的调用

```
QSSI.12/frameworks/base/core/java/android/nfc/INfcAdapter.aidl
interface INfcAdapter
{
    IBinder getNfcAdapterVendorInterface(in String vendor);
}
```

```
QSSI.12/vendor/nxp/frameworks/com/nxp/nfc/INxpNfcAdapter.aidl
package com.nxp.nfc;

/**
 * @hide
 */
interface INxpNfcAdapter
{
    int doWriteT4tData(in byte[] fileId, in byte[] data, int length);
    byte[] doReadT4tData(in byte[] fileId);
}
```