//
//  MKNBJSettingPageBleModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJSettingPageBleModel.h"

#import "MKMacroDefines.h"

#import "MKNBJCentralManager.h"

@interface MKNBJSettingPageBleModel ()<mk_nbj_centralManagerScanDelegate>

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)void (^sucBlock)(void);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, strong)dispatch_queue_t connectQueue;

@property (nonatomic, strong)dispatch_source_t connectTimer;

@property (nonatomic, assign)NSInteger scanTimerCount;

@property (nonatomic, assign)BOOL timeout;

@end

@implementation MKNBJSettingPageBleModel

- (void)dealloc {
    NSLog(@"MKNBJSettingPageBleModel销毁");
}

- (instancetype)init {
    if (self = [super init]) {
        [MKNBJCentralManager shared].delegate = self;
    }
    return self;
}

#pragma mark - mk_nbj_centralManagerScanDelegate
- (void)mk_nbj_receiveDevice:(NSDictionary *)deviceModel {
    if (self.timeout || !ValidDict(deviceModel) || ![[self.macAddress uppercaseString] isEqualToString:deviceModel[@"macAddress"]]) {
        return;
    }
    [[MKNBJCentralManager shared] connectPeripheral:deviceModel[@"peripheral"] sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (self.connectTimer) {
            dispatch_cancel(self.connectTimer);
        }
        self.timeout = NO;
        [[MKNBJCentralManager shared] stopScan];
        if (self.sucBlock) {
            self.sucBlock();
        }
    } failedBlock:^(NSError * _Nonnull error) {
        if (self.connectTimer) {
            dispatch_cancel(self.connectTimer);
        }
        self.timeout = NO;
        [[MKNBJCentralManager shared] stopScan];
        if (self.failedBlock) {
            self.failedBlock(error);
        }
    }];
}

#pragma mark - public method
- (void)connectDeviceWithMacAddress:(NSString *)macAddress
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(macAddress)) {
        [self operationFailedBlockWithMsg:@"MacAddress error" block:failedBlock];
        return;
    }
    self.sucBlock = nil;
    self.failedBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = failedBlock;
    self.macAddress = macAddress;
    [[MKNBJCentralManager shared] startScan];
}

#pragma mark - private method
- (void)addConnectTimer {
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
        self.connectTimer = nil;
    }
    self.scanTimerCount = 0;
    self.timeout = NO;
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.connectQueue);
    dispatch_source_set_timer(self.connectTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.connectTimer, ^{
        @strongify(self);
        if (self.scanTimerCount >= 20) {
            self.timeout = YES;
            dispatch_cancel(self.connectTimer);
            [[MKNBJCentralManager shared] stopScan];
            [self operationFailedBlockWithMsg:@"Connect Failed" block:self.failedBlock];
            return;
        }
        self.scanTimerCount ++;
    });
    dispatch_resume(self.connectTimer);
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"settingBleConnectDeviceParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_queue_t)connectQueue {
    if (!_connectQueue) {
        _connectQueue = dispatch_queue_create("settingPageBleConnectQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _connectQueue;
}

@end
