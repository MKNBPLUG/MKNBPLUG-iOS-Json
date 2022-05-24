//
//  MKNBJDeviceModeManager.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKNBJDeviceModeManagerDataProtocol <NSObject>

/**
 数据交互可能存在多个设备订阅同一个topic的情况，这个时候只能通过deviceID区分设备，所以统一为topic+deviceID来区分通信数据
 */
@property (nonatomic, copy)NSString *deviceID;

/// MTQQ通信所需的ID，如果存在重复的，会出现交替上线的情况
@property (nonatomic, copy)NSString *clientID;

/**
 mac地址,对应设备读取信息参数的device_id
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 设备广播名字
 */
@property (nonatomic, copy)NSString *deviceName;

/// 本地名字
@property (nonatomic, copy)NSString *localName;

@property (nonatomic, copy)NSString *deviceType;

- (NSString *)currentSubscribedTopic;

- (NSString *)currentPublishedTopic;

@end

@interface MKNBJDeviceModeManager : NSObject

+ (MKNBJDeviceModeManager *)shared;

+ (void)sharedDealloc;

/// 当前设备的deviceID
- (NSString *)deviceID;

/// 当前设备的mac地址
- (NSString *)macAddress;

/// 当前设备的订阅主题
- (NSString *)subscribedTopic;

/// 本地存储的名字
- (NSString *)deviceName;

/// 当前需要托管的deviceModel
/// @param protocol protocol
- (void)addDeviceModel:(id <MKNBJDeviceModeManagerDataProtocol>)protocol;

/// 清空当前托管的数据
- (void)clearDeviceModel;

- (void)updateDeviceName:(NSString *)deviceName;

@end

NS_ASSUME_NONNULL_END
