//
//  TuyaSmartStandSchemaModel+TuyaSmartLightKit.h
//  TuyaSmartLightKit
//
//  Created by neil on 2020/11/28.
//

#import <TuyaSmartDeviceCoreKit/TuyaSmartDeviceCoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartStandSchemaModel (TuyaSmartLightKit)

@end

@interface TuyaSmartStatusSchemaModel (TuyaSmartLightKit)

@property (nonatomic, strong) NSString     *valueRange; //取值范围
@property (nonatomic, strong) NSDictionary *relationDpIdMaps; //dpcode->dpid映射关系

@end

@interface TuyaSmartFunctionSchemaModel (TuyaSmartLightKit)

@property (nonatomic, strong) NSString     *valueRange; //取值范围
@property (nonatomic, strong) NSDictionary *relationDpIdMaps; //dpcode->dpid映射关系

@end

NS_ASSUME_NONNULL_END
