# 概要

工程同事反馈,工厂生产,时区配置成纽约,但是会自动变成中国上海

# 关键字

时区

# 步骤

* pax_adb.exe systool set timezone America/New_York

* 重启

* pax_adb.exe systool get sysver

    发现时区是中国上海

# log

```
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider: Into the callback
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider callback messageID 36
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider: Into the callback
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider callback messageID 36
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider: Into the callback
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider callback messageID 36
[2023-09-19 04:35:08].662 D/qcc-trd ( 1133): setqdmaConnectivityData MCC-460 MNC-11
[2023-09-19 04:35:08].662 D/qcc-trd ( 1133): ==================== campaign_mgr_check_for_camp_management ====================
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider new mCC-460 new mNC-11
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider: Into the callback
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider callback messageID 36
[2023-09-19 04:35:08].662 D/qcc-trd ( 1133): setqdmaConnectivityData MCC-0 MNC-0
[2023-09-19 04:35:08].662 D/qcc-trd ( 1133): ==================== campaign_mgr_check_for_camp_management ====================
[2023-09-19 04:35:08].662 D/qcc-trd ( 1133): setRoamingData Roaming-0
[2023-09-19 04:35:08].662 D/qcc-trd ( 1133): ==================== campaign_mgr_check_for_camp_management ====================
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider Registration state is not REGISTERED
[2023-09-19 04:35:08].662 I/qcc-trd ( 1133): qdmaConnectivityInfoProvider setting mcc=0, mnc=0 and roaming=0
[2023-09-19 04:35:09].033 D/OsAgent ( 2946): [string_dataitem_update][2980] [HC] =>> [HS]
[2023-09-19 04:35:09].034 V/LocSvc_HIDL_IzatSubscription(  621): [stringDataItemUpdate][283] [HS] <<<<= [HC]
[2023-09-19 04:35:09].036 D/XDivertUtility( 2296):  isAllSubActive false
[2023-09-19 04:35:09].036 D/XDivertUtility( 2296): getXDivertStatus status = false
[2023-09-19 04:35:09].037 D/MultiSimSettingController( 2206): notifySubscriptionInfoChanged
[2023-09-19 04:35:09].063 D/WifiService( 1318): Country code changed to :cn
[2023-09-19 04:35:09].063 D/WifiCountryCode( 1318): Set telephony country code to: cn
[2023-09-19 04:35:09].063 D/WifiCountryCode( 1318): skip update supplicant not ready yet
[2023-09-19 04:35:09].107 I/Telephony( 2206): TelecomAccountRegistry: onSubscriptionsChanged - reregister accounts
[2023-09-19 04:35:09].108 D/Telephony( 2206): isEmergencyPreferredAccount: subId=-1, activeData=-1
[2023-09-19 04:35:09].108 D/Telephony( 2206): isEmergencyPreferredAccount: Device does not require preference.
[2023-09-19 04:35:09].109 I/Telephony( 2206): isRttCurrentlySupported -- emergency acct and no device support
[2023-09-19 04:35:09].110 I/Telephony( 2206): reRegisterPstnPhoneAccount: subId: -1 - no change
[2023-09-19 04:35:09].110 D/MultiSimSettingController( 2206): onSubscriptionsChanged
[2023-09-19 04:35:09].110 D/MultiSimSettingController( 2206): isReadyToReevaluate: subInfoInitialized=true, carrierConfigsLoaded=true
[2023-09-19 04:35:09].110 D/MultiSimSettingController( 2206): updateDefaults
[2023-09-19 04:35:09].110 D/MultiSimSettingController( 2206): isReadyToReevaluate: subInfoInitialized=true, carrierConfigsLoaded=true
[2023-09-19 04:35:09].112 D/MultiSimSettingController( 2206): [updateDefaultValues] No active sub. Setting default to INVALID sub.
[2023-09-19 04:35:09].127 D/MultiSimSettingController( 2206): isReadyToReevaluate: subInfoInitialized=true, carrierConfigsLoaded=true
[2023-09-19 04:35:09].132 W/OsPaxApiInternal( 1318): current timezone: America/New_York , 2023-09-19 04:35:09
[2023-09-19 04:35:09].132 I/Telephony( 2206): Locale change; re-registering phone accounts.
[2023-09-19 04:35:09].132 D/Telephony( 2206): Unregistering: Handler (com.qualcomm.qti.internal.telephony.QtiGsmCdmaPhone) {691ae54}
[2023-09-19 04:35:09].132 I/Telephony( 2206): TelecomAccountRegistry: setupAccounts: Found 2 phones.  Attempting to register.
[2023-09-19 04:35:09].132 I/Telephony( 2206): setupAccounts: Phone with subscription id: -1 slotId: 0
[2023-09-19 04:35:09].133 D/Telephony( 2206): TelecomAccountRegistry: setupAccounts: skipping invalid subid -1
[2023-09-19 04:35:09].133 I/Telephony( 2206): setupAccounts: Phone with subscription id: -1 slotId: 1
[2023-09-19 04:35:09].133 D/Telephony( 2206): TelecomAccountRegistry: setupAccounts: skipping invalid subid -1
[2023-09-19 04:35:09].133 I/Telephony( 2206): setupAccounts: adding default
[2023-09-19 04:35:09].133 D/PhoneUtils( 2206): Logical Modem id: 0 phoneId: 0
[2023-09-19 04:35:09].133 D/PhoneUtils( 2206): Primay Stack phone id: 0 selected
[2023-09-19 04:35:09].135 W/OsPaxApiInternal( 1318): new timezone: Asia/Shanghai , 2023-09-19 16:35:09
```

# 总结

* 跟esim没关,没有esim的机器也会出现

* 打开飞行模式不会,执行网络相关,wifi可能也有关系

* 猜测可能是手机搜到附近小区网络(类似于紧急呼叫,没有sim卡也能拨打),然后把国家码配置成中国,Country code changed to :cn

    导致时区变成中国上海

# 解决方法

* 把自动时区关闭