//
//  MKNBJIndicatorColorModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/10/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJIndicatorColorModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJIndicatorColorModel ()

@property (nonatomic, assign)mk_nbj_productModel productModel;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJIndicatorColorModel
- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSpecification]) {
            [self operationFailedBlockWithMsg:@"Read Product Model Timeout" block:failedBlock];
            return;
        }
        if (![self readColorDatas]) {
            [self operationFailedBlockWithMsg:@"Read Power Indicator Color Timeout" block:failedBlock];
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
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configColorDatas]) {
            [self operationFailedBlockWithMsg:@"Config Power Indicator Color Timeout" block:failedBlock];
            return;
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
        self.productModel = [returnData[@"data"][@"type"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readColorDatas {
    __block BOOL success = NO;
    
    [MKNBJMQTTInterface nbj_readPowerIndicatorColorWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.colorType = [returnData[@"data"][@"led_state"] integerValue];
        self.b_color = [returnData[@"data"][@"blue"] integerValue];
        self.g_color = [returnData[@"data"][@"green"] integerValue];
        self.y_color = [returnData[@"data"][@"yellow"] integerValue];
        self.o_color = [returnData[@"data"][@"orange"] integerValue];
        self.r_color = [returnData[@"data"][@"red"] integerValue];
        self.p_color = [returnData[@"data"][@"purple"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configColorDatas {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configPowerIndicatorColor:self.colorType colorProtocol:self productModel:self.productModel deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"IndicatorColorParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (self.colorType == mk_nbj_ledColorTransitionSmoothly || self.colorType == mk_nbj_ledColorTransitionDirectly) {
        NSInteger maxValue = 4416;
        if (self.productModel == mk_nbj_productModel_America) {
            maxValue = 2160;
        }else if (self.productModel == mk_nbj_productModel_UK) {
            maxValue = 3588;
        }
        if (self.b_color < 1 || self.b_color > (maxValue - 5)) {
            return NO;
        }
        if (self.g_color <= self.b_color || self.g_color > (maxValue - 4)) {
            return NO;
        }
        if (self.y_color <= self.g_color || self.y_color > (maxValue - 3)) {
            return NO;
        }
        if (self.o_color <= self.y_color || self.o_color > (maxValue - 2)) {
            return NO;
        }
        if (self.r_color <= self.o_color || self.r_color > (maxValue - 1)) {
            return NO;
        }
        if (self.p_color <= self.r_color || self.p_color > maxValue) {
            return NO;
        }
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
        _readQueue = dispatch_queue_create("IndicatorColorQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
