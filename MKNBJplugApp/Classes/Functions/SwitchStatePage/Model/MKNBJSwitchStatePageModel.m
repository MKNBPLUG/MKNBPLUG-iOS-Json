//
//  MKNBJSwitchStatePageModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJSwitchStatePageModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTServerManager.h"
#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJSwitchStatePageModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJSwitchStatePageModel

- (void)dealloc {
    NSLog(@"MKNBJSwitchStatePageModel销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //返回设备列表页面需要销毁单例
    [[MKNBJDeviceModeManager shared] clearDeviceModel];
}

#pragma mark - notes

- (void)receiveDeviceStateChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    moko_dispatch_main_safe(^{
        if (self.switchStateChangedBlock) {
            self.switchStateChangedBlock(user[@"data"]);
        }
    });
}

- (void)receiveCountdownData:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    moko_dispatch_main_safe(^{
        if (self.receiveCountdownDataBlock) {
            self.receiveCountdownDataBlock(user[@"data"]);
        }
    });
}

- (void)receiveDeviceLoadChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL load = ([user[@"data"][@"load"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveLoadStatusChangedBlock) {
            self.receiveLoadStatusChangedBlock(load);
        }
    });
}

- (void)deviceOverload:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL overload = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOverloadBlock) {
            self.receiveOverloadBlock(overload);
        }
    });
}

- (void)deviceOvercurrent:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL overcurrent = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOvercurrentBlock) {
            self.receiveOvercurrentBlock(overcurrent);
        }
    });
}

- (void)deviceOvervoltage:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL overvoltage = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOvervoltageBlock) {
            self.receiveOvervoltageBlock(overvoltage);
        }
    });
}

- (void)deviceUndervoltage:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL undervoltage = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveUndervoltageBlock) {
            self.receiveUndervoltageBlock(undervoltage);
        }
    });
}

#pragma mark - public method

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSwitchState]) {
            [self operationFailedBlockWithMsg:@"Read Switch State Timeout" block:failedBlock];
            return;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDeviceStateChanged:)
                                                     name:MKNBJReceivedSwitchStateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveCountdownData:)
                                                     name:MKNBJReceivedCountdownNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDeviceLoadChanged:)
                                                     name:MKNBJDeviceLoadStatusChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOverload:)
                                                     name:MKNBJReceiveOverloadNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOvercurrent:)
                                                     name:MKNBJReceiveOverCurrentNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOvervoltage:)
                                                     name:MKNBJReceiveOvervoltageNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceUndervoltage:)
                                                     name:MKNBJReceiveUndervoltageNotification
                                                   object:nil];
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configSwitchStatus:(BOOL)isOn
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_configSwitchStatus:isOn
                                      deviceID:[MKNBJDeviceModeManager shared].deviceID
                                    macAddress:[MKNBJDeviceModeManager shared].macAddress
                                         topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                      sucBlock:sucBlock
                                   failedBlock:failedBlock];
}

- (void)configCountdown:(NSInteger)second
               sucBlock:(void (^)(id returnData))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_configCountdown:second
                                   deviceID:[MKNBJDeviceModeManager shared].deviceID
                                 macAddress:[MKNBJDeviceModeManager shared].macAddress
                                      topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                   sucBlock:sucBlock
                                failedBlock:failedBlock];
}

- (void)clearOverloadWithSucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_clearOverloadStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID
                                                 macAddress:[MKNBJDeviceModeManager shared].macAddress
                                                      topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                                   sucBlock:sucBlock
                                                failedBlock:failedBlock];
}

- (void)clearOvercurrentWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_clearOvercurrentStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID
                                                    macAddress:[MKNBJDeviceModeManager shared].macAddress
                                                         topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                                      sucBlock:sucBlock
                                                   failedBlock:failedBlock];
}

- (void)clearOvervoltageWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_clearOvervoltageStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID
                                                    macAddress:[MKNBJDeviceModeManager shared].macAddress
                                                         topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                                      sucBlock:sucBlock
                                                   failedBlock:failedBlock];
}

- (void)clearUndervoltageWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_clearUndervoltageStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID
                                                     macAddress:[MKNBJDeviceModeManager shared].macAddress
                                                          topic:[MKNBJDeviceModeManager shared].subscribedTopic
                                                       sucBlock:sucBlock
                                                    failedBlock:failedBlock];
}

#pragma mark - interface
- (BOOL)readSwitchState {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readSwitchStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"switch_state"] integerValue] == 1);
        self.overload = ([returnData[@"data"][@"overload_state"] integerValue] == 1);
        self.overcurrent = ([returnData[@"data"][@"overcurrent_state"] integerValue] == 1);
        self.overvoltage = ([returnData[@"data"][@"overvoltage_state"] integerValue] == 1);
        self.undervoltage = ([returnData[@"data"][@"undervoltage_state"] integerValue] == 1);
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
        NSError *error = [[NSError alloc] initWithDomain:@"switchStateParams"
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
        _readQueue = dispatch_queue_create("switchStateQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
