# Tuya Smart Lighting Standard Control iOS SDK Documentation

[中文版](README-zh.md) | [English](README.md)

#### Function Overview

The Tuya SmartLighting iOS SDK is an interface package that extends the TuyaSmartDevice with access to lighting device related features to speed up the development process. The main features included are：

* Get how many lights the current device is.
* Get the value of all function points of the lamp.
* Lights on or off.
* Switching working mode.
* Control the brightness of the light.
* Control the color temperature of the lamp.
* Switching scene mode.
* Set the color of the colored lights.

#### Fast Integration

### Using CocoaPods Integration

Add the following to the `Podfile` file：

```ruby
platform :ios, '9.0'

target 'your_target_name' do

   pod 'TuyaSmartLightKit', :git => 'https://github.com/TuyaInc/tuyasmart_lighting_ios_sdk.git'
```

Then execute the `pod update` command in the project root directory to integrate third-party libraries.

For the use of CocoaPods, please refer to：[CocoaPods Guides](https://guides.cocoapods.org/)

#### Initializing the SDK

1. Open Project Settings,`Target => General`,Modify `Bundle Identifier` to the corresponding iOS package name of Tuya Developer Platform.
2. Import security images to the project root,Rename to`t_s.bmp`,and add it to 「Project Settings => Target => Build Phases => Copy Bundle Resources」.
3. Add the following to the project's `PrefixHeader.pch` file：

```
#import <TuyaSmartLightKit/TuyaSmartLightKit.h>
```

Swift projects can add the following to the `xxx_Bridging-Header.h` bridge file

```
#import <TuyaSmartLightKit/TuyaSmartLightKit.h>
```

1. Open the `AppDelegate.m` file and initialize the SDK in the `[AppDelegate application:didFinishLaunchingWithOptions:]` method：

Objc:

```
[[TuyaSmartSDK sharedInstance] startWithAppKey:<#your_app_key#> secretKey:<#your_secret_key#>];
```

Swift:

```
TuyaSmartSDK.sharedInstance()?.start(withAppKey: <#your_app_key#>, secretKey: <#your_secret_key#>)
```

At this point, all the preparation work has been completed, and we can start the app development.

#### Device initialization

**Interface Description**

Initialize the device control class based on the device id.

```objective-c
/**
 *  Get TuyaSmartLightDevice instance. If current user don't have this device, a nil will be return.
 *
 *  @param devId Device ID
 *  @return instance
 */
+ (nullable instancetype)deviceWithDeviceId:(NSString *)devId;
```

**Parameter Description**

| Parameters | Description |
| ---------- | ----------- |
| devId      | device id   |

**Sample Code**

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
device.delegate = self;
```

#### Determine if the current product supports standard directives

Using the standard command requires determining whether the current device supports the standard command control, and devices that do not support it cannot use this control method, and can only use the previous interface control. If the device does not support it, and you must use standard control, you need to contact Tuya Adaptation.

Sample Code：

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
BOOL isStandard = device.isStandard;
```

#### Category Description

There are many categories of iot devices on the Tuya iot platform, and the different categories have fixed numbers on the Tuya platform（category）.

The developer documentation is reflected in the title of each category instruction set, e.g. [lamps(dj) standard instruction set](https://developer.tuya.com/en/docs/iot/open-api/standard-function/lighting/categorydj/f?id=K9i5ql3v98hn3) in`dj`，`dj`is the category value of the fixture.

Use the category field to determine what product the current device is to display different panels.

#### Get the category value of the product（category）

Get the category value of the product by product id.

Sample Code：

```objective-c
TuyaSmartLightDevice *device = [TuyaSmartLightDevice deviceWithDeviceId:devId];
NSString *category = device.deviceModel.category;
```

#### Device Agent Listening

After implementing the `TuyaSmartLightDeviceDelegate` proxy protocol, you can handle the device state change callbacks to refresh the UI of the App device control panel, `TuyaSmartLightDeviceDelegate` inherits from `TuyaSmartDeviceDelegate`. TuyaSmartDeviceDelegate`, the callback for `TuyaSmartDeviceDelegate` can be found at: [Device Management](https://tuyainc.github.io/tuyasmart_home_ios_sdk_doc/en/resource/Device.html#delegate-of-device).

**Sample Code**

Objc:

```objective-c
- (void)initDevice {
    self.device = [TuyaSmartLightDevice deviceWithDeviceId:@"your_device_id"];
    self.device.delegate = self;
}

#pragma mark - TuyaSmartLightDeviceDelegate

- (void)lightDevice:(TuyaSmartLightDevice*)device dpUpdate:(TuyaSmartLightDataPointModel*)lightDp {
    // The dps status of the device changes and the interface UI is refreshed
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

**`TuyaSmartLightDataPointModel` Data Model**

| Fields           | Type                     | Description                                                  |
| ---------------- | ------------------------ | ------------------------------------------------------------ |
| powerSwitch      | BOOL                     | Whether the switch is open, YES means open, NO means close.  |
| workMode         | TuyaSmartLightMode       | Working mode, TuyaSmartLightModeWhite, //White light mode; TuyaSmartLightModeColour, //Colour Light Mode; TuyaSmartLightModeScene, //Scenario Mode. |
| brightness       | NSUInteger               | Brightness percentage, from 1-100.                           |
| colorTemperature | NSUInteger               | Percentage of color temperature, from 0-100.                 |
| colourHSV        | TuyaSmartLightColourData | Color value, HSV color space; H is hue, the value range 0-360; S is saturation, the value range 0-100; V is brightness, the value range 1-100. |
| scene            | TuyaSmartLightScene      | Colour light scenario, TuyaSmartLightSceneGoodnight, //goodnight scenario; TuyaSmartLightSceneWork, //work scenario; TuyaSmartLightSceneRead, //reading scenario; TuyaSmartLightSceneCasual, //leisure scenario. |

#### Get the current light type

The lights are divided into one way lights (white light only), two way lights (white light + warm and cold control), three way lights (color light mode only), four way lights (white light + color light), five way lights (white light + color light + warm and cold).

These 5 types of luminaires differ in their functional definitions and differ in the development of the corresponding UI and controls.

This method gets the type of the current lamp.

**Interface Description**

```objective-c
/// Get light type
- (TuyaSmartLightType)getLightType;
```

```objective-c
typedef enum : NSUInteger {
    TuyaSmartLightTypeC=1,//bright light，dpCode：bright_value
    TuyaSmartLightTypeCW,//bright + temperature，dpCode：bright_value + temp_value
    TuyaSmartLightTypeRGB,//RGB，dpCode：colour_data
    TuyaSmartLightTypeRGBC,//bright+RGB，dpCode：bright_value + colour_data
    TuyaSmartLightTypeRGBCW,//bright+temperature+RGB，dpCode：bright_value + temp_value + colour_data
} TuyaSmartLightType;
```

#### Get the value of all function points of the lamp

**Interface Description**

```objective-c
/// Get light data point
- (TuyaSmartLightDataPointModel *)getLightDataPoint;
```

#### Switch

**Interface Description**

```objective-c
/// turn the light on or off
/// @param isOn YES or NO
/// @param success success block
/// @param failure failure block
- (void)turnLightOn:(BOOL)isOn
            success:(nullable TYSuccessHandler)success
            failure:(nullable TYFailureError)failure;
```

#### Switching working mode

**Interface Description**

```objective-c
/// switch the work mode
/// @param mode work mode
/// @param success success block
/// @param failure failure block
- (void)switchWorkMode:(TuyaSmartLightMode)mode
               success:(nullable TYSuccessHandler)success
               failure:(nullable TYFailureError)failure;
```

#### Control the brightness of the light

**Interface Description**

```objective-c
/// change the brightness
/// @param value brightness percent value range 1-100
/// @param success success block
/// @param failure failure block
- (void)changeBrightness:(NSUInteger)value
                 success:(nullable TYSuccessHandler)success
                 failure:(nullable TYFailureError)failure;
```

#### Control the color temperature of the lamp

**Interface Description**

```objective-c
/// change the color temperature
/// @param value color temperature percent value range 0-100
/// @param success success block
/// @param failure failure block
- (void)changeColorTemperature:(NSUInteger)value
                       success:(nullable TYSuccessHandler)success
                       failure:(nullable TYFailureError)failure;
```

#### Switching scene mode

**Interface Description**

```objective-c
/// switch the scene mode
/// @param mode scene mode
/// @param success success block
/// @param failure failure block
- (void)switchSceneMode:(TuyaSmartLightScene)mode
                success:(nullable TYSuccessHandler)success
                failure:(nullable TYFailureError)failure;
```

#### Set the color of the colored lights

**Interface Description**

```objective-c
/// change the light color HSV
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



