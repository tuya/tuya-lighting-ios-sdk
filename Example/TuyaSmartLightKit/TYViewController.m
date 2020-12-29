//
//  TYViewController.m
//  TuyaSmartLightKit
//
//  Created by Tuya on 12/28/2020.
//  Copyright (c) 2020 Tuya. All rights reserved.
//

#import "TYViewController.h"
#import <TuyaSmartLightKit/TuyaSmartLightKit.h>
#import <TuyaSmartDeviceKit/TuyaSmartDeviceKit.h>

@interface TYViewController () <TuyaSmartLightDeviceDelegate>

@property (nonatomic, strong) TuyaSmartHomeManager *manager;
@property (nonatomic, strong) TuyaSmartHome *home;
@property (nonatomic, strong) TuyaSmartLightDevice *device;
@property (nonatomic, strong) UIButton *workModeBtn;
@property (nonatomic, strong) UIButton *sceneModeBtn;
@property (nonatomic, strong) UIButton *brightValueBtn;
@property (nonatomic, strong) UIButton *tempValueBtn;
@property (nonatomic, strong) UIButton *colorHValueBtn;
@property (nonatomic, strong) UIButton *colorSValueBtn;
@property (nonatomic, strong) UIButton *colorVValueBtn;
@property (nonatomic, strong) UISlider *colorHSlide;
@property (nonatomic, strong) UISlider *colorSSlide;
@property (nonatomic, strong) UISlider *colorVSlide;

@end

@implementation TYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *lightTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, APP_TOP_BAR_HEIGHT+20, 100, 60)];
    lightTypeLabel.text = @"";
    lightTypeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:lightTypeLabel];
    
    UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, lightTypeLabel.frame.origin.y+lightTypeLabel.frame.size.height+10, 50, 40)];
    switchLabel.text = @"开关";
    switchLabel.textColor = [UIColor blackColor];
    [self.view addSubview:switchLabel];
    
    UISwitch *lightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(switchLabel.frame.origin.x+switchLabel.frame.size.width+10, switchLabel.frame.origin.y+4, 50, 60)];
    [lightSwitch addTarget:self action:@selector(switchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightSwitch];
    
    UILabel *workModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, switchLabel.frame.origin.y+50, 80, 60)];
    workModeLabel.text = @"模式切换:";
    workModeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:workModeLabel];
    
    _workModeBtn = [[UIButton alloc] initWithFrame:CGRectMake(workModeLabel.frame.origin.x+workModeLabel.frame.size.width, workModeLabel.frame.origin.y, 100, 60)];
    [_workModeBtn addTarget:self action:@selector(workModeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_workModeBtn setTitle:@"" forState:UIControlStateNormal];
    [_workModeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_workModeBtn];
    
    UILabel *sceneModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, workModeLabel.frame.origin.y+60, 80, 60)];
    sceneModeLabel.text = @"情景切换:";
    sceneModeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:sceneModeLabel];
    
    _sceneModeBtn = [[UIButton alloc] initWithFrame:CGRectMake(sceneModeLabel.frame.origin.x+sceneModeLabel.frame.size.width, sceneModeLabel.frame.origin.y, 100, 60)];
    [_sceneModeBtn addTarget:self action:@selector(sceneModeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sceneModeBtn setTitle:@"" forState:UIControlStateNormal];
    [_sceneModeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_sceneModeBtn];
    
    UILabel *brightLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, sceneModeLabel.frame.origin.y+60, 50, 60)];
    brightLabel.text = @"亮度";
    brightLabel.textColor = [UIColor blackColor];
    [self.view addSubview:brightLabel];
    
    UISlider *brightSlide = [[UISlider alloc] initWithFrame:CGRectMake(110, brightLabel.frame.origin.y, 180, 60)];
    brightSlide.minimumValue = 1;
    brightSlide.maximumValue = 100;
    [brightSlide addTarget:self action:@selector(changeBrightValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:brightSlide];
    
    _brightValueBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, brightLabel.frame.origin.y, 50, 60)];
    [_brightValueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_brightValueBtn];
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, brightLabel.frame.origin.y+60, 50, 60)];
    tempLabel.text = @"色温";
    tempLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tempLabel];
    
    UISlider *tempSlide = [[UISlider alloc] initWithFrame:CGRectMake(110, tempLabel.frame.origin.y, 180, 60)];
    tempSlide.minimumValue = 0;
    tempSlide.maximumValue = 100;
    [tempSlide addTarget:self action:@selector(changeTempValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:tempSlide];
    
    _tempValueBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, tempLabel.frame.origin.y, 50, 60)];
    [_tempValueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_tempValueBtn];
    
    UILabel *colorHLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, tempLabel.frame.origin.y+60, 50, 60)];
    colorHLabel.text = @"H值";
    colorHLabel.textColor = [UIColor blackColor];
    [self.view addSubview:colorHLabel];
    
    _colorHSlide = [[UISlider alloc] initWithFrame:CGRectMake(110, colorHLabel.frame.origin.y, 180, 60)];
    _colorHSlide.minimumValue = 0;
    _colorHSlide.maximumValue = 360;
    [_colorHSlide addTarget:self action:@selector(changeColorHValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_colorHSlide];
    
    _colorHValueBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, colorHLabel.frame.origin.y, 50, 60)];
    [_colorHValueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_colorHValueBtn];
    
    UILabel *colorSLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, colorHLabel.frame.origin.y+60, 50, 60)];
    colorSLabel.text = @"S值";
    colorSLabel.textColor = [UIColor blackColor];
    [self.view addSubview:colorSLabel];
    
    _colorSSlide = [[UISlider alloc] initWithFrame:CGRectMake(110, colorSLabel.frame.origin.y, 180, 60)];
    _colorSSlide.minimumValue = 0;
    _colorSSlide.maximumValue = 100;
    [_colorSSlide addTarget:self action:@selector(changeColorSValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_colorSSlide];
    
    _colorSValueBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, colorSLabel.frame.origin.y, 50, 60)];
    [_colorSValueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_colorSValueBtn];
    
    UILabel *colorVLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, colorSLabel.frame.origin.y+60, 50, 60)];
    colorVLabel.text = @"V值";
    colorVLabel.textColor = [UIColor blackColor];
    [self.view addSubview:colorVLabel];
    
    _colorVSlide = [[UISlider alloc] initWithFrame:CGRectMake(110, colorVLabel.frame.origin.y, 180, 60)];
    _colorVSlide.minimumValue = 1;
    _colorVSlide.maximumValue = 100;
    [_colorVSlide addTarget:self action:@selector(changeColorVValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_colorVSlide];
    
    _colorVValueBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, colorVLabel.frame.origin.y, 50, 60)];
    [_colorVValueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_colorVValueBtn];
    
    self.device = [TuyaSmartLightDevice deviceWithDeviceId:_deviceModel.devId];
    self.device.delegate = self;
    switch ([self.device getLightType]) {
        case TuyaSmartLightTypeC:
            lightTypeLabel.text = @"一路灯";
            break;
        case TuyaSmartLightTypeCW:
            lightTypeLabel.text = @"二路灯";
            break;
        case TuyaSmartLightTypeRGB:
            lightTypeLabel.text = @"三路灯";
            break;
        case TuyaSmartLightTypeRGBC:
            lightTypeLabel.text = @"四路灯";
            break;
        case TuyaSmartLightTypeRGBCW:
            lightTypeLabel.text = @"五路灯";
            break;
            
        default:
            break;
    }
    
    lightSwitch.on = [self.device getLightDataPoint].powerSwitch;
    
    switch ([self.device getLightDataPoint].workMode) {
        case TuyaSmartLightModeWhite:
            [self.workModeBtn setTitle:@"白光模式" forState:UIControlStateNormal];
            break;
        case TuyaSmartLightModeScene:
            [self.workModeBtn setTitle:@"彩光模式" forState:UIControlStateNormal];
            break;
        case TuyaSmartLightModeColour:
            [self.workModeBtn setTitle:@"情景模式" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    switch ([self.device getLightDataPoint].scene) {
        case TuyaSmartLightSceneGoodnight:
            [self.sceneModeBtn setTitle:@"晚安情景" forState:UIControlStateNormal];
            break;
        case TuyaSmartLightSceneWork:
            [self.sceneModeBtn setTitle:@"工作情景" forState:UIControlStateNormal];
            break;
        case TuyaSmartLightSceneRead:
            [self.sceneModeBtn setTitle:@"阅读情景" forState:UIControlStateNormal];
            break;
        case TuyaSmartLightSceneCasual:
            [self.sceneModeBtn setTitle:@"休闲情景" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    brightSlide.value = [self.device getLightDataPoint].brightness;
    [self.brightValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.device getLightDataPoint].brightness] forState:UIControlStateNormal];
    
    tempSlide.value = [self.device getLightDataPoint].colorTemperature;
    [self.tempValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.device getLightDataPoint].colorTemperature] forState:UIControlStateNormal];
    
    self.colorHSlide.value = [self.device getLightDataPoint].colourHSV.H;
    [self.colorHValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.device getLightDataPoint].colourHSV.H] forState:UIControlStateNormal];
    
    self.colorSSlide.value = [self.device getLightDataPoint].colourHSV.S;
    [self.colorSValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.device getLightDataPoint].colourHSV.S] forState:UIControlStateNormal];
    
    self.colorVSlide.value = [self.device getLightDataPoint].colourHSV.V;
    [self.colorVValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[self.device getLightDataPoint].colourHSV.V] forState:UIControlStateNormal];
    
}

- (void)switchBtnClicked {
    [self.device turnLightOn:![self.device getLightDataPoint].powerSwitch success:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)workModeBtnClicked {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"工作模式"
                                                                             message:@"请选择工作模式"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    WEAKSELF_TYSDK
    UIAlertAction *whiteAction = [UIAlertAction actionWithTitle:@"白光模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device switchWorkMode:TuyaSmartLightModeWhite success:^{
            NSLog(@"success");
            [weakSelf_TYSDK.workModeBtn setTitle:@"白光模式" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [alertController addAction:whiteAction];
    
    UIAlertAction *colorAction = [UIAlertAction actionWithTitle:@"彩光模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device switchWorkMode:TuyaSmartLightModeColour success:^{
            NSLog(@"success");
            [weakSelf_TYSDK.workModeBtn setTitle:@"彩光模式" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [alertController addAction:colorAction];
    
    UIAlertAction *sceneAction = [UIAlertAction actionWithTitle:@"情景模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device switchWorkMode:TuyaSmartLightModeScene success:^{
            NSLog(@"success");
            [weakSelf_TYSDK.workModeBtn setTitle:@"情景模式" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [alertController addAction:sceneAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sceneModeBtnClicked
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"情景模式"
                                                                             message:@"请选择情景模式"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    WEAKSELF_TYSDK
    UIAlertAction *goodnightAction = [UIAlertAction actionWithTitle:@"晚安情景" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device switchSceneMode:TuyaSmartLightSceneGoodnight success:^{
            NSLog(@"success");
            [weakSelf_TYSDK.sceneModeBtn setTitle:@"晚安情景" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [alertController addAction:goodnightAction];
    
    UIAlertAction *workAction = [UIAlertAction actionWithTitle:@"工作情景" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device switchSceneMode:TuyaSmartLightSceneWork success:^{
            NSLog(@"success");
            [weakSelf_TYSDK.sceneModeBtn setTitle:@"工作情景" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [alertController addAction:workAction];
    
    UIAlertAction *readAction = [UIAlertAction actionWithTitle:@"阅读情景" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device switchSceneMode:TuyaSmartLightSceneRead success:^{
            NSLog(@"success");
            [weakSelf_TYSDK.sceneModeBtn setTitle:@"阅读情景" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [alertController addAction:readAction];
    
    UIAlertAction *casualAction = [UIAlertAction actionWithTitle:@"休闲情景" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.device switchSceneMode:TuyaSmartLightSceneCasual success:^{
            NSLog(@"success");
            [weakSelf_TYSDK.sceneModeBtn setTitle:@"休闲情景" forState:UIControlStateNormal];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];
    [alertController addAction:casualAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeBrightValue:(UISlider *)slide
{
    [self.brightValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)slide.value] forState:UIControlStateNormal];
    [self.device changeBrightness:slide.value success:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)changeTempValue:(UISlider *)slide
{
    [self.tempValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)slide.value] forState:UIControlStateNormal];
    [self.device changeColorTemperature:slide.value success:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)changeColorHValue:(UISlider *)slide
{
    [self.colorHValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)slide.value] forState:UIControlStateNormal];
    [self.device changeColorHSVWithHue:slide.value saturation:self.colorSSlide.value value:self.colorVSlide.value success:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)changeColorSValue:(UISlider *)slide
{
    [self.colorSValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)slide.value] forState:UIControlStateNormal];
    [self.device changeColorHSVWithHue:self.colorHSlide.value saturation:slide.value value:self.colorVSlide.value success:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)changeColorVValue:(UISlider *)slide
{
    [self.colorVValueBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)slide.value] forState:UIControlStateNormal];
    [self.device changeColorHSVWithHue:self.colorHSlide.value saturation:self.colorSSlide.value value:slide.value success:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TuyaSmartLightDeviceDelegate
- (void)lightDevice:(TuyaSmartLightDevice*)device dpUpdate:(TuyaSmartLightDataPointModel*)lightDp
{
    NSLog(@"%@,%@",device,lightDp);
}

@end
