# 涂鸦智能照明标准控制 iOS SDK 接入指南

[中文版](README-zh.md) | [English](README.md)

#### 功能概述

涂鸦智能照明iOS SDK是在TuyaSmartDevice基础上扩展了接入照明设备相关功能的接口封装，加速开发过程。主要包括了以下功能：

* 获取当前设备是几路灯
* 获取灯所有功能点的值
* 开灯或关灯
* 切换工作模式
* 控制灯的亮度
* 控制灯的色温
* 切换场景模式
* 设置彩灯的颜色

#### 快速集成

### 使用 CocoaPods 集成

在 `Podfile` 文件中添加以下内容：

```ruby
platform :ios, '9.0'

target 'your_target_name' do

   pod 'TuyaSmartLightKit', :git => 'https://github.com/TuyaInc/tuyasmart_lighting_ios_sdk.git'
```

然后在项目根目录下执行 `pod update` 命令，集成第三方库。

CocoaPods 的使用请参考：[CocoaPods Guides](https://guides.cocoapods.org/)

#### 初始化SDK

1. 打开项目设置，Target => General，修改`Bundle Identifier`为涂鸦开发者平台对应的iOS包名
2. 导入安全图片到工程根目录，重命名为`t_s.bmp`，并加入「项目设置 => Target => Build Phases => Copy Bundle Resources」中。
3. 在项目的`PrefixHeader.pch`文件添加以下内容：

```
#import <TuyaSmartLightKit/TuyaSmartLightKit.h>
```

Swift 项目可以添加在 `xxx_Bridging-Header.h` 桥接文件中添加以下内容

```
#import <TuyaSmartLightKit/TuyaSmartLightKit.h>
```

1. 打开`AppDelegate.m`文件，在`[AppDelegate application:didFinishLaunchingWithOptions:]`方法中初始化SDK：

Objc:

```
[[TuyaSmartSDK sharedInstance] startWithAppKey:<#your_app_key#> secretKey:<#your_secret_key#>];
```

Swift:

```
TuyaSmartSDK.sharedInstance()?.start(withAppKey: <#your_app_key#>, secretKey: <#your_secret_key#>)
```

至此，准备工作已经全部完毕，可以开始App开发啦。

#### 设备初始化

**接口说明**

根据设备 id 去初始化设备控制类。

```objective-c
/**
 *  Get TuyaSmartLightDevice instance. If current user don't have this device, a nil will be return.
 *  获取设备实例。如果当前用户没有该设备，将会返回nil。
 *
 *  @param devId Device ID
 *  @return instance
 */
+ (nullable instancetype)deviceWithDeviceId:(NSString *)devId;
```

**参数说明**

| 参数  | 说明    |
| ----- | ------- |
| devId | 设备 id |

**示例代码**

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
device.delegate = self;
```

#### 判断当前产品是否支持标准指令

使用标准指令需要判断当前设备是否支持标准指令控制，不支持的设备不可以使用该控制方式，只能使用之前的接口控制。如果不支持的设备，而又必须使用标准控制，需要联系涂鸦适配。

示例代码：

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
BOOL isStandard = device.isStandard;
```

#### 品类说明

涂鸦 iot 平台上有很多品类的iot设备，不同的品类在涂鸦平台上都有固定的编号（category）。

开发者文档上体现在每个品类指令集的标题上，如 [灯具(dj) 标准指令集](https://developer.tuya.com/cn/docs/iot/open-api/standard-function/lighting/categorydj/f?id=K9i5ql3v98hn3) 中`dj`，`dj`就是灯具的category值。

使用 category 字段可以判断当前设备是什么产品，来展示不同的面板。

#### 获取产品的品类值（category）

通过产品 id 获取产品的品类值。

示例代码：

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
NSString *category = device.deviceModel.category;
```

#### 设备代理监听

实现 `TuyaSmartLightDeviceDelegate` 代理协议后，可以在设备状态更变的回调中进行处理，刷新 App 设备控制面板的 UI，`TuyaSmartLightDeviceDelegate`继承自`TuyaSmartDeviceDelegate`，`TuyaSmartDeviceDelegate` 的回调可以参考：[设备管理](https://tuyainc.github.io/tuyasmart_home_ios_sdk_doc/zh-hans/resource/Device.html#设备代理监听)

**示例代码**

Objc:

```objective-c
- (void)initDevice {
    self.device = [TuyaSmartLightDevice deviceWithDeviceId:@"your_device_id"];
    self.device.delegate = self;
}

#pragma mark - TuyaSmartLightDeviceDelegate

- (void)lightDevice:(TuyaSmartLightDevice*)device dpUpdate:(TuyaSmartLightDataPointModel*)lightDp {
    // 设备的 dps 状态发生变化，刷新界面 UI
}
```

Swift:

```swift
func initDevice() {
    device = TuyaSmartLightDevice(deviceId: "your_device_id")
    device?.delegate = self
}

// MARK: - TuyaSmartLightDeviceDelegate

func device(_ device: TuyaSmartLightDevice?, dpsUpdate lightDp: TuyaSmartLightDataPointModel?) {
    // 设备的 dps 状态发生变化，刷新界面 UI
}
```

**`TuyaSmartLightDataPointModel` 数据模型**

| 字段             | 类型                     | 描述                                                         |
| ---------------- | ------------------------ | ------------------------------------------------------------ |
| powerSwitch      | BOOL                     | 开关是否打开，YES代表开，NO代表关                            |
| workMode         | TuyaSmartLightMode       | 工作模式，TuyaSmartLightModeWhite, //白光模式；TuyaSmartLightModeColour, //彩光模式；TuyaSmartLightModeScene, //情景模式 |
| brightness       | NSUInteger               | 亮度百分比，从1-100                                          |
| colorTemperature | NSUInteger               | 色温百分比，从0-100                                          |
| colourHSV        | TuyaSmartLightColourData | 颜色值，HSV色彩空间；H为色调，取值范围0-360；S为饱和度，取值范围0-100；V为明度，取值范围1-100 |
| scene            | TuyaSmartLightScene      | 彩灯情景，TuyaSmartLightSceneGoodnight, //晚安情景；TuyaSmartLightSceneWork, //工作情景；TuyaSmartLightSceneRead, //阅读情景；TuyaSmartLightSceneCasual, //休闲情景 |

#### 获取当前灯的类型

灯共分为一路灯（仅有白光）、二路灯（白光+冷暖控制）、三路灯（仅有彩光模式）、四路灯（白光+彩光）、五路灯（白光+彩光+冷暖）。

这5种灯具在功能定义上有所区别，在开发相应的UI和控制时有所区别。

该方法可获取当前灯的类型。

**接口说明**

```objective-c
/// Get light type
/// 获取当前是几路灯
- (TuyaSmartLightType)getLightType;
```

```objective-c
typedef enum : NSUInteger {
    TuyaSmartLightTypeC=1,//白光灯 bright light，dpCode：bright_value
    TuyaSmartLightTypeCW,//白光+冷暖 bright + temperature，dpCode：bright_value + temp_value
    TuyaSmartLightTypeRGB,//RGB，dpCode：colour_data
    TuyaSmartLightTypeRGBC,//bright+RGB，dpCode：bright_value + colour_data
    TuyaSmartLightTypeRGBCW,//bright+temperature+RGB，dpCode：bright_value + temp_value + colour_data
} TuyaSmartLightType;
```

#### 获取灯所有功能点的值

**接口说明**

```objective-c
/// Get light data point
/// 获取灯所有功能点的值
- (TuyaSmartLightDataPointModel *)getLightDataPoint;
```

#### 开关

**接口说明**

```objective-c
/// turn the light on or off
/// 开灯或关灯
/// @param isOn YES or NO
/// @param success success block
/// @param failure failure block
- (void)turnLightOn:(BOOL)isOn
            success:(nullable TYSuccessHandler)success
            failure:(nullable TYFailureError)failure;
```

#### 切换工作模式

**接口说明**

```objective-c
/// switch the work mode
/// 切换工作模式
/// @param mode work mode
/// @param success success block
/// @param failure failure block
- (void)switchWorkMode:(TuyaSmartLightMode)mode
               success:(nullable TYSuccessHandler)success
               failure:(nullable TYFailureError)failure;
```

#### 控制灯的亮度

**接口说明**

```objective-c
/// change the brightness
/// 控制灯的亮度
/// @param value brightness percent value range 1-100  亮度的百分比，取值范围1-100
/// @param success success block
/// @param failure failure block
- (void)changeBrightness:(NSUInteger)value
                 success:(nullable TYSuccessHandler)success
                 failure:(nullable TYFailureError)failure;
```

#### 控制灯的色温

**接口说明**

```objective-c
/// change the color temperature
/// 控制灯的色温
/// @param value color temperature percent value range 0-100 色温的百分比，取值范围0-100
/// @param success success block
/// @param failure failure block
- (void)changeColorTemperature:(NSUInteger)value
                       success:(nullable TYSuccessHandler)success
                       failure:(nullable TYFailureError)failure;
```

#### 切换场景模式

**接口说明**

```objective-c
/// switch the scene mode
/// 切换场景模式
/// @param mode scene mode
/// @param success success block
/// @param failure failure block
- (void)switchSceneMode:(TuyaSmartLightScene)mode
                success:(nullable TYSuccessHandler)success
                failure:(nullable TYFailureError)failure;
```

#### 设置彩灯的颜色

**接口说明**

```objective-c
/// change the light color HSV
/// 设置彩灯的颜色
/// @param hue hue range 0-360 色调 范围0-360
/// @param saturation saturation range 0-100 饱和度 范围0-100
/// @param value lightness range 1-100 明度 范围1-100
/// @param success success block
/// @param failure failure block
- (void)changeColorHSVWithHue:(NSUInteger)hue
                   saturation:(NSUInteger)saturation
                        value:(NSUInteger)value
                      success:(nullable TYSuccessHandler)success
                      failure:(nullable TYFailureError)failure;
```



