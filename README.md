##操作：


With the app running, from the Simulator’s menu bar at the top of the screen, choose Debug → Location → Apple.


##结果

didUpdateLocations <+马赛克,-马赛克> +/- 5.00m (speed 0.00 mps / course -1.00) @ 10/29/16, 11:00:07 PM China Standard Time

##解释说明

This is the accuracy of the measurement, expressed in meters. What you see is the Simulator imitating what happens when you ask for a location on a real device.

>模拟器中这是模仿正式设备定位的功能

定位的三种方式：

- Cell tower triangulation 基站定位，只要有信号就能定位，但是不会太准
、。
- Wi-Fi 定位 好一些，局限就是附近要有wifi路由器，它是利用无线网络设备的分布数据

- 最好的方法当然是gps定位，要和卫星通信所以要慢一点


##补充说明

有些设备是没有GPS功能，只能用wifi来定位

coreloaction 获取位置之后立即给你个结果，然后后面慢慢变精确

iOS 有一个看门狗当你的app半天没有响应，在某种环境下，看门狗会无情的杀死你的app

