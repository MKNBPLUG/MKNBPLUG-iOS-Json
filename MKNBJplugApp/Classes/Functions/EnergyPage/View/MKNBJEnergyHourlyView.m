//
//  MKNBJEnergyHourlyView.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/1.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJEnergyHourlyView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "MKBaseTableView.h"

#import "MKCustomUIAdopter.h"

#import "MKNBJMQTTServerManager.h"

#import "MKNBJEnergyDataCell.h"

@interface MKNBJEnergyHourlyView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UILabel *energyLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIView *msgView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKNBJEnergyHourlyView

- (void)dealloc {
    NSLog(@"MKNBJEnergyHourlyView销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.energyLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.msgView];
        [self addSubview:self.tableView];
        self.backgroundColor = COLOR_WHITE_MACROS;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveHourlyDatas:)
                                                     name:MKNBJReceiveHourlyEnergyDataNotification
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
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.energyLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.msgView.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJEnergyDataCell *cell = [MKNBJEnergyDataCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - note
- (void)receiveHourlyDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    [self updateHourlyDatas:dic];
}

#pragma mark - public method
- (void)updateHourlyDatas:(NSDictionary *)dic {
    if (!ValidDict(dic)) {
        return;
    }
    [self.dataList removeAllObjects];
    NSArray *tempList = dic[@"energyList"];
    NSString *number = dic[@"number"];
    NSString *time = [NSString stringWithFormat:@"00:00 to %@:00",(number.length == 1 ? [@"0" stringByAppendingString:number] : number)];
    self.timeLabel.text = [NSString stringWithFormat:@"%@,%@-%@",time,SafeStr(dic[@"month"]),SafeStr(dic[@"day"])];
    float totalValue = 0;
    for (NSInteger i = 0; i < tempList.count; i ++) {
        float tempValue = [tempList[i] floatValue];
        totalValue += tempValue;
        NSString *tempLeft = [NSString stringWithFormat:@"%ld",(long)i];
        if (tempLeft.length == 1) {
            tempLeft = [@"0" stringByAppendingString:tempLeft];
        }
        MKNBJEnergyDataCellModel *cellModel = [[MKNBJEnergyDataCellModel alloc] init];
        cellModel.leftMsg = [NSString stringWithFormat:@"%@:00",tempLeft];
        cellModel.rightMsg = tempList[i];
        [self.dataList addObject:cellModel];
    }
    self.dataList = [[self.dataList reverseObjectEnumerator] allObjects];
    NSString *totalValueString = [NSString stringWithFormat:@"%.2f",totalValue];
    self.energyLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Today energy: ",totalValueString,@"KWh"]
                                                                    fonts:@[MKFont(13.f),MKFont(17.f),MKFont(17.f)]
                                                                   colors:@[DEFAULT_TEXT_COLOR,NAVBAR_COLOR_MACROS,NAVBAR_COLOR_MACROS]];
    
    [self.tableView reloadData];
}

#pragma mark - getter
- (UILabel *)energyLabel {
    if (!_energyLabel) {
        _energyLabel = [[UILabel alloc] init];
        _energyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _energyLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGBCOLOR(128, 128, 128);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = MKFont(13.f);
    }
    return _timeLabel;
}

- (UIView *)msgView {
    if (!_msgView) {
        _msgView = [[UIView alloc] init];
        
        UILabel *hourLabel = [[UILabel alloc] init];
        hourLabel.textColor = DEFAULT_TEXT_COLOR;
        hourLabel.textAlignment = NSTextAlignmentLeft;
        hourLabel.font = MKFont(13.f);
        hourLabel.text = @"Hour";
        [_msgView addSubview:hourLabel];
        
        [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.width.mas_equalTo(80.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        UILabel *kwLabel = [[UILabel alloc] init];
        kwLabel.textColor = DEFAULT_TEXT_COLOR;
        kwLabel.textAlignment = NSTextAlignmentRight;
        kwLabel.font = MKFont(13.f);
        kwLabel.text = @"KWh";
        [_msgView addSubview:kwLabel];
        
        [kwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15.f);
            make.width.mas_equalTo(80.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _msgView;
}

- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
