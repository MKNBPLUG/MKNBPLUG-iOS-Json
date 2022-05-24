//
//  MKNBJModifyServerSettingView.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/6.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJModifyServerSettingView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"
#import "MKTextField.h"

@implementation MKNBJModifyServerSettingViewModel
@end

@interface MKNBJModifyServerSettingView ()

@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UILabel *topMsgLabel;

@property (nonatomic, strong)UILabel *apnLabel;

@property (nonatomic, strong)MKTextField *apnField;

@property (nonatomic, strong)UILabel *netUsernameLabel;

@property (nonatomic, strong)MKTextField *netUsernameField;

@property (nonatomic, strong)UILabel *netPasswordLabel;

@property (nonatomic, strong)MKTextField *netPasswordField;

@property (nonatomic, strong)UILabel *netPriorityLabel;

@property (nonatomic, strong)UIButton *priorityButton;

@property (nonatomic, strong)NSArray *priorityList;

@end

@implementation MKNBJModifyServerSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLineView];
        [self.topLineView addSubview:self.topMsgLabel];
        [self addSubview:self.apnLabel];
        [self addSubview:self.apnField];
        [self addSubview:self.netUsernameLabel];
        [self addSubview:self.netUsernameField];
        [self addSubview:self.netPasswordLabel];
        [self addSubview:self.netPasswordField];
        [self addSubview:self.netPriorityLabel];
        [self addSubview:self.priorityButton];
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
    [self.apnField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.apnLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.topMsgLabel.mas_bottom).mas_offset(10.f);
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
}

#pragma mark - event method
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
        if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyDevice_networkPriorityChanged:)]) {
            [self.delegate nbj_mqtt_modifyDevice_networkPriorityChanged:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKNBJModifyServerSettingViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNBJModifyServerSettingViewModel.class]) {
        return;
    }
    self.apnField.text = SafeStr(_dataModel.apn);
    self.netUsernameField.text = SafeStr(_dataModel.networkUsername);
    self.netPasswordField.text = SafeStr(_dataModel.networkPassword);
    if (_dataModel.networkPriority < 0 || _dataModel.networkPriority > 10) {
        return;
    }
    [self.priorityButton setTitle:self.priorityList[_dataModel.networkPriority] forState:UIControlStateNormal];
}

#pragma mark - getter
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _topLineView;
}

- (UILabel *)topMsgLabel {
    if (!_topMsgLabel) {
        _topMsgLabel = [[UILabel alloc] init];
        _topMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _topMsgLabel.textAlignment = NSTextAlignmentLeft;
        _topMsgLabel.font = MKFont(15.f);
        _topMsgLabel.text = @"Network Setting";
    }
    return _topMsgLabel;
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
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyDevice_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_modifyDevice_textChanged:text textID:0];
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
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyDevice_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_modifyDevice_textChanged:text textID:1];
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
            if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyDevice_textChanged:textID:)]) {
                [self.delegate nbj_mqtt_modifyDevice_textChanged:text textID:2];
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

- (NSArray *)priorityList {
    if (!_priorityList) {
        _priorityList = @[@"eMTC->NB-IOT->GSM",@"eMTC-> GSM -> NB-IOT",@"NB-IOT->GSM-> eMTC",
                          @"NB-IOT-> eMTC-> GSM",@"GSM -> NB-IOT-> eMTC",@"GSM -> eMTC->NB-IOT",
                          @"eMTC->NB-IOT",@"NB-IOT-> eMTC",@"GSM",@"NB-IOT",@"eMTC"];
    }
    return _priorityList;
}

@end
