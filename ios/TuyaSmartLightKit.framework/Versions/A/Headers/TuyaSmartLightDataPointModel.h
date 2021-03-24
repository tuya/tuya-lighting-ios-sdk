//
//  TuyaSmartLightDataPointModel.h
//  TuyaSmartLightKit
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ///White light mode.  白光模式
    TuyaSmartLightModeWhite,
    ///Colour Light Mode.  彩光模式
    TuyaSmartLightModeColour,
    ///Scenario Mode.  情景模式
    TuyaSmartLightModeScene,
} TuyaSmartLightMode;

typedef enum : NSUInteger {
    ///Good night scenario. 晚安情景
    TuyaSmartLightSceneGoodnight,
    ///Work scenarios. 工作情景
    TuyaSmartLightSceneWork,
    ///Reading Scenarios. 阅读情景
    TuyaSmartLightSceneRead,
    ///Leisure Scenario. 休闲情景
    TuyaSmartLightSceneCasual,
} TuyaSmartLightScene;

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartLightColourData : NSObject

///H is the hue, take the value range 0-360.  H为色调，取值范围0-360
@property (nonatomic, assign) NSUInteger H;
///S is the saturation degree, the value range 0-100.  S为饱和度，取值范围0-100
@property (nonatomic, assign) NSUInteger S;
///V is the brightness, the value range of 1-100.  V为明度，取值范围1-100
@property (nonatomic, assign) NSUInteger V;

@end

@interface TuyaSmartLightDataPointModel : NSObject

///Switch.  开关
@property (nonatomic, assign) BOOL powerSwitch;
///Working mode.  工作模式
@property (nonatomic, assign) TuyaSmartLightMode workMode;
///Brightness percentage, from 1 to 100.  亮度百分比，从1到100
@property (nonatomic, assign) NSUInteger brightness;
///Percentage of color temperature, from 0 to 100.  色温百分比，从0到100
@property (nonatomic, assign) NSUInteger colorTemperature;
///Color values, HSV color space.  颜色值，HSV色彩空间
@property (nonatomic, strong) TuyaSmartLightColourData *colourHSV;
///Colored lights scene.  彩灯情景
@property (nonatomic, assign) TuyaSmartLightScene scene;

@end

NS_ASSUME_NONNULL_END
