# README

paydroidtester 	WriteReadISOCertificate_FUN2 用例测试失败

paydroidtester 到 系统PaxDeviceManager.java 的aidl 跨进程调用在另外一篇文章分析.

不在此展开.

# verifyPaxImageByName_v2 安装 TCPTest_sign.apk 验签失败

## 失败log

verifyPaxImageByName_v2 /data/app/vmdl53617826.tmp/base.apk Fail! [ret=2]

## 验签调用流程

* paydroidtester 调用 pdm.update(mode, path);

    ```
    IPaxDeviceManager pdm = getPDMBinder();
                if (pdm != null) {
                    try {
                        int ret = pdm.update(mode, path);
    ```

    ```
    protected static IPaxDeviceManager getPDMBinder() {
        IBinder binder = ServiceManager.getService("DeviceManagerService");
        return binder == null ? null : com.paxdroid.os.IPaxDeviceManager.Stub.asInterface(binder);
    }
    ```

* PaxDeviceManagerService.java 调用 update方法

    ```
    public int update(int mode, String source) throws RemoteException {
        Plog.s(TAG, "remote["+PkgParser.getProcessNameByPid(Binder.getCallingPid())+"] calling update()");
        if (!(mode == 0 || mode == 1 || mode == 2)) {
            Log.w(TAG, "update mode = "+mode+" not supported!");
            return -1;
        }    
        // Check permission
        if (checkUpdatePermission(mode, Binder.getCallingPid(), Binder.getCallingUid()) == PackageManager.PERMISSION_DENIED) {
            Log.e(TAG, "Permission Denied for pid="+Binder.getCallingPid()+", uid="+Binder.getCallingUid()+" to call update(int, String)!");
            return UPDATE_PERMISSION_DENIED;
        }    
        Log.w(TAG, "===== In update ===== --> mode="+mode+", source="+source);
        Plog.s(TAG, "===== In update ===== --> mode="+mode+", source="+source);
        int result = -1;
        synchronized(mUpdateLock) {
            IOsManagerUtil osmanager = IOsManagerUtil.Stub.asInterface(ServiceManager.getService("OsManagerUtil"));
            if (osmanager != null) {
                try {
                    result = osmanager.update(mode, source);
                } catch (RemoteException e) { 
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }    
            }    
        }    
        Log.w(TAG, "===== Out update ===== --> result="+result);
        Plog.s(TAG, "===== Out update ===== --> result="+result);
        return result;
    }
    ```

* OsManagerUtil.java 调用 update 方法

    ```
   public int update(int mode, String what) {
        enforceCallingPermission("update", true);
        Log.w(TAG, "update ---> mode = "+mode+", what = "+what);
        OsManager osManager = new OsManager(mContext);
        return osManager.mOsUpdate.update(mode, what);
    }   
    ```

* OsManager.java 获取 mOsUpdate

    ```
    public OsManager(Context context) {
        mContext = context;
        mOsManagerConfig = MainApplication.mPaxGlobalManagerSvr.mAppAllConfig.mOsManagerConfig;
        mOsUpdate = MainApplication.mPaxGlobalManagerSvr.mGlobFuns.mOsUpdate;
    }   
    ```

* MainApplication.java 获取 mPaxGlobalManagerSvr

    ```
    public void onCreate() {
        super.onCreate();
        mContext = getApplicationContext();
        pref = getSharedPreferences(PRE_PACKAGE_NAME, Context.MODE_APPEND);


        mPaxGlobalManagerSvr = PlatFormFactory.getGlobalManagerSvr();
        PlatFormFactory.initConfig(mPaxGlobalManagerSvr);
        mPaxGlobalManagerSvr.initDevice(mContext);
        UiHandler.initHandler();
    }   
    ```

* PlatFormFactory.java 获取 getGlobalManagerSvr

    ```
    public static PaxBaseGlobalManagerSvr getGlobalManagerSvr(){
        PaxBaseGlobalManagerSvr mPaxBaseGlobalManagerSvr = null;
        String series = getSeries();
        if(series.equals("ASeries")){
            Log.d(TAG,"ASeriesGlobalManagerSvr");
            mPaxBaseGlobalManagerSvr = new ASeriesGlobalManagerSvr();
        }else if(series.equals("ESeries")){
            mPaxBaseGlobalManagerSvr = new ESeriesGlobalManagerSvr();
        }else if(series.equals("PDA")){
            mPaxBaseGlobalManagerSvr = new PDAGlobalManagerSvr();
        }else if(series.equals("ATM")){
            mPaxBaseGlobalManagerSvr = new ATMGlobalManagerSvr();
        }else{
            mPaxBaseGlobalManagerSvr = new DefaultGlobalManagerSvr();
        }   
        return mPaxBaseGlobalManagerSvr;
    }   
    ```

* ASeriesGlobalManagerSvr.java 获取 mGlobFuns

    ```
    public class ASeriesGlobalManagerSvr extends PaxBaseGlobalManagerSvr
    ```

* PaxBaseGlobalManagerSvr.java 获取 mGlobFuns

    ```
    public abstract class PaxBaseGlobalManagerSvr {
    public abstract void initDevice(Context mContext);
    public AppAllConfig mAppAllConfig = new AppAllConfig();
    public PaxBaseManager mGlobFuns;
    ```

* PlatFormFactory.java 赋值 mGlobFuns

    MainApplication.java oncreate,有吊用 PlatFormFactory.initConfig(mPaxGlobalManagerSvr);

    ```
    public static  void initConfig(PaxBaseGlobalManagerSvr mPaxBaseGlobalManagerSvr){
       PaxBaseManager mPaxBaseManager = null;
//       String model = SystemProperties.get("ro.platform.model", "");
       if(mPaxBaseGlobalManagerSvr instanceof ASeriesGlobalManagerSvr){
               mPaxBaseManager = new ASeriesManager();
       }else if(mPaxBaseGlobalManagerSvr instanceof ESeriesGlobalManagerSvr){
           if ("Gemini".equals(SystemProperties.get("ro.platform.name", ""))) {
               mPaxBaseManager = new ESeriesGeminiManager();
           } else {
               mPaxBaseManager = new ESeriesManager();
           }   
       }else if(mPaxBaseGlobalManagerSvr instanceof PDAGlobalManagerSvr){
           mPaxBaseManager = new PDAManager();
       }    
       else if(mPaxBaseGlobalManagerSvr instanceof ATMGlobalManagerSvr){
           mPaxBaseManager = new ATMManager();
       }else{
           mPaxBaseManager = new DefaultManager();
       }   
       if(mPaxBaseManager != null){
           mPaxBaseManager.initConfig(mPaxBaseGlobalManagerSvr.mAppAllConfig);
           //打印配置清单信息
           Log.d(TAG, mPaxBaseGlobalManagerSvr.mAppAllConfig.toString());
           mPaxBaseGlobalManagerSvr.mGlobFuns = mPaxBaseManager;
       }   
    ```

* ASeriesManager.java 获取 mOsUpdate

    ```
    public void initConfig(AppAllConfig mAppAllConfig) {
        // TODO Auto-generated method stub
        DEVICE_INFO mDevice_INFO = DevUtils.getDeviceInfo();
        // 硬扫码通过SDLGui去调用，这里不需要启动扫描服务
        //if(mDevice_INFO.isFWSupport== 1 &&  mDevice_INFO.isScannerHwSupport == 1)
        //    MainApplication.mPaxGlobalManagerSvr.mAppAllConfig.startScannerManagerService = true;
        {   
            // A系列默认是支持底座的
            mAppAllConfig.mNetWorkManagerConfig.supportBaseDeviceStatusService = true;
            mAppAllConfig.mNetWorkManagerConfig.supportenAbleConnectdev = true;
            mAppAllConfig.mNetWorkManagerConfig.supportstartPaxNetWorkService = true;
            mAppAllConfig.mNetWorkManagerConfig.mNetWokrServiceConfig.supportWiFiProbeService = true;
        }   

        String model = SystemProperties.get("ro.platform.model", "");
        if(model.equals("A920C")){
            mOsUpdate = new A920QOsUpdate(MainApplication.getContext());
        } else if (model.equals("A35") || model.equals("AF5") || model.equals("A35F")
                || model.equals("A80") || model.equals("A8300")) {
            mOsUpdate = new A35OsUpdate(MainApplication.getContext());
        //[FEATURE]-Add-BEGIN by songzhihao@paxsz.com, 2022/11/01 ,for A8700/L1400 update.
        } else if (model.equals("A8700") || model.equals("L1450")){
            mOsUpdate = new A8700OsUpdate(MainApplication.getContext());
        //[FEATURE]-Add-END by songzhihao@paxsz.com, 2022/11/01 ,for A8700/L1400 update.
        } else{
            //提供一个默认初始化
            mOsUpdate = new DefaultOsUpdate(MainApplication.getContext());
        }   
    ```

* 使用默认的DefaultOsUpdate, 调用 update 函数

    ```
    public class DefaultOsUpdate extends OsUpdate {
    ```

* OsUpdate.java 调用 update 函数

    ```
    public int update (int mode, String source) {
        if (mode == UPDATE_MODE_APP) {
            return updateApp(source);
        } else if (mode == UPDATE_MODE_UNINSTALL_APP) {
            return uninstallApp(source);
        } else {
            // By default, update firmware
            if ((source == null) || (source.equals(""))){
                Log.e(TAG, "update source error!");
                int ret = UPDATE_RESULT_UNKNOWN_ERR;
                if (mode == UPDATE_MODE_FIRMWARE){
                    setUpdateResult(ret);
                }
                return ret;
            }
            setUpdateState(UPDATE_STATE_START);
            return doUpdateFirmware(source);
        }
    }
    ```

    ```
    public int updateApp(String apkPath) {
        PackageMgr mPackageMgr = new PackageMgr(mContext);
        int ret =  mPackageMgr.installPackage(new File(apkPath));
        if (ret >= 0)
            return 0;
        else
            return ret;
    }
    ```

* PackageMgr.java 调用 installPackage

    ```
    public int installPackage(File apkFilePath) {
        return mPackageMgrCompat.installPackage(apkFilePath);
    }   
    ```

* QSSI.12/paxdroid/packages/PaxOsManager/compat/android-v28-later/PackageMgrCompat.java 调用 installPackage

    ```
    public int installPackage(File apkFilePath) {
        Log.w(TAG, "installPackage pkg: " + apkFilePath);
        int installResult = PackageManager.INSTALL_FAILED_INVALID_APK;

        PackageInstaller.SessionParams params = new PackageInstaller.SessionParams(
                PackageInstaller.SessionParams.MODE_FULL_INSTALL);

        PackageInstaller.Session session = null;
        // 创建一个Session
        try {
            int sessionId = getPi().createSession(params);
            // 建立和PackageManager的socket通道，Android中的通信不仅仅有Binder还有很多其它的
            session = getPi().openSession(sessionId);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return PackageManager.INSTALL_FAILED_INVALID_APK;
        }   
        addApkToInstallSession(apkFilePath, session);
        final LocalIntentReceiver localReceiver = new LocalIntentReceiver();
        session.commit(localReceiver.getIntentSender());
        final Intent result = localReceiver.getResult();
        synchronized (localReceiver) {
            final int status = result.getIntExtra(PackageInstaller.EXTRA_STATUS,
                    PackageInstaller.STATUS_FAILURE);
            int legacyStatus = result.getIntExtra(PackageInstaller.EXTRA_LEGACY_STATUS, 0); 
            if (session != null) {
                session.close();
            }   
            installResult = legacyStatus;
            if (installResult == PackageManager.INSTALL_SUCCEEDED) {
                Log.w(TAG, "installPackage " + apkFilePath + " Success [" + installResult + "]");
            } else {
                Log.w(TAG, "installPackage " + apkFilePath + " Failure [" + installResult + "]");
            }
        }
        return installResult;
    }
    ```

* PackageManagerService.java 调用安装验签,

    ```
        //[FEATURE]-Add-BEGIN by (xielianxiong@paxsz.com), 2021/12/29 for apk verify pax signature
        String paxSp = SystemProperties.get("ro.fac.cfg.SP_MCU","");
        if ("yes".equals(SystemProperties.get(PaxProperties.PROPERTY_PAXDROID_DEBUG))||
            paxSp.equals("")){}
        else{
            /**
            * Package Verification Routine
            */
            String tmpPackagePath = null;
            if (android.os.Build.VERSION.SDK_INT >= 22) {
                tmpPackagePath = args.getCodePath() + "/base.apk";
            } else {
                tmpPackagePath = args.getCodePath();
            }

            String packageUriPath = args.origin.file.getAbsolutePath();
            int verifyReturnCode = PaxCustomerManager.packageVerifyRoutineAtInstallR(tmpPackagePath,
                            packageUriPath,parsedPackage.getPackageName(), parsedPackage.getSharedUserId());
            Slog.w(TAG, "packageVerifyRoutineAtInstall verify "+parsedPackage.getPackageName()+
                    ((verifyReturnCode == PackageManager.INSTALL_SUCCEEDED) ? " OK!" : " Fail!"));
            if (verifyReturnCode != PackageManager.INSTALL_SUCCEEDED) {
                res.returnCode = verifyReturnCode;
                throw new PrepareFailure(verifyReturnCode,"Apk verify pax signature failed!");
            }else
                res.returnCode = PackageManager.INSTALL_SUCCEEDED; // Don't forget to set returnCode
        }
        //[FEATURE]-Add-BEGIN by (xielianxiong@paxsz.com), 2021/12/29 for apk verify pax signature
    ```

* PaxCustomerManager 调用 packageVerifyRoutineAtInstallR

    ```
    Log.w(TAG, "Install: isPosTriggered="+PaxSecurity.isPosTriggered()+", BootLevel="+PaxSecurity.getPosAuthBootLevel());
    boolean isVendorFirmPukVerifyNeeded = true;
    int verifyReturnCode = PackageManager.INSTALL_FAILED_INVALID_APK;

    if (!PaxSecurity.isPosTriggered() || PaxSecurity.getPosAuthBootLevel() == 0) {
        if (PaxSecurity.getPosAuthSecMode() == 0 && PaxSecurity.getPosAuthBootLevel() > 0) {
            isVendorFirmPukVerifyNeeded = true;
        } else {
            verifyReturnCode = customerVerifyPackage(packageCodePath, packageUriPath, pkg);
            if (verifyReturnCode != PackageManager.INSTALL_SUCCEEDED) {
                isVendorFirmPukVerifyNeeded = true;
            } else {
                isVendorFirmPukVerifyNeeded = false;
                // TODO: to avoid APK getting system permission by sharing SystemUid if needed. {
                if (sharedUserId != null && "android.uid.system".equals(sharedUserId) &&
                    isForbiddingSharedSystemUid(packageName, packageCodePath)) {
                    Log.e(TAG, "Forbidding non-paxsz package "+packageName+" sharing system uid !!!");
                    return PackageManager.INSTALL_FAILED_SHARED_USER_INCOMPATIBLE;
                }
                // }

                return PackageManager.INSTALL_SUCCEEDED;
            }
    ```

## 失败原因

本地的机器getPosAuthSecMode = 0,所以变成isVendorFirmPukVerifyNeeded = true;

需要固件签名TCPTest_sign.apk,才能安装成功

换一台机器,SecMode 授权成L2 = 3后, TCPTest_sign.apk 顺利安装成功

```
01-30 06:49:52.268  2549  2585 W Util    : have v1 signature
01-30 06:49:52.269  2549  2585 D CustomerPaxsz: traditionnal verify
01-30 06:49:52.270  1003  1170 D systool_server: FUNC(svr_paxVerifyAppByName)
01-30 06:49:52.270  1003  1170 W paxsec  : VerifyPaxAppByName /data/app/vmdl1504529421.tmp/base.apk
paxsec  : VerifyPaxAppByName /data/app/vmdl1504529421.tmp/base.apk OK! [ret=0]
```

# tripe_signature_test.apk 安装失败,vmdl424555044.tmp

## 失败log

缺少aapt

```
01-30 06:50:09.475  2549  2585 W System.err: java.io.IOException: Cannot run program "aapt": error=2, No such file or directory
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.ProcessBuilder.start(ProcessBuilder.java:1050)
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.Runtime.exec(Runtime.java:694)
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.Runtime.exec(Runtime.java:524)
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.Runtime.exec(Runtime.java:421)
01-30 06:50:09.476  2549  2585 W System.err: 	at com.paxdroid.verify.util.Util.exeCmd(Util.java:67)
01-30 06:50:09.476  2549  2585 W System.err: 	at com.paxdroid.verify.customer.PaxCertVerify.prepareFiles(PaxCertVerify.java:113)
01-30 06:50:09.476  2549  2585 W System.err: 	at com.paxdroid.verify.customer.PaxCertVerify.realVerify(PaxCertVerify.java:50)
01-30 06:50:09.476  2549  2585 W System.err: 	at com.paxdroid.verify.customer.CustomerPaxCert.verifyPackage(CustomerPaxCert.java:12)
01-30 06:50:09.476  2549  2585 W System.err: 	at com.paxdroid.verify.customer.CustomerPaxsz.verifyPackage(CustomerPaxsz.java:80)
01-30 06:50:09.476  2549  2585 W System.err: 	at com.paxdroid.verify.PkgVerifier.verifyPackage(PkgVerifier.java:46)
01-30 06:50:09.476  2549  2585 W System.err: 	at com.paxdroid.verify.IPkgVerifier$Stub.onTransact(IPkgVerifier.java:128)
01-30 06:50:09.476  2549  2585 W System.err: 	at android.os.Binder.execTransactInternal(Binder.java:1179)
01-30 06:50:09.476  2549  2585 W System.err: 	at android.os.Binder.execTransact(Binder.java:1143)
01-30 06:50:09.476  2549  2585 W System.err: Caused by: java.io.IOException: error=2, No such file or directory
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.UNIXProcess.forkAndExec(Native Method)
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.UNIXProcess.<init>(UNIXProcess.java:133)
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.ProcessImpl.start(ProcessImpl.java:141)
01-30 06:50:09.476  2549  2585 W System.err: 	at java.lang.ProcessBuilder.start(ProcessBuilder.java:1029)
01-30 06:50:09.476  2549  2585 W System.err: 	... 12 more
```

## 调用流程

接着上面第一次的调用流程

* PaxCustomerManager.java 调用 customerVerifyPackage

    ```
    public static int customerVerifyPackage(String packagePath, String packageUriPath, PackageParser.Package pkg) {
        Log.w(TAG, "customerVerifyPackage " + packagePath + " ("+packageUriPath+") "+" for "+getCustomerName());
        mCustomer = getCustomerInstance(mContext);
        int retCode = mCustomer.verifyPackage(packagePath, packageUriPath, pkg);
        mCustomer.handleVerifyFinish();
        return retCode;
    }
    ```

* 因为目前是paxsz customer,所以 调用 paxdroid/frameworks/base/core/java/com/paxdroid/customer/CustomerPaxsz.java 的 verifyPackage

    ```
    public int verifyPackage(String packagePath, String packageUriPath, PackageParser.Package pkg) {
        return verifyPkgByService(packagePath, packageUriPath);
    }
    ```

* 调用 PaxPackageMgr.java 的 verifyPkgByService

    ```
    public static int verifyPkgByService(String packagePath, String packageUriPath) {
        IPkgVerifier pkgVerifier = IPkgVerifier.Stub.asInterface(ServiceManager.getService("PkgVerifyService"));
        // wait for PkgVerifyService for a while
        int timeout = 20;       // 20 s
        while (pkgVerifier == null) {
            Log.w(TAG, "waitting for PkgVerifyService...");
            try {
                Thread.sleep(1000);
                timeout--;
            } catch (InterruptedException e) {
                e.printStackTrace();
            }   
            if (timeout < 0) {
                Log.e(TAG, "wait for PkgVerifyService timeout...");
                return PackageManager.INSTALL_FAILED_VERIFICATION_TIMEOUT;
            }   
            pkgVerifier = IPkgVerifier.Stub.asInterface(ServiceManager.getService("PkgVerifyService"));
        }   

        if (pkgVerifier != null) {
            try {
                return pkgVerifier.verifyPackage(packagePath, packageUriPath);
            } catch (RemoteException e) {
                e.printStackTrace();
            }   
        }   
        return PackageManager.INSTALL_PARSE_FAILED_INCONSISTENT_CERTIFICATES;
    }   
    ```

* 调用 PkgVerifier.java 的 verifyPackage

    ```
    public int verifyPackage(String packagePath, String packageUriPath) {
        Log.w(TAG, "verifyPackage packagePath="+packagePath+", packageUriPath="+packageUriPath);
        mCustomer = CustomerBase.getCustomerInstance();
        if (mCustomer != null) {
            int ret = mCustomer.verifyPackage(packagePath, packageUriPath);
            handleVerifyFinished();
            return ret;
        }   
        return PackageManager.INSTALL_PARSE_FAILED_INCONSISTENT_CERTIFICATES;
    }   
    ```

* 调用 QSSI.12/paxdroid/packages/PkgVerifyService/src/com/paxdroid/verify/customer/CustomerPaxsz.java 的  verifyPackage

    ```
    public int verifyPackage(String packagePath, String packageUriPath) {
        if (!Util.haveV1Signature(packagePath)) {//log have v1 signature,return true
            if (PaxV2Verify.parseSign(packagePath)) {
                Log.w(TAG, "pax v2 parse success");
                if (PaxV2Verify.realVerifyForApp() == 0) {
                    return PackageManager.INSTALL_SUCCEEDED;
                }   
            } else {
                Log.w(TAG, "pax v2 parse fail");
            }   
            return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
        }   

        if ((!ISOSignature.ISOCertExists()) && (hasTraditionalSign(packagePath))) {//hasTraditionalSign return false,没有固件签名
            Log.d(TAG, "traditionnal verify");
            if (PaxSecurity.verifyApk(packagePath) == 0) {
                if (PackageSignerChecker.isSupportPkgSignChecker()) {
                    PackageSignerChecker.recordPackageSigner(packagePath);
                }   
                return PackageManager.INSTALL_SUCCEEDED;
            } else {
                Log.e(TAG, "verifyPackage: "+packagePath+" INSTALL_FAILED_VERIFICATION_FAILURE");
                return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
            }   
        } else {
            // try new signature
            Log.d(TAG, "certificate verify");
            CustomerPaxCert paxCert = new CustomerPaxCert();
            return paxCert.verifyPackage(packagePath, packageUriPath);
        }   
    }   
    ```

* 调用 CustomerPaxCert.java 的 verifyPackage

    ```
    public int verifyPackage(String pkgPath, String pkgUriPath) {
        if (!Util.checkZipEoCD(pkgPath)) {//An APK file: EoCD found,return true
            return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
        }   
        int result = new PaxCertVerify().realVerify(pkgPath, pkgUriPath);
        Util.handleVerifyFinish("/tmp");
        return result;
    }
    ```

* 调用 PaxCertVerify 的 realVerify

    ```
    public int realVerify(String packagePath, String packageUriPath) {
        String certcaPath = null;
        File newCert = new File(PAXCERT_NEW_CERT_PATH);
        if (newCert.exists()) {
            certcaPath = PAXCERT_NEW_CERT_PATH;
        } else {
            certcaPath = PaxCustomerManager.getDefaultCert();
        }   
        Log.w(TAG, "certcaPath = " + certcaPath);// certcaPath = null
        try {
            Log.w(TAG, "apk path=" + packagePath);//data/app/vmdl424555044.tmp/base.apk
            backupFile(packagePath);
            boolean verifyFlag = false;
            Certificate cert = null;

            if (!prepareFiles()){//这里出错,没有aapt,但是不是 导致安装失败的原因
                return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
            }   

            byte[] signData = ByteConverter.fileToByteArray(APKSIGN_FILE_PATH);//这个没有权限是导致失败原因,
            PaxCertParser p = new PaxCertParser();
            int parseSignResult = p.parse(signData);
            Log.w(TAG, "paxsz parse sign result = " + parseSignResult);

            if (parseSignResult == 1) {
                boolean certificateOK = false;
                if (ISOSignature.ISOCertExists()) {
                    // check ISO signature first
                    if (ISOSignature.checkISOSignature(BACKUP_APK_PATH, ISOSIGN_FILE_PATH)
                        == PackageManager.INSTALL_SUCCEEDED) {
                        Log.w(TAG, "check ISO signature OK!");
                    } else {
                        Log.w(TAG, "check ISO signature FAIL!");
                        return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
                    }
                }
                PublicKey usPuk = paxPuk2RSAPublicKey();
                if (usPuk != null) {
                    cert = DigitalCertificate.getCertificateInstance(p.appCert);
                    if (RSAUtil.verifyCertByPublicKey(cert, usPuk)) {
                        certificateOK = true;
                    }
                }
                Log.w(TAG, "Use PublicKey to verify WorkCert: "+certificateOK);
                if (certificateOK) {
                    PublicKey pbk = cert.getPublicKey();
                    verifyFlag = Util.checkSig(BACKUP_APK_PATH, p.signData, pbk);
                    Log.w(TAG, "WorkCert verify sign: " + verifyFlag);
                }
                if (!verifyFlag) {
                    return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
                }
            } else {
                return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return PackageManager.INSTALL_FAILED_VERIFICATION_FAILURE;
        }

        return PackageManager.INSTALL_SUCCEEDED;
    }
    ```

    ```
    private boolean prepareFiles() {
        Util.exeCmd(CMD_BACKUP_APKSIGN);//miniunz -o /tmp/whole.apk META-INF/APKSIGNV1.SGN -d /tmp
        Util.exeCmd(CMD_BACKUP_ISOSIGN);//miniunz -o /tmp/whole.apk META-INF/ISOSIGNV1.SGN -d /tmp
        Util.exeCmd(CMD_REMOVE_APKSIGN_FILE);//aapt r /tmp/whole.apk  META-INF/APKSIGNV1.SGN
        Util.exeCmd(CMD_REMOVE_ISOSIGN_FILE);//aapt r /tmp/whole.apk  META-INF/ISOSIGNV1.SGN
        File file = new File(APKSIGN_FILE_PATH);
        return file.exists();   // at least 'APKSIGNV1.SGN' should exist.
    }
    ```

    ```
    type=1400 audit(0.0:48025): avc: denied { map } for path="/pax/tmp/META-INF/APKSIGNV1.SGN" dev="mmcblk0p82" ino=25609 scontext=u:r:system_app:s0 tcontext=u:object_r:cache_file:s0 tclass=file permissive=0
    ```

## 修改方法

```
+++ b/QSSI.12/vendor/paxsz/sepolicy/public/system_app.te
@@ -27,3 +27,4 @@ allow system_app SettingsManagerService_service:service_manager      { add find
 allow system_app shell_data_file:dir { search };
 allow system_app shell_data_file:file { read open map };
 allow system_app PaxScannerService_service:service_manager { add };
+allow system_app cache_file:file { create read write open setattr getattr map unlink };
```
