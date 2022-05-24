//
//  MKNBJOTADataModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJOTADataModel.h"
#import "MKMacroDefines.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTServerManager.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@implementation MKNBJOTAFirmwareModel
@end

@implementation MKNBJOTASlaveFirmware
@end

@implementation MKNBJOTACACertificateModel
@end

@implementation MKNBJOTASelfSignedModel
@end

@interface MKNBJOTADataModel ()

@property (nonatomic, strong)MKNBJOTAFirmwareModel *firmwareModel;

@property (nonatomic, strong)MKNBJOTACACertificateModel *caFileModel;

@property (nonatomic, strong)MKNBJOTASelfSignedModel *signedModel;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)void (^sucBlock)(void);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@end

@implementation MKNBJOTADataModel

- (void)dealloc {
    NSLog(@"MKNBJOTADataModel销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - note
- (void)receiveOTAResult:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    NSInteger result = [user[@"data"][@"result"] integerValue];
    if (result != 1) {
        [self operationFailedBlockWithMsg:@"Update Failed" block:self.failedBlock];
        return;
    }
    moko_dispatch_main_safe(^{
        if (self.sucBlock) {
            self.sucBlock();
        }
    });
}

- (void)startUpdateWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    dispatch_async(self.readQueue, ^{
        NSString *msg = [self checkParams];
        if (ValidStr(msg)) {
            [self operationFailedBlockWithMsg:msg block:failedBlock];
            return;
        }
        NSInteger status = [self readDeviceState];
        if (status == 999) {
            [self operationFailedBlockWithMsg:@"Fetch Current Device State Timeout" block:failedBlock];
            return;
        }
        if (status != 0) {
            [self operationFailedBlockWithMsg:@"Device is OTA, please wait" block:failedBlock];
            return;
        }
        if (self.type == 0) {
            if (![self otaFirmware]) {
                [self operationFailedBlockWithMsg:@"OTA Firmware Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == 1) {
            if (![self otaCAFile]) {
                [self operationFailedBlockWithMsg:@"OTA CA File Timeout" block:failedBlock];
                return;
            }
        }else if (self.type == 2) {
            if (![self otaSelfSigned]) {
                [self operationFailedBlockWithMsg:@"OTA Self Signed Certificates Timeout" block:failedBlock];
                return;
            }
        }else {
            [self operationFailedBlockWithMsg:@"Type Error" block:failedBlock];
            return;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveOTAResult:)
                                                     name:MKNBJReceiveDeviceOTAResultNotification
                                                   object:nil];
    });
}

#pragma mark - interval
- (NSInteger)readDeviceState {
    __block NSInteger status = 999;
    [MKNBJMQTTInterface nbj_readDeviceUpdateStateWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        status = [returnData[@"data"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

- (BOOL)otaFirmware {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_otaFirmware:self.firmwareModel.host port:[self.firmwareModel.port integerValue] filePath:self.firmwareModel.filePath deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)otaCAFile {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_otaCACertificate:self.caFileModel.host port:[self.caFileModel.port integerValue] filePath:self.caFileModel.filePath deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)otaSelfSigned {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_otaSelfSignedCertificates:self.signedModel.host port:[self.signedModel.port integerValue] caFilePath:self.signedModel.caFilePath clientKeyPath:self.signedModel.clientKeyPath clientCertPath:self.signedModel.clientCertPath deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"mqttServerParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (NSString *)checkParams {
    if (self.type == 0) {
        //Firmware
        if (!ValidStr(self.firmwareModel.host) || self.firmwareModel.host.length > 64) {
            return @"Host error";
        }
        if (!ValidStr(self.firmwareModel.port) || [self.firmwareModel.port integerValue] < 1 || [self.firmwareModel.port integerValue] > 65535) {
            return @"Port error";
        }
        if (!ValidStr(self.firmwareModel.filePath) || self.firmwareModel.filePath.length > 100) {
            return @"File Path error";
        }
    }
    if (self.type == 1) {
        //CA certificate
        if (!ValidStr(self.caFileModel.host) || self.caFileModel.host.length > 64) {
            return @"Host error";
        }
        if (!ValidStr(self.caFileModel.port) || [self.caFileModel.port integerValue] < 1 || [self.caFileModel.port integerValue] > 65535) {
            return @"Port error";
        }
        if (!ValidStr(self.caFileModel.filePath) || self.caFileModel.filePath.length > 100) {
            return @"File Path error";
        }
    }
    if (self.type == 2) {
        //Self signed server certificates
        if (!ValidStr(self.signedModel.host) || self.signedModel.host.length > 64) {
            return @"Host error";
        }
        if (!ValidStr(self.signedModel.port) || [self.signedModel.port integerValue] < 1 || [self.signedModel.port integerValue] > 65535) {
            return @"Port error";
        }
        if (!ValidStr(self.signedModel.caFilePath) || self.signedModel.caFilePath.length > 100) {
            return @"CA File Path error";
        }
        if (!ValidStr(self.signedModel.clientKeyPath) || self.signedModel.clientKeyPath.length > 100) {
            return @"Client Key file error";
        }
        if (!ValidStr(self.signedModel.clientCertPath) || self.signedModel.clientCertPath.length > 100) {
            return @"Client Cert file error";
        }
    }
    return @"";
}

#pragma mark - getter
- (MKNBJOTAFirmwareModel *)firmwareModel {
    if (!_firmwareModel) {
        _firmwareModel = [[MKNBJOTAFirmwareModel alloc] init];
    }
    return _firmwareModel;
}

- (MKNBJOTACACertificateModel *)caFileModel {
    if (!_caFileModel) {
        _caFileModel = [[MKNBJOTACACertificateModel alloc] init];
    }
    return _caFileModel;
}

- (MKNBJOTASelfSignedModel *)signedModel {
    if (!_signedModel) {
        _signedModel = [[MKNBJOTASelfSignedModel alloc] init];
    }
    return _signedModel;
}

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
