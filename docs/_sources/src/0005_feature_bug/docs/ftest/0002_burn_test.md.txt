# README

ftest 煲机

# 煲机时长

* A6650 默认3000分钟,50个小时,超过就不煲机

* if (!batteryS.isAcPlug() && !batteryS.isUsbPlug() && batteryS.capacity <= offlevel) {

    * 符合这个条件也是不煲机

# 查看煲机结果

## adb pull /data/data/com.pax.ft baoji

* BAOJI0.txt,里面有记录煲机到第几项,还有时间标记

    ![0002_0001](images/0002_0001.png)

* com.pax.ft_preferences.xml 有煲机的一些信息

    ![0002_0002](images/0002_0002.png)