//
//  TYAddDeviceMenuViewController+ModuleConfig.m
//  BlocksKit
//
//  Created by huangkai on 2020/6/3.
//

#import "TYDemoAddDeviceMenuViewController+ModuleConfig.h"

@implementation TYDemoAddDeviceMenuViewController (ModuleConfig)
@dynamic barTitle;
@dynamic barImage;
@dynamic barSelectedImage;
@dynamic needNavigation;
@dynamic isMain;

TY_EXPORT_TABBAR(self)

- (NSString *)barTitle {
    return TYSDKDemoLocalizedString(@"Activate", @"");
}

- (UIImage *)barImage {
    return [UIImage tysdkdemo_imageNamed:@"ty_mainbt_add"];
}

- (UIImage *)barSelectedImage {
    return [UIImage tysdkdemo_imageNamed:@"ty_mainbt_add_active"];
}

- (BOOL)needNavigation {
    return YES;
}

- (BOOL)isMain {
    return NO;
}

@end
