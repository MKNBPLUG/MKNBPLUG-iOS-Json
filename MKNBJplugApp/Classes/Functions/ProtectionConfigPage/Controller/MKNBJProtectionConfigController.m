//
//  MKNBJProtectionConfigController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJProtectionConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"

#import "MKNBJProtectionConfigModel.h"

@interface MKNBJProtectionConfigController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate>

@property (nonatomic, assign)nbj_protectionConfigType pageType;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKNBJProtectionConfigModel *dataModel;

@end

@implementation MKNBJProtectionConfigController

- (void)dealloc {
    NSLog(@"MKNBJProtectionConfigController销毁");
}

- (instancetype)initWithPageType:(nbj_protectionConfigType)type {
    if (self = [self init]) {
        self.pageType = type;
    }
    return self;
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
    if (indexPath.section == 1) {
        return 70.f;
    }
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Protection
        self.dataModel.isOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Over Threshold
        self.dataModel.overThreshold = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Time Threshold
        self.dataModel.timeThreshold = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
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
    if (self.pageType == nbj_protectionConfigType_overload) {
        [self loadOverLoadDatas];
    }else if (self.pageType == nbj_protectionConfigType_overvoltage) {
        [self loadOverVoltageDatas];
    }else if (self.pageType == nbj_protectionConfigType_undervoltage) {
        [self loadSagVoltageDatas];
    }else {
        [self loadOverCurrentDatas];
    }
    [self.tableView reloadData];
}

- (void)loadOverLoadDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Overload Protection";
    cellModel1.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 0;
    cellModel2.msg = @"Power threshold";
    cellModel2.unit = @"W";
    cellModel2.maxLength = 4;
    cellModel2.textFieldValue = self.dataModel.overThreshold;
    if (self.dataModel.specification == 0) {
        //欧法
        cellModel2.textPlaceholder = @"10~4416";
    }else if (self.dataModel.specification == 1) {
        //美规
        cellModel2.textPlaceholder = @"10~2160";
    }else {
        //英规
        cellModel2.textPlaceholder = @"10~3588";
    }
    [self.section1List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 1;
    cellModel3.msg = @"Time threshold";
    cellModel3.unit = @"sec";
    cellModel3.maxLength = 2;
    cellModel3.textPlaceholder = @"1 ~ 30";
    cellModel3.textFieldValue = self.dataModel.timeThreshold;
    [self.section1List addObject:cellModel3];
}

- (void)loadOverVoltageDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Overvoltage Protection";
    cellModel1.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 0;
    cellModel2.msg = @"Voltage threshold";
    cellModel2.unit = @"V";
    cellModel2.maxLength = 3;
    cellModel2.textFieldValue = self.dataModel.overThreshold;
    if (self.dataModel.specification == 0) {
        //欧法
        cellModel2.textPlaceholder = @"231~264";
    }else if (self.dataModel.specification == 1) {
        //美规
        cellModel2.textPlaceholder = @"121~138";
    }else {
        //英规
        cellModel2.textPlaceholder = @"231~264";
    }
    [self.section1List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 1;
    cellModel3.msg = @"Time threshold";
    cellModel3.unit = @"sec";
    cellModel3.maxLength = 2;
    cellModel3.textPlaceholder = @"1 ~ 30";
    cellModel3.textFieldValue = self.dataModel.timeThreshold;
    [self.section1List addObject:cellModel3];
}

- (void)loadSagVoltageDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Undervoltage Protection";
    cellModel1.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 0;
    cellModel2.msg = @"Voltage threshold";
    cellModel2.unit = @"V";
    cellModel2.maxLength = 3;
    cellModel2.textFieldValue = self.dataModel.overThreshold;
    if (self.dataModel.specification == 0) {
        //欧法
        cellModel2.textPlaceholder = @"196~229";
    }else if (self.dataModel.specification == 1) {
        //美规
        cellModel2.textPlaceholder = @"102~119";
    }else {
        //英规
        cellModel2.textPlaceholder = @"196~229";
    }
    [self.section1List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 1;
    cellModel3.msg = @"Time threshold";
    cellModel3.unit = @"sec";
    cellModel3.maxLength = 2;
    cellModel3.textPlaceholder = @"1 ~ 30";
    cellModel3.textFieldValue = self.dataModel.timeThreshold;
    [self.section1List addObject:cellModel3];
}

- (void)loadOverCurrentDatas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Overcurrent Protection";
    cellModel1.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 0;
    cellModel2.msg = @"Current threshold";
    cellModel2.unit = @"x0.1A";
    cellModel2.maxLength = 3;
    cellModel2.textFieldValue = self.dataModel.overThreshold;
    if (self.dataModel.specification == 0) {
        //欧法
        cellModel2.textPlaceholder = @"1~192";
    }else if (self.dataModel.specification == 1) {
        //美规
        cellModel2.textPlaceholder = @"1~180";
    }else {
        //英规
        cellModel2.textPlaceholder = @"1~156";
    }
    [self.section1List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 1;
    cellModel3.msg = @"Time threshold";
    cellModel3.unit = @"sec";
    cellModel3.maxLength = 2;
    cellModel3.textPlaceholder = @"1 ~ 30";
    cellModel3.textFieldValue = self.dataModel.timeThreshold;
    [self.section1List addObject:cellModel3];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [self currentTitle];
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJProtectionConfigController", @"nbj_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

- (NSString *)currentTitle {
    switch (self.pageType) {
        case nbj_protectionConfigType_overload:
            return @"Overload Protection";
        case nbj_protectionConfigType_overvoltage:
            return @"Overvoltage Protection";
        case nbj_protectionConfigType_undervoltage:
            return @"Undervoltage Protection";
        case nbj_protectionConfigType_overcurrent:
            return @"Overcurrent Protection";
    }
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (MKNBJProtectionConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJProtectionConfigModel alloc] initWithType:self.pageType];
    }
    return _dataModel;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
    footerView.backgroundColor = COLOR_WHITE_MACROS;
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = UIColorFromRGB(0x353535);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = MKFont(11.f);
    noteLabel.numberOfLines = 0;
    noteLabel.text = [self noteMsg];
    
    CGSize size = [NSString sizeWithText:noteLabel.text
                                 andFont:noteLabel.font
                              andMaxSize:CGSizeMake(kViewWidth - 2 * 15, MAXFLOAT)];
    noteLabel.frame = CGRectMake(15.f, 20.f, kViewWidth - 2 * 15.f, size.height);
    [footerView addSubview:noteLabel];
    
    return footerView;
}

- (NSString *)noteMsg {
    if (self.pageType == nbj_protectionConfigType_overload) {
        return @"When the measured power exceeds the protection threshold and the duration exceeds the time threshold, the device will turn off automatically.";
    }
    if (self.pageType == nbj_protectionConfigType_overvoltage) {
        return @"When the measured voltage exceeds the protection threshold and the duration exceeds the time threshold, the device will turn off automatically.";
    }
    if (self.pageType == nbj_protectionConfigType_undervoltage) {
        return @"When the measured voltage exceeds the protection threshold and the duration exceeds the time threshold, the device will turn off automatically.";
    }
    if (self.pageType == nbj_protectionConfigType_overcurrent) {
        return @"When the measured current exceeds the protection threshold and the duration exceeds the time threshold, the device will turn off automatically.";
    }
    return @"";
}

@end
