//
//  MKNBJTaskAdopter.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKNBJOperationID.h"
#import "MKNBJSDKDataAdopter.h"

@implementation MKNBJTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 10) {
            state = [content substringWithRange:NSMakeRange(8, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_nbj_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    if ([headerString isEqualToString:@"ee"]) {
        //分包协议
        return [self parsePacketData:readData];
    }
    if (![headerString isEqualToString:@"ed"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"01"]) {
        //配置
        return [self parseCustomConfigData:content cmd:cmd];
    }
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    return @{};
}

+ (NSDictionary *)parsePacketData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    if ([flag isEqualToString:@"01"]) {
        //配置
        mk_nbj_taskOperationID operationID = mk_nbj_defaultTaskOperationID;
        NSString *content = [readString substringWithRange:NSMakeRange(8, 2)];
        BOOL success = [content isEqualToString:@"01"];
        
        if ([cmd isEqualToString:@"42"]) {
            //CA证书
            operationID = mk_nbj_taskConfigCAFileOperation;
        }else if ([cmd isEqualToString:@"43"]) {
            //设备证书
            operationID = mk_nbj_taskConfigClientCertOperation;
        }else if ([cmd isEqualToString:@"44"]) {
            //设备私钥
            operationID = mk_nbj_taskConfigClientPrivateKeyOperation;
        }
        
        return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
    }
    if ([flag isEqualToString:@"00"]) {
        //读取
        NSString *totalNum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(6, 2)];
        NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(8, 2)];
        NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(10, 2)];
        if ([index integerValue] >= [totalNum integerValue]) {
            return @{};
        }
        return @{};
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_nbj_taskOperationID operationID = mk_nbj_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    if ([cmd isEqualToString:@"4e"]) {
        //读取设备广播名称
        NSData *nameData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *deviceName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"deviceName":(MKValidStr(deviceName) ? deviceName : @""),
        };
        operationID = mk_nbj_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"4f"]) {
        //读取MAC地址
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
        operationID = mk_nbj_taskReadDeviceMacAddressOperation;
    }
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_nbj_taskOperationID operationID = mk_nbj_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    
    if ([cmd isEqualToString:@"31"]) {
        //MQTT服务器地址
        operationID = mk_nbj_taskConfigServerHostOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //MQTT服务器端口号
        operationID = mk_nbj_taskConfigServerPortOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //MQTT用户名
        operationID = mk_nbj_taskConfigServerUserNameOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //MQTT密码
        operationID = mk_nbj_taskConfigServerPasswordOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //MQTT ClientID
        operationID = mk_nbj_taskConfigClientIDOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //Clean Session
        operationID = mk_nbj_taskConfigServerCleanSessionOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //Keep Alive
        operationID = mk_nbj_taskConfigServerKeepAliveOperation;
    }else if ([cmd isEqualToString:@"38"]) {
        //MTQQ Qos
        operationID = mk_nbj_taskConfigServerQosOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //Subscribe Topic
        operationID = mk_nbj_taskConfigSubscibeTopicOperation;
    }else if ([cmd isEqualToString:@"3a"]) {
        //Publish Topic
        operationID = mk_nbj_taskConfigPublishTopicOperation;
    }else if ([cmd isEqualToString:@"3b"]) {
        //LWT 开关
        operationID = mk_nbj_taskConfigLWTStatusOperation;
    }else if ([cmd isEqualToString:@"3c"]) {
        //LWT Qos
        operationID = mk_nbj_taskConfigLWTQosOperation;
    }else if ([cmd isEqualToString:@"3d"]) {
        //LWT Retain
        operationID = mk_nbj_taskConfigLWTRetainOperation;
    }else if ([cmd isEqualToString:@"3e"]) {
        //LWT Topic
        operationID = mk_nbj_taskConfigLWTTopicOperation;
    }else if ([cmd isEqualToString:@"3f"]) {
        //LWT message
        operationID = mk_nbj_taskConfigLWTMessageOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //DeviceID
        operationID = mk_nbj_taskConfigDeviceIDOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //加密方式
        operationID = mk_nbj_taskConfigConnectModeOperation;
    }else if ([cmd isEqualToString:@"45"]) {
        //NTP服务器
        operationID = mk_nbj_taskConfigNTPServerHostOperation;
    }else if ([cmd isEqualToString:@"46"]) {
        //时区
        operationID = mk_nbj_taskConfigTimeZoneOperation;
    }else if ([cmd isEqualToString:@"47"]) {
        //APN
        operationID = mk_nbj_taskConfigAPNOperation;
    }else if ([cmd isEqualToString:@"48"]) {
        //APN用户名
        operationID = mk_nbj_taskConfigAPNUserNameOperation;
    }else if ([cmd isEqualToString:@"49"]) {
        //APN密码
        operationID = mk_nbj_taskConfigAPNPasswordOperation;
    }else if ([cmd isEqualToString:@"4a"]) {
        //网络制式
        operationID = mk_nbj_taskConfigNetworkPriorityOperation;
    }else if ([cmd isEqualToString:@"4b"]) {
        //MQTT数据格式
        operationID = mk_nbj_taskConfigDataFormatOperation;
    }else if ([cmd isEqualToString:@"4c"]) {
        //进入产测模式
        operationID = mk_nbj_taskConfigEnterProductTestModeOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //工作模式
        operationID = mk_nbj_taskConfigWorkModeOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //退出debug模式
        operationID = mk_nbj_taskConfigExitDebugModeOperation;
    }
 
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

#pragma mark - private method

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_nbj_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
