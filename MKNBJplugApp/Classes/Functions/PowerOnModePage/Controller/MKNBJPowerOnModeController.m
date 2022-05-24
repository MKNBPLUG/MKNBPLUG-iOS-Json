//
//  MKNBJPowerOnModeController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJPowerOnModeController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"

#import "MKNBJPowerOnModeCell.h"

#import "MKNBJPowerOnModeModel.h"

@interface MKNBJPowerOnModeController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKNBJPowerOnModeModel *dataModel;

@end

@implementation MKNBJPowerOnModeController

- (void)dealloc {
    NSLog(@"MKNBJPowerOnModeController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSInteger tempMode = self.dataModel.mode;
    self.dataModel.mode = indexPath.row;
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            MKNBJPowerOnModeCellModel *cellModel = self.dataList[i];
            cellModel.selected = (i == indexPath.row);
        }
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        self.dataModel.mode = tempMode;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJPowerOnModeCell *cell = [MKNBJPowerOnModeCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}


#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKNBJPowerOnModeCellModel *cellModel1 = [[MKNBJPowerOnModeCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"OFF";
    cellModel1.selected = (self.dataModel.mode == 0);
    [self.dataList addObject:cellModel1];
    
    MKNBJPowerOnModeCellModel *cellModel2 = [[MKNBJPowerOnModeCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"ON";
    cellModel2.selected = (self.dataModel.mode == 1);
    [self.dataList addObject:cellModel2];
    
    MKNBJPowerOnModeCellModel *cellModel3 = [[MKNBJPowerOnModeCellModel alloc] init];
    cellModel3.index = 0;
    cellModel3.msg = @"Restore to last status";
    cellModel3.selected = (self.dataModel.mode == 2);
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Power On Deafault Mode";
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKNBJPowerOnModeModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJPowerOnModeModel alloc] init];
    }
    return _dataModel;
}

@end
