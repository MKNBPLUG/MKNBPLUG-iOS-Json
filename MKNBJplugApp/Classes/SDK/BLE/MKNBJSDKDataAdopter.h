//
//  MKNBJSDKDataAdopter.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKNBJSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJSDKDataAdopter : NSObject

+ (NSString *)fetchAsciiCode:(NSString *)value;

+ (NSString *)fetchMqttServerQosMode:(mk_nbj_mqttServerQosMode)mode;

+ (NSString *)fetchConnectModeString:(mk_nbj_connectMode)mode;

+ (NSString *)fetchNetworkPriority:(mk_nbj_networkPriority)priority;

+ (NSString *)fetchDataFormat:(mk_nbj_dataFormat)format;

+ (NSString *)fetchWorkMode:(mk_nbj_workMode)mode;

@end

NS_ASSUME_NONNULL_END
