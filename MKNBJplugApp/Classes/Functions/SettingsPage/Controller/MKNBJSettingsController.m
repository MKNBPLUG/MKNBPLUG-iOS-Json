//
//  MKNBJSettingsController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJSettingsController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKSettingTextCell.h"
#import "MKTextSwitchCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKAlertView.h"

#import "MKNBJDeviceListDatabaseManager.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJSettingsPageModel.h"
#import "MKNBJSettingPageBleModel.h"

#import "MKNBJPowerOnModeController.h"
#import "MKNBJPeriodicalReportController.h"
#import "MKNBJPowerReportController.h"
#import "MKNBJEnergyParamController.h"
#import "MKNBJConnectSettingController.h"
#import "MKNBJSystemTimeController.h"
#import "MKNBJProtectionSwitchController.h"
#import "MKNBJNotificationSwitchController.h"
#import "MKNBJIndicatorSettingController.h"
#import "MKNBJModifyServerController.h"
#import "MKNBJOTAController.h"
#import "MKNBJMQTTSettingInfoController.h"
#import "MKNBJDeviceInfoController.h"
#import "MKNBJDebuggerController.h"

@interface MKNBJSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKNBJSettingsPageModel *dataModel;

@property (nonatomic, strong)MKNBJSettingPageBleModel *bleDataModel;

@property (nonatomic, copy)NSString *localNameAsciiStr;

@end

@implementation MKNBJSettingsController

- (void)dealloc {
    NSLog(@"MKNBJSettingsController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self configLocalName];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 3 || section == 5) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //Power On Default Mode
        MKNBJPowerOnModeController *vc = [[MKNBJPowerOnModeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //Period Reporting
        MKNBJPeriodicalReportController *vc = [[MKNBJPeriodicalReportController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        //Power Report Setting
        MKNBJPowerReportController *vc = [[MKNBJPowerReportController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        //Energy Storage and Report
        MKNBJEnergyParamController *vc = [[MKNBJEnergyParamController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        //Connect Timeout  Setting
        MKNBJConnectSettingController *vc = [[MKNBJConnectSettingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 5) {
        //System Time
        MKNBJSystemTimeController *vc = [[MKNBJSystemTimeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        //Protection Switch
        MKNBJProtectionSwitchController *vc = [[MKNBJProtectionSwitchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        //Notification Switch
        MKNBJNotificationSwitchController *vc = [[MKNBJNotificationSwitchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        //Indicator  Setting
        MKNBJIndicatorSettingController *vc = [[MKNBJIndicatorSettingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        //Modify Network and MQTT
        MKNBJModifyServerController *vc = [[MKNBJModifyServerController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        //OTA
        MKNBJOTAController *vc = [[MKNBJOTAController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        //MQTT Settings for Device
        MKNBJMQTTSettingInfoController *vc = [[MKNBJMQTTSettingInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 4 && indexPath.row == 1) {
        //Device Information
        MKNBJDeviceInfoController *vc = [[MKNBJDeviceInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 0) {
        //Debug Mode
        [self startConnectDevice];
        return;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return (self.dataModel.debugMode ? 0 : self.section3List.count);
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return (self.dataModel.debugMode ? self.section5List.count : 0);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 4) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        return cell;
    }
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section5List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Switch by button
        [self configSwitchStatus:isOn];
        return;
    }
}

#pragma mark - event method
- (void)removeButtonPressed {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self removeDevice];
    }];
    NSString *msg = @"Please confirm again whether to remove the device，the device will be deleted from the device list.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Remove Device" message:msg notificationName:@"mk_nbj_needDismissAlert"];
}

- (void)resetButtonPressed {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self resetDevice];
    }];
    NSString *msg = @"After reset, the device will be removed from the device list, and relevant data will be totally cleared.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Reset Device" message:msg notificationName:@"mk_nbj_needDismissAlert"];
}

#pragma mark - interface
- (void)readDataFromDevice {
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

- (void)configSwitchStatus:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configSwitchByButton:isOn sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        MKTextSwitchCellModel *cellModel = self.section2List[0];
        cellModel.isOn = isOn;
        self.dataModel.switchByButton = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)resetDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel resetDeviceWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self removeDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Debug mode页面
- (void)startConnectDevice {
    @weakify(self);
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [self.bleDataModel connectDeviceWithMacAddress:self.dataModel.macAddress
                                          sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self pushDebugModePage];
    }
                                       failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)pushDebugModePage {
    MKNBJDebuggerController *vc = [[MKNBJDebuggerController alloc] init];
    vc.macAddress = self.dataModel.macAddress;
    @weakify(self);
    vc.deviceExitDebugModeBlock = ^{
        @strongify(self);
        [self removeDevice];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 移除本地设备
- (void)removeDevice {
    [[MKHudManager share] showHUDWithTitle:@"Delete..." inView:self.view isPenetration:NO];
    [MKNBJDeviceListDatabaseManager deleteDeviceWithMacAddress:self.dataModel.macAddress sucBlock:^{
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_nbj_deleteDeviceNotification"
                                                            object:nil
                                                          userInfo:@{@"macAddress":self.dataModel.macAddress}];
        [self popToViewControllerWithClassName:@"MKNBJDeviceListController"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 修改设备本地名称
- (void)configLocalName{
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self saveDeviceLocalName];
    }];
    self.localNameAsciiStr = SafeStr([MKNBJDeviceModeManager shared].deviceName);
    MKAlertViewTextField *textField = [[MKAlertViewTextField alloc] initWithTextValue:SafeStr([MKNBJDeviceModeManager shared].deviceName)
                                                                          placeholder:@"1-20 characters"
                                                                        textFieldType:mk_normal
                                                                            maxLength:20
                                                                              handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.localNameAsciiStr = text;
    }];
    
    NSString *msg = @"Note:The local name should be 1-20 characters.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView addTextField:textField];
    [alertView showAlertWithTitle:@"Edit Local Name" message:msg notificationName:@"mk_nbj_needDismissAlert"];
}

- (void)saveDeviceLocalName {
    if (!ValidStr(self.localNameAsciiStr) || self.localNameAsciiStr.length > 20) {
        [self.view showCentralToast:@"The local name should be 1-20 characters."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Save..." inView:self.view isPenetration:NO];
    [MKNBJDeviceListDatabaseManager updateLocalName:self.localNameAsciiStr
                                         macAddress:[MKNBJDeviceModeManager shared].macAddress
                                           sucBlock:^{
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_nbj_deviceNameChangedNotification"
                                                            object:nil
                                                          userInfo:@{
                                                              @"macAddress":[MKNBJDeviceModeManager shared].macAddress,
                                                              @"deviceName":self.localNameAsciiStr
                                                          }];
    }
                                        failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    
    for (NSInteger i = 0; i < 6; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"Power On Default Mode";
    [self.section0List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Period Reporting";
    [self.section0List addObject:cellModel2];
    
    MKSettingTextCellModel *cellModel3 = [[MKSettingTextCellModel alloc] init];
    cellModel3.leftMsg = @"Power Report Setting";
    [self.section0List addObject:cellModel3];
    
    MKSettingTextCellModel *cellModel4 = [[MKSettingTextCellModel alloc] init];
    cellModel4.leftMsg = @"Energy Storage and Report";
    [self.section0List addObject:cellModel4];
    
    MKSettingTextCellModel *cellModel5 = [[MKSettingTextCellModel alloc] init];
    cellModel5.leftMsg = @"Connect Timeout  Setting";
    [self.section0List addObject:cellModel5];
    
    MKSettingTextCellModel *cellModel6 = [[MKSettingTextCellModel alloc] init];
    cellModel6.leftMsg = @"System Time";
    [self.section0List addObject:cellModel6];
}

- (void)loadSection1Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"Protection Switch";
    [self.section1List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Notification Switch";
    [self.section1List addObject:cellModel2];
    
    MKSettingTextCellModel *cellModel3 = [[MKSettingTextCellModel alloc] init];
    cellModel3.leftMsg = @"Indicator Setting";
    [self.section1List addObject:cellModel3];
}

- (void)loadSection2Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Switch by button";
    cellModel.isOn = self.dataModel.switchByButton;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"Modify Network and MQTT";
    [self.section3List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"OTA";
    [self.section3List addObject:cellModel2];
}

- (void)loadSection4Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"MQTT Settings for Device";
    cellModel1.leftMsgTextFont = MKFont(14.f);
    [self.section4List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Device Information";
    [self.section4List addObject:cellModel2];
}

- (void)loadSection5Datas {
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = @"Debug Mode";
    [self.section5List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Settings";
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJSettingsController", @"nbj_editIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKNBJSettingsPageModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJSettingsPageModel alloc] init];
    }
    return _dataModel;
}

- (MKNBJSettingPageBleModel *)bleDataModel {
    if (!_bleDataModel) {
        _bleDataModel = [[MKNBJSettingPageBleModel alloc] init];
    }
    return _bleDataModel;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 150.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    CGFloat offset_X = 60.f;
    
    UIButton *removeButton = [MKCustomUIAdopter customButtonWithTitle:@"Remove device"
                                                               target:self
                                                               action:@selector(removeButtonPressed)];
    removeButton.frame = CGRectMake(offset_X, 20.f, kViewWidth - 2 * offset_X, 40.f);
    [footerView addSubview:removeButton];
    
    UIButton *resetButton = [MKCustomUIAdopter customButtonWithTitle:@"Reset"
                                                              target:self
                                                              action:@selector(resetButtonPressed)];
    resetButton.frame = CGRectMake(offset_X, 20.f + 40.f + 10.f, kViewWidth - 2 * offset_X, 40.f);
    [footerView addSubview:resetButton];
    
    return footerView;
}

@end
