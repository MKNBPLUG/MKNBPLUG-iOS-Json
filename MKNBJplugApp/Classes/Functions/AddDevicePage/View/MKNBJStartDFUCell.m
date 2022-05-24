//
//  MKNBJStartDFUCell.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJStartDFUCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKNBJStartDFUCellModel
@end

@interface MKNBJStartDFUCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *startButton;

@end

@implementation MKNBJStartDFUCell

+ (MKNBJStartDFUCell *)initCellWithTableView:(UITableView *)tableView {
    MKNBJStartDFUCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNBJStartDFUCellIdenty"];
    if (!cell) {
        cell = [[MKNBJStartDFUCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNBJStartDFUCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.startButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(65.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.startButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)startButtonPressed {
    if ([self.delegate respondsToSelector:@selector(nbj_startDfuButtonPressed)]) {
        [self.delegate nbj_startDfuButtonPressed];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKNBJStartDFUCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNBJStartDFUCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
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

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [MKCustomUIAdopter customButtonWithTitle:@"Start"
                                                         target:self
                                                         action:@selector(startButtonPressed)];
    }
    return _startButton;
}

@end
