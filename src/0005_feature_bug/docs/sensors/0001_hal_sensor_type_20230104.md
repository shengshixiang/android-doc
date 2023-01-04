# README

高通平台,see sensor 架构 去掉 某一类型sensor type,例如陀螺仪 gyro

# 背景

硬件qmi8658c 性能不达标,fifo丢数据, gms cts sensor,vts sensor测试不过

# 解决方法

* 换性能达标的芯片,qmi8658a

* 软件关闭陀螺仪

# gms 测试case

* hasGyroscope 要等于 false

* sensor = null

```
    sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
177         boolean hasGyroscope = getContext().getPackageManager().hasSystemFeature(
178                 PackageManager.FEATURE_SENSOR_GYROSCOPE);
179         // gyroscope sensor is optional
180         if (hasGyroscope) {
181             assertNotNull(sensor);
182             assertEquals(Sensor.TYPE_GYROSCOPE, sensor.getType());
183             assertSensorValues(sensor);
184         } else {
185             assertNull(sensor);
186         }
```

# 关闭陀螺仪方法

## 关闭feature

* hasSystemFeature FEATURE_SENSOR_GYROSCOPE 需要返回false
    > 不要把android.hardware.sensor.gyroscope.xml 预置进入系统

* getDefaultSensor TYPE_GYROSCOPE 要返回null
    > 由于vts也要测试sensor,所以要从hal层根本性去掉
    > 在hal层获取,available sensor列表的时候,把陀螺仪相关类型去掉

    ```
    +++ b/UM.9.15/vendor/qcom/proprietary/sensors-see/sensors-hal-2.0/framework/sensor_factory.cpp
    @@ -389,6 +389,13 @@ vector<unique_ptr<sensor>> sensor_factory::get_all_available_sensors() const
    continue;
    }
    sns_logd("type=%d, num_sensors=%u", item.first, (unsigned int)sensors.size());
    +//[feature]-add-begin xielianxiong@paxsz.com,20230103,for skip gyro ,gms
    +        if(SENSOR_TYPE_GYROSCOPE == item.first ||
    +           SENSOR_TYPE_GYROSCOPE_UNCALIBRATED == item.first){
    +            sns_loge("skip %d,victorSensor,for gms",item.first);
    +            continue;
    +        }
    +//[feature]-add-end xielianxiong@paxsz.com,20230103,for skip gyro ,gms
    for (auto&& s : sensors) {
    ```