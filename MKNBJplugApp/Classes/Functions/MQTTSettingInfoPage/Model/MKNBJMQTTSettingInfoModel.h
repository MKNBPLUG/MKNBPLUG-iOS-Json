//
//  MKNBJMQTTSettingInfoModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJMQTTSettingInfoModel : NSObject

@property (nonatomic, copy)NSString *type;

@property (nonatomic, copy)NSString *host;

@property (nonatomic, copy)NSString *port;

@property (nonatomic, copy)NSString *clientID;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, copy)NSString *cleanSession;

@property (nonatomic, copy)NSString *qos;

@property (nonatomic, copy)NSString *keepAlive;

@property (nonatomic, copy)NSString *lwt;

@property (nonatomic, copy)NSString *lwtRetain;

@property (nonatomic, copy)NSString *lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@property (nonatomic, copy)NSString *deviceID;

@property (nonatomic, copy)NSString *publishedTopic;

@property (nonatomic, copy)NSString *subscribedTopic;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
