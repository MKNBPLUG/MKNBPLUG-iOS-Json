//
//  MKNBJPeriodicalReportModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJPeriodicalReportModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJPeriodicalReportModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJPeriodicalReportModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readPeriodicalReport]) {
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
        if (![self configPeriodicalReport]) {
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
- (BOOL)readPeriodicalReport {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readPeriodicalReportingWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.switchInterval = [NSString stringWithFormat:@"%@",returnData[@"data"][@"switch_interval"]];
        self.countdownInterval = [NSString stringWithFormat:@"%@",returnData[@"data"][@"countdown_interval"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPeriodicalReport {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configSwitchReportInterval:[self.switchInterval integerValue] countdownInterval:[self.countdownInterval integerValue] deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"reportingPageParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.switchInterval) || [self.switchInterval integerValue] < 0 || [self.switchInterval integerValue] > 86400) {
        return NO;
    }
    if (!ValidStr(self.countdownInterval) || [self.countdownInterval integerValue] < 0 || [self.countdownInterval integerValue] > 86400) {
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
        _readQueue = dispatch_queue_create("reportingPageQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
