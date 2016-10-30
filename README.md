##接下来要做得优化：

The problem is that you can’t always get the accuracy you want, so you have to detect this. When the last couple of coordinates you received aren’t increasing in accuracy then this is probably as good as it’s going to get and you should let the radio power down.

当你最后一次定位没有提高精度，那么你还是关了它吧。



1 如果地址是好早之前获取的，比如5秒钟之前，这就是所谓的缓存。这个的假设就是你和最近的定位之间没有多少移动。
当隔得太久的话，那就忽略之前的定位信息。

2. 为了检测新数值是否比之前的精度高 ，你需要用到location 对象的 horizontalAccuracy 属性
但是有些时候，一些location对象的这个属性比0要小，这种情况你需要忽略他们。

3 然后就是处理精度确实提高了的情况
  通常来说后面来的精度会比之前的越来越高，但是不能保证每一个后面的定位精度都比之前的定位精度要高。

需要说明的是精度数据越大，说明越不精确。

Note that a larger accuracy value means less accurate – after all, accurate up to 100 meters is worse than accurate up to 10 meters. That’s why you check whether the previous reading, location!.horizontalAccuracy, is greater than the new reading, newLocation.horizontalAccuracy.
You also check for location == nil. Recall that location is the optional instance variable that stores the CLLocation object that you obtained in a previous call to “didUpdateLocations”. If location is nil then this is the very first location update you’re receiving and in that case you should also continue.
So if this is the very first location reading (location is nil) or the new location is more accurate than the previous reading, you go on.
4. You’ve seen this before. It clears out any previous error if there was one and stores the new location object into the location variable.
5. If the new location’s accuracy is equal to or better than the desired accuracy, you can call it a day and stop asking the location manager for updates. When you started the location manager in startLocationManager(), you set the desired accuracy to 10 meters (kCLLocationAccuracyNearestTenMeters), which is good enough for this app.
