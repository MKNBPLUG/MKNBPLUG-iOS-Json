//
//  MKNBJEnergyTotalView.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/1.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJEnergyTotalView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

#import "MKNBJMQTTServerManager.h"

@interface MKNBJEnergyTotalView ()

@property (nonatomic, strong)UILabel *energyLabel;

@property (nonatomic, strong)UIButton *resetButton;

@end

@implementation MKNBJEnergyTotalView

- (void)dealloc {
    NSLog(@"MKNBJEnergyTotalView销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.energyLabel];
        [self addSubview:self.resetButton];
        self.backgroundColor = COLOR_WHITE_MACROS;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTotalEnergy:)
                                                     name:MKNBJReceiveTotalEnergyDataNotification
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.energyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(17.f).lineHeight);
    }];
}

#pragma mark - note
- (void)receiveTotalEnergy:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    [self updateTotalEnergy:SafeStr(dic[@"total"])];
}

#pragma mark - public method
- (void)updateTotalEnergy:(NSString *)total {
    if (!ValidStr(total)) {
        return;
    }
    self.energyLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Historical total energy: ",total,@"KWh"]
                                                                    fonts:@[MKFont(13.f),MKFont(17.f),MKFont(17.f)]
                                                                   colors:@[DEFAULT_TEXT_COLOR,NAVBAR_COLOR_MACROS,NAVBAR_COLOR_MACROS]];
}

#pragma mark - getter
- (UILabel *)energyLabel {
    if (!_energyLabel) {
        _energyLabel = [[UILabel alloc] init];
        _energyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _energyLabel;
}


@end
