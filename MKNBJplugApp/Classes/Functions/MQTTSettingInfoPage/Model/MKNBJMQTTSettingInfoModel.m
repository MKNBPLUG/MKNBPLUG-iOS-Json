//
//  MKNBJMQTTSettingInfoModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTSettingInfoModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTInterface.h"

@interface MKNBJMQTTSettingInfoModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJMQTTSettingInfoModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceMQTTInfo]) {
            [self operationFailedBlockWithMsg:@"Read MQTT Params Timeout" block:failedBlock];
            return;
        }
        if (![self readDeviceMQTTLWTInfo]) {
            [self operationFailedBlockWithMsg:@"Read MQTT LWT Params Timeout" block:failedBlock];
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
- (BOOL)readDeviceMQTTInfo {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readDeviceMQTTServerInfoWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.type = ([returnData[@"data"][@"encryption_type"] integerValue] == 0 ? @"TCP" : @"SSL");
        self.host = returnData[@"data"][@"host"];
        self.port = [NSString stringWithFormat:@"%@",returnData[@"data"][@"port"]];
        self.clientID = returnData[@"data"][@"client_id"];
        self.userName = returnData[@"data"][@"username"];
        self.password = returnData[@"data"][@"password"];
        self.cleanSession = ([returnData[@"data"][@"clean_session"] integerValue] == 1 ? @"YES" : @"NO");
        self.qos = [NSString stringWithFormat:@"%@",returnData[@"data"][@"qos"]];
        self.keepAlive = [NSString stringWithFormat:@"%@",returnData[@"data"][@"keepalive"]];
        self.deviceID = returnData[@"device_info"][@"device_id"];
        self.publishedTopic = returnData[@"data"][@"publish_topic"];
        self.subscribedTopic = returnData[@"data"][@"subscribe_topic"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceMQTTLWTInfo {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readDeviceMQTTLWTParamsWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.lwt = [NSString stringWithFormat:@"%@",returnData[@"data"][@"lwt_enable"]];
        self.lwtRetain = [NSString stringWithFormat:@"%@",returnData[@"data"][@"lwt_retain"]];
        self.lwtQos = [NSString stringWithFormat:@"%@",returnData[@"data"][@"lwt_qos"]];
        self.lwtTopic = returnData[@"data"][@"lwt_topic"];
        self.lwtPayload = returnData[@"data"][@"lwt_message"];
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
        NSError *error = [[NSError alloc] initWithDomain:@"mqttServerParams"
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
        _readQueue = dispatch_queue_create("mqttServerQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
