//
//  MKNBJPowerOnModeModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJPowerOnModeModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJPowerOnModeModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJPowerOnModeModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readPowerOnMode]) {
            [self operationFailedBlockWithMsg:@"Read Params Timeout" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Para Error" block:failedBlock];
            return;
        }
        if (![self configPowerOnMode]) {
            [self operationFailedBlockWithMsg:@"Config Params Timeout" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interfae
- (BOOL)readPowerOnMode {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readPowerOnSwitchStatusWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.mode = [returnData[@"data"][@"default_status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPowerOnMode {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configPowerOnSwitchStatus:self.mode deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
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
        NSError *error = [[NSError alloc] initWithDomain:@"powerOnModeParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.mode < 0 || self.mode > 2) {
        return NO;
    }
    return YES;
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
        _readQueue = dispatch_queue_create("powerOnModeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
