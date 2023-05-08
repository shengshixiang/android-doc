# Luancher隐藏某一个应用

有时候,需要应用安装,但是不希望应用显示在桌面上

# 修改方法,基于Android 12

* QSSI.12/packages/apps/Launcher3/res/values/config.xml

```
+	<string-array name="filtered_apps" >
+		<item>com.android.vending</item>
+	</string-array>
```

* QSSI.12/packages/apps/Launcher3/src/com/android/launcher3/model/LoaderTask.java

```
 import java.util.Map;
 import java.util.Set;
 import java.util.concurrent.CancellationException;
+import java.util.Arrays;
+import android.os.SystemProperties;
+import com.android.launcher3.R;
 
 /**
  * Runnable for the thread that loads the contents of the launcher:
@@ -922,10 +927,19 @@ public class LoaderTask implements Runnable {
             final List<LauncherActivityInfo> apps = mLauncherApps.getActivityList(null, user);
             ArrayList<Pair<ItemInfo, Object>> added = new ArrayList<>();
             ArrayList<Pair<ItemInfo, Object>> addedLast = new ArrayList<>();
+			String[] filterApps = context.getResources().getStringArray(R.array.filtered_apps);
             synchronized (this) {
                 for (LauncherActivityInfo app : apps) {
                     ItemInstallQueue.PendingInstallShortcutInfo pendingInstallShortcutInfo =
                         new ItemInstallQueue.PendingInstallShortcutInfo(app.getComponentName().getPackageName(), user);
+
+					if ("A6650".equals(SystemProperties.get("ro.platform.model")) && Arrays.asList(filterApps).contains(app.getComponentName().getPackageName())) {
+						continue;
+					}
                     if (mApp.getModel().needSortApp(app)) {
                         addedLast.add(pendingInstallShortcutInfo.getItemInfo(context));
                         continue;
```

* QSSI.12/packages/apps/Launcher3/src/com/android/launcher3/model/PackageUpdatedTask.java

```
 import java.util.HashMap;
 import java.util.HashSet;
 import java.util.List;
+import java.util.Arrays;
+import android.os.SystemProperties;
+import com.android.launcher3.R;
 
 /**
  * Handles updates due to changes in package manager (app installed/updated/removed)
@@ -380,11 +385,18 @@ public class PackageUpdatedTask extends BaseModelUpdateTask {
         ArrayList<ItemInstallQueue.PendingInstallShortcutInfo> added
         = new ArrayList<ItemInstallQueue.PendingInstallShortcutInfo>();
         final LauncherApps launcherApps = context.getSystemService(LauncherApps.class);
-
+		String[] filterApps = context.getResources().getStringArray(R.array.filtered_apps);
         for (UserHandle user : profiles) {
             final List<LauncherActivityInfo> apps = launcherApps.getActivityList(null, user);
             synchronized (this) {
                 for (LauncherActivityInfo info : apps) {
+					if ("A6650".equals(SystemProperties.get("ro.platform.model")) && Arrays.asList(filterApps).contains(info.getComponentName().getPackageName())) {
+						continue;
+					}
                     for (AppInfo appInfo : appsList.data) {
                         if(info.getComponentName().equals(appInfo.componentName)) {
                             ItemInstallQueue.PendingInstallShortcutInfo mPendingInstallShortcutInfo
-- 
```