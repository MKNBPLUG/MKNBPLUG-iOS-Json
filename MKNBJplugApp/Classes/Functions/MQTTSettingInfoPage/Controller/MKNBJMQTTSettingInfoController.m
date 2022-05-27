//
//  MKNBJMQTTSettingInfoController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTSettingInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"

#import "MKNBJMQTTSettingForDeviceCell.h"

#import "MKNBJMQTTSettingInfoModel.h"

@interface MKNBJMQTTSettingInfoController ()<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKNBJMQTTSettingInfoModel *dataModel;

@end

@implementation MKNBJMQTTSettingInfoController

- (void)dealloc {
    NSLog(@"MKNBJMQTTSettingInfoController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJMQTTSettingForDeviceCellModel *cellModel = self.dataList[indexPath.row];
    return [cellModel fetchCellHeight];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJMQTTSettingForDeviceCell *cell = [MKNBJMQTTSettingForDeviceCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - interface
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
    MKNBJMQTTSettingForDeviceCellModel *cellModel1 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel1.msg = @"Type";
    cellModel1.rightMsg = SafeStr(self.dataModel.type);
    [self.dataList addObject:cellModel1];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel2 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel2.msg = @"Host";
    cellModel2.rightMsg = SafeStr(self.dataModel.host);
    [self.dataList addObject:cellModel2];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel3 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel3.msg = @"Port";
    cellModel3.rightMsg = SafeStr(self.dataModel.port);
    [self.dataList addObject:cellModel3];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel4 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel4.msg = @"Client Id";
    cellModel4.rightMsg = SafeStr(self.dataModel.clientID);
    [self.dataList addObject:cellModel4];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel5 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel5.msg = @"Username";
    cellModel5.rightMsg = SafeStr(self.dataModel.userName);
    [self.dataList addObject:cellModel5];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel6 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel6.msg = @"Password";
    cellModel6.rightMsg = SafeStr(self.dataModel.password);
    [self.dataList addObject:cellModel6];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel7 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel7.msg = @"Clean Session";
    cellModel7.rightMsg = SafeStr(self.dataModel.cleanSession);
    [self.dataList addObject:cellModel7];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel8 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel8.msg = @"Qos";
    cellModel8.rightMsg = SafeStr(self.dataModel.qos);
    [self.dataList addObject:cellModel8];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel9 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel9.msg = @"Keep Alive";
    cellModel9.rightMsg = SafeStr(self.dataModel.keepAlive);
    [self.dataList addObject:cellModel9];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel10 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel10.msg = @"LWT";
    cellModel10.rightMsg = SafeStr(self.dataModel.lwt);
    [self.dataList addObject:cellModel10];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel11 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel11.msg = @"LWT Retain";
    cellModel11.rightMsg = SafeStr(self.dataModel.lwtRetain);
    [self.dataList addObject:cellModel11];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel12 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel12.msg = @"LWT Qos";
    cellModel12.rightMsg = SafeStr(self.dataModel.lwtQos);
    [self.dataList addObject:cellModel12];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel13 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel13.msg = @"LWT Topic";
    cellModel13.rightMsg = SafeStr(self.dataModel.lwtTopic);
    [self.dataList addObject:cellModel13];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel14 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel14.msg = @"LWT Payload";
    cellModel14.rightMsg = SafeStr(self.dataModel.lwtPayload);
    [self.dataList addObject:cellModel14];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel15 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel15.msg = @"Device Id";
    cellModel15.rightMsg = SafeStr(self.dataModel.deviceID);
    [self.dataList addObject:cellModel15];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel16 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel16.msg = @"Published Topic";
    cellModel16.rightMsg = SafeStr(self.dataModel.publishedTopic);
    [self.dataList addObject:cellModel16];
    
    MKNBJMQTTSettingForDeviceCellModel *cellModel17 = [[MKNBJMQTTSettingForDeviceCellModel alloc] init];
    cellModel17.msg = @"Subscribed Topic";
    cellModel17.rightMsg = SafeStr(self.dataModel.subscribedTopic);
    [self.dataList addObject:cellModel17];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Settings for Device";
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

- (MKNBJMQTTSettingInfoModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJMQTTSettingInfoModel alloc] init];
    }
    return _dataModel;
}

@end
