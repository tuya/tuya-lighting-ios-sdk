//
//  TuyaSmartLightDataPointModel.h
//  TuyaSmartLightKit
//
//  Created by neil on 2020/11/13.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TuyaSmartLightModeWhite, //白光模式
    TuyaSmartLightModeColour, //彩光模式
    TuyaSmartLightModeScene, //情景模式
} TuyaSmartLightMode;

typedef enum : NSUInteger {
    TuyaSmartLightSceneGoodnight, //晚安情景
    TuyaSmartLightSceneWork, //工作情景
    TuyaSmartLightSceneRead, //阅读情景
    TuyaSmartLightSceneCasual, //休闲情景
} TuyaSmartLightScene;

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartLightColourData : NSObject

@property (nonatomic, assign) NSUInteger H; //H为色调，取值范围0-360
@property (nonatomic, assign) NSUInteger S; //S为饱和度，取值范围0-100
@property (nonatomic, assign) NSUInteger V; //V为明度，取值范围1-100

@end

@interface TuyaSmartLightDataPointModel : NSObject

@property (nonatomic, assign) BOOL powerSwitch; //开关
@property (nonatomic, assign) TuyaSmartLightMode workMode; //工作模式
@property (nonatomic, assign) NSUInteger brightness; //亮度百分比，从1到100
@property (nonatomic, assign) NSUInteger colorTemperature; //色温百分比，从0到100
@property (nonatomic, strong) TuyaSmartLightColourData *colourHSV; //颜色值，HSV色彩空间
@property (nonatomic, assign) TuyaSmartLightScene scene; //彩灯情景

@end

NS_ASSUME_NONNULL_END
