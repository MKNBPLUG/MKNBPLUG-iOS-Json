//
//  MKNBJMQTTInterface.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTInterface.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKNBJMQTTServerManager.h"

@implementation MKNBJMQTTInterface

+ (void)nbj_readPowerOnSwitchStatusWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2001),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadPowerOnSwitchStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readPeriodicalReportingWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2002),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadPeriodicalReportingOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readPowerReportingWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2003),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadPowerReportingOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readEnergyReportingWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2004),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadEnergyReportingOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readOverloadProtectionDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2005),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadOverloadProtectionDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readOvervoltageProtectionDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2006),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadOvervoltageProtectionDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readUndervoltageProtectionDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2007),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadUndervoltageProtectionDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readOvercurrentProtectionDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2008),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadOvercurrentProtectionDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readPowerIndicatorColorWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2009),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadPowerIndicatorColorOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readNTPServerParamsWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2010),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadNTPServerParamsOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readTimeZoneWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2011),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadTimeZoneOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readLoadNotificationSwitchWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2012),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadLoadNotificationSwitchOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readServerConnectingIndicatorStatusWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2013),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadServerConnectingIndicatorStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readServerConnectedIndicatorStatusWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2014),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadServerConnectedIndicatorStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readIndicatorStatusWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2015),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadIndicatorStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readIndicatorProtectionSignalWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2016),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadIndicatorProtectionSignalOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readConnectionTimeoutWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2017),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadConnectionTimeoutOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readSwitchByButtonStatusWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2018),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadSwitchByButtonStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readSwitchStatusWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2038),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadSwitchStatusOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readDeviceUpdateStateWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2045),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadDeviceUpdateStateOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readElectricityDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2046),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadElectricityDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readTotalEnergyDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2047),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadTotalEnergyDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readMonthlyEnergyDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2048),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadMonthlyEnergyDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readHourlyEnergyDataWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2049),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadHourlyEnergyDataOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readDeviceInfoWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2050),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadDeviceInfoOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readSpecificationsOfDeviceWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2051),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadSpecificationsOfDeviceOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readDeviceUTCTimeWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2052),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadDeviceUTCTimeOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readDeviceWorkModeWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2053),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadDeviceWorkModeOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

#pragma mark - 服务器参数

+ (void)nbj_readDeviceMQTTServerInfoWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2097),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadDeviceMQTTServerInfoOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

+ (void)nbj_readDeviceMQTTLWTParamsWithDeviceID:(NSString *)deviceID
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
        @"msg_id":@(2098),
        @"device_info":@{
                @"device_id":deviceID,
                @"mac":macAddress
        },
    };
    [[MKNBJMQTTServerManager shared] sendData:data
                                        topic:topic
                                     deviceID:deviceID
                                       taskID:mk_nbj_server_taskReadDeviceMQTTLWTParamsOperation
                                     sucBlock:sucBlock
                                  failedBlock:failedBlock];
}

#pragma mark - private method
+ (NSString *)checkDeviceID:(NSString *)deviceID
                      topic:(NSString *)topic
                 macAddress:(NSString *)macAddress {
    if (!ValidStr(topic) || topic.length > 128 || ![topic isAsciiString]) {
        return @"Topic error";
    }
    if (!ValidStr(deviceID) || deviceID.length > 32 || ![deviceID isAsciiString]) {
        return @"ClientID error";
    }
    if (!ValidStr(macAddress)) {
        return @"Mac error";
    }
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@"-" withString:@""];
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@"_" withString:@""];
    if (macAddress.length != 12 || ![macAddress regularExpressions:isHexadecimal]) {
        return @"Mac error";
    }
    return @"";
}

+ (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.NBJMQTTManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    moko_dispatch_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

@end
