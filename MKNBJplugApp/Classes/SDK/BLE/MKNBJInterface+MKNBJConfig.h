//
//  MKNBJInterface+MKNBJConfig.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJInterface.h"

#import "MKNBJSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJInterface (MKNBJConfig)

/// Configure the domain name of the MQTT server.
/// @param host 1~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configServerHost:(NSString *)host
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the port number of the MQTT server.
/// @param port 0~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configServerPort:(NSInteger)port
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the user name for the device to connect to the server. If the server passes the certificate or does not require any authentication, you do not need to fill in.
/// @param userName 0~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configServerUserName:(NSString *)userName
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the password for the device to connect to the server. If the server passes the certificate or does not require any authentication, you do not need to fill in.
/// @param password 0~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configServerPassword:(NSString *)password
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Client ID of the MQTT server.
/// @param clientID 1~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configClientID:(NSString *)clientID
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure clean session of the  MQTT server.
/// @param clean clean
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configServerCleanSession:(BOOL)clean
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Keep Alive of the MQTT server.
/// @param interval 10s~120s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configServerKeepAlive:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Qos of the MQTT server.
/// @param mode mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configServerQos:(mk_nbj_mqttServerQosMode)mode
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the subscription topic of the device.
/// @param subscibeTopic 1~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configSubscibeTopic:(NSString *)subscibeTopic
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the publishing theme of the device.
/// @param publishTopic 1~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configPublishTopic:(NSString *)publishTopic
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the switch state of MQTT LWT.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configLWTStatus:(BOOL)isOn
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Qos of the MQTT LWT.
/// @param mode mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configLWTQos:(mk_nbj_mqttServerQosMode)mode
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the retain state of MQTT LWT.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configLWTRetain:(BOOL)isOn
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the topic of MQTT LWT.
/// @param topic 1~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configLWTTopic:(NSString *)topic
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the message of MQTT LWT.
/// @param message 1~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configLWTMessage:(NSString *)message
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Device ID.Alibaba Cloud server needs this parameter to distinguish different messages.
/// @param deviceID 1~32 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configDeviceID:(NSString *)deviceID
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the device tcp communication encryption method.
/// @param mode mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configConnectMode:(mk_nbj_connectMode)mode
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the root certificate of the MQTT server.
/// @param caFile caFile
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configCAFile:(NSData *)caFile
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure client certificate.
/// @param cert cert
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configClientCert:(NSData *)cert
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure client private key.
/// @param privateKey privateKey
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configClientPrivateKey:(NSData *)privateKey
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure NTP server domain name.
/// @param host 0~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configNTPServerHost:(NSString *)host
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the time zone of the device.
/// @param timeZone -24~28  //(The time zone is in units of 30 minutes, UTC-12:00~UTC+14:00.eg:timeZone = -23 ,--> UTC-11:30)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configTimeZone:(NSInteger)timeZone
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// APN.
/// @param apn 0~100 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configAPN:(NSString *)apn
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the username of the APN.
/// @param userName 0~127 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configAPNUserName:(NSString *)userName
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the password of the APN.
/// @param password 0~127 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configAPNPassword:(NSString *)password
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the network priority of the device
/// @param priority priority
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configNetworkPriority:(mk_nbj_networkPriority)priority
                         sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the MQTT data format returned by the device.
/// @param format format
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configDataFormat:(mk_nbj_dataFormat)format
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Enter production test mode.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_enterProductTestModeWithSucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Work Mode.
/// @param mode RC/Debug
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_configWorkMode:(mk_nbj_workMode)mode
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Exit Debug Mode.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)nbj_exitDebugModeWithSucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
