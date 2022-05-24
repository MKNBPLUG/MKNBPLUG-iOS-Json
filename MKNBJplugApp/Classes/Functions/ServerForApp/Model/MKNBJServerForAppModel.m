//
//  MKNBJServerForAppModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJServerForAppModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKNBJMQTTServerManager.h"

@implementation MKNBJServerForAppModel

- (instancetype)init {
    if (self = [super init]) {
        [self loadServerParams];
    }
    return self;
}

- (void)clearAllParams {
    _host = @"";
    _port = @"";
    _clientID = @"";
    _subscribeTopic = @"";
    _publishTopic = @"";
    _cleanSession = NO;
    _qos = 0;
    _keepAlive = @"";
    _userName = @"";
    _password = @"";
    _sslIsOn = NO;
    _certificate = 0;
    _caFileName = @"";
    _clientFileName = @"";
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
    if (self.publishTopic.length > 128 || (ValidStr(self.publishTopic) && ![self.publishTopic isAsciiString])) {
        return @"PublishTopic error";
    }
    if (self.subscribeTopic.length > 128 || (ValidStr(self.subscribeTopic) && ![self.subscribeTopic isAsciiString])) {
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
        if (!ValidStr(self.caFileName)) {
            return @"CA File cannot be empty.";
        }
        if (self.certificate == 1 && !ValidStr(self.clientFileName)) {
            return @"Client File cannot be empty.";
        }
    }
    return @"";
}

- (void)updateValue:(MKNBJServerForAppModel *)model {
    if (!model || ![model isKindOfClass:MKNBJServerForAppModel.class]) {
        return;
    }
    self.host = model.host;
    self.port = model.port;
    self.clientID = model.clientID;
    self.subscribeTopic = model.subscribeTopic;
    self.publishTopic = model.publishTopic;
    self.cleanSession = model.cleanSession;
    
    self.qos = model.qos;
    self.keepAlive = model.keepAlive;
    self.userName = model.userName;
    self.password = model.password;
    self.sslIsOn = model.sslIsOn;
    self.certificate = model.certificate;
}

#pragma mark - private method
- (void)loadServerParams {
    if (!ValidStr([MKNBJMQTTServerManager shared].serverParams.host)) {
        //本地没有服务器参数
        self.cleanSession = YES;
        self.keepAlive = @"60";
        self.qos = 1;
        return;
    }
    self.host = [MKNBJMQTTServerManager shared].serverParams.host;
    self.port = [MKNBJMQTTServerManager shared].serverParams.port;
    self.clientID = [MKNBJMQTTServerManager shared].serverParams.clientID;
    self.subscribeTopic = [MKNBJMQTTServerManager shared].serverParams.subscribeTopic;
    self.publishTopic = [MKNBJMQTTServerManager shared].serverParams.publishTopic;
    self.cleanSession = [MKNBJMQTTServerManager shared].serverParams.cleanSession;
    
    self.qos = [MKNBJMQTTServerManager shared].serverParams.qos;
    self.keepAlive = [MKNBJMQTTServerManager shared].serverParams.keepAlive;
    self.userName = [MKNBJMQTTServerManager shared].serverParams.userName;
    self.password = [MKNBJMQTTServerManager shared].serverParams.password;
    self.sslIsOn = [MKNBJMQTTServerManager shared].serverParams.sslIsOn;
    self.certificate = [MKNBJMQTTServerManager shared].serverParams.certificate;
    self.caFileName = [MKNBJMQTTServerManager shared].serverParams.caFileName;
    self.clientFileName = [MKNBJMQTTServerManager shared].serverParams.clientFileName;
}

@end
