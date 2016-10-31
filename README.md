程序有一个bug

你只在精度提高的时候才更新一下

模拟器的debug 下 有 run city 选项


计算当前定位和最近定位之间的距离。

如果之前没有定位，那就把这个距离设置成很大的数据

```

var distance = CLLocationDistance(DBL_MAX) 
if let location = location {
    distance = newLocation.distanceFromLocation(location)
}

```



即使这个时候正在reserve geocoding 中，强制执行最后一次定位的reserve geocoding 工作。

```
    if distance > 0 {
                    performingReverseGeocoding = false
                }

```

如你在一个地方呆了很就，那就不要再定位了

```
    if timeInterval > 10 {
    print("*** Force done!")
    stopLocationManager()
    updateLabels()
    configureGetButton()
    
}
```