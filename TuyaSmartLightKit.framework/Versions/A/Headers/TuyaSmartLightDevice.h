//
//  TuyaSmartLightDevice.h
//  TuyaSmartLightKit
//
//  Created by neil on 2020/11/12.
//

#import <Foundation/Foundation.h>
#import <TuyaSmartDeviceCoreKit/TuyaSmartDeviceCoreKit.h>
#import "TuyaSmartLightDataPointModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TuyaSmartLightDevice;

typedef enum : NSUInteger {
    TuyaSmartLightTypeC=1,//白光灯 bright light，dpCode：bright_value
    TuyaSmartLightTypeCW,//白光+冷暖 bright + temperature，dpCode：bright_value + temp_value
    TuyaSmartLightTypeRGB,//RGB，dpCode：colour_data
    TuyaSmartLightTypeRGBC,//bright+RGB，dpCode：bright_value + colour_data
    TuyaSmartLightTypeRGBCW,//bright+temperature+RGB，dpCode：bright_value + temp_value + colour_data
} TuyaSmartLightType;

@protocol TuyaSmartLightDeviceDelegate <TuyaSmartDeviceDelegate>

@optional

/// dp data update
/// 设备 dps 变化回调
/// @param device instance
/// @param lightDp lightDp TuyaSmartLightDataPointModel instance
- (void)lightDevice:(TuyaSmartLightDevice*)device dpUpdate:(TuyaSmartLightDataPointModel*)lightDp;

@end

@interface TuyaSmartLightDevice : TuyaSmartDevice

@property (nonatomic, weak, nullable) id<TuyaSmartLightDeviceDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isStandard; //是否标准化

/// Get light type
/// 获取当前是几路灯
- (TuyaSmartLightType)getLightType;

/// Get light data point
/// 获取灯所有功能点的值
- (TuyaSmartLightDataPointModel *)getLightDataPoint;

/// turn the light on or off
/// 开灯或关灯
/// @param isOn YES or NO
/// @param success success block
/// @param failure failure block
- (void)turnLightOn:(BOOL)isOn
            success:(nullable TYSuccessHandler)success
            failure:(nullable TYFailureError)failure;

/// switch the work mode
/// 切换工作模式
/// @param mode work mode
/// @param success success block
/// @param failure failure block
- (void)switchWorkMode:(TuyaSmartLightMode)mode
               success:(nullable TYSuccessHandler)success
               failure:(nullable TYFailureError)failure;

/// change the brightness
/// 控制灯的亮度
/// @param value brightness percent value range 1-100  亮度的百分比，取值范围1-100
/// @param success success block
/// @param failure failure block
- (void)changeBrightness:(NSUInteger)value
                 success:(nullable TYSuccessHandler)success
                 failure:(nullable TYFailureError)failure;

/// change the color temperature
/// 控制灯的色温
/// @param value color temperature percent value range 0-100 色温的百分比，取值范围0-100
/// @param success success block
/// @param failure failure block
- (void)changeColorTemperature:(NSUInteger)value
                       success:(nullable TYSuccessHandler)success
                       failure:(nullable TYFailureError)failure;

/// switch the scene mode
/// 切换场景模式
/// @param mode scene mode
/// @param success success block
/// @param failure failure block
- (void)switchSceneMode:(TuyaSmartLightScene)mode
                success:(nullable TYSuccessHandler)success
                failure:(nullable TYFailureError)failure;

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

@end

NS_ASSUME_NONNULL_END
