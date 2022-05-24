//
//  MKNBJSystemTimeCell.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJSystemTimeCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKCustomUIAdopter.h"

@implementation MKNBJSystemTimeCellModel
@end

@interface MKNBJSystemTimeCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *rightButton;

@end

@implementation MKNBJSystemTimeCell

+ (MKNBJSystemTimeCell *)initCellWithTableView:(UITableView *)tableView {
    MKNBJSystemTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNBJSystemTimeCellIdenty"];
    if (!cell) {
        cell = [[MKNBJSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNBJSystemTimeCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rightButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)rightButtonPressed {
    if ([self.delegate respondsToSelector:@selector(nbj_systemTimeButtonPressed:)]) {
        [self.delegate nbj_systemTimeButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKNBJSystemTimeCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNBJSystemTimeCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    [self.rightButton setTitle:SafeStr(_dataModel.buttonTitle) forState:UIControlStateNormal];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [MKCustomUIAdopter customButtonWithTitle:@""
                                                         target:self
                                                         action:@selector(rightButtonPressed)];
    }
    return _rightButton;
}

@end
