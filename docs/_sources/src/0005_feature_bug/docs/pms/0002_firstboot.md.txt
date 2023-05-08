# android 第一次启动标记

有些工作需要判断是否第一次启动,/data/system/packages.xml

# PackageManagerService.java

```
@Override
public boolean isFirstBoot() {
    // allow instant applications
    return mFirstBoot;
}
```

```
public PackageManagerService(Injector injector, boolean onlyCore, boolean factoryTest,
            final String buildFingerprint, final boolean isEngBuild,
            final boolean isUserDebugBuild, final int sdkVersion, final String incrementalVersion) {
    t.traceBegin("read user settings");
    mFirstBoot = !mSettings.readLPw(mInjector.getUserManagerInternal().getUsers(
            /* excludePartial= */ true,
            /* excludeDying= */ false,
            /* excludePreCreated= */ false));
    t.traceEnd();
}
```

* frameworks\base\services\core\java\com\android\server\pm\Settings.java

```
 mSettingsFilename = new File(mSystemDir, "packages.xml");
 boolean readLPw(@NonNull List<UserInfo> users) {
        FileInputStream str = null;
        if (mBackupSettingsFilename.exists()) {
            try {
                str = new FileInputStream(mBackupSettingsFilename);
                mReadMessages.append("Reading from backup settings file\n");
                PackageManagerService.reportSettingsProblem(Log.INFO,
                        "Need to read from backup settings file");
                if (mSettingsFilename.exists()) {
                    // If both the backup and settings file exist, we
                    // ignore the settings since it might have been
                    // corrupted.
                    Slog.w(PackageManagerService.TAG, "Cleaning up settings file "
                            + mSettingsFilename);
                    mSettingsFilename.delete();
                }
            } catch (java.io.IOException e) {
                // We'll try for the normal settings file.
            }
        }
```