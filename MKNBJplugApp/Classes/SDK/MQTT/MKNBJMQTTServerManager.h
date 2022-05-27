//
//  MKNBJMQTTServerManager.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseMQTTModule/MKMQTTServerManager.h>

#import "MKNBJServerConfigDefines.h"

#import "MKNBJMQTTTaskID.h"

NS_ASSUME_NONNULL_BEGIN

//The notification that is thrown when the connection status between the APP and the MQTT server changes.
extern NSString *const MKNBJMQTTSessionManagerStateChangedNotification;

//Notification of device online.
extern NSString *const MKNBJReceiveDeviceNetStateNotification;

extern NSString *const MKNBJReceivedSwitchStateNotification;

extern NSString *const MKNBJReceivedCountdownNotification;

extern NSString *const MKNBJReceiveDeviceOTAResultNotification;

extern NSString *const MKNBJReceivedElectricityDataNotification;

extern NSString *const MKNBJReceiveTotalEnergyDataNotification;

extern NSString *const MKNBJReceiveMonthlyEnergyDataNotification;

extern NSString *const MKNBJReceiveHourlyEnergyDataNotification;

extern NSString *const MKNBJReceiveOverloadNotification;
extern NSString *const MKNBJReceiveOvervoltageNotification;
extern NSString *const MKNBJReceiveUndervoltageNotification;
extern NSString *const MKNBJReceiveOverCurrentNotification;
extern NSString *const MKNBJDeviceLoadStatusChangedNotification;

extern NSString *const MKNBJReceivedDownMQTTParamsDataCompleteNotification;

@interface MKNBJMQTTServerManager : NSObject<MKMQTTServerProtocol>

@property (nonatomic, assign, readonly)MKNBJMQTTSessionManagerState state;

+ (MKNBJMQTTServerManager *)shared;

+ (void)singleDealloc;

/// 当前app连接服务器参数
@property (nonatomic, strong, readonly, getter=currentServerParams)id <MKNBJServerParamsProtocol>serverParams;

/// 当前用户有没有设置MQTT的订阅topic，如果设置了，则只能定于这个topic，如果没有设置，则订阅添加的设备的topic
@property (nonatomic, copy, readonly, getter=currentSubscribeTopic)NSString *subscribeTopic;

/// 当前用户有没有设置MQTT的订阅topic，如果设置了，则只能定于这个topic，如果没有设置，则订阅添加的设备的topic
@property (nonatomic, copy, readonly, getter=currentPublishedTopic)NSString *publishedTopic;

/// 将参数保存到本地，下次启动通过该参数连接服务器
/// @param protocol protocol
- (BOOL)saveServerParams:(id <MKNBJServerParamsProtocol>)protocol;

/**
 清除本地记录的设置信息
 */
- (BOOL)clearLocalData;

#pragma mark - *****************************服务器交互部分******************************

/// 开始连接服务器，前提是必须服务器参数不能为空
- (BOOL)connect;

- (void)disconnect;

/// 如果是从壳工程进入的设备列表页面，接收不到需要网络改变导致需要联网的通知，所以需要走网络改变的流程
- (void)startWork;

/**
 Subscribe the topic

 @param topicList topicList
 */
- (void)subscriptions:(NSArray <NSString *>*)topicList;

/**
 Unsubscribe the topic
 
 @param topicList topicList
 */
- (void)unsubscriptions:(NSArray <NSString *>*)topicList;

- (void)clearAllSubscriptions;

/// Send Data
/// @param data json
/// @param topic topic,1-128 Characters
/// @param deviceID deviceID,1-32 Characters
/// @param taskID taskID
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
        deviceID:(NSString *)deviceID
          taskID:(mk_nbj_serverOperationID)taskID
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
