# README

ftest 煲机

# 煲机时长

* A6650 默认3000分钟,50个小时,超过就不煲机

* if (!batteryS.isAcPlug() && !batteryS.isUsbPlug() && batteryS.capacity <= offlevel) {

    * 符合这个条件也是不煲机