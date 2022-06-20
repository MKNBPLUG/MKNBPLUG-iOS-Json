//
//  MKNBJDeviceListController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJDeviceListController.h"

#import <CoreLocation/CoreLocation.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAboutController.h"
#import "MKAlertView.h"

#import "MKNetworkManager.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJDeviceModel.h"

#import "MKNBJMQTTServerManager.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

#import "MKNBJDeviceListDatabaseManager.h"

#import "MKNBJDeviceListDataModel.h"

#import "MKNBJAddDeviceView.h"
#import "MKNBJDeviceListCell.h"
#import "MKNBJEasyShowView.h"

#import "MKNBJSwitchStateController.h"
#import "MKNBJScanPageController.h"
#import "MKNBJServerForAppController.h"

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKNBJDeviceListController ()<UITableViewDelegate,
UITableViewDataSource,
MKNBJDeviceListCellDelegate>

/// 没有添加设备的时候显示
@property (nonatomic, strong)MKNBJAddDeviceView *addView;

/// 本地有设备的时候显示
@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)MKNBJEasyShowView *loadingView;

@property (nonatomic, strong)NSMutableArray *dataList;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@property (nonatomic, strong)MKNBJDeviceListDataModel *dataModel;

@end

@implementation MKNBJDeviceListController

- (void)dealloc {
    NSLog(@"MKNBJDeviceListController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKNBJMQTTServerManager shared] clearAllSubscriptions];
    [[MKNBJMQTTServerManager shared] disconnect];
    [MKNBJMQTTServerManager singleDealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    if (self.connectServer) {
        //对于从壳工程进来的时候，需要走本地联网流程
        [[MKNBJMQTTServerManager shared] startWork];
    }
    
    [self readDataFromDatabase];
    [self runloopObserver];
    [self addNotifications];
    [self startDataMonitor];
}

#pragma mark - super method

- (void)rightButtonMethod {
    MKNBJServerForAppController *vc = [[MKNBJServerForAppController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJDeviceModel *deviceModel = self.dataList[indexPath.row];
    [[MKNBJDeviceModeManager shared] addDeviceModel:deviceModel];
    MKNBJSwitchStateController *vc = [[MKNBJSwitchStateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJDeviceListCell *cell = [MKNBJDeviceListCell initCellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKNBJDeviceListCellDelegate
- (void)nbj_deviceStateChanged:(MKNBJDeviceModel *)deviceModel {
    if (deviceModel.state == MKNBJDeviceModelStateOffline) {
        [self.view showCentralToast:@"Device is offline, please check it!"];
        return;
    }
    if (deviceModel.overState == MKNBJDeviceOverState_overLoad) {
        //过载
        [self.view showCentralToast:@"Device is overload, please check it!"];
        return;
    }
    if (deviceModel.overState == MKNBJDeviceOverState_overCurrent) {
        //过流
        [self.view showCentralToast:@"Device is overcurrent, please check it!"];
        return;
    }
    if (deviceModel.overState == MKNBJDeviceOverState_overVoltage) {
        //过压
        [self.view showCentralToast:@"Device is overvoltage, please check it!"];
        return;
    }
    if (deviceModel.overState == MKNBJDeviceOverState_underVoltage) {
        //欠压
        [self.view showCentralToast:@"Device is undervoltage, please check it!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    BOOL isOn = (deviceModel.state == MKNBJDeviceModelStateOn);
    [MKNBJMQTTInterface nbj_configSwitchStatus:!isOn
                                      deviceID:deviceModel.deviceID
                                    macAddress:deviceModel.macAddress
                                         topic:[deviceModel currentSubscribedTopic]
                                      sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
    }
                                   failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)nbj_cellDeleteButtonPressed:(NSInteger)index {
    if (index >= self.dataList.count) {
        return;
    }
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self removeDeviceFromLocal:index];
    }];
    NSString *msg = @"Please confirm again whether to remove the device.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Remove Device" message:msg notificationName:@"mk_nbj_needDismissAlert"];
}

#pragma mark - MKNBJDeviceModelDelegate
/// 当前设备离线
/// @param deviceID 当前设备的deviceID
- (void)nbj_deviceOfflineWithDeviceID:(NSString *)deviceID {
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *deviceModel = self.dataList[i];
        if ([deviceModel.deviceID isEqualToString:deviceID]) {
            deviceModel.state = MKNBJDeviceModelStateOffline;
            break;
        }
    }
    [self needRefreshList];
}

#pragma mark - note
- (void)receiveNewDevice:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user)) {
        return;
    }
    MKNBJDeviceModel *deviceModel = user[@"deviceModel"];
    deviceModel.delegate = self;
    [deviceModel startStateMonitoringTimer];
    
    NSInteger index = 0;
    BOOL contain = NO;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:deviceModel.macAddress]) {
            index = i;
            contain = YES;
            break;
        }
    }
    if (contain) {
        //当前设备列表存在deviceID相同的设备，替换，本地数据库已经替换过了
        [self.dataList replaceObjectAtIndex:index withObject:deviceModel];
    }else {
        //不存在，则添加到设备列表
        if (self.dataList.count == 0) {
            [self.dataList addObject:deviceModel];
        }else {
            [self.dataList insertObject:deviceModel atIndex:0];
        }
    }
    
    [self loadMainViews];
    [[MKNBJMQTTServerManager shared] subscriptions:@[[deviceModel currentPublishedTopic]]];
}

- (void)receiveDeviceModifyMQTTServer:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user)) {
        return;
    }
    
    NSInteger index = 0;
    BOOL contain = NO;
    NSString *unsubTopic = @"";
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
            if (!ValidStr([MKNBJMQTTServerManager shared].serverParams.subscribeTopic)) {
                //app端MQTT订阅了指定的topic，不能取消订阅
                //如果是app端MQTT订阅每一个设备的topic，则切网成功之后需要选取消原来的订阅，增加新的订阅
                unsubTopic = [model currentPublishedTopic];
            }
            model.clientID = user[@"clientID"];
            model.subscribedTopic = user[@"subscribedTopic"];
            model.publishedTopic = user[@"publishedTopic"];
            model.state = MKNBJDeviceModelStateOffline;
            contain = YES;
            break;
        }
    }
    if (!contain) {
        return;
    }
    [[MKNBJMQTTServerManager shared] unsubscriptions:@[unsubTopic]];
    [self loadMainViews];
    [[MKNBJMQTTServerManager shared] subscriptions:@[user[@"publishedTopic"]]];
}

- (void)receiveDeleteDevice:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    MKNBJDeviceModel *deviceModel = nil;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
            deviceModel = model;
            break;
        }
    }
    
    if (!deviceModel) {
        return;
    }
    [[MKNBJMQTTServerManager shared] unsubscriptions:@[[deviceModel currentPublishedTopic]]];
    [self.dataList removeObject:deviceModel];
    
    [self loadMainViews];
}

/// 当前MQTT服务器连接状态发生改变
- (void)serverManagerStateChanged {
    if ([MKNBJMQTTServerManager shared].state == MKNBJMQTTSessionManagerStateConnecting) {
        [self.loadingView showText:@"Connecting..." superView:self.titleLabel animated:YES];
        return;
    }
    if ([MKNBJMQTTServerManager shared].state == MKNBJMQTTSessionManagerStateConnected) {
        [self.loadingView hidden];
        self.defaultTitle = @"MKNBPLUG";
        return;
    }
    if ([MKNBJMQTTServerManager shared].state == MKNBJMQTTSessionManagerStateError) {
        [self connectFailed];
        return;
    }
}

- (void)networkStatusChanged {
    if (![[MKNetworkManager sharedInstance] currentNetworkAvailable]) {
        self.defaultTitle = @"Network Unreachable";
        return;
    }
}

- (void)connectFailed {
    [self.loadingView hidden];
    self.defaultTitle = @"Connect Failed";
}

- (void)reloadDeviceTopics {
    //切网之后需要重新加载topic
    //先取消当前所有订阅
    [[MKNBJMQTTServerManager shared] clearAllSubscriptions];
    //重新加载需要订阅的topic
    NSMutableArray *topicList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *deviceModel = self.dataList[i];
        [topicList addObject:[deviceModel currentPublishedTopic]];
    }
    [[MKNBJMQTTServerManager shared] subscriptions:topicList];
}

#pragma mark - event method
- (void)addButtonPressed {
    if ([kSystemVersionString floatValue] >= 13 && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            //未授权位置信息
            [self showAuthAlert];
            return;
        }
    if (!ValidStr([MKNBJMQTTServerManager shared].serverParams.host)) {
        //如果MQTT服务器参数不存在，则去引导用户添加服务器参数，让app连接MQTT服务器
        [self rightButtonMethod];
        return;
    }
    //MQTT服务器参数存在，则添加设备
    MKNBJScanPageController *vc = [[MKNBJScanPageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)showAuthAlert {
    NSString *msg = @"Please go to Settings-Privacy-Location Services to turn on location services permission.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Note"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                           options:@{}
                                 completionHandler:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)removeDeviceFromLocal:(NSInteger)index {
    MKNBJDeviceModel *deviceModel = self.dataList[index];
    [[MKHudManager share] showHUDWithTitle:@"Delete..." inView:self.view isPenetration:NO];
    [MKNBJDeviceListDatabaseManager deleteDeviceWithMacAddress:deviceModel.macAddress sucBlock:^{
        [[MKHudManager share] hide];
        [self.dataList removeObject:deviceModel];
        [[MKNBJMQTTServerManager shared] unsubscriptions:@[[deviceModel currentPublishedTopic]]];
        [self loadMainViews];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadMainViews {
    if (self.tableView.superview) {
        [self.tableView removeFromSuperview];
    }
    if (self.addView.superview) {
        [self.addView removeFromSuperview];
    }
    if (!ValidArray(self.dataList)) {
        //没有设备的情况下，隐藏设备列表，显示添加设备页面
        [self.view addSubview:self.addView];
        [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(defaultTopInset);
            make.bottom.mas_equalTo(self.footerView.mas_top);
        }];
        return;
    }
    //有设备了，显示设备列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(self.footerView.mas_top);
    }];
    [self.tableView reloadData];
}

- (void)readDataFromDatabase {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKNBJDeviceListDatabaseManager readLocalDeviceWithSucBlock:^(NSArray<MKNBJDeviceModel *> * _Nonnull deviceList) {
        [[MKHudManager share] hide];
        [self loadTopics:deviceList];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadTopics:(NSArray<MKNBJDeviceModel *>*)deviceList {
    NSMutableArray *topicList = [NSMutableArray array];
    for (NSInteger i = 0; i < deviceList.count; i ++) {
        MKNBJDeviceModel *deviceModel = deviceList[i];
        deviceModel.delegate = self;
        [deviceModel startStateMonitoringTimer];
        [self.dataList addObject:deviceModel];
        [topicList addObject:[deviceModel currentPublishedTopic]];
    }
    self.dataList = [[self.dataList reverseObjectEnumerator] allObjects];
    [self loadMainViews];
    [[MKNBJMQTTServerManager shared] subscriptions:topicList];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewDevice:)
                                                 name:@"mk_nbj_addNewDeviceSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceModifyMQTTServer:)
                                                 name:@"mk_nbj_deviceModifyMQTTServerSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeleteDevice:)
                                                 name:@"mk_nbj_deleteDeviceNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverManagerStateChanged)
                                                 name:MKNBJMQTTSessionManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged)
                                                 name:MKNetworkStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectFailed)
                                                 name:@"MKNBJMQTTServerConnectFailedNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDeviceTopics)
                                                 name:@"mk_nbj_needReloadTopicsNotification"
                                               object:nil];
}

- (void)startDataMonitor {
    @weakify(self);
    self.dataModel.deviceOnlineBlock = ^(NSString * _Nonnull deviceID) {
        @strongify(self);
        [self receiveDeviceOnlineState:deviceID];
    };
    self.dataModel.switchStateChangedBlock = ^(NSDictionary * _Nonnull dataDic, NSString * _Nonnull deviceID) {
        @strongify(self);
        [self receiveSwitchState:dataDic deviceID:deviceID];
    };
    self.dataModel.receiveOverloadBlock = ^(BOOL overload, NSString * _Nonnull deviceID) {
        @strongify(self);
        MKNBJDeviceOverState state = (overload ? MKNBJDeviceOverState_overLoad : MKNBJDeviceOverState_normal);
        [self deviceOverStateChanged:state deviceID:deviceID];
    };
    self.dataModel.receiveOvercurrentBlock = ^(BOOL overcurrent, NSString * _Nonnull deviceID) {
        @strongify(self);
        MKNBJDeviceOverState state = (overcurrent ? MKNBJDeviceOverState_overCurrent : MKNBJDeviceOverState_normal);
        [self deviceOverStateChanged:state deviceID:deviceID];
    };
    self.dataModel.receiveOvervoltageBlock = ^(BOOL overvoltage, NSString * _Nonnull deviceID) {
        @strongify(self);
        MKNBJDeviceOverState state = (overvoltage ? MKNBJDeviceOverState_overVoltage : MKNBJDeviceOverState_normal);
        [self deviceOverStateChanged:state deviceID:deviceID];
    };
    self.dataModel.receiveUndervoltageBlock = ^(BOOL undervoltage, NSString * _Nonnull deviceID) {
        @strongify(self);
        MKNBJDeviceOverState state = (undervoltage ? MKNBJDeviceOverState_underVoltage : MKNBJDeviceOverState_normal);
        [self deviceOverStateChanged:state deviceID:deviceID];
    };
    self.dataModel.receiveDeviceNameChangedBlock = ^(NSString * _Nonnull macAddress, NSString * _Nonnull deviceName) {
        @strongify(self);
        [self receiveDeviceNameChanged:macAddress deviceName:deviceName];
    };
}

#pragma mark - block
- (void)receiveSwitchState:(NSDictionary *)dataDic deviceID:(NSString *)deviceID {
    if (self.dataList.count == 0 || !ValidStr(deviceID)) {
        return;
    }
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *deviceModel = self.dataList[i];
        if ([deviceModel.deviceID isEqualToString:deviceID]) {
            [deviceModel resetTimerCounter];
            MKNBJDeviceModelState state = (([dataDic[@"switch_state"] integerValue] == 1) ? MKNBJDeviceModelStateOn : MKNBJDeviceModelStateOff);
            deviceModel.state = state;
            MKNBJDeviceOverState overState = MKNBJDeviceOverState_normal;
            if (ValidNum(dataDic[@"overload_state"]) && [dataDic[@"overload_state"] integerValue] == 1) {
                overState = MKNBJDeviceOverState_overLoad;
            }else if (ValidNum(dataDic[@"overcurrent_state"]) && [dataDic[@"overcurrent_state"] integerValue] == 1) {
                overState = MKNBJDeviceOverState_overCurrent;
            }else if (ValidNum(dataDic[@"overvoltage_state"]) && [dataDic[@"overvoltage_state"] integerValue] == 1) {
                overState = MKNBJDeviceOverState_overVoltage;
            }else if (ValidNum(dataDic[@"undervoltage_state"]) && [dataDic[@"undervoltage_state"] integerValue] == 1) {
                overState = MKNBJDeviceOverState_underVoltage;
            }
            deviceModel.overState = overState;
            break;
        }
    }
    [self needRefreshList];
}

- (void)deviceOverStateChanged:(MKNBJDeviceOverState)overState deviceID:(NSString *)deviceID {
    if (self.dataList.count == 0 || !ValidStr(deviceID)) {
        return;
    }
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *deviceModel = self.dataList[i];
        if ([deviceModel.deviceID isEqualToString:deviceID]) {
            [deviceModel resetTimerCounter];
            deviceModel.overState = overState;
            break;
        }
    }
    [self needRefreshList];
}

/// 设备在线通知
/// @param note 通知
/*
    注意，因为这个在线状态没有开关状态，所以业务要求如下，当前设备是在线状态，则只清零计数不改变状态，如果是离线状态则显示开关关闭状态
 */
- (void)receiveDeviceOnlineState:(NSString *)deviceID {
    if (!ValidStr(deviceID) || self.dataList.count == 0) {
        return;
    }
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *deviceModel = self.dataList[i];
        if ([deviceModel.deviceID isEqualToString:deviceID]) {
            [deviceModel resetTimerCounter];
            if (deviceModel.state == MKNBJDeviceModelStateOffline) {
                deviceModel.state = MKNBJDeviceModelStateOff;
            }
            break;
        }
    }
    [self needRefreshList];
}

- (void)receiveDeviceNameChanged:(NSString *)macAddress deviceName:(NSString *)deviceName {
    if (!ValidStr(deviceName) || !ValidStr(macAddress) || self.dataList.count == 0) {
        return;
    }
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDeviceModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:macAddress]) {
            deviceModel.deviceName = deviceName;
            index = i;
            break;
        }
    }
    [self.tableView mk_reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 定时刷新

- (void)needRefreshList {
    //标记需要刷新
    self.isNeedRefresh = YES;
    //唤醒runloop
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

- (void)runloopObserver {
    @weakify(self);
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        @strongify(self);
        if (activity == kCFRunLoopBeforeWaiting) {
            //runloop空闲的时候刷新需要处理的列表,但是需要控制刷新频率
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            if (currentInterval - timeInterval < kRefreshInterval) {
                return;
            }
            timeInterval = currentInterval;
            if (self.isNeedRefresh) {
                [self.tableView reloadData];
                self.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"MKNBPLUG";
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJDeviceListController", @"nbj_menuIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.footerView];
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
        make.height.mas_equalTo(100.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (MKNBJAddDeviceView *)addView {
    if (!_addView) {
        _addView = [[MKNBJAddDeviceView alloc] init];
    }
    return _addView;
}

- (MKNBJEasyShowView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[MKNBJEasyShowView alloc] init];
    }
    return _loadingView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKNBJDeviceListDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJDeviceListDataModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = COLOR_WHITE_MACROS;
        UIButton *addButton = [MKCustomUIAdopter customButtonWithTitle:@"Add Devices"
                                                                target:self
                                                                action:@selector(addButtonPressed)];
        [_footerView addSubview:addButton];
        [addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60.f);
            make.right.mas_equalTo(-60.f);
            make.centerY.mas_equalTo(_footerView.mas_centerY);
            make.height.mas_equalTo(40.f);
        }];
    }
    return _footerView;
}

@end
