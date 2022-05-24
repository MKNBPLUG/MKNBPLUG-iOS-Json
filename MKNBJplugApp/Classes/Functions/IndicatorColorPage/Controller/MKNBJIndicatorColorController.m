//
//  MKNBJIndicatorColorController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/10/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJIndicatorColorController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKNBJIndicatorColorModel.h"

#import "MKNBJIndicatorColorCell.h"
#import "MKNBJIndicatorColorHeaderView.h"

@interface MKNBJIndicatorColorController ()<UITableViewDelegate,
UITableViewDataSource,
MKNBJIndicatorColorHeaderViewDelegate,
MKNBJIndicatorColorCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKNBJIndicatorColorHeaderView *tableHeaderView;

@property (nonatomic, strong)MKNBJIndicatorColorModel *dataModel;

@end

@implementation MKNBJIndicatorColorController

- (void)dealloc {
    NSLog(@"MKNBJIndicatorColorController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.dataModel.colorType == nbj_ledColorTransitionDirectly || self.dataModel.colorType == nbj_ledColorTransitionSmoothly) ? self.dataList.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJIndicatorColorCell *cell = [MKNBJIndicatorColorCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKNBJIndicatorColorHeaderViewDelegate
- (void)nbj_colorSettingPickViewTypeChanged:(NSInteger)colorType {
    if (self.dataModel.colorType == colorType) {
        return;
    }
    self.dataModel.colorType = colorType;
    [self.tableView reloadData];
}

#pragma mark - MKNBJIndicatorColorCellDelegate
- (void)nbj_ledColorChanged:(NSString *)value index:(NSInteger)index {
    MKNBJIndicatorColorCellModel *cellModel = self.dataList[index];
    cellModel.textValue = value;
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

- (void)saveDataToDevice {
    MKNBJIndicatorColorCellModel *bModel = self.dataList[0];
    self.dataModel.b_color = [bModel.textValue integerValue];
    MKNBJIndicatorColorCellModel *gModel = self.dataList[1];
    self.dataModel.g_color = [gModel.textValue integerValue];
    MKNBJIndicatorColorCellModel *yModel = self.dataList[2];
    self.dataModel.y_color = [yModel.textValue integerValue];
    MKNBJIndicatorColorCellModel *oModel = self.dataList[3];
    self.dataModel.o_color = [oModel.textValue integerValue];
    MKNBJIndicatorColorCellModel *rModel = self.dataList[4];
    self.dataModel.r_color = [rModel.textValue integerValue];
    MKNBJIndicatorColorCellModel *pModel = self.dataList[5];
    self.dataModel.p_color = [pModel.textValue integerValue];
    
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self.tableHeaderView updateColorType:self.dataModel.colorType];
    
    MKNBJIndicatorColorCellModel *bModel = [[MKNBJIndicatorColorCellModel alloc] init];
    bModel.msg = @"Measured power for blue LED(W)";
    bModel.placeholder = @"";
    bModel.index = 0;
    bModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.b_color];
    [self.dataList addObject:bModel];
    
    MKNBJIndicatorColorCellModel *gModel = [[MKNBJIndicatorColorCellModel alloc] init];
    gModel.msg = @"Measured power for green LED(W)";
    gModel.placeholder = @"";
    gModel.index = 1;
    gModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.g_color];
    [self.dataList addObject:gModel];
    
    MKNBJIndicatorColorCellModel *yModel = [[MKNBJIndicatorColorCellModel alloc] init];
    yModel.msg = @"Measured power for yellow LED(W)";
    yModel.placeholder = @"";
    yModel.index = 2;
    yModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.y_color];
    [self.dataList addObject:yModel];
    
    MKNBJIndicatorColorCellModel *oModel = [[MKNBJIndicatorColorCellModel alloc] init];
    oModel.msg = @"Measured power for orange LED(W)";
    oModel.placeholder = @"";
    oModel.index = 3;
    oModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.o_color];
    [self.dataList addObject:oModel];
    
    MKNBJIndicatorColorCellModel *rModel = [[MKNBJIndicatorColorCellModel alloc] init];
    rModel.msg = @"Measured power for red LED(W)";
    rModel.placeholder = @"";
    rModel.index = 4;
    rModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.r_color];
    [self.dataList addObject:rModel];
    
    MKNBJIndicatorColorCellModel *pModel = [[MKNBJIndicatorColorCellModel alloc] init];
    pModel.msg = @"Measured power for purple LED(W)";
    pModel.placeholder = @"";
    pModel.index = 5;
    pModel.textValue = [NSString stringWithFormat:@"%ld",(long)self.dataModel.p_color];
    [self.dataList addObject:pModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Indicator Setting";
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJIndicatorColorController", @"nbj_slotSaveIcon.png") forState:UIControlStateNormal];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKNBJIndicatorColorHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MKNBJIndicatorColorHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 200.f)];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (MKNBJIndicatorColorModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJIndicatorColorModel alloc] init];
    }
    return _dataModel;
}

@end
