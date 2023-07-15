//
//  MKNBJModifyServerModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/6.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJModifyServerModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTServerManager.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

static NSString *const defaultSubTopic = @"{device_name}/{device_id}/app_to_device";
static NSString *const defaultPubTopic = @"{device_name}/{device_id}/device_to_app";

@implementation MKNBJUpdateMQTTServerModel

- (instancetype)initWithModifyServerModel:(MKNBJModifyServerModel *)serverModel {
    if (self = [self init]) {
        self.mqtt_host = SafeStr(serverModel.host);
        self.mqtt_port = [serverModel.port integerValue];
        self.clientID = SafeStr(serverModel.clientID);
        self.subscribeTopic = [serverModel currentSubscribeTopic];
        self.publishTopic = [serverModel currentPublishTopic];
        self.cleanSession = serverModel.cleanSession;
        self.qos = serverModel.qos;
        self.keepAlive = [serverModel.keepAlive integerValue];
        self.mqtt_userName = SafeStr(serverModel.userName);
        self.mqtt_password = SafeStr(serverModel.password);
        if (!serverModel.sslIsOn) {
            self.connect_mode = 0;
        }else {
            if (serverModel.certificate == 0) {
                self.connect_mode = 1;
            }else if (serverModel.certificate == 1) {
                self.connect_mode = 2;
            }
        }
        self.sslHost = SafeStr(serverModel.sslHost);
        self.sslPort = [serverModel.sslPort integerValue];
        self.caFilePath = SafeStr(serverModel.caFilePath);
        self.clientKeyPath = SafeStr(serverModel.clientKeyPath);
        self.clientCertPath = SafeStr(serverModel.clientCertPath);
        self.lwtStatus = serverModel.lwtStatus;
        self.lwtRetain = serverModel.lwtRetain;
        self.lwtQos = serverModel.lwtQos;
        self.lwtTopic = [serverModel currentLWTTopic];
        self.lwtPayload = serverModel.lwtPayload;
        self.apn = serverModel.apn;
        self.networkUsername = serverModel.networkUsername;
        self.networkPassword = serverModel.networkPassword;
        self.networkPriority = serverModel.networkPriority;
    }
    return self;
}

@end


@interface MKNBJModifyServerModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)void (^sucBlock)(void);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@end

@implementation MKNBJModifyServerModel

- (void)dealloc {
    NSLog(@"MKNBJModifyServerModel销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        _subscribeTopic = defaultSubTopic;
        _publishTopic = defaultPubTopic;
        _cleanSession = YES;
        _keepAlive = @"60";
        _qos = 1;
        _lwtQos = 1;
        _lwtTopic = defaultPubTopic;
        _lwtPayload = @"Offline";
    }
    return self;
}

#pragma mark - notes
- (void)receiveDownMQTTServerComplete:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    NSInteger result = [user[@"data"][@"result"] integerValue];
    if (result != 1) {
        [self operationFailedBlockWithMsg:@"Update Failed" block:self.failedBlock];
        return;
    }
    [MKNBJMQTTInterface nbj_reconnectMQTTServerWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if (self.sucBlock) {
            self.sucBlock();
        }
    } failedBlock:self.failedBlock];
}

#pragma mark - public method
- (void)updateServerWithSucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
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
        if (![self configMQTTServer]) {
            [self operationFailedBlockWithMsg:@"Config MQTT Server Timeout" block:failedBlock];
            return;
        }
        if (![self configMQTTLWT]) {
            [self operationFailedBlockWithMsg:@"Config MQTT LWT Timeout" block:failedBlock];
            return;
        }
        if (![self configAPN]) {
            [self operationFailedBlockWithMsg:@"Config APN Timeout" block:failedBlock];
            return;
        }
        if (![self configNetworkPriority]) {
            [self operationFailedBlockWithMsg:@"Config Network Priority Timeout" block:failedBlock];
            return;
        }
        if (![self configComplete]) {
            [self operationFailedBlockWithMsg:@"Config Data Timeout" block:failedBlock];
            return;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDownMQTTServerComplete:)
                                                     name:MKNBJReceivedDownMQTTParamsDataCompleteNotification
                                                   object:nil];
    });
}

- (NSString *)currentSubscribeTopic {
    NSString *subTopic = @"";
    if ([self.subscribeTopic isEqualToString:defaultSubTopic]) {
        //用户使用默认的topic
        subTopic = [NSString stringWithFormat:@"%@/%@/%@",[MKNBJDeviceModeManager shared].deviceName,[MKNBJDeviceModeManager shared].deviceID,@"app_to_device"];
    }else {
        //用户修改了topic
        subTopic = self.subscribeTopic;
    }
    return subTopic;
}

- (NSString *)currentPublishTopic {
    NSString *pubTopic = @"";
    if ([self.publishTopic isEqualToString:defaultPubTopic]) {
        //用户使用默认的topic
        pubTopic = [NSString stringWithFormat:@"%@/%@/%@",[MKNBJDeviceModeManager shared].deviceName,[MKNBJDeviceModeManager shared].deviceID,@"device_to_app"];
    }else {
        //用户修改了topic
        pubTopic = self.publishTopic;
    }
    return pubTopic;
}

- (NSString *)currentLWTTopic {
    NSString *topic = @"";
    if ([self.lwtTopic isEqualToString:defaultPubTopic]) {
        //用户使用默认的topic
        topic = [NSString stringWithFormat:@"%@/%@/%@",[MKNBJDeviceModeManager shared].deviceName,[MKNBJDeviceModeManager shared].deviceID,@"device_to_app"];
    }else {
        //用户修改了topic
        topic = self.lwtTopic;
    }
    return topic;
}

- (NSString *)macAddress {
    return [MKNBJDeviceModeManager shared].macAddress;
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

- (BOOL)configMQTTServer {
    __block BOOL success = NO;
    MKNBJUpdateMQTTServerModel *serverModel = [[MKNBJUpdateMQTTServerModel alloc] initWithModifyServerModel:self];
    [MKNBJMQTTInterface nbj_configMQTTServer:serverModel deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMQTTLWT {
    __block BOOL success = NO;
    MKNBJUpdateMQTTServerModel *serverModel = [[MKNBJUpdateMQTTServerModel alloc] initWithModifyServerModel:self];
    [MKNBJMQTTInterface nbj_configMQTTLWTParams:serverModel deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAPN {
    __block BOOL success = NO;
    MKNBJUpdateMQTTServerModel *serverModel = [[MKNBJUpdateMQTTServerModel alloc] initWithModifyServerModel:self];
    [MKNBJMQTTInterface nbj_configAPNParams:serverModel deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkPriority {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configNetworkPriority:self.networkPriority deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configComplete {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_configMQTTServerParamsCompleteWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    if (!ValidStr(self.host) || self.host.length > 64 || ![self.host isAsciiString]) {
        return @"Host error";
    }
    if (!ValidStr(self.port) || [self.port integerValue] < 1 || [self.port integerValue] > 65535) {
        return @"Port error";
    }
    if (!ValidStr(self.clientID) || self.clientID.length > 64 || ![self.clientID isAsciiString]) {
        return @"ClientID error";
    }
    if (!ValidStr(self.publishTopic) || self.publishTopic.length > 128 || ![self.publishTopic isAsciiString]) {
        return @"PublishTopic error";
    }
    if (!ValidStr(self.subscribeTopic) || self.subscribeTopic.length > 128 || ![self.subscribeTopic isAsciiString]) {
        return @"SubscribeTopic error";
    }
    if (self.qos < 0 || self.qos > 2) {
        return @"Qos error";
    }
    if (!ValidStr(self.keepAlive) || [self.keepAlive integerValue] < 10 || [self.keepAlive integerValue] > 120) {
        return @"KeepAlive error";
    }
    if (self.userName.length > 128 || (ValidStr(self.userName) && ![self.userName isAsciiString])) {
        return @"UserName error";
    }
    if (self.password.length > 128 || (ValidStr(self.password) && ![self.password isAsciiString])) {
        return @"Password error";
    }
    if (self.sslIsOn) {
        if (self.certificate < 0 || self.certificate > 1) {
            return @"Certificate error";
        }
        if (!ValidStr(self.sslHost) || self.sslHost.length > 64) {
            return @"SSL Host error";
        }
        if (!ValidStr(self.sslPort) || [self.sslPort integerValue] < 1 || [self.sslPort integerValue] > 65535) {
            return @"SSL Port error";
        }
        if (!ValidStr(self.caFilePath) || self.caFilePath.length > 128) {
            return @"CA File cannot be empty.";
        }
        if (self.certificate == 1 && (!ValidStr(self.clientKeyPath) || self.clientKeyPath.length > 128 || !ValidStr(self.clientCertPath) || self.clientCertPath.length > 128)) {
            return @"Client File cannot be empty.";
        }
    }
    if (self.lwtStatus) {
        if (self.lwtQos < 0 || self.lwtQos > 2) {
            return @"LWT Qos error";
        }
        if (!ValidStr(self.lwtTopic) || self.lwtTopic.length > 128 || ![self.lwtTopic isAsciiString]) {
            return @"LWT Topic error";
        }
        if (!ValidStr(self.lwtPayload) || self.lwtPayload.length > 128 || ![self.lwtPayload isAsciiString]) {
            return @"LWT Payload error";
        }
    }
    if (self.apn.length > 100 || (ValidStr(self.apn) && ![self.apn isAsciiString])) {
        return @"APN error";
    }
    if (self.networkUsername.length > 127 || (ValidStr(self.networkUsername) && ![self.networkUsername isAsciiString])) {
        return @"Network username error";
    }
    if (self.networkPassword.length > 127 || (ValidStr(self.networkPassword) && ![self.networkPassword isAsciiString])) {
        return @"Network password error";
    }
    if (self.networkPriority < 0 || self.networkPriority > 10) {
        return @"Network Priority error";
    }
    return @"";
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

