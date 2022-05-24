//
//  MKNBJElectricityController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJElectricityController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKNBJElectricityModel.h"

@interface MKNBJElectricityController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKNBJElectricityModel *dataModel;

@end

@implementation MKNBJElectricityController

- (void)dealloc {
    NSLog(@"MKNBJElectricityController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self readDatasFromDevice];
    @weakify(self);
    self.dataModel.receiveElectricityBlock = ^{
        @strongify(self);
        [self updateElectricityDatas];
    };
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.section];
    return cell;
}

#pragma mark - note


#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateElectricityDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSections

- (void)updateElectricityDatas {
    MKNormalTextCellModel *cellModel1 = self.dataList[0];
    cellModel1.rightMsg = self.dataModel.voltage;

    MKNormalTextCellModel *cellModel2 = self.dataList[1];
    cellModel2.rightMsg = self.dataModel.current;
    
    MKNormalTextCellModel *cellModel3 = self.dataList[2];
    cellModel3.rightMsg = self.dataModel.power;
    
    MKNormalTextCellModel *cellModel4 = self.dataList[3];
    cellModel4.rightMsg = self.dataModel.factor;
    
    MKNormalTextCellModel *cellModel5 = self.dataList[4];
    cellModel5.rightMsg = self.dataModel.frequency;
   
    [self.tableView reloadData];
}

- (void)loadSectionDatas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftIcon = LOADICON(@"MKNBJplugApp", @"MKNBJElectricityController", @"nbj_powerPage_voltageIcon.png");
    cellModel1.leftMsg = @"Voltage(V)";
    [self.dataList addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftIcon = LOADICON(@"MKNBJplugApp", @"MKNBJElectricityController", @"nbj_powerPage_currentIcon.png");
    cellModel2.leftMsg = @"Current(mA)";
    [self.dataList addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftIcon = LOADICON(@"MKNBJplugApp", @"MKNBJElectricityController", @"nbj_powerPage_powerIcon.png");
    cellModel3.leftMsg = @"Power(W)";
    [self.dataList addObject:cellModel3];
    
    MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
    cellModel4.leftIcon = LOADICON(@"MKNBJplugApp", @"MKNBJElectricityController", @"nbj_powerPage_powerFactorIcon.png");
    cellModel4.leftMsg = @"Power Factor";
    [self.dataList addObject:cellModel4];
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.leftIcon = LOADICON(@"MKNBJplugApp", @"MKNBJElectricityController", @"nbj_powerPage_frequencyIcon.png");
    cellModel5.leftMsg = @"Frequency(HZ)";
    [self.dataList addObject:cellModel5];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Electricity Management";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
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

- (MKNBJElectricityModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJElectricityModel alloc] init];
    }
    return _dataModel;
}

@end
