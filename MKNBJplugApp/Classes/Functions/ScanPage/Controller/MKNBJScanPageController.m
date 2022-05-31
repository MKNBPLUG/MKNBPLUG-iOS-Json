//
//  MKNBJScanPageController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJScanPageController.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertController.h"

//#import "CTMediator+MKNBJAdd.h"

#import "MKNBJBLESDK.h"

#import "MKNBJScanPageCell.h"

#import "MKNBJScanPageModel.h"

#import "MKNBJAddDeviceController.h"
#import "MKNBJDebuggerController.h"

static NSString *const localPasswordKey = @"mk_nbj_passwordKey";

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKNBJScanPageController ()<UITableViewDelegate,
UITableViewDataSource,
mk_nbj_centralManagerScanDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)UIImageView *refreshIcon;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//扫描到新的设备不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@property (nonatomic, strong)NSMutableDictionary *deviceCache;

@property (nonatomic, strong)UITextField *passwordField;

/// 保存当前密码输入框ascii字符部分
@property (nonatomic, copy)NSString *asciiText;

@end

@implementation MKNBJScanPageController

- (void)dealloc {
    NSLog(@"MKNBJScanPageController销毁");
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKNBJCentralManager shared] stopScan];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self rightButtonMethod];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self runloopObserver];
    [MKNBJCentralManager shared].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_nbj_centralDeallocNotification"
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    if ([MKNBJCentralManager shared].centralStatus != mk_nbj_centralManagerStatusEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.rightButton.selected = !self.rightButton.selected;
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    if (!self.rightButton.isSelected) {
        //停止扫描
        [[MKNBJCentralManager shared] stopScan];
        if (self.scanTimer) {
            dispatch_cancel(self.scanTimer);
        }
        return;
    }
    [self.dataList removeAllObjects];
    [self.deviceCache removeAllObjects];
    [self.tableView reloadData];
    [self.refreshIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"mk_refreshAnimationKey"];
    [self scanTimerRun];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self connectDeviceWithModel:self.dataList[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKNBJScanPageCell *cell = [MKNBJScanPageCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - mk_nbj_centralManagerScanDelegate

- (void)mk_nbj_receiveDevice:(NSDictionary *)deviceModel {
    MKNBJScanPageModel *dataModel = [MKNBJScanPageModel mk_modelWithJSON:deviceModel];
    
    [self updateDataWithDeviceModel:dataModel];
}

- (void)mk_nbj_stopScan {
    if (self.rightButton.isSelected) {
        [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
        [self.rightButton setSelected:NO];
    }
}

#pragma mark - note
- (void)dfuUpdateComplete {
    [MKNBJCentralManager shared].delegate = self;
}

#pragma mark - 刷新
- (void)startScanDevice {
    self.rightButton.selected = NO;
    [self rightButtonMethod];
}

- (void)scanTimerRun{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKNBJCentralManager shared] startScan];
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        @strongify(self);
        [[MKNBJCentralManager shared] stopScan];
        [self needRefreshList];
    });
    dispatch_resume(self.scanTimer);
}

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

- (void)updateDataWithDeviceModel:(MKNBJScanPageModel *)deviceModel{
    [self.deviceCache setObject:deviceModel forKey:deviceModel.macAddress];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:NO];
    NSArray *objList = [[self.deviceCache allValues] sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:objList];
    
    [self needRefreshList];
}

#pragma mark - 连接部分
- (void)connectDeviceWithModel:(MKNBJScanPageModel *)deviceModel {
    //停止扫描
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    [[MKNBJCentralManager shared] stopScan];
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    BOOL debugMode = ([deviceModel.mode integerValue] == 2);
    if (debugMode) {
        [self connectDeviceWithoutPassword:deviceModel];
        return;
    }
    NSString *msg = @"Please enter connection password.";
    MKAlertController *alertController = [MKAlertController alertControllerWithTitle:@"Enter password"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.passwordField = nil;
        self.passwordField = textField;
        NSString *localPassword = [[NSUserDefaults standardUserDefaults] objectForKey:localPasswordKey];
        textField.text = localPassword;
        self.asciiText = localPassword;
        self.passwordField.placeholder = @"The password is 8 characters.";
        [textField addTarget:self action:@selector(passwordInput) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.rightButton.selected = NO;
        [self rightButtonMethod];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self connectDevice:deviceModel];
    }];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)connectDevice:(MKNBJScanPageModel *)deviecModel {
    NSString *password = self.passwordField.text;
    if (password.length != 8) {
        [self.view showCentralToast:@"The password should be 8 characters."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [[MKNBJCentralManager shared] connectPeripheral:deviecModel.peripheral password:password sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:localPasswordKey];
        [[MKHudManager share] hide];
        self.rightButton.selected = NO;
        [self pushAddDevicePage];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKNBJCentralManager shared] disconnect];
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)connectDeviceWithoutPassword:(MKNBJScanPageModel *)deviecModel {
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [[MKNBJCentralManager shared] connectPeripheral:deviecModel.peripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [[MKHudManager share] hide];
        self.rightButton.selected = NO;
        [self pushLogController:deviecModel.macAddress];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKNBJCentralManager shared] disconnect];
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)pushAddDevicePage {
    MKNBJAddDeviceController *vc = [[MKNBJAddDeviceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushLogController:(NSString *)macAddress {
    MKNBJDebuggerController *vc = [[MKNBJDebuggerController alloc] init];
    vc.macAddress = macAddress;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)connectFailed {
    self.rightButton.selected = NO;
    [self rightButtonMethod];
}

/**
 监听输入的密码
 */
- (void)passwordInput{
    NSString *inputValue = self.passwordField.text;
    if (!ValidStr(inputValue)) {
        self.passwordField.text = @"";
        self.asciiText = @"";
        return;
    }
    NSInteger strLen = inputValue.length;
    NSInteger dataLen = [inputValue dataUsingEncoding:NSUTF8StringEncoding].length;
    NSString *currentStr = self.asciiText;
    if (dataLen == strLen) {
        //当前输入是ascii字符
        currentStr = inputValue;
    }
    if (currentStr.length > 8) {
        self.passwordField.text = [currentStr substringToIndex:8];
        self.asciiText = [currentStr substringToIndex:8];
    }else {
        self.passwordField.text = currentStr;
        self.asciiText = currentStr;
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Add Device";
    [self.rightButton setImage:nil forState:UIControlStateNormal];
    [self.rightButton addSubview:self.refreshIcon];
    [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rightButton.mas_centerX);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.rightButton.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)refreshIcon {
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] init];
        _refreshIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJScanPageController", @"nbj_scanRefresh.png");
    }
    return _refreshIcon;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableDictionary *)deviceCache {
    if (!_deviceCache) {
        _deviceCache = [NSMutableDictionary dictionary];
    }
    return _deviceCache;
}

@end
