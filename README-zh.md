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

   pod 'TuyaSmartLightKit', :git => 'https://github.com/tuya/tuya-lighting-ios-sdk.git'
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

#### 标准DP code下发

SDK没有封装的方法可以通过TuyaSmartLightDevice父类的此接口下发标准DP code指令。

**接口说明**

```objective-c
/// Dp command publish.
/// @param commands DpCode - value dictionary.
/// @param success Called when the task finishes successfully.
/// @param failure Called when the task is interrupted by an error.
- (void)publishDpWithCommands:(NSDictionary *)commands
                      success:(nullable TYSuccessHandler)success
                      failure:(nullable TYFailureError)failure;
```

标准指令集分为v1和v2两个版本，可以通过标准code后面的v1和v2区分，具体有哪些指令可以参考下面的列表：

#### 灯具v1标准指令集说明

| 功能     | 标准code        | 类型    | 标准值                                                       | 示例                                                         | 备注                                                         |
| -------- | --------------- | ------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 开关     | switch_led      | Boolean | true/false （打开/关闭）                                     | {"switch_led":true}                                          |                                                              |
| 模式     | work_mode       | Enum    | "white"/"colour"/"scene"/"scene_1"/"scene_2"/"scene_3"/"scene_4" | {"work_mode":"scene"}                                        |                                                              |
| 亮度     | bright_value_v1 | Integer | 25-255                                                       | {"bright_value_v1":100}                                      | 亮度值25-255，对应实际亮度10%-100%，最低亮度显示为10%        |
| 色温     | temp_value_v1   | Integer | 0-255                                                        | {"temp_value_v1":100"}                                       | 色温范围0-100，对应实际色温0%-100%，分别对应最暖和最冷的范围取值，实际的色温值依赖于硬件的灯珠规格，比如2700K-6500K |
| 颜色     | colour_data_v1  | String  | Value: ”00112233334455”（长度为14的字符串） 00: R 11: G 22: B 3333: H(色调Hue) 44: S(饱和度Saturation) 55: V(明度Value) | {"colour_data_v2":"2700000000ff27"}                          | 颜色按照HSV体系传输，也可以通过算法转换为RGB颜色体系 参考网址https://www.rapidtables.com/convert/color/index.html 可以获得RGB (R,G,B): (HEX)(32,64,C8),(DEC)(50,100,200) |
| 情景     | scene_data      | String  | Value: "00112233334455"（长度为14的字符串） 00: R 11: G 22: B 3333: H(色调Hue) 44: S(饱和度Saturation) 55: V(明度Value) | {"work_mode":"scene","scene_data":"fffcf70168ffff"}          |                                                              |
| 柔光情景 | flash_scene_1   | String  | Value :"00112233445566"（长度为14的字符串） 00: 亮度(brightness) 11: 色温(color Temperature) 22: 变化频率(frequency) 33：变化组数(01) 445566：R G B | {"work_mode":"scene_1","flash_scene_1":"ffff320100ff00"}     |                                                              |
| 炫彩情景 | flash_scene_3   | String  | 同上                                                         | {"work_mode":"scene_3","flash_scene_3":"ffff320100ff00"}     |                                                              |
| 缤纷情景 | flash_scene_2   | String  | Value:"00112233445566....445566"（长度为14~~44的字符串） 00: 亮度(brightness) 11: 色温(color Temperature) 22: 变化频率(frequency) 33：变化组数(01~~06) 445566：R G B 注：变化组数有多少，就有多少个445566,组数最大为6组 | {"work_mode":"scene_2","flash_scene_2":"ffff5003ff000000ff000000ff"} |                                                              |
| 斑斓情景 | flash_scene_4   | String  | 同上                                                         | {"work_mode":"scene_4","flash_scene_4":"ffff0505ff000000ff00ffff00ff00ff0000ff"} |                                                              |

#### 灯具v2标准指令集说明

| 功能       | 标准code        | 类型    | 标准值                                                       | 示例                                                         | 备注                                                         |
| ---------- | --------------- | ------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 开关       | switch_led      | Boolean | true/false （打开/关闭）                                     | {"switch_led":true}                                          |                                                              |
| 模式       | work_mode       | Enum    | "white"/"colour"/"scene"/"music"白光模式/彩光模式/场景/音乐灯 | {"work_mode":"scene"}                                        | 白光、彩光、场景、音乐灯的TAB栏，由DP点决定：  “白光”菜单栏：模式和亮度DP共同决定 “彩光”菜单栏：模式和颜色DP共同决定 “场景”菜单栏：模式和情境DP共同决定 “音乐灯”菜单栏：模式和音乐灯DP共同决定 “倒计时”：由倒计时DP点决定 “定时”：由云功能的，云端定时决定 |
| 亮度       | bright_value_v2 | Integer | 10 – 1000                                                    | {"bright_value_v2":670}                                      | 亮度值10-1000，对应实际亮度1%-100%，最低亮度显示为1%         |
| 色温       | temp_value_v2   | Integer | 0-1000                                                       | {"temp_value_v2":797"}                                       | 色温范围0-1000，对应实际色温0%-100%，分别对应最暖和最冷的范围取值，实际的色温值依赖于硬件的灯珠规格，比如2700K-6500K |
| 颜色       | colour_data_v2  | String  | 000011112222  值说明：  0000：H（色度：0-360，0X0000-0X0168）  1111：S (饱和：0-1000, 0X0000-0X03E8)  2222：V (明度：0-1000，0X0000-0X03E8)  HSV (H,S,V): (HEX)(00DC, 004B,004E),转换为(DEC)为(220度,75%,78%) | {"colour_data_v2":"00DC004B004E"}                            | 颜色按照HSV体系传输，也可以通过算法转换为RGB颜色体系  参考网址https://www.rapidtables.com/convert/color/index.html  可以获得RGB (R,G,B): (HEX)(32,64,C8),(DEC)(50,100,200) |
| 情景       | scene_data_v2   | String  | 0011223344445555666677778888  00：情景号  11：单元切换间隔时间（0-100）  22：单元变化时间（0-100）  33：单元变化模式（0静态1跳变2渐变）  4444：H（色度：0-360，0X0000-0X0168）  5555：S (饱和：0-1000, 0X0000-0X03E8)  6666：V (明度：0-1000，0X0000-0X03E8)  7777：白光亮度（0-1000）  8888：色温值（0-1000）  注：数字1-8的标号对应有多少单元就有多少组 | {"25":"010b0a02000003e803e8000000000b0a02007603e803e8000000000b0a0200e703e803e800000000"} | 01：情景号01  0b：单元切换间隔时间（0）  0a：单元变化时间（10）  02：单元变化模式:渐变  0000：H（色度：0X0000）  03e8：S (饱和：0-1000, 0X0000-0X03E8)  03e8：V (明度：0-1000，0X0000-0X03E8)  0000：白光亮度（0-1000）  0000：色温值（0-1000） |
| 倒计时     | countdown_1     | Integer | **0-86400** **说明：** 数据单位秒，对应一分钟取值60，最大设置86400=23小时59分钟 0表示关闭 | **{ "\**countdown_1\**":"120" }**                            |                                                              |
| 音乐       | music_data      | String  | 011112222333344445555 说明： 0： 变化方式，0表示直接输出，1表示渐变  1111：H（色度：0-360，0X0000-0X0168）  2222：S (饱和：0-1000, 0X0000-0X03E8)  3333：V (明度：0-1000，0X0000-0X03E8)  4444：白光亮度（0-1000）  5555：色温值（0-1000） | {"music_data":"1007603e803e800120025"}  0： 变化方式，0表示直接输出，1表示渐变  示例说明：  1： 变化方式， 1表示渐变  0076：H（色度： 0X0076）  03e8：S (饱和：0X03e8)  03e8：：V (明度： 0X03e8)  0012：亮度（18%）  0025：色温（37%） | 该功能点和模式功能点一起，决定是否显示音乐灯                 |
| 调节DP控制 | control_data    | String  | 0： 变化方式，0表示直接输出，1表示渐变 1111：H（色度：0-360，0 X0000-0X0168 ） 2222： S ( 饱和：0 -1000, 0X0000-0X03E8) 3333： V ( 明度：0-1000，0 X0000-0X03E8) 4444：白光亮度（0-1000） 5555：色温值（0-1000） | **{** **"\**control_data\**":"** **10076** **03e803e800120025"** **}** 1： 变化方式， 1表示渐变 0076 ：H（色度： 0 X0076 ） 03e8 ： S ( 饱和： 0X03e8) 03e8 ：： V ( 明度： 0 X03e8) 0012 ：亮度（ 18 %） 0025 ：色温（ 37 %） | 该DP用于面板调节过程中实时数据下发                           |
| 情景变化   | scene_data_v2   | String  | 情景的具体格式如下： 00 11 22 33 444455556666 77778888  Tab time speed mode color(hsv) white(bright,temper)  除了Tab之外，其余部分组成基本的情景单元，目前最大可设置8个  即 00 +（11223344445555666677778888）* 8  Time与speed的关系：  渐变与单元切换目前为同时进行，可以达到三种变化状态（分布进行只有两种）  A:同步完成：  要实现渐变完成后马上切换下一个单元，发送time = speed即可  B:渐变后停滞等待  例如，将实现1s完成渐变，并停滞1s在继续渐变。发送time = 2，speed = 1即可  C:提前切换  当渐变时间小于切换时间，会发生在变化之中切换到下一个目标状态开始渐变，实现一种比较随机的变化效果。发送time<speed  Time（各个情景单元间切换时间）0 – 100（单位：100ms）  可以实现100ms – 10s的切换间隔，为0时表示直接切换到下一个单元，但从此单元的状态进行过度  具体如下图：  以上图为例，当单元B的time为0时，可以相当于变化是A到C的过程，但是在中间节点X处灯光状态切换到B继续变化  Speed（情景单元从上个状态切换到目标状态的渐变速度）0-100（单位HZ）  注：目前具体实现依旧使用时间为单位，所以最快为1（10khz），最慢为100（100hz），需不需修改后续商议。  新版灯光的渐变步进为1000，所以速度 = 时间变化时间/1000  设变化时间为t  例如，当speed下发1，s = 0.1s/1000 = 10Khz  当speed = 0时，当前单元的变化会停滞，直到单元切换时间T到，切换到下一个目标情景单元才会开始从停滞单元变化到新的单元  Mode为当前情景单元过度到下一个目标情景单元的变化方式，有0，1，2三种方式  Mode = 0：静态情景，当目标情景的模式为0时，当此变化完成便停止情景变化，成为静态情景。变化速度目前固定为正常白光和彩光的呼吸时间（500ms）。  Mode = 1：跳变模式，当单元切换时间一到，直接切换为新的情景单元  Mode = 2：渐变模式，当线程读取到了当前情景单元中数据由上一个情景单元渐变到新的情景  新版灯的情景较旧版本只能点亮彩灯，现在支持白光灯和彩灯同时点亮的功能 |                                                              |                                                              |



