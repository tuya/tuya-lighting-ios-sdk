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



