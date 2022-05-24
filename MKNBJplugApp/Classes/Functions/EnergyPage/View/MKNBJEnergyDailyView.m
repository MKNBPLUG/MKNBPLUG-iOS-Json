//
//  MKNBJEnergyDailyView.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/1.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJEnergyDailyView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "MKBaseTableView.h"

#import "MKCustomUIAdopter.h"

#import "MKNBJMQTTServerManager.h"

#import "MKNBJEnergyDataCell.h"

@interface MKNBJEnergyDailyView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UILabel *energyLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIView *msgView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation MKNBJEnergyDailyView

- (void)dealloc {
    NSLog(@"MKNBJEnergyDailyView销毁");
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
                                                 selector:@selector(receiveDailyDatas:)
                                                     name:MKNBJReceiveMonthlyEnergyDataNotification
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
- (void)receiveDailyDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    [self updateDailyDatas:dic];
}

#pragma mark - public method
- (void)updateDailyDatas:(NSDictionary *)dic {
    if (!ValidDict(dic)) {
        return;
    }
    [self.dataList removeAllObjects];
    NSString *currentTime = [NSString stringWithFormat:@"%@-%@-%@",SafeStr(dic[@"year"]),SafeStr(dic[@"month"]),SafeStr(dic[@"day"])];
    NSDate *currentDate = [self.dateFormatter dateFromString:currentTime];
    
    NSArray *tempList = dic[@"energyList"];
    NSString *number = dic[@"number"];
    
    NSString *startTime = @"";
    NSString *endTime = @"";
    
    float totalValue = 0;
    for (NSInteger i = 0; i < tempList.count; i ++) {
        float tempValue = [tempList[i] floatValue];
        totalValue += tempValue;
        NSString *dateString = [self getDateString:currentDate days:i];
        if (i == 0) {
            endTime = dateString;
        }
        if (i == tempList.count - 1) {
            startTime = dateString;
        }
        MKNBJEnergyDataCellModel *cellModel = [[MKNBJEnergyDataCellModel alloc] init];
        cellModel.leftMsg = dateString;
        cellModel.rightMsg = tempList[i];
        [self.dataList addObject:cellModel];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@ to %@",startTime,endTime];
    NSString *totalValueString = [NSString stringWithFormat:@"%.2f",totalValue];
    self.energyLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Last 30 days energy: ",totalValueString,@"KWh"]
                                                                    fonts:@[MKFont(13.f),MKFont(17.f),MKFont(17.f)]
                                                                   colors:@[DEFAULT_TEXT_COLOR,NAVBAR_COLOR_MACROS,NAVBAR_COLOR_MACROS]];
    
    [self.tableView reloadData];
}

#pragma mark - private method
- (NSString *)getDateString:(NSDate *)currentDate days:(NSInteger)days {
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSDate *date = [currentDate initWithTimeIntervalSinceNow:-(oneDay * days)];
    NSString *string = [self.dateFormatter stringFromDate:date];
    NSArray *stringList = [string componentsSeparatedByString:@"-"];
    
    return [NSString stringWithFormat:@"%@-%@",stringList[1],stringList[2]];
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
        hourLabel.text = @"Date";
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

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

@end
