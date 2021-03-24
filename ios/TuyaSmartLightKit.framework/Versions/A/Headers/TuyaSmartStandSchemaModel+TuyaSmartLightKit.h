//
//  TuyaSmartStandSchemaModel+TuyaSmartLightKit.h
//  TuyaSmartLightKit
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <TuyaSmartDeviceCoreKit/TuyaSmartDeviceCoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartStandSchemaModel (TuyaSmartLightKit)

@end

@interface TuyaSmartStatusSchemaModel (TuyaSmartLightKit)

///Range of values.  取值范围
@property (nonatomic, strong) NSString     *valueRange;
///dpcode->dpid mapping relationship.  dpcode->dpid映射关系
@property (nonatomic, strong) NSDictionary *relationDpIdMaps;

@end

@interface TuyaSmartFunctionSchemaModel (TuyaSmartLightKit)

///Range of values.  取值范围
@property (nonatomic, strong) NSString     *valueRange;
///dpcode->dpid mapping relationship.  dpcode->dpid映射关系
@property (nonatomic, strong) NSDictionary *relationDpIdMaps;

@end

NS_ASSUME_NONNULL_END
