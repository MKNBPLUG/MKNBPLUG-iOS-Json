//
//  MKNBJServerConfigDeviceSettingView.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJServerConfigDeviceSettingView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"
#import "MKTextField.h"

@implementation MKNBJServerConfigDeviceSettingViewModel
@end

@interface MKNBJServerConfigDeviceSettingView ()

@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UILabel *topMsgLabel;

@property (nonatomic, strong)UILabel *deviceIDLabel;

@property (nonatomic, strong)MKTextField *deviceIDField;

@property (nonatomic, strong)UIView *timeLineView;

@property (nonatomic, strong)UILabel *timeLineMsgLabel;

@property (nonatomic, strong)UILabel *ntpLabel;

@property (nonatomic, strong)MKTextField *ntpUrlField;

@property (nonatomic, strong)UILabel *timeZoneLabel;

@property (nonatomic, strong)UIButton *timeZoneButton;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)UIView *netLineView;

@property (nonatomic, strong)UILabel *netLineMsgLabel;

@property (nonatomic, strong)UILabel *apnLabel;

@property (nonatomic, strong)MKTextField *apnField;

@property (nonatomic, strong)UILabel *netUsernameLabel;

@property (nonatomic, strong)MKTextField *netUsernameField;

@property (nonatomic, strong)UILabel *netPasswordLabel;

@property (nonatomic, strong)MKTextField *netPasswordField;

@property (nonatomic, strong)UILabel *netPriorityLabel;

@property (nonatomic, strong)UIButton *priorityButton;

@property (nonatomic, strong)UIView *debugLineView;

@property (nonatomic, strong)UILabel *debugLineMsgLabel;

@property (nonatomic, strong)UILabel *debugLabel;

@property (nonatomic, strong)UIButton *debugButton;

@property (nonatomic, strong)UIButton *exportButton;

@property (nonatomic, strong)UIButton *importButton;

@property (nonatomic, strong)NSArray *timeZoneList;

@property (nonatomic, strong)NSArray *priorityList;

@end

@implementation MKNBJServerConfigDeviceSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLineView];
        [self.topLineView addSubview:self.topMsgLabel];
        [self addSubview:self.deviceIDLabel];
        [self addSubview:self.deviceIDField];
        [self addSubview:self.timeLineView];
        [self.timeLineView addSubview:self.timeLineMsgLabel];
        [self addSubview:self.ntpLabel];
        [self addSubview:self.ntpUrlField];
        [self addSubview:self.timeZoneLabel];
        [self addSubview:self.timeZoneButton];
        [self addSubview:self.noteLabel];
        [self addSubview:self.netLineView];
        [self.netLineView addSubview:self.netLineMsgLabel];
        [self addSubview:self.apnLabel];
        [self addSubview:self.apnField];
        [self addSubview:self.netUsernameLabel];
        [self addSubview:self.netUsernameField];
        [self addSubview:self.netPasswordLabel];
        [self addSubview:self.netPasswordField];
        [self addSubview:self.netPriorityLabel];
        [self addSubview:self.priorityButton];
        [self addSubview:self.debugLineView];
        [self.debugLineView addSubview:self.debugLineMsgLabel];
        [self addSubview:self.debugLabel];
        [self addSubview:self.debugButton];
        [self addSubview:self.exportButton];
        [self addSubview:self.importButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(20.f);
    }];
    [self.topMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.deviceIDField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceIDLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.topLineView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.deviceIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.deviceIDField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.timeLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.deviceIDField.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.timeLineMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.ntpUrlField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ntpLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.timeLineView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.ntpLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.ntpUrlField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.timeZoneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(85.f);
        make.top.mas_equalTo(self.ntpUrlField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.timeZoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.timeZoneButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.timeZoneButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(self.frame.size.width - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.timeZoneButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(size.height);
    }];
    [self.netLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.noteLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.netLineMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.apnField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.apnLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.netLineView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.apnLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.apnField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.netUsernameField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.netUsernameLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.apnField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.netUsernameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.netUsernameField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.netPasswordField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.netPasswordLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.netUsernameField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.netPasswordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.netPasswordField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.priorityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(150.f);
        make.top.mas_equalTo(self.netPasswordField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.netPriorityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.priorityButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.priorityButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.debugLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.priorityButton.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.debugLineMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.debugButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.debugLineMsgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.debugLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.debugButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.debugButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.exportButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.width.mas_equalTo(130.f);
        make.top.mas_equalTo(self.debugButton.mas_bottom).mas_offset(40.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.importButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.width.mas_equalTo(130.f);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)timeZoneButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.timeZoneList.count; i ++) {
        if ([self.timeZoneButton.titleLabel.text isEqualToString:self.timeZoneList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.timeZoneList selectedRow:index block:^(NSInteger currentRow) {
        [self.timeZoneButton setTitle:self.timeZoneList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_timeZoneChanged:)]) {
            [self.delegate nbj_mqtt_deviecSetting_timeZoneChanged:currentRow];
        }
    }];
}

- (void)priorityButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.priorityList.count; i ++) {
        if ([self.priorityButton.titleLabel.text isEqualToString:self.priorityList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.priorityList selectedRow:index block:^(NSInteger currentRow) {
        [self.priorityButton setTitle:self.priorityList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_networkPriorityChanged:)]) {
            [self.delegate nbj_mqtt_deviecSetting_networkPriorityChanged:currentRow];
        }
    }];
}

- (void)debugButtonPressed {
    self.debugButton.selected = !self.debugButton.selected;
    UIImage *icon = (self.debugButton.selected ? LOADICON(@"MKNBJplugApp", @"MKNBJServerConfigDeviceSettingView", @"nbj_switchSelectedIcon.png") : LOADICON(@"MKNBJplugApp", @"MKNBJServerConfigDeviceSettingView", @"nbj_switchUnselectedIcon.png"));
    [self.debugButton setImage:icon forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_debugModeChanged:)]) {
        [self.delegate nbj_mqtt_deviecSetting_debugModeChanged:self.debugButton.selected];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_fileButtonPressed:)]) {
        [self.delegate nbj_mqtt_deviecSetting_fileButtonPressed:0];
    }
}

- (void)importButtonPressed {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_fileButtonPressed:)]) {
        [self.delegate nbj_mqtt_deviecSetting_fileButtonPressed:1];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKNBJServerConfigDeviceSettingViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNBJServerConfigDeviceSettingViewModel.class]) {
        return;
    }
    self.deviceIDField.text = SafeStr(_dataModel.deviceID);
    self.ntpUrlField.text = SafeStr(_dataModel.ntpHost);
    self.apnField.text = SafeStr(_dataModel.apn);
    self.netUsernameField.text = SafeStr(_dataModel.networkUsername);
    self.netPasswordField.text = SafeStr(_dataModel.networkPassword);
    self.debugButton.selected = _dataModel.debugMode;
    UIImage *icon = (self.debugButton.selected ? LOADICON(@"MKNBJplugApp", @"MKNBJServerConfigDeviceSettingView", @"nbj_switchSelectedIcon.png") : LOADICON(@"MKNBJplugApp", @"MKNBJServerConfigDeviceSettingView", @"nbj_switchUnselectedIcon.png"));
    [self.debugButton setImage:icon forState:UIControlStateNormal];
    if (_dataModel.timeZone < 0 || dataModel.timeZone > 52) {
        return;
    }
    [self.timeZoneButton setTitle:self.timeZoneList[_dataModel.timeZone] forState:UIControlStateNormal];
    if (_dataModel.networkPriority < 0 || _dataModel.networkPriority > 10) {
        return;
    }
    [self.priorityButton setTitle:self.priorityList[_dataModel.networkPriority] forState:UIControlStateNormal];
}

#pragma mark - getter
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [self loadLineView];
    }
    return _topLineView;
}

- (UILabel *)topMsgLabel {
    if (!_topMsgLabel) {
        _topMsgLabel = [self msgLabel:@"Device Id" font:MKFont(15.f)];
    }
    return _topMsgLabel;
}

- (UILabel *)deviceIDLabel {
    if (!_deviceIDLabel) {
        _deviceIDLabel = [self msgLabel:@"Device Id" font:MKFont(13.f)];
    }
    return _deviceIDLabel;
}

- (MKTextField *)deviceIDField {
    if (!_deviceIDField) {
        _deviceIDField = [self textFieldWithPlaceholder:@"1-32 Characters" maxLengh:32];
        @weakify(self);
        _deviceIDField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_deviecSetting_textChanged:text textID:0];
            }
        };
    }
    return _deviceIDField;
}

- (UIView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [self loadLineView];
    }
    return _timeLineView;
}

- (UILabel *)timeLineMsgLabel {
    if (!_timeLineMsgLabel) {
        _timeLineMsgLabel = [self msgLabel:@"Time Setting" font:MKFont(15.f)];
    }
    return _timeLineMsgLabel;
}

- (UILabel *)ntpLabel {
    if (!_ntpLabel) {
        _ntpLabel = [self msgLabel:@"NTP URL" font:MKFont(13.f)];
    }
    return _ntpLabel;
}

- (MKTextField *)ntpUrlField {
    if (!_ntpUrlField) {
        _ntpUrlField = [self textFieldWithPlaceholder:@"0-64 Characters" maxLengh:64];
        @weakify(self);
        _ntpUrlField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_deviecSetting_textChanged:text textID:1];
            }
        };
    }
    return _ntpUrlField;
}

- (UILabel *)timeZoneLabel {
    if (!_timeZoneLabel) {
        _timeZoneLabel = [self msgLabel:@"TimeZone" font:MKFont(13.f)];
    }
    return _timeZoneLabel;
}

- (UIButton *)timeZoneButton {
    if (!_timeZoneButton) {
        _timeZoneButton = [MKCustomUIAdopter customButtonWithTitle:@"UTC+00"
                                                            target:self
                                                            action:@selector(timeZoneButtonPressed)];
        [_timeZoneButton.titleLabel setFont:MKFont(13.f)];
    }
    return _timeZoneButton;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [self msgLabel:@"Note: the NTP URL can be set to empty, then it will use the default NTP server"
                               font:MKFont(13.f)];
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

- (UIView *)netLineView {
    if (!_netLineView) {
        _netLineView = [self loadLineView];
    }
    return _netLineView;
}

- (UILabel *)netLineMsgLabel {
    if (!_netLineMsgLabel) {
        _netLineMsgLabel = [self msgLabel:@"Network Setting" font:MKFont(15.f)];
    }
    return _netLineMsgLabel;
}

- (UILabel *)apnLabel {
    if (!_apnLabel) {
        _apnLabel = [self msgLabel:@"APN" font:MKFont(13.f)];
    }
    return _apnLabel;
}

- (MKTextField *)apnField {
    if (!_apnField) {
        _apnField = [self textFieldWithPlaceholder:@"0-100 Characters" maxLengh:100];
        @weakify(self);
        _apnField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_deviecSetting_textChanged:text textID:2];
            }
        };
    }
    return _apnField;
}

- (UILabel *)netUsernameLabel {
    if (!_netUsernameLabel) {
        _netUsernameLabel = [self msgLabel:@"Username" font:MKFont(13.f)];
    }
    return _netUsernameLabel;
}

- (MKTextField *)netUsernameField {
    if (!_netUsernameField) {
        _netUsernameField = [self textFieldWithPlaceholder:@"0-127 Characters" maxLengh:127];
        @weakify(self);
        _netUsernameField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_deviecSetting_textChanged:text textID:3];
            }
        };
    }
    return _netUsernameField;
}

- (UILabel *)netPasswordLabel {
    if (!_netPasswordLabel) {
        _netPasswordLabel = [self msgLabel:@"Password" font:MKFont(13.f)];
    }
    return _netPasswordLabel;
}

- (MKTextField *)netPasswordField {
    if (!_netPasswordField) {
        _netPasswordField = [self textFieldWithPlaceholder:@"0-127 Characters" maxLengh:127];
        @weakify(self);
        _netPasswordField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_deviecSetting_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_deviecSetting_textChanged:text textID:4];
            }
        };
    }
    return _netPasswordField;
}

- (UILabel *)netPriorityLabel {
    if (!_netPriorityLabel) {
        _netPriorityLabel = [self msgLabel:@"Network Priority" font:MKFont(13.f)];
    }
    return _netPriorityLabel;
}

- (UIButton *)priorityButton {
    if (!_priorityButton) {
        _priorityButton = [MKCustomUIAdopter customButtonWithTitle:@"eMTC->NB-IOT->GSM"
                                                            target:self
                                                            action:@selector(priorityButtonPressed)];
        [_priorityButton.titleLabel setFont:MKFont(12.f)];
    }
    return _priorityButton;
}

- (UIView *)debugLineView {
    if (!_debugLineView) {
        _debugLineView = [self loadLineView];
    }
    return _debugLineView;
}

- (UILabel *)debugLineMsgLabel {
    if (!_debugLineMsgLabel) {
        _debugLineMsgLabel = [self msgLabel:@"Advanced Setting" font:MKFont(15.f)];
    }
    return _debugLineMsgLabel;
}

- (UILabel *)debugLabel {
    if (!_debugLabel) {
        _debugLabel = [self msgLabel:@"Debug Mode" font:MKFont(13.f)];
    }
    return _debugLabel;
}

- (UIButton *)debugButton {
    if (!_debugButton) {
        _debugButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_debugButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJServerConfigDeviceSettingView", @"nbj_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_debugButton addTarget:self
                         action:@selector(debugButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _debugButton;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [MKCustomUIAdopter customButtonWithTitle:@"Export Demo File"
                                                          target:self
                                                          action:@selector(exportButtonPressed)];
        _exportButton.titleLabel.font = MKFont(13.f);
    }
    return _exportButton;
}

- (UIButton *)importButton {
    if (!_importButton) {
        _importButton = [MKCustomUIAdopter customButtonWithTitle:@"Import Config File"
                                                          target:self
                                                          action:@selector(importButtonPressed)];
        _importButton.titleLabel.font = MKFont(13.f);
    }
    return _importButton;
}

- (NSArray *)timeZoneList {
    if (!_timeZoneList) {
        _timeZoneList = @[@"UTC-12:00",@"UTC-11:30",@"UTC-11:00",@"UTC-10:30",@"UTC-10:00",@"UTC-09:30",
                          @"UTC-09:00",@"UTC-08:30",@"UTC-08:00",@"UTC-07:30",@"UTC-07:00",@"UTC-06:30",
                          @"UTC-06:00",@"UTC-05:30",@"UTC-05:00",@"UTC-04:30",@"UTC-04:00",@"UTC-03:30",
                          @"UTC-03:00",@"UTC-02:30",@"UTC-02:00",@"UTC-01:30",@"UTC-01:00",@"UTC-00:30",
                          @"UTC+00:00",@"UTC+00:30",@"UTC+01:00",@"UTC+01:30",@"UTC+02:00",@"UTC+02:30",
                          @"UTC+03:00",@"UTC+03:30",@"UTC+04:00",@"UTC+04:30",@"UTC+05:00",@"UTC+05:30",
                          @"UTC+06:00",@"UTC+06:30",@"UTC+07:00",@"UTC+07:30",@"UTC+08:00",@"UTC+08:30",
                          @"UTC+09:00",@"UTC+09:30",@"UTC+10:00",@"UTC+10:30",@"UTC+11:00",@"UTC+11:30",
                          @"UTC+12:00",@"UTC+12:30",@"UTC+13:00",@"UTC+13:30",@"UTC+14:00"];
    }
    return _timeZoneList;
}

- (NSArray *)priorityList {
    if (!_priorityList) {
        _priorityList = @[@"eMTC->NB-IOT->GSM",@"eMTC-> GSM -> NB-IOT",@"NB-IOT->GSM-> eMTC",
                          @"NB-IOT-> eMTC-> GSM",@"GSM -> NB-IOT-> eMTC",@"GSM -> eMTC->NB-IOT",
                          @"eMTC->NB-IOT",@"NB-IOT-> eMTC",@"GSM",@"NB-IOT",@"eMTC"];
    }
    return _priorityList;
}

- (UIView *)loadLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBCOLOR(242, 242, 242);
    return lineView;
}

- (UILabel *)msgLabel:(NSString *)msg font:(UIFont *)font {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = font;
    msgLabel.text = msg;
    return msgLabel;
}

- (MKTextField *)textFieldWithPlaceholder:(NSString *)placeholder maxLengh:(NSInteger)maxLengh {
    MKTextField *textField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
    textField.maxLength = maxLengh;
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = MKFont(13.f);
    textField.textColor = DEFAULT_TEXT_COLOR;
    
    textField.backgroundColor = COLOR_WHITE_MACROS;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = CUTTING_LINE_HEIGHT;
    textField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
    textField.layer.cornerRadius = 6.f;
    return textField;
}

@end
