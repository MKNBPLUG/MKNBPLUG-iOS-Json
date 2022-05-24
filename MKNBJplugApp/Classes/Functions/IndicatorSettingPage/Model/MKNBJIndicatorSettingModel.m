//
//  MKNBJIndicatorSettingModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJIndicatorSettingModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJIndicatorSettingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJIndicatorSettingModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readServerConnecting]) {
            [self operationFailedBlockWithMsg:@"Read Server Connecting Timeout" block:failedBlock];
            return;
        }
        if (![self readServerConnected]) {
            [self operationFailedBlockWithMsg:@"Read Server Connected Timeout" block:failedBlock];
            return;
        }
        if (![self readIndicatorStatus]) {
            [self operationFailedBlockWithMsg:@"Read Indicator Status Timeout" block:failedBlock];
            return;
        }
        if (![self readProtectionSignal]) {
            [self operationFailedBlockWithMsg:@"Read Protection Signal Timeout" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configServerConnecting:(BOOL)isOn
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_configServerConnectingIndicatorStatus:isOn
                                                         deviceID:[MKNBJDeviceModeManager shared].deviceID
                                                       macAddress:[MKNBJDeviceModeManager shared].macAddress
                                                            topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                                         sucBlock:sucBlock
                                                      failedBlock:failedBlock];
}

- (void)configIndicatorStatus:(BOOL)isOn
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_configIndicatorStatus:isOn
                                         deviceID:[MKNBJDeviceModeManager shared].deviceID
                                       macAddress:[MKNBJDeviceModeManager shared].macAddress
                                            topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                         sucBlock:sucBlock
                                      failedBlock:failedBlock];
}

- (void)configProtectionSignal:(BOOL)isOn
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_configIndicatorProtectionSignal:isOn
                                                   deviceID:[MKNBJDeviceModeManager shared].deviceID
                                                 macAddress:[MKNBJDeviceModeManager shared].macAddress
                                                      topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                                   sucBlock:sucBlock
                                                failedBlock:failedBlock];
}

- (void)configServerConnectedIndicatorStatus:(NSInteger)status
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_configServerConnectedIndicatorStatus:status
                                                        deviceID:[MKNBJDeviceModeManager shared].deviceID
                                                      macAddress:[MKNBJDeviceModeManager shared].macAddress
                                                           topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                                        sucBlock:sucBlock
                                                     failedBlock:failedBlock];
}

#pragma mark - interfae
- (BOOL)readServerConnecting {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readServerConnectingIndicatorStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.connecting = ([returnData[@"data"][@"net_connecting"] integerValue] == 1);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readServerConnected {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readServerConnectedIndicatorStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.connected = [returnData[@"data"][@"net_connected"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readIndicatorStatus {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readIndicatorStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.indicatorStatus = ([returnData[@"data"][@"power_switch"] integerValue] == 1);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readProtectionSignal {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readIndicatorProtectionSignalWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.protectionSignal = ([returnData[@"data"][@"power_protect"] integerValue] == 1);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"loadNotesParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("loadNotesQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
