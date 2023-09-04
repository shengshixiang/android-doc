# 概要

一直知道.adb shell dumpsys battery help 等,dumpsys可以输出一系列帮忙调试信息

就adb shell dumpsys battery 展开简单流程,看看原理

# dumpsys

先看help输出,用的最多的还是adb shell dumpsys service

* adb shell dumpsys --help

```
usage: dumpsys
         To dump all services.
or:
       dumpsys [-t TIMEOUT] [--priority LEVEL] [--pid] [--thread] [--help | -l | --skip SERVICES | SERVICE [ARGS]]
         --help: shows this help
         -l: only list services, do not dump them
         -t TIMEOUT_SEC: TIMEOUT to use in seconds instead of default 10 seconds
         -T TIMEOUT_MS: TIMEOUT to use in milliseconds instead of default 10 seconds
         --pid: dump PID instead of usual dump
         --thread: dump thread usage instead of usual dump
         --proto: filter services that support dumping data in proto format. Dumps
               will be in proto format.
         --priority LEVEL: filter services based on specified priority
               LEVEL must be one of CRITICAL | HIGH | NORMAL
         --skip SERVICES: dumps all services but SERVICES (comma-separated list)
         SERVICE [ARGS]: dumps only service SERVICE, optionally passing ARGS to it
```

# dumpsys -l

可以列出可以dump的service

* adb shell dumpsys -l | grep battery

```
battery
batteryproperties
batterystats
```

* adb shell dumpsys batterystats -h

```
Battery stats (batterystats) dump options:
  [--checkin] [--proto] [--history] [--history-start] [--charged] [-c]
  [--daily] [--reset] [--write] [--new-daily] [--read-daily] [-h] [<package.name>]
  --checkin: generate output for a checkin report; will write (and clear) the
             last old completed stats when they had been reset.
  -c: write the current stats in checkin format.
  --proto: write the current aggregate stats (without history) in proto format.
  --history: show only history data.
  --history-start <num>: show only history data starting at given time offset.
  --history-create-events <num>: create <num> of battery history events.
  --charged: only output data since last charged.
  --daily: only output full daily data.
  --reset: reset the stats, clearing all current data.
  --write: force write current collected stats to disk.
  --new-daily: immediately create and write new daily stats record.
  --read-daily: read-load last written daily stats.
  --settings: dump the settings key/values related to batterystats
  --cpu: dump cpu stats for debugging purpose
  <package.name>: optional name of package to filter output by.
  -h: print this help text.
Battery stats (batterystats) commands:
  enable|disable <option>
    Enable or disable a running option.  Option state is not saved across boots.
    Options are:
      full-history: include additional detailed events in battery history:
          wake_lock_in, alarms and proc events
      no-auto-reset: don't automatically reset stats when unplugged
      pretend-screen-off: pretend the screen is off, even if screen state changes
```

# adb shell dumpsys battery -help

分析实现原理

* QSSI.12/frameworks/native/cmds/dumpsys/Android.bp

dumpsys_vendor 没有编译

```
cc_binary {
    name: "dumpsys",

    defaults: ["dumpsys_defaults"],

    srcs: [
        "main.cpp",
    ],  
}

cc_binary {
    name: "dumpsys_vendor",
    stem: "dumpsys",

    vendor: true,

    defaults: ["dumpsys_defaults"],

    srcs: [
        "main.cpp",
    ],
```

* QSSI.12/frameworks/native/cmds/dumpsys/main.cpp

```
int main(int argc, char* const argv[]) {
    signal(SIGPIPE, SIG_IGN);
    sp<IServiceManager> sm = defaultServiceManager();
    fflush(stdout);
    if (sm == nullptr) {
        ALOGE("Unable to get default service manager!");
        std::cerr << "dumpsys: Unable to get default service manager!" << std::endl;
        return 20; 
    }   

    Dumpsys dumpsys(sm.get());
    return dumpsys.main(argc, argv);
}
```

* QSSI.12/frameworks/native/cmds/dumpsys/dumpsys.cpp

```
int Dumpsys::main(int argc, char* const argv[]) {
    static struct option longOptions[] = {{"thread", no_argument, 0, 0}, 
                                          {"pid", no_argument, 0, 0}, 
                                          {"priority", required_argument, 0, 0}, 
                                          {"proto", no_argument, 0, 0}, 
                                          {"skip", no_argument, 0, 0}, 
                                          {"help", no_argument, 0, 0}, 
                                          {0, 0, 0, 0}};

    switch (c) {
            case 0:
                break;
            case 'l':
            showListOnly = true;
            break;
            case 't':
                break;
            default:
                fprintf(stderr, "\n");
                usage();
                return -1;
            }
    }

    if (services.empty() || showListOnly) {
        services = listServices(priorityFlags, asProto);
        setServiceArgs(args, asProto, priorityFlags);
    }

    for (size_t i = 0; i < N; i++) {
        const String16& serviceName = services[i];
        if (IsSkipped(skippedServices, serviceName)) continue;

        if (startDumpThread(type, serviceName, args) == OK) {
        }
    }
}
```

```
status_t Dumpsys::startDumpThread(Type type, const String16& serviceName,
                                  const Vector<String16>& args) {
    sp<IBinder> service = sm_->checkService(serviceName);
    if (service == nullptr) {
        std::cerr << "Can't find service: " << serviceName << std::endl;
        return NAME_NOT_FOUND;
    }

    int sfd[2];
    if (pipe(sfd) != 0) {
        std::cerr << "Failed to create pipe to dump service info for " << serviceName << ": "
             << strerror(errno) << std::endl;
        return -errno;
    }

    redirectFd_ = unique_fd(sfd[0]);
    unique_fd remote_end(sfd[1]);
    sfd[0] = sfd[1] = -1;
    // dump blocks until completion, so spawn a thread..
    activeThread_ = std::thread([=, remote_end{std::move(remote_end)}]() mutable {
        status_t err = 0;

        switch (type) {
        case Type::DUMP:
            err = service->dump(remote_end.get(), args);
            break;
        case Type::PID:
            err = dumpPidToFd(service, remote_end);
            break;
        case Type::THREAD:
            err = dumpThreadsToFd(service, remote_end);
            break;
        default:
            std::cerr << "Unknown dump type" << static_cast<int>(type) << std::endl;
            return;
        }

        if (err != OK) {
            std::cerr << "Error dumping service info status_t: " << statusToString(err) << " "
                 << serviceName << std::endl;
        }
    });
    return OK;
}
```

* 重点备注下,service->dump 就调用到对应的service dump了

# BatteryService

* QSSI.12/frameworks/base/services/core/java/com/android/server/BatteryService.java

这个service创建的时候,publishBinderService battery,所以 dumpsys battery就找到他了

```
public void onStart() {
        registerHealthCallback();

        mBinderService = new BinderService();
        publishBinderService("battery", mBinderService);
        mBatteryPropertiesRegistrar = new BatteryPropertiesRegistrar();
        publishBinderService("batteryproperties", mBatteryPropertiesRegistrar);
        publishLocalService(BatteryManagerInternal.class, new LocalService());
    }    
```

```
private final class BinderService extends Binder {
        @Override protected void dump(FileDescriptor fd, PrintWriter pw, String[] args) {
            if (!DumpUtils.checkDumpPermission(mContext, TAG, pw)) return;

            if (args.length > 0 && "--proto".equals(args[0])) {
                dumpProto(fd);
            } else {
                dumpInternal(fd, pw, args);
            }
        }

        @Override public void onShellCommand(FileDescriptor in, FileDescriptor out,
                FileDescriptor err, String[] args, ShellCallback callback,
                ResultReceiver resultReceiver) {
            (new Shell()).exec(this, in, out, err, args, callback, resultReceiver);
        }
    }
```

* 所以,上面的service->dump 就走到了 BinderService 的 dump函数

```
private void dumpInternal(FileDescriptor fd, PrintWriter pw, String[] args) {
        synchronized (mLock) {
            if (args == null || args.length == 0 || "-a".equals(args[0])) {
                pw.println("Current Battery Service state:");
                if (mUpdatesStopped) {
                    pw.println("  (UPDATES STOPPED -- use 'reset' to restart)");
                }
                pw.println("  AC powered: " + mHealthInfo.chargerAcOnline);
                pw.println("  USB powered: " + mHealthInfo.chargerUsbOnline);
                pw.println("  Wireless powered: " + mHealthInfo.chargerWirelessOnline);
                pw.println("  Max charging current: " + mHealthInfo.maxChargingCurrent);
                pw.println("  Max charging voltage: " + mHealthInfo.maxChargingVoltage);
                pw.println("  Charge counter: " + mHealthInfo.batteryChargeCounter);
                pw.println("  status: " + mHealthInfo.batteryStatus);
                pw.println("  health: " + mHealthInfo.batteryHealth);
                pw.println("  present: " + mHealthInfo.batteryPresent);
                pw.println("  level: " + mHealthInfo.batteryLevel);
                pw.println("  scale: " + BATTERY_SCALE);
                pw.println("  voltage: " + mHealthInfo.batteryVoltage);
                pw.println("  temperature: " + mHealthInfo.batteryTemperature);
                pw.println("  technology: " + mHealthInfo.batteryTechnology);
            } else {
                Shell shell = new Shell();
                shell.exec(mBinderService, null, fd, null, args, null, new ResultReceiver(null));
            }
        }
    }
```

* 如果没有加参数,只有adb shell dumpsys battery, 就打印上面列出的一堆pw.println,如果有参数,就执行shell.exec

```
class Shell extends ShellCommand {
        @Override
        public int onCommand(String cmd) {
            return onShellCommand(this, cmd);
        }

        @Override
        public void onHelp() {
            PrintWriter pw = getOutPrintWriter();
            dumpHelp(pw);
        }
    }
```

然后就执行 onShellCommand

* adb shell dumpsys battery -h

    就调用 onHelp()

* adb shell dumpsys battery unplug

就调如下,最终调用unplugBattery

```
int onShellCommand(Shell shell, String cmd) {
        if (cmd == null) {
            return shell.handleDefaultCommands(cmd);
        }
        PrintWriter pw = shell.getOutPrintWriter();
        switch (cmd) {
            case "unplug": {
                int opts = parseOptions(shell);
                getContext().enforceCallingOrSelfPermission(
                        android.Manifest.permission.DEVICE_POWER, null);
                unplugBattery(/* forceUpdate= */ (opts & OPTION_FORCE_UPDATE) != 0, pw);
            } break;

            default:
                return shell.handleDefaultCommands(cmd);
        }
        return 0;
    }
```

```
private void unplugBattery(boolean forceUpdate, PrintWriter pw) {
        if (!mUpdatesStopped) {
            copy(mLastHealthInfo, mHealthInfo);
        }
        mHealthInfo.chargerAcOnline = false;
        mHealthInfo.chargerUsbOnline = false;
        mHealthInfo.chargerWirelessOnline = false;
        mUpdatesStopped = true;
        Binder.withCleanCallingIdentity(() -> processValuesLocked(forceUpdate, pw));
    }
```