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



