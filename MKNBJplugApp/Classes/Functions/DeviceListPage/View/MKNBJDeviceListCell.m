//
//  MKNBJDeviceListCell.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJDeviceListCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModel.h"

@interface MKNBJDeviceListCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *stateLabel;

@property (nonatomic, strong)UIImageView *nextIcon;

@property (nonatomic, strong)UIButton *stateButton;

@end

@implementation MKNBJDeviceListCell

+ (MKNBJDeviceListCell *)initCellWithTableView:(UITableView *)tableView {
    MKNBJDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNBJDeviceListCellIdenty"];
    if (!cell) {
        cell = [[MKNBJDeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNBJDeviceListCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.deviceNameLabel];
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.nextIcon];
        [self.contentView addSubview:self.stateButton];
        [self addLongPressEventAction];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(33.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(33.f);
    }];
    [self.deviceNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.nextIcon.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(self.deviceNameLabel.mas_width);
        make.bottom.mas_equalTo(-10.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.nextIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.stateButton.mas_left).mas_offset(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
    [self.stateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)stateButtonPressed {
    if ([self.delegate respondsToSelector:@selector(nbj_deviceStateChanged:)]) {
        [self.delegate nbj_deviceStateChanged:self.dataModel];
    }
}

- (void)longPressEventAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(nbj_cellDeleteButtonPressed:)]) {
            [self.delegate nbj_cellDeleteButtonPressed:self.indexPath.row];
        }
    }
}

#pragma mark - setter
- (void)setDataModel:(MKNBJDeviceModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNBJDeviceModel.class]) {
        return;
    }
    self.deviceNameLabel.text = SafeStr(_dataModel.deviceName);
    
    if (_dataModel.state == MKNBJDeviceModelStateOffline) {
        //是否在线优先级最高
        self.stateLabel.text = @"Offline";
        self.stateLabel.textColor = UIColorFromRGB(0xcccccc);
        [self.stateButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJDeviceListCell", @"nbj_switchUnselectedIcon.png") forState:UIControlStateNormal];
        return;
    }
    
    if (_dataModel.overState != MKNBJDeviceOverState_normal) {
        //设备处于过载、过流、过压状态
        self.stateLabel.textColor = [UIColor redColor];
        [self.stateButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJDeviceListCell", @"nbj_switchUnselectedIcon.png") forState:UIControlStateNormal];
        if (_dataModel.overState == MKNBJDeviceOverState_overLoad) {
            //过载
            self.stateLabel.text = @"Overload";
        }else if (_dataModel.overState == MKNBJDeviceOverState_overCurrent) {
            //过流
            self.stateLabel.text = @"Overcurrent";
        }else if (_dataModel.overState == MKNBJDeviceOverState_overVoltage) {
            //过压
            self.stateLabel.text = @"Overvoltage";
        }else if (_dataModel.overState == MKNBJDeviceOverState_underVoltage) {
            //欠压
            self.stateLabel.text = @"Undervoltage";
        }
        return;
    }
    //正常状态
    self.stateLabel.textColor = (_dataModel.state == MKNBJDeviceModelStateOn) ? UIColorFromRGB(0x0188cc) : UIColorFromRGB(0xcccccc);
    if (_dataModel.state == MKNBJDeviceModelStateOn) {
        self.stateLabel.text = @"ON";
    }else if (_dataModel.state == MKNBJDeviceModelStateOff) {
        self.stateLabel.text = @"OFF";
    }
    UIImage *stateIcon = (_dataModel.state == MKNBJDeviceModelStateOn) ? LOADICON(@"MKNBJplugApp", @"MKNBJDeviceListCell", @"nbj_switchSelectedIcon.png") : LOADICON(@"MKNBJplugApp", @"MKNBJDeviceListCell", @"nbj_switchUnselectedIcon.png");
    [self.stateButton setImage:stateIcon forState:UIControlStateNormal];
}

#pragma mark - private method
- (void)addLongPressEventAction {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    [longPress addTarget:self action:@selector(longPressEventAction:)];
    [self.contentView addGestureRecognizer:longPress];
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDeviceListCell", @"nbj_deviceListIcon.png");
    }
    return _leftIcon;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(14.f);
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    return _deviceNameLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = UIColorFromRGB(0xcccccc);
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.font = MKFont(12.f);
    }
    return _stateLabel;
}

- (UIImageView *)nextIcon {
    if (!_nextIcon) {
        _nextIcon = [[UIImageView alloc] init];
        _nextIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDeviceListCell", @"mk_nbj_goNextIcon.png");
    }
    return _nextIcon;
}

- (UIButton *)stateButton {
    if (!_stateButton) {
        _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stateButton addTarget:self
                         action:@selector(stateButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateButton;
}

@end
