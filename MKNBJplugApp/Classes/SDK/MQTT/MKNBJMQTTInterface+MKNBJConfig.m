//
//  MKNBJMQTTInterface+MKNBJConfig.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTInterface+MKNBJConfig.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKNBJMQTTServerManager.h"

@implementation MKNBJMQTTInterface (MKNBJConfig)

+ (void)nbj_configPowerOnSwitchStatus:(mk_nbj_switchStatus)status
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1001),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"default_status":@(status),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigPowerOnSwitchStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configSwitchReportInterval:(NSInteger)switchInterval
                     countdownInterval:(NSInteger)countdownInterval
                              deviceID:(NSString *)deviceID
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (switchInterval < 0 || switchInterval > 86400 || countdownInterval < 0 || countdownInterval > 86400) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1002),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"switch_interval":@(switchInterval),
            @"countdown_interval":@(countdownInterval),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigPeriodicalReportOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configPowerReportInterval:(NSInteger)interval
                      changeThreshold:(NSInteger)threshold
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 86400 || threshold < 0 || threshold > 100) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1003),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"report_interval":@(interval),
            @"report_threshold":@(threshold),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigPowerReportOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configEnergyReportInterval:(NSInteger)interval
                       storageInterval:(NSInteger)storageInterval
                       changeThreshold:(NSInteger)threshold
                              deviceID:(NSString *)deviceID
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 43200 || threshold < 1 || threshold > 100 || storageInterval < 1 || storageInterval > 60) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1004),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"report_interval":@(interval),
            @"storage_threshold":@(threshold),
            @"storage_interval":@(storageInterval)
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigEnergyReportOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configOverload:(BOOL)isOn
              productModel:(mk_nbj_productModel)productModel
             overThreshold:(NSInteger)overThreshold
             timeThreshold:(NSInteger)timeThreshold
                  deviceID:(NSString *)deviceID
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 10;
    NSInteger maxValue = 4416;
    if (productModel == mk_nbj_productModel_America) {
        //美规
        minValue = 10;
        maxValue = 2160;
    }else if (productModel == mk_nbj_productModel_UK) {
        //英规
        minValue = 10;
        maxValue = 3588;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1005),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"protection_enable":(isOn ? @(1) : @(0)),
            @"protection_value":@(overThreshold),
            @"judge_time":@(timeThreshold)
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigOverloadOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configOvervoltage:(BOOL)isOn
                 productModel:(mk_nbj_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     deviceID:(NSString *)deviceID
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 231;
    NSInteger maxValue = 264;
    if (productModel == mk_nbj_productModel_America) {
        //美规
        minValue = 121;
        maxValue = 138;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1006),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"protection_enable":(isOn ? @(1) : @(0)),
            @"protection_value":@(overThreshold),
            @"judge_time":@(timeThreshold)
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigOvervoltageOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configUndervoltage:(BOOL)isOn
                  productModel:(mk_nbj_productModel)productModel
                 overThreshold:(NSInteger)overThreshold
                 timeThreshold:(NSInteger)timeThreshold
                      deviceID:(NSString *)deviceID
                    macAddress:(NSString *)macAddress
                         topic:(NSString *)topic
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 196;
    NSInteger maxValue = 229;
    if (productModel == mk_nbj_productModel_America) {
        //美规
        minValue = 102;
        maxValue = 119;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1007),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"protection_enable":(isOn ? @(1) : @(0)),
            @"protection_value":@(overThreshold),
            @"judge_time":@(timeThreshold)
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigUndervoltageOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configOvercurrent:(BOOL)isOn
                 productModel:(mk_nbj_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     deviceID:(NSString *)deviceID
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSInteger minValue = 1;
    NSInteger maxValue = 192;
    if (productModel == mk_nbj_productModel_America) {
        //美规
        minValue = 1;
        maxValue = 180;
    }else if (productModel == mk_nbj_productModel_UK) {
        //英规
        minValue = 1;
        maxValue = 156;
    }
    if (overThreshold < minValue || overThreshold > maxValue || timeThreshold < 1 || timeThreshold > 30) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1008),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"protection_enable":(isOn ? @(1) : @(0)),
            @"protection_value":@(overThreshold),
            @"judge_time":@(timeThreshold)
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigOvercurrentOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configPowerIndicatorColor:(mk_nbj_ledColorType)colorType
                        colorProtocol:(id <mk_nbj_ledColorConfigProtocol>)protocol
                         productModel:(mk_nbj_productModel)productModel
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self checkLEDColorParams:colorType colorProtocol:protocol productModel:productModel]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1009),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"led_state":@(colorType),
            @"blue":@(protocol.b_color),
            @"green":@(protocol.g_color),
            @"yellow":@(protocol.y_color),
            @"orange":@(protocol.o_color),
            @"red":@(protocol.r_color),
            @"purple":@(protocol.p_color),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigPowerIndicatorColorOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configNTPServerStatus:(BOOL)isOn
                             host:(NSString *)host
                     syncInterval:(NSInteger)syncInterval
                         deviceID:(NSString *)deviceID
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!host || ![host isKindOfClass:NSString.class] || host.length > 64) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (syncInterval < 1 || syncInterval > 720) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1010),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"ntp_switch":(isOn ? @(1) : @(0)),
            @"interval":@(syncInterval),
            @"server":host,
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigNTPServerParamsOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configDeviceTimeZone:(NSInteger)timeZone
                        deviceID:(NSString *)deviceID
                      macAddress:(NSString *)macAddress
                           topic:(NSString *)topic
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeZone < -24 || timeZone > 28) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1011),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
                @"time_zone":@(timeZone),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigDeviceTimeZoneOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configLoadNotificationSwitch:(BOOL)start
                                    stop:(BOOL)stop
                                deviceID:(NSString *)deviceID
                              macAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1012),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"access":(start ? @(1) : @(0)),
            @"remove":(stop ? @(1) : @(0)),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigLoadNotificationSwitchOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configServerConnectingIndicatorStatus:(BOOL)isOn
                                         deviceID:(NSString *)deviceID
                                       macAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1013),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"net_connecting":(isOn ? @(1) : @(0)),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigServerConnectingIndicatorStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configServerConnectedIndicatorStatus:(mk_nbj_indicatorBleConnectedStatus)status
                                        deviceID:(NSString *)deviceID
                                      macAddress:(NSString *)macAddress
                                           topic:(NSString *)topic
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1014),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"net_connected":@(status),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigServerConnectedIndicatorStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configIndicatorStatus:(BOOL)isOn
                         deviceID:(NSString *)deviceID
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1015),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"power_switch":(isOn ? @(1) : @(0)),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigIndicatorStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configIndicatorProtectionSignal:(BOOL)isOn
                                   deviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1016),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"power_protect":(isOn ? @(1) : @(0)),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigIndicatorProtectionSignalOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configConnectionTimeout:(NSInteger)timeout
                           deviceID:(NSString *)deviceID
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 0 || timeout > 1440) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1017),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"timeout":@(timeout),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigConnectionTimeoutOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configSwitchByButtonStatus:(BOOL)isOn
                              deviceID:(NSString *)deviceID
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1018),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"key_enable":(isOn ? @(1) : @(0)),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigSwitchByButtonStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_clearOverloadStatusWithDeviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1033),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{}
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskClearOverloadStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_clearOvervoltageStatusWithDeviceID:(NSString *)deviceID
                                    macAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1034),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{}
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskClearOvervoltageStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_clearUndervoltageStatusWithDeviceID:(NSString *)deviceID
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1035),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{}
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskClearUndervoltageStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_clearOvercurrentStatusWithDeviceID:(NSString *)deviceID
                                    macAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1036),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{}
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskClearOvercurrentStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configSwitchStatus:(BOOL)isOn
                      deviceID:(NSString *)deviceID
                    macAddress:(NSString *)macAddress
                         topic:(NSString *)topic
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1037),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"switch_state":(isOn ? @(1) : @(0)),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigSwitchStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configCountdown:(NSInteger)second
                   deviceID:(NSString *)deviceID
                 macAddress:(NSString *)macAddress
                      topic:(NSString *)topic
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (second < 1 || second > 86400) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1039),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"countdown":@(second),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigCountdownOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_clearAllEnergyDatasWithdeviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1040),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskClearAllEnergyDatasOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_resetDeviceWithdeviceID:(NSString *)deviceID
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1041),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskResetDeviceOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_otaFirmware:(NSString *)host
                   port:(NSInteger)port
               filePath:(NSString *)filePath
               deviceID:(NSString *)deviceID
             macAddress:(NSString *)macAddress
                  topic:(NSString *)topic
               sucBlock:(void (^)(id returnData))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(host) || host.length > 64 || !ValidStr(filePath) || filePath.length > 100 || port < 1 || port > 65535) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1042),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"host":host,
            @"port":@(port),
            @"file_path":filePath
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigOTAFirmwareOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_otaCACertificate:(NSString *)host
                        port:(NSInteger)port
                    filePath:(NSString *)filePath
                    deviceID:(NSString *)deviceID
                  macAddress:(NSString *)macAddress
                       topic:(NSString *)topic
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(host) || host.length > 64 || !ValidStr(filePath) || filePath.length > 100 || port < 1 || port > 65535) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1043),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"host":host,
            @"port":@(port),
            @"file_path":filePath
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigOTACACertificateOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_otaSelfSignedCertificates:(NSString *)host
                                 port:(NSInteger)port
                           caFilePath:(NSString *)caFilePath
                        clientKeyPath:(NSString *)clientKeyPath
                       clientCertPath:(NSString *)clientCertPath
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(host) || host.length > 64 || !ValidStr(caFilePath) || caFilePath.length > 100 || port < 1 || port > 65535 || !ValidStr(clientKeyPath) || clientKeyPath.length > 100 || !ValidStr(clientCertPath) || clientCertPath.length > 100) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1044),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"host":host,
            @"port":@(port),
            @"ca_file_path":caFilePath,
            @"client_cert_file_path":clientCertPath,
            @"client_key_file_path":clientKeyPath
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigOTASelfSignedCertificatesOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configDeviceUTCTime:(long long)timestamp
                       deviceID:(NSString *)deviceID
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1052),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"time":@(timestamp),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigDeviceUTCTimeOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

#pragma mark - 服务器参数
+ (void)nbj_configMQTTServer:(id <nbj_updateMQTTServerProtocol>)protocol
                    deviceID:(NSString *)deviceID
                  macAddress:(NSString *)macAddress
                       topic:(NSString *)topic
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self checkMQTTServerProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1097),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"encryption_type":@(protocol.connect_mode),
            @"host":SafeStr(protocol.mqtt_host),
            @"port":@(protocol.mqtt_port),
            @"username":SafeStr(protocol.mqtt_userName),
            @"password":SafeStr(protocol.mqtt_password),
            @"clean_session":(protocol.cleanSession ? @(1) : @(0)),
            @"keepalive":@(protocol.keepAlive),
            @"qos":@(protocol.qos),
            @"subscribe_topic":SafeStr(protocol.subscribeTopic),
            @"publish_topic":SafeStr(protocol.publishTopic),
            @"client_id":SafeStr(protocol.clientID),
            @"cert_host":SafeStr(protocol.sslHost),
            @"cert_port":@(protocol.sslPort),
            @"ca_cert_path":SafeStr(protocol.caFilePath),
            @"client_cert_path":SafeStr(protocol.clientCertPath),
            @"client_key_path":SafeStr(protocol.clientKeyPath)
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigMQTTServerOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configMQTTLWTParams:(id <nbj_updateLWTProtocol>)protocol
                       deviceID:(NSString *)deviceID
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self checkMQTTLWTProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1098),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"lwt_enable":(protocol.lwtStatus ? @(1) : @(0)),
            @"lwt_qos":@(protocol.lwtQos),
            @"lwt_retain":(protocol.lwtRetain ? @(1) : @(0)),
            @"lwt_topic":SafeStr(protocol.lwtTopic),
            @"lwt_message":SafeStr(protocol.lwtPayload),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigMQTTLWTParamsOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configAPNParams:(id <nbj_updateAPNSettingsProtocol>)protocol
                   deviceID:(NSString *)deviceID
                 macAddress:(NSString *)macAddress
                      topic:(NSString *)topic
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self checkAPNProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1099),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"apn":SafeStr(protocol.apn),
            @"apn_username":SafeStr(protocol.networkUsername),
            @"apn_password":SafeStr(protocol.networkPassword),
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigAPNParamsOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configNetworkPriority:(mk_nbj_mqtt_networkPriority)priority
                         deviceID:(NSString *)deviceID
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1100),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
        @"data":@{
            @"network_priority":@(priority)
        }
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigNetworkPriorityOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_configMQTTServerParamsCompleteWithDeviceID:(NSString *)deviceID
                                            macAddress:(NSString *)macAddress
                                                 topic:(NSString *)topic
                                              sucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1101),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskConfigMQTTServerParamsCompleteOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_reconnectMQTTServerWithDeviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkDeviceID:deviceID topic:topic macAddress:macAddress];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1102),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReconnectMQTTServerOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

#pragma mark - private method
+ (BOOL)checkLEDColorParams:(mk_nbj_ledColorType)colorType
              colorProtocol:(nullable id <mk_nbj_ledColorConfigProtocol>)protocol
               productModel:(mk_nbj_productModel)productModel {
    if (colorType == mk_nbj_ledColorTransitionSmoothly || colorType == mk_nbj_ledColorTransitionDirectly) {
        if (!protocol || ![protocol conformsToProtocol:@protocol(mk_nbj_ledColorConfigProtocol)]) {
            return NO;
        }
        NSInteger maxValue = 4416;
        if (productModel == mk_nbj_productModel_America) {
            maxValue = 2160;
        }else if (productModel == mk_nbj_productModel_UK) {
            maxValue = 3588;
        }
        if (protocol.b_color < 1 || protocol.b_color > (maxValue - 5)) {
            return NO;
        }
        if (protocol.g_color <= protocol.b_color || protocol.g_color > (maxValue - 4)) {
            return NO;
        }
        if (protocol.y_color <= protocol.g_color || protocol.y_color > (maxValue - 3)) {
            return NO;
        }
        if (protocol.o_color <= protocol.y_color || protocol.o_color > (maxValue - 2)) {
            return NO;
        }
        if (protocol.r_color <= protocol.o_color || protocol.r_color > (maxValue - 1)) {
            return NO;
        }
        if (protocol.p_color <= protocol.r_color || protocol.p_color > maxValue) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkMQTTServerProtocol:(id <nbj_updateMQTTServerProtocol>)protocol {
    if (!protocol || ![protocol conformsToProtocol:@protocol(nbj_updateMQTTServerProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.mqtt_host) || protocol.mqtt_host.length > 64 || ![protocol.mqtt_host isAsciiString]) {
        return NO;
    }
    if (protocol.mqtt_port < 1 || protocol.mqtt_port > 65535) {
        return NO;
    }
    if (!ValidStr(protocol.clientID) || protocol.clientID.length > 64 || ![protocol.clientID isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.publishTopic) || protocol.publishTopic.length > 128 || ![protocol.publishTopic isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.subscribeTopic) || protocol.subscribeTopic.length > 128 || ![protocol.subscribeTopic isAsciiString]) {
        return NO;
    }
    if (protocol.qos < 0 || protocol.qos > 2) {
        return NO;
    }
    if (protocol.keepAlive < 10 || protocol.keepAlive > 120) {
        return NO;
    }
    if (protocol.mqtt_userName.length > 256 || (ValidStr(protocol.mqtt_userName) && ![protocol.mqtt_userName isAsciiString])) {
        return NO;
    }
    if (protocol.mqtt_password.length > 256 || (ValidStr(protocol.mqtt_password) && ![protocol.mqtt_password isAsciiString])) {
        return NO;
    }
    if (protocol.connect_mode < 0 || protocol.connect_mode > 3) {
        return NO;
    }
    if (protocol.connect_mode == 2 || protocol.connect_mode == 3) {
        if (!ValidStr(protocol.sslHost) || protocol.sslHost.length > 64) {
            return NO;
        }
        if (protocol.sslPort < 0 || protocol.sslPort > 65535) {
            return NO;
        }
        if (!ValidStr(protocol.caFilePath) || protocol.caFilePath.length > 100) {
            return NO;
        }
        if (protocol.connect_mode == 3 && (!ValidStr(protocol.clientKeyPath) || protocol.clientKeyPath.length > 100 || !ValidStr(protocol.clientCertPath) || protocol.clientCertPath.length > 100)) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)checkMQTTLWTProtocol:(id <nbj_updateLWTProtocol>)protocol {
    if (!protocol || ![protocol conformsToProtocol:@protocol(nbj_updateLWTProtocol)]) {
        return NO;
    }
    if (!protocol.lwtStatus) {
        return YES;
    }
    
    if (!ValidStr(protocol.lwtTopic) || protocol.lwtTopic.length > 128 || ![protocol.lwtTopic isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.lwtPayload) || protocol.lwtPayload.length > 128 || ![protocol.lwtPayload isAsciiString]) {
        return NO;
    }
    if (protocol.lwtQos < 0 || protocol.lwtQos > 2) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkAPNProtocol:(id <nbj_updateAPNSettingsProtocol>)protocol {
    if (!protocol || ![protocol conformsToProtocol:@protocol(nbj_updateAPNSettingsProtocol)]) {
        return NO;
    }
    
    if (protocol.apn.length > 100 || (ValidStr(protocol.apn) && ![protocol.apn isAsciiString])) {
        return NO;
    }
    if (protocol.networkUsername.length > 127 || (ValidStr(protocol.networkUsername) && ![protocol.networkUsername isAsciiString])) {
        return NO;
    }
    if (protocol.networkPassword.length > 127 || (ValidStr(protocol.networkPassword) && ![protocol.networkPassword isAsciiString])) {
        return NO;
    }
    
    return YES;
}

@end
