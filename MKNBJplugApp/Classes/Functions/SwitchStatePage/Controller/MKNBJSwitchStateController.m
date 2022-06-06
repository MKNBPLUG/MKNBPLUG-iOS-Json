//
//  MKNBJSwitchStateController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJSwitchStateController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKAlertController.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJSwitchViewButton.h"
#import "MKNBJCountdownPickerView.h"

#import "MKNBJSwitchStatePageModel.h"

#import "MKNBJElectricityController.h"
#import "MKNBJSettingsController.h"
#import "MKNBJEnergyController.h"

static CGFloat const switchButtonWidth = 200.f;
static CGFloat const switchButtonHeight = 200.f;
static CGFloat const buttonViewWidth = 70.f;
static CGFloat const buttonViewHeight = 50.f;

@interface MKNBJSwitchStateController ()

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *stateLabel;

@property (nonatomic, strong)UILabel *delayTimeLabel;

@property (nonatomic, strong)MKNBJSwitchViewButton *powerButton;

@property (nonatomic, strong)MKNBJSwitchViewButtonModel *powerButtonModel;

@property (nonatomic, strong)MKNBJSwitchViewButton *timerButton;

@property (nonatomic, strong)MKNBJSwitchViewButtonModel *timerButtonModel;

@property (nonatomic, strong)MKNBJSwitchViewButton *energyButton;

@property (nonatomic, strong)MKNBJSwitchViewButtonModel *energyButtonModel;

@property (nonatomic, strong)MKNBJSwitchStatePageModel *dataModel;

///  0:过载  1:过流  2:过压  3:欠压
@property (nonatomic, assign)NSInteger overType;

@end

@implementation MKNBJSwitchStateController

- (void)dealloc {
    NSLog(@"MKNBJSwitchStateController销毁");    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
    [self startDataMonitor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceNameChanged:)
                                                 name:@"mk_nbj_deviceNameChangedNotification"
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    MKNBJSettingsController *vc = [[MKNBJSettingsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - notes
- (void)receiveDeviceNameChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || ![[MKNBJDeviceModeManager shared].macAddress isEqualToString:user[@"macAddress"]]) {
        return;
    }
    self.defaultTitle = user[@"deviceName"];
}

#pragma mark - event method
- (void)switchButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    BOOL isOn = !self.dataModel.isOn;
    @weakify(self);
    [self.dataModel configSwitchStatus:isOn sucBlock:^(id  _Nonnull returnData) {
        @strongify(self);
        [[MKHudManager share] hide];
        self.dataModel.isOn = isOn;
        [self updateButtonView];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)powerButtonPressed {
    MKNBJElectricityController *vc = [[MKNBJElectricityController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timerButtonPressed {
    MKNBJCountdownPickerViewModel *timeModel = [[MKNBJCountdownPickerViewModel alloc] init];
    timeModel.hour = @"0";
    timeModel.minutes = @"0";
    timeModel.titleMsg = (self.dataModel.isOn ? @"Countdown timer(off)" : @"Countdown timer(on)");
    MKNBJCountdownPickerView *pickView = [[MKNBJCountdownPickerView alloc] init];
    pickView.timeModel = timeModel;
    @weakify(self);
    [pickView showTimePickViewBlock:^(MKNBJCountdownPickerViewModel *timeModel) {
        @strongify(self);
        [self setDelay:timeModel.hour delayMin:timeModel.minutes];
    }];
}

- (void)energyButtonPressed {
    MKNBJEnergyController *vc = [[MKNBJEnergyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateButtonView];
        [self updateOverState];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    }];
}

- (void)setDelay:(NSString *)hour delayMin:(NSString *)min{
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    NSInteger second = [hour integerValue] * 60 * 60 + [min integerValue] * 60;
    @weakify(self);
    [self.dataModel configCountdown:second sucBlock:^(id  _Nonnull returnData) {
        @strongify(self);
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearOverload {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel clearOverloadWithSucBlock:^(id  _Nonnull returnData) {
        @strongify(self);
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearOvercurrent {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel clearOvercurrentWithSucBlock:^(id  _Nonnull returnData) {
        @strongify(self);
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearOvervoltage {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel clearOvervoltageWithSucBlock:^(id  _Nonnull returnData) {
        @strongify(self);
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearUndervoltage {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel clearUndervoltageWithSucBlock:^(id  _Nonnull returnData) {
        @strongify(self);
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 解除过载、过压、欠压、过流状态
- (void)updateOverState {
    if (self.dataModel.overload) {
        self.overType = 0;
        [self presentOverNoteAlert];
        return;
    }
    if (self.dataModel.overcurrent) {
        self.overType = 1;
        [self presentOverNoteAlert];
        return;
    }
    if (self.dataModel.overvoltage) {
        self.overType = 2;
        [self presentOverNoteAlert];
        return;
    }
    if (self.dataModel.undervoltage) {
        self.overType = 3;
        [self presentOverNoteAlert];
        return;
    }
}

/// 过载、过流、过压、欠压状态推出的弹窗
- (void)presentOverNoteAlert {
    NSString *msg = @"Detect the socket overload, please confirm whether to exit the over-load status?";
    if (self.overType == 1) {
        msg = @"Detect the socket overcurrent, please confirm whether to exit the over-current status?";
    }else if (self.overType == 2) {
        msg = @"Detect the socket overvoltage, please confirm whether to exit the overvoltage status?";
    }else if (self.overType == 3) {
        msg = @"Detect the socket undervoltage, please confirm whether to exit the undervoltage status?";
    }
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_nbj_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self popToViewControllerWithClassName:@"MKNBJDeviceListController"];
    }];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self performSelector:@selector(presentDismissOverAlert) withObject:nil afterDelay:0.8f];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

/// 过载、过流、过压、欠压状态推出二级的弹窗
- (void)presentDismissOverAlert {
    NSString *msg = @"If YES, the socket will exit overload status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    if (self.overType == 1) {
        msg = @"If YES, the socket will exit overcurrent status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    }else if (self.overType == 2) {
        msg = @"If YES, the socket will exit overvoltage status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    }else if (self.overType == 3) {
        msg = @"If YES, the socket will exit undervoltage status, and please make sure it is within the protection threshold. If NO, you need manually reboot it to exit this status.";
    }
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_nbj_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self popToViewControllerWithClassName:@"MKNBJDeviceListController"];
    }];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        if (self.overType == 0) {
            [self clearOverload];
            return;
        }
        if (self.overType == 1) {
            [self clearOvercurrent];
            return;
        }
        if (self.overType == 2) {
            [self clearOvervoltage];
            return;
        }
        if (self.overType == 3) {
            [self clearUndervoltage];
            return;
        }
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - Private method

- (void)startDataMonitor {
    @weakify(self);
    self.dataModel.switchStateChangedBlock = ^(NSDictionary * _Nonnull dataDic) {
        //设备上报开关状态
        @strongify(self);
        self.dataModel.isOn = ([dataDic[@"switch_state"] integerValue] == 1);
        self.dataModel.overload = ([dataDic[@"overload_state"] integerValue] == 1);
        self.dataModel.overcurrent = ([dataDic[@"overcurrent_state"] integerValue] == 1);
        self.dataModel.overvoltage = ([dataDic[@"overvoltage_state"] integerValue] == 1);
        self.dataModel.undervoltage = ([dataDic[@"undervoltage_state"] integerValue] == 1);
        [self updateButtonView];
    };
    self.dataModel.receiveCountdownDataBlock = ^(NSDictionary * _Nonnull dataDic) {
        //设备上报到倒计时
        @strongify(self);
        NSInteger seconds = [dataDic[@"countdown"] integerValue];
        self.delayTimeLabel.hidden = (seconds == 0);
        BOOL isOn = ([dataDic[@"switch_state"] integerValue] == 1);
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
        NSString *time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        NSString *msg = [NSString stringWithFormat:@"Device will turn %@ after %@",(isOn ? @"on" : @"off"),time];
        self.delayTimeLabel.text = msg;
    };
    self.dataModel.receiveLoadStatusChangedBlock = ^(BOOL load) {
        //设备负载状态发生改变
        @strongify(self);
        if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
            return;
        }
        NSString *msg = (load ? @"Load starts working now!" : @"Load stops working now!");
        [self.view showCentralToast:msg];
    };
    self.dataModel.receiveOverloadBlock = ^(BOOL overload) {
      //设备过载保护发生改变
        @strongify(self);
        if (!overload) {
            return;
        }
        self.overType = 0;
        [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
    };
    self.dataModel.receiveOvervoltageBlock = ^(BOOL overvoltage) {
      //设备过压保护发生改变
        @strongify(self);
        if (!overvoltage) {
            return;
        }
        self.overType = 2;
        [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
    };
    self.dataModel.receiveUndervoltageBlock = ^(BOOL undervoltage) {
      //设备欠压保护发生改变
        @strongify(self);
        if (!undervoltage) {
            return;
        }
        self.overType = 3;
        [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
    };
    self.dataModel.receiveOvercurrentBlock = ^(BOOL overcurrent) {
        //设备过流保护发生改变
        @strongify(self);
        if (!overcurrent) {
            return;
        }
        self.overType = 1;
        [self performSelector:@selector(presentOverNoteAlert) withObject:nil afterDelay:1.f];
    };
}
    
#pragma mark - UI method
- (void)updateButtonView {
    self.switchButton.selected = self.dataModel.isOn;
    UIImage *switchIcon = (self.dataModel.isOn ? LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_switchButtonOn.png") : LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_switchButtonOff.png"));
    [self.switchButton setImage:switchIcon forState:UIControlStateNormal];
    UIColor *msgColor = (self.dataModel.isOn ? UIColorFromRGB(0x0188cc) : UIColorFromRGB(0x808080));
    self.timerButtonModel.icon = (self.dataModel.isOn ? LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_timerOn.png") : LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_timerOff.png"));
    self.timerButtonModel.msgColor = msgColor;
    self.timerButton.dataModel = self.timerButtonModel;
    
    self.powerButtonModel.icon = (self.dataModel.isOn ? LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_powerOn.png") : LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_powerOff.png"));
    self.powerButtonModel.msgColor = msgColor;
    self.powerButton.dataModel = self.powerButtonModel;
    
    self.energyButtonModel.icon = (self.dataModel.isOn ? LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_energyOn.png") : LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_energyOff.png"));
    self.energyButtonModel.msgColor = msgColor;
    self.energyButton.dataModel = self.energyButtonModel;
    
    self.stateLabel.textColor = msgColor;
    self.stateLabel.text = (self.dataModel.isOn ? @"Socket is on" : @"Socket is off");
}

- (void)loadSubViews {
    self.defaultTitle = [MKNBJDeviceModeManager shared].deviceName;
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJSwitchStateController", @"nbj_moreIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.switchButton];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(200.f);
        make.top.mas_equalTo(176.f);
        make.height.mas_equalTo(200.f);
    }];
    [self.view addSubview:self.stateLabel];
    [self.view addSubview:self.delayTimeLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(45.f);
        make.height.mas_equalTo(3 * MKFont(15.f).lineHeight);
    }];
    [self.delayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.view addSubview:self.powerButton];
    [self.view addSubview:self.timerButton];
    [self.view addSubview:self.energyButton];
    [self.timerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70.f);
        make.width.mas_equalTo(buttonViewWidth);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 20.f);
        make.height.mas_equalTo(buttonViewHeight);
    }];
    [self.powerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(buttonViewWidth);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 20.f);
        make.height.mas_equalTo(buttonViewHeight);
    }];
    [self.energyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-70.f);
        make.width.mas_equalTo(buttonViewWidth);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 20.f);
        make.height.mas_equalTo(buttonViewHeight);
    }];
}

#pragma mark - getter
- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = UIColorFromRGB(0x0188cc);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = MKFont(15.f);
//        _stateLabel.text = @"Socket is on";
        _stateLabel.numberOfLines = 0;
    }
    return _stateLabel;
}

- (UILabel *)delayTimeLabel{
    if (!_delayTimeLabel) {
        _delayTimeLabel = [[UILabel alloc] init];
        _delayTimeLabel.textColor = UIColorFromRGB(0x0188cc);
        _delayTimeLabel.textAlignment = NSTextAlignmentCenter;
        _delayTimeLabel.font = MKFont(15.f);
    }
    return _delayTimeLabel;
}

- (MKNBJSwitchViewButton *)powerButton {
    if (!_powerButton) {
        _powerButton = [[MKNBJSwitchViewButton alloc] init];
        [_powerButton addTarget:self
                         action:@selector(powerButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerButton;
}

- (MKNBJSwitchViewButtonModel *)powerButtonModel {
    if (!_powerButtonModel) {
        _powerButtonModel = [[MKNBJSwitchViewButtonModel alloc] init];
        _powerButtonModel.msg = @"Power";
    }
    return _powerButtonModel;
}

- (MKNBJSwitchViewButton *)timerButton {
    if (!_timerButton) {
        _timerButton = [[MKNBJSwitchViewButton alloc] init];
        [_timerButton addTarget:self
                         action:@selector(timerButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerButton;
}

- (MKNBJSwitchViewButtonModel *)timerButtonModel {
    if (!_timerButtonModel) {
        _timerButtonModel = [[MKNBJSwitchViewButtonModel alloc] init];
        _timerButtonModel.msg = @"Timer";
    }
    return _timerButtonModel;
}

- (MKNBJSwitchViewButton *)energyButton {
    if (!_energyButton) {
        _energyButton = [[MKNBJSwitchViewButton alloc] init];
        [_energyButton addTarget:self
                          action:@selector(energyButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _energyButton;
}

- (MKNBJSwitchViewButtonModel *)energyButtonModel {
    if (!_energyButtonModel) {
        _energyButtonModel = [[MKNBJSwitchViewButtonModel alloc] init];
        _energyButtonModel.msg = @"Energy";
    }
    return _energyButtonModel;
}

- (MKNBJSwitchStatePageModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJSwitchStatePageModel alloc] init];
    }
    return _dataModel;
}

@end
