//
//  MKNBJSDKDataAdopter.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJSDKDataAdopter.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKNBJSDKDataAdopter

+ (NSString *)fetchAsciiCode:(NSString *)value {
    if (!MKValidStr(value)) {
        return @"";
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < value.length; i ++) {
        int asciiCode = [value characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    return tempString;
}

+ (NSString *)fetchMqttServerQosMode:(mk_nbj_mqttServerQosMode)mode {
    switch (mode) {
        case mk_nbj_mqttQosLevelAtMostOnce:
            return @"00";
        case mk_nbj_mqttQosLevelAtLeastOnce:
            return @"01";
        case mk_nbj_mqttQosLevelExactlyOnce:
            return @"02";
    }
}

+ (NSString *)fetchConnectModeString:(mk_nbj_connectMode)mode {
    switch (mode) {
        case mk_nbj_connectMode_TCP:
            return @"00";
        case mk_nbj_connectMode_CACertificate:
            return @"01";
        case mk_nbj_connectMode_SelfSignedCertificates:
            return @"02";
    }
}

+ (NSString *)fetchNetworkPriority:(mk_nbj_networkPriority)priority {
    switch (priority) {
        case mk_nbj_networkPriority_eMTC_nbj_IOT_GSM:
            return @"00";
        case mk_nbj_networkPriority_eMTC_GSM_nbj_IOT:
            return @"01";
        case mk_nbj_networkPriority_nbj_IOT_GSM_eMTC:
            return @"02";
        case mk_nbj_networkPriority_nbj_IOT_eMTC_GSM:
            return @"03";
        case mk_nbj_networkPriority_GSM_nbj_IOT_eMTC:
            return @"04";
        case mk_nbj_networkPriority_GSM_eMTC_nbj_IOT:
            return @"05";
        case mk_nbj_networkPriority_eMTC_nbj_IOT:
            return @"06";
        case mk_nbj_networkPriority_nbj_IOT_eMTC:
            return @"07";
        case mk_nbj_networkPriority_GSM:
            return @"08";
        case mk_nbj_networkPriority_nbj_IOT:
            return @"09";
        case mk_nbj_networkPriority_eMTC:
            return @"0a";
    }
}

+ (NSString *)fetchDataFormat:(mk_nbj_dataFormat)format {
    switch (format) {
        case mk_nbj_dataFormat_json:
            return @"00";
        case mk_nbj_dataFormat_hex:
            return @"01";
    }
}

+ (NSString *)fetchWorkMode:(mk_nbj_workMode)mode {
    switch (mode) {
        case mk_nbj_workMode_rc:
            return @"00";
        case mk_nbj_workMode_debug:
            return @"01";
    }
}

@end
