//
//  MKNBJProtectionConfigModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJProtectionConfigModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJProtectionConfigModel ()

@property (nonatomic, assign)nbj_protectionConfigType type;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJProtectionConfigModel

- (instancetype)initWithType:(nbj_protectionConfigType)type {
    if (self = [self init]) {
        self.type = type;
    }
    return self;
}

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSpecification]) {
            [self operationFailedBlockWithMsg:@"Read Specification Timeout" block:failedBlock];
            return;
        }
        if (self.type == nbj_protectionConfigType_overload) {
            //过载
            if (![self readOverLoadProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == nbj_protectionConfigType_overvoltage) {
            //过压
            if (![self readOverVoltageProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == nbj_protectionConfigType_undervoltage) {
            //欠压
            if (![self readSagVoltageProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == nbj_protectionConfigType_overcurrent) {
            //过流
            if (![self readOverCurrentProtectionData]) {
                [self operationFailedBlockWithMsg:@"Read Over Value Timeout" block:failedBlock];
                return;
            }
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
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (self.type == nbj_protectionConfigType_overload) {
            //过载
            if (![self configOverLoadProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == nbj_protectionConfigType_overvoltage) {
            //过压
            if (![self configOverVoltageProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == nbj_protectionConfigType_undervoltage) {
            //欠压
            if (![self configSagVoltageProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == nbj_protectionConfigType_overcurrent) {
            //过流
            if (![self configOverCurrentProtection]) {
                [self operationFailedBlockWithMsg:@"Config Over Value Timeout" block:failedBlock];
                return;
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readSpecification {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readSpecificationsOfDeviceWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.specification = [returnData[@"data"][@"type"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverVoltageProtectionData {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readOvervoltageProtectionDataWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"protection_enable"] integerValue] == 1);
        self.overThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"protection_value"]];
        self.timeThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"judge_time"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverVoltageProtection {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configOvervoltage:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSagVoltageProtectionData {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readUndervoltageProtectionDataWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"protection_enable"] integerValue] == 1);
        self.overThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"protection_value"]];
        self.timeThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"judge_time"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSagVoltageProtection {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configUndervoltage:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverCurrentProtectionData {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readOvercurrentProtectionDataWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"protection_enable"] integerValue] == 1);
        self.overThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"protection_value"]];
        self.timeThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"judge_time"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverCurrentProtection {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configOvercurrent:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverLoadProtectionData {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readOverloadProtectionDataWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = ([returnData[@"data"][@"protection_enable"] integerValue] == 1);
        self.overThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"protection_value"]];
        self.timeThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"judge_time"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOverLoadProtection {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configOverload:self.isOn productModel:self.specification overThreshold:[self.overThreshold integerValue] timeThreshold:[self.timeThreshold integerValue] deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"OverProtectionParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.overThreshold) || !ValidStr(self.timeThreshold) || [self.timeThreshold integerValue] < 1 || [self.timeThreshold integerValue] > 30) {
        return NO;
    }
    NSInteger maxValue = 0;
    NSInteger minValue = 0;
    if (self.type == nbj_protectionConfigType_overload) {
        //过载
        if (self.specification == 0) {
            //欧法
            minValue = 10;
            maxValue = 4416;
        }else if (self.specification == 1) {
            //美规
            minValue = 10;
            maxValue = 2160;
        }else if (self.specification == 2) {
            //英规
            minValue = 10;
            maxValue = 3588;
        }
    }else if (self.type == nbj_protectionConfigType_overvoltage) {
        //过压
        if (self.specification == 0) {
            //欧法
            minValue = 231;
            maxValue = 264;
        }else if (self.specification == 1) {
            //美规
            minValue = 121;
            maxValue = 138;
        }else if (self.specification == 2) {
            //英规
            minValue = 231;
            maxValue = 264;
        }
    }else if (self.type == nbj_protectionConfigType_undervoltage) {
        //欠压
        if (self.specification == 0) {
            //欧法
            minValue = 196;
            maxValue = 229;
        }else if (self.specification == 1) {
            //美规
            minValue = 102;
            maxValue = 119;
        }else if (self.specification == 2) {
            //英规
            minValue = 196;
            maxValue = 229;
        }
    }else if (self.type == nbj_protectionConfigType_overcurrent) {
        //过流
        if (self.specification == 0) {
            //欧法
            minValue = 1;
            maxValue = 192;
        }else if (self.specification == 1) {
            //美规
            minValue = 1;
            maxValue = 180;
        }else if (self.specification == 2) {
            //英规
            minValue = 1;
            maxValue = 156;
        }
    }
    if ([self.overThreshold integerValue] < minValue || [self.overThreshold integerValue] > maxValue) {
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
        _readQueue = dispatch_queue_create("OverProtectionQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
