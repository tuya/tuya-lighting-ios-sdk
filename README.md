# Tuya Smart Lighting iOS SDK Integration

[中文版](README-zh.md) | [English](README.md)

### Overview

Tuya Smart Lighting iOS SDK is built on `TuyaSmartDevice` and extends integration with lighting-related features to speed up your development process. This SDK has the following features:

* Get light type.
* Get values of all data points (DPs) of a light.
* Turn light on or off.
* Switch working mode.
* Control light brightness.
* Control light color temperature.
* Switch scene mode.
* Set light color.

### Quick integration

#### Use CocoaPods for integration

Add the following to the `Podfile` file:

```ruby
platform :ios, '9.0'

target 'your_target_name' do

   pod 'TuyaSmartLightKit', :git => 'https://github.com/tuya/tuyasmart-lighting-ios-sdk.git'
```

Then execute the `pod update` command in the project root directory to integrate with third-party libraries.

For the use of CocoaPods, refer to [CocoaPods Guides](https://guides.cocoapods.org/).

#### SDK initialization

1. Open the project settings, click `Target` > `General`, and modify `Bundle Identifier` to the corresponding iOS Bundle ID set on the [Tuya IoT Platform](https://iot.tuya.com/).
2. Import the security image to the root directory of the project, rename it as `t_s.bmp`. Go to Project Settings > Target > Build Phases, and add this image to `Copy Bundle Resources`.
3. Add the following to the `PrefixHeader.pch` file of the project.

    ```
    #import <TuyaSmartLightKit/TuyaSmartLightKit.h>
    ```

    Swift projects can add the following to the `xxx_Bridging-Header.h` bridge file.

    ```
    #import <TuyaSmartLightKit/TuyaSmartLightKit.h>
    ```

4. Open the `AppDelegate.m` file and initialize the SDK in the `[AppDelegate application:didFinishLaunchingWithOptions:]` method: 

    Objc:

    ```
    [[TuyaSmartSDK sharedInstance] startWithAppKey:<#your_app_key#> secretKey:<#your_secret_key#>];
    ```

    Swift:

    ```
    TuyaSmartSDK.sharedInstance()?.start(withAppKey: <#your_app_key#>, secretKey: <#your_secret_key#>)
    ```

The preparation has been completed. Now, let's start the app development.

#### Device initialization

**Interface description**

Initialize the device control class based on the device ID.

```objective-c
/**
 *  Get TuyaSmartLightDevice instance. If current user don't have this device, a nil will be returned.
 *
 *  @param devId Device ID
 *  @return instance
 */
+ (nullable instancetype)deviceWithDeviceId:(NSString *)devId;
```

**Parameter description**

| Parameters | Description |
| ---------- | ----------- |
| devId      | device ID   |

**Sample code**

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
device.delegate = self;
```

#### Determine command applicability

To use the standard command, you need to first determine whether the current device supports the standard command control. If the standard commands are not applicable to your devices, you can only proceed with the alternate method to implement device control. If you want inapplicable devices to be controlled by standard commands, you can contact Tuya for further support.

Sample code: 

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
BOOL isStandard = device.isStandard;
```

#### Category description

Each IoT product category on the [Tuya IoT Platform](https://iot.tuya.com/) has its unique `category` value. For example, the `dj` in the [light (dj) standard instruction set](https://developer.tuya.com/en/docs/iot/open-api/standard-function/lighting/categorydj/f?id=K9i5ql3v98hn3) is the `category` value of lights. You can use the `category` field to determine the category of your device and display different control panels.


#### Get category value

You can get category value based on the product ID. 

Sample code: 

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
NSString *category = device.deviceModel.category;
```

#### Device proxy listener

After implementing the `TuyaSmartLightDeviceDelegate` proxy protocol, you can handle the device status change callbacks to refresh the UI of the app's control panel. `TuyaSmartLightDeviceDelegate` inherits from `TuyaSmartDeviceDelegate`. The callback of `TuyaSmartDeviceDelegate` can be found at [Device Management](https://developer.tuya.com/en/docs/app-development/ios-app-sdk/device?id=Ka5cgmmjr46cp#title-1-Delegate%20of%20device).

**Sample code**

Objc:

```objective-c
- (void)initDevice {
    self.device = [TuyaSmartLightDevice deviceWithDeviceId:@"your_device_id"];
    self.device.delegate = self;
}

#pragma mark - TuyaSmartLightDeviceDelegate

- (void)lightDevice:(TuyaSmartLightDevice*)device dpUpdate:(TuyaSmartLightDataPointModel*)lightDp {
    // The dps status of the device changes and the UI is refreshed
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
    // The dps status of the device changes and the interface UI is refreshed
}
```

**`TuyaSmartLightDataPointModel` data model**

| Fields           | Type                     | Description                                                  |
| ---------------- | ------------------------ | ------------------------------------------------------------ |
| powerSwitch      | BOOL                     | Whether the light is turned on. YES means on. NO means off.  |
| workMode         | TuyaSmartLightMode       | Working modes. `TuyaSmartLightModeWhite` indicates white light. `TuyaSmartLightModeColour` indicates multi-color light. `TuyaSmartLightModeScene` indicates scene mode. |
| brightness       | NSUInteger               | Brightness percentage, from 1 to 100.                           |
| colorTemperature | NSUInteger               | Color temperature percentage, from 0 to 100.                 |
| colourHSV        | TuyaSmartLightColourData | Color value in HSV. H is hue, the value from 0 to 360; S is saturation, the value from 0 to 100; V is brightness, the value from 1 to 100. |
| scene            | TuyaSmartLightScene      | Multi-color scenes. `TuyaSmartLightSceneGoodnight` indicates goodnight scene. `TuyaSmartLightSceneWork` indicates working scene. `TuyaSmartLightSceneRead` indicates reading scene. `TuyaSmartLightSceneCasual` indicates leisure scene. |

#### Get light type

Five types of light: cool white light (C), cool and warm white light (CW), multi-color light (RGB), cool white and multi-color light (RGBC), as well as cool and warm white and multi-color light (RGBCW).

These five types of light differ in the function definition. Take the difference into account during UI design and control method development.

The following method can get the light type.

**Interface description**

```objective-c
/// Get light type
- (TuyaSmartLightType)getLightType;
```

```objective-c
typedef enum : NSUInteger {
    TuyaSmartLightTypeC=1,// For cool white light, dpCode is bright_value
    TuyaSmartLightTypeCW,// For cool and warm light, dpCode is bright_value + temp_value
    TuyaSmartLightTypeRGB,// For multi-color light, dpCode is colour_data
    TuyaSmartLightTypeRGBC,// For cool white and multi-color light, dpCode is bright_value + colour_data
    TuyaSmartLightTypeRGBCW,// For cool and warm white and multi-color light, dpCode is bright_value + temp_value + colour_data
} TuyaSmartLightType;
```

#### Get all DP values

**Interface description**

```objective-c
/// Get light data point
- (TuyaSmartLightDataPointModel *)getLightDataPoint;
```

#### On/off

**Interface description**

```objective-c
/// Turn light on or off
/// @param isOn YES or NO
/// @param success success block
/// @param failure failure block
- (void)turnLightOn:(BOOL)isOn
            success:(nullable TYSuccessHandler)success
            failure:(nullable TYFailureError)failure;
```

#### Working mode

**Interface description**

```objective-c
/// Switch a working mode
/// @param mode work mode
/// @param success success block
/// @param failure failure block
- (void)switchWorkMode:(TuyaSmartLightMode)mode
               success:(nullable TYSuccessHandler)success
               failure:(nullable TYFailureError)failure;
```

#### Brightness

**Interface description**

```objective-c
/// Adjust brightness
/// @param value brightness percentage value range 1-100
/// @param success success block
/// @param failure failure block
- (void)changeBrightness:(NSUInteger)value
                 success:(nullable TYSuccessHandler)success
                 failure:(nullable TYFailureError)failure;
```

#### Color temperature

**Interface description**

```objective-c
/// Adjust color temperature
/// @param value color temperature percentage value range 0-100
/// @param success success block
/// @param failure failure block
- (void)changeColorTemperature:(NSUInteger)value
                       success:(nullable TYSuccessHandler)success
                       failure:(nullable TYFailureError)failure;
```

#### Scene mode

**Interface description**

```objective-c
/// Switch a scene mode
/// @param mode scene mode
/// @param success success block
/// @param failure failure block
- (void)switchSceneMode:(TuyaSmartLightScene)mode
                success:(nullable TYSuccessHandler)success
                failure:(nullable TYFailureError)failure;
```

#### Multi-color

**Interface description**

```objective-c
/// Adjust light colors in HSV
/// @param hue hue range 0-360
/// @param saturation saturation range 0-100
/// @param value lightness range 1-100
/// @param success success block
/// @param failure failure block
- (void)changeColorHSVWithHue:(NSUInteger)hue
                   saturation:(NSUInteger)saturation
                        value:(NSUInteger)value
                      success:(nullable TYSuccessHandler)success
                      failure:(nullable TYFailureError)failure;
```

#### Standard DP code issued

The SDK does not encapsulate a method to issue standard DP code commands through this interface of the TuyaSmartLightDevice parent class.

**Interface Description**

```objective-c
/**
 *  dp command publish.
 *
 *  @param commands dpCode - value dictionary
 *  @param success Success block
 *  @param failure Failure block
 */
- (void)publishDpWithCommands:(NSDictionary *)commands
                      success:(nullable TYSuccessHandler)success
                      failure:(nullable TYFailureError)failure;
```

The standard instruction set is divided into two versions, v1 and v2, which can be distinguished by the standard code followed by v1 and v2. The specific instructions available can be found in the following list:

#### Luminaire v1 standard instruction set description

| Function            | Standard code   | Type    | Standard value                                               | Example                                                      | Remarks                                                      |
| ------------------- | --------------- | ------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Switch              | switch_led      | Boolean | true/false （Turn on/off）                                   | {"switch_led":true}                                          |                                                              |
| Mode                | work_mode       | Enum    | "white"/"colour"/"scene"/"scene_1"/"scene_2"/"scene_3"/"scene_4" | {"work_mode":"scene"}                                        |                                                              |
| Brightness          | bright_value_v1 | Integer | 25-255                                                       | {"bright_value_v1":100}                                      | Brightness value 25-255, corresponding to the actual brightness 10%-100%, the lowest brightness display is 10% |
| Colour temperature  | temp_value_v1   | Integer | 0-255                                                        | {"temp_value_v1":100"}                                       | Color temperature range 0-100, corresponding to the actual color temperature 0%-100%, respectively, corresponding to the warmest and coldest range of values, the actual color temperature value depends on the hardware specifications of the lamp beads, such as 2700K-6500K |
| Colour              | colour_data_v1  | String  | Value: ”00112233334455”（A string of length 14） 00: R 11: G 22: B 3333: H(Hue) 44: S(Saturation) 55: V(Value) | {"colour_data_v2":"2700000000ff27"}                          | Colors are transmitted according to the HSV system, but can also be converted to the RGB color system by an algorithm. Refer to the website https://www.rapidtables.com/convert/color/index.html to obtain RGB (R,G,B): (HEX)(32,64,C8), (DEC)(50, 100,200) |
| Scenario            | scene_data      | String  | Value: "00112233334455"（A string of length 14） 00: R 11: G 22: B 3333: H(Hue) 44: S(Saturation) 55: V(Value) | {"work_mode":"scene","scene_data":"fffcf70168ffff"}          |                                                              |
| Soft Light Scenario | flash_scene_1   | String  | Value :"00112233445566"（A string of length 14） 00: (brightness) 11: (color Temperature) 22: (frequency) 33：Number of change groups(01) 445566：R G B | {"work_mode":"scene_1","flash_scene_1":"ffff320100ff00"}     |                                                              |
| Dazzling scenarios  | flash_scene_3   | String  | Id.                                                          | {"work_mode":"scene_3","flash_scene_3":"ffff320100ff00"}     |                                                              |
| Colorful scenes     | flash_scene_2   | String  | Value: "00112233445566... .445566" (length 14~~44 string) 00: brightness (brightness) 11: color temperature (color Temperature) 22: change frequency (frequency) 33: change group number (01~~06) 445566: R G B Note: change group number how many, there are How many 445566, the maximum number of groups for 6 groups | {"work_mode":"scene_2","flash_scene_2":"ffff5003ff000000ff000000ff"} |                                                              |
| Glittering scenes   | flash_scene_4   | String  | Id.                                                          | {"work_mode":"scene_4","flash_scene_4":"ffff0505ff000000ff00ffff00ff00ff0000ff"} |                                                              |

#### Luminaire v2 standard instruction set description

| Function              | Standard code   | Type    | Standard value                                               | Example                                                      | Remarks                                                      |
| --------------------- | --------------- | ------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Switch                | switch_led      | Boolean | true/false （Turn on/off）                                   | {"switch_led":true}                                          |                                                              |
| Mode                  | work_mode       | Enum    | "white"/"colour"/"scene"/"music"                             | {"work_mode":"scene"}                                        | White light, color light, scene, music light TAB bar, decided by DP points: "white light" menu bar: mode and brightness DP common decision "color light" menu bar: mode and color DP common decision "scene" menu bar: mode and context DP common decision "music light" menu bar: mode and music light DP common decision "countdown": decided by countdown DP points "timing": by the cloud function, cloud timing decision |
| Brightness            | bright_value_v2 | Integer | 10 – 1000                                                    | {"bright_value_v2":670}                                      | Brightness 10-1000 values, corresponding to the actual brightness 1%-100%, the lowest brightness display for 1% |
| Colour temperature    | temp_value_v2   | Integer | 0-1000                                                       | {"temp_value_v2":797"}                                       | Color temperature range 0-1000, corresponding to the actual color temperature 0%-100%, respectively, corresponding to the warmest and coldest range of values, the actual color temperature value depends on the hardware specifications of the lamp beads, such as 2700K-6500K |
| Colour                | colour_data_v2  | String  | 000011112222 Value Description: 0000: H (Chroma: 0-360, 0X0000-0X0168) 1111: S (Saturation: 0-1000, 0X0000-0X03E8) 2222: V (Brightness: 0-1000, 0X0000-0X03E8) HSV (H,S,V): ( HEX)(00DC, 004B,004E), converted to (DEC) as (220 degrees, 75%, 78%) | {"colour_data_v2":"00DC004B004E"}                            | Colors are transmitted according to the HSV system, but can also be converted to the RGB color system by an algorithm. Refer to the website https://www.rapidtables.com/convert/color/index.html to obtain RGB (R,G,B): (HEX)(32,64,C8), (DEC)(50, 100,200) |
| Scenario              | scene_data_v2   | String  | 001122334444555555666677778888 00: Scenario number 11: Unit switching interval time (0-100) 22: Unit change time (0-100) 33: Unit change mode (0 static 1 jump 2 fade) 4444: H (Chromaticity: 0-360, 0X0000-0X0168) 5555: S (saturation: 0-1000, 0X0000-0X03E8) 6666: V (brightness: 0-1000, 0X0000-0X03E8) 7777: white light brightness (0-1000) 8888: color temperature value (0-1000) Note: the number 1-8 of the label corresponds to how many units there are as many groups | {"25":"010b0a02000003e803e8000000000b0a02007603e803e8000000000b0a0200e703e803e800000000"} | 01: Scenario number 01 0b: Unit switching interval time (0) 0a: Unit change time (10) 02: Unit change mode:Gradient 0000: H (Chromaticity: 0X0000) 03e8: S (Saturation: 0-1000, 0X0000-0X03E8) 03e8: V (Brightness: 0-1000, 0X0000- 0X03E8) 0000: White luminance (0-1000) 0000: Color temperature value (0-1000) |
| Countdown             | countdown_1     | Integer | **0-86400** **Description:** Data unit seconds, corresponding to a minute value of 60, the maximum setting of 86400 = 23 hours and 59 minutes 0 means off | **{ "\**countdown_1\**":"120" }**                            |                                                              |
| Music                 | music_data      | String  | 011112222333344445555 Description: 0: Change mode, 0 means direct output, 1 means gradient 1111: H (Chroma: 0-360, 0X0000-0X0168) 2222: S (Saturation: 0-1000, 0X0000-0X03E8) 3333: V (Brightness: 0-1000, 0X0000-0X03E8) 4444: White luminance (0-1000) 5555: Color temperature value (0-1000) | {"music_data": "1007603e803e800120025"} 0: Change mode, 0 means direct output, 1 means fade Example Description: 1: Change mode, 1 means fade 0076: H (Chroma: 0X0076) 03e8: S (Saturation: 0X03e8) 03e8:: V ( Brightness: 0X03e8) 0012: Brightness (18%) 0025: Color temperature (37%) | This function point, together with the mode function point, determines whether the music light is displayed |
| Adjustment DP control | control_data    | String  | 0: Change mode, 0 means direct output, 1 means gradient 1111: H ( Chroma: 0-360, 0 X0000-0X0168 ) 2222: S ( Saturation: 0 -1000, 0X0000-0X03E8 ) 3333: V ( Brightness: 0-1000, 0 X0000-0X03E8 ) 4444: White luminance (0-1000) 5555: Color temperature value (0-1000) | **{** **"\**control_data\**": "** **10076** **03e803e800120025"** **}** 1: Change mode, 1 means gradient 0076: H (chromaticity: 0 X0076) 03e8: S ( saturation: 0X03e8) 03e8 : : V ( Brightness : 0 X03e8 ) 0012 : Brightness (18 %) 0025 : Color temperature (37 %) | This DP is used to send real-time data down during panel adjustment |
| Scenario change       | scene_data_v2   | String  | The specific format of the scenario is as follows: 00 11 22 33 444455556666 77778888 Tab time speed mode color(hsv) white(bright,temper) In addition to the Tab, the rest of the composition of the basic scenario unit, the current maximum can be set to 8 that is 00 + (112233444455555566666677778888)* 8 Relationship between time and speed: fade and unit switching is currently carried out simultaneously, you can achieve three states of change (only two types of distribution) A: synchronous completion: to achieve the completion of the fade immediately switch to the next unit, send time = speed can  B: stall after fading. For example, the fade will be completed in 1s, and stall for 1s before continuing the fade. Send time = 2, speed = 1. C:Advance switch When the fade time is less than the switch time, it will happen in the middle of the change to switch to the next target state to start the fade, to achieve a more random change effect. Send time<speed Time (switching time between each scenario unit) 0 - 100 (unit: 100ms) can be achieved 100ms - 10s switching interval, when 0 means directly switch to the next unit, but from the state of the unit for excessive Specifically, the following figure.  The above figure as an example, when the unit B time is 0, can be equivalent to the change is the process of A to C, but in the middle node X at the light state switch to B continue to change Speed (scenario unit from the previous state to switch to the target state of the fading speed) 0 - 100 (unit HZ) Note: the current specific implementation still use time as a unit, so the fastest for 1 (10khz), the slowest for 100 (100hz), the need to modify the subsequent discussion.  The new version of the light fade step for 1000, so the speed = time change time / 1000 set change time t For example, when speed sent down 1, s = 0.1s/1000 = 10Khz When speed = 0, the current unit change will stall until the unit switch time T to, switch to the next target scenario unit will begin to change from stagnant Unit change to the new unit Mode is the change mode of the current scenario unit to the next target scenario unit, there are 0, 1, 2 Mode = 0: static scenario, when the mode of the target scenario is 0, when this change is completed, the scenario change will stop and become a static scenario. The change speed is currently fixed to the normal white light and color light breathing time (500ms).  Mode = 1: jump mode, when the unit switching time, directly switch to a new scenario unit Mode = 2: fade mode, when the thread reads the data in the current scenario unit from the previous scenario unit fade to the new scenario The new version of the light scenario compared to the old version can only light up the color light, now supports the white light and color light at the same time to light up the function |                                                              |                                                              |

