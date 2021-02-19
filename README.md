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

   pod 'TuyaSmartLightKit', :git => 'https://github.com/TuyaInc/tuyasmart_lighting_ios_sdk.git'
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
