//
//  MKNBJMQTTInterface+MKNBJConfig.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTInterface.h"

#import "MKNBJServerConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJMQTTInterface (MKNBJConfig)

/// 配置开关上电状态
/// @param isOn isOn
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configPowerOnSwitchStatus:(mk_nbj_switchStatus)status
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置开关上报和倒计时上报间隔
/// @param switchInterval 开关上报间隔，0s or 10s~86400s
/// @param countdownInterval 倒计时上报间隔，0s or 10s~86400s
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configSwitchReportInterval:(NSInteger)switchInterval
                     countdownInterval:(NSInteger)countdownInterval
                              deviceID:(NSString *)deviceID
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置电量上报信息
/// @param interval 电量信息上报间隔，0s or 10s~86400s
/// @param threshold 电量变化上报阈值，0%~100%
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configPowerReportInterval:(NSInteger)interval
                      changeThreshold:(NSInteger)threshold
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置电能上报信息
/// @param interval 电能信息上报间隔，0s~43200s
/// @param storageInterval 电能存储间隔，1min~60mins
/// @param threshold 电能变化上报阈值，1%~100%
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configEnergyReportInterval:(NSInteger)interval
                       storageInterval:(NSInteger)storageInterval
                       changeThreshold:(NSInteger)threshold
                              deviceID:(NSString *)deviceID
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置过载保护参数
/// @param isOn 过载保护是否打开
/// @param productModel 产品规格
/// @param overThreshold Overload protection value, Europe and France: 10~4416W, U.K: 10~3558W, America: 10~2160W.
/// @param timeThreshold 1s~30s
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configOverload:(BOOL)isOn
              productModel:(mk_nbj_productModel)productModel
             overThreshold:(NSInteger)overThreshold
             timeThreshold:(NSInteger)timeThreshold
                  deviceID:(NSString *)deviceID
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置过压保护参数
/// @param isOn 过压保护是否打开
/// @param productModel 产品规格
/// @param overThreshold Overvoltage protection value, Europe and France: 231~264V, U.K: 231~264V, America: 121~138V.
/// @param timeThreshold 1s~30s
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configOvervoltage:(BOOL)isOn
                 productModel:(mk_nbj_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     deviceID:(NSString *)deviceID
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置欠压保护参数
/// @param isOn 欠压保护是否打开
/// @param productModel 产品规格
/// @param overThreshold Undervoltage protection value, Europe and France: 196~229V, U.K: 196~229V, America: 102~119V.
/// @param timeThreshold 1s~30s
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configUndervoltage:(BOOL)isOn
                  productModel:(mk_nbj_productModel)productModel
                 overThreshold:(NSInteger)overThreshold
                 timeThreshold:(NSInteger)timeThreshold
                      deviceID:(NSString *)deviceID
                    macAddress:(NSString *)macAddress
                         topic:(NSString *)topic
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置过流保护参数
/// @param isOn 过流保护是否打开
/// @param productModel 产品规格
/// @param overThreshold Overcurrent protection value, Europe and France: 1~192(0.1A), U.K: 1~156(0.1A), America: 1~180(0.1A).
/// @param timeThreshold 1s~30s
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configOvercurrent:(BOOL)isOn
                 productModel:(mk_nbj_productModel)productModel
                overThreshold:(NSInteger)overThreshold
                timeThreshold:(NSInteger)timeThreshold
                     deviceID:(NSString *)deviceID
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;


/// 配置功率指示灯颜色
/// @param colorType colorType
/// @param protocol protocol
/// @param productModel productModel
/// @param timeThreshold 1s~30s
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configPowerIndicatorColor:(mk_nbj_ledColorType)colorType
                        colorProtocol:(id <mk_nbj_ledColorConfigProtocol>)protocol
                         productModel:(mk_nbj_productModel)productModel
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置NTP服务器参数
/// @param isOn Sync Switch状态
/// @param host 0-64 characters
/// @param syncInterval  1-720 hour
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configNTPServerStatus:(BOOL)isOn
                             host:(NSString *)host
                     syncInterval:(NSInteger)syncInterval
                         deviceID:(NSString *)deviceID
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the UTC time zone of the device, and the device will reset the time according to the time zone.
/// @param timeZone Time Zone(-24~28,Unit:0.5)
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configDeviceTimeZone:(NSInteger)timeZone
                        deviceID:(NSString *)deviceID
                      macAddress:(NSString *)macAddress
                           topic:(NSString *)topic
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置负载通知开关
/// @param start 负载接入
/// @param stop 负载移除
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configLoadNotificationSwitch:(BOOL)start
                                    stop:(BOOL)stop
                                deviceID:(NSString *)deviceID
                              macAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置连接中网络指示灯开关状态
/// @param isOn isOn
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configServerConnectingIndicatorStatus:(BOOL)isOn
                                         deviceID:(NSString *)deviceID
                                       macAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置联网成功指示灯状态
/// @param status status
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configServerConnectedIndicatorStatus:(mk_nbj_indicatorBleConnectedStatus)status
                                        deviceID:(NSString *)deviceID
                                      macAddress:(NSString *)macAddress
                                           topic:(NSString *)topic
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置电源指示灯开关状态
/// @param isOn isOn
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configIndicatorStatus:(BOOL)isOn
                         deviceID:(NSString *)deviceID
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置电源指示灯开关保护触发指示
/// @param isOn isOn
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configIndicatorProtectionSignal:(BOOL)isOn
                                   deviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置服务器重连超时重启时间
/// @param timeout 0~1440Mins
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configConnectionTimeout:(NSInteger)timeout
                           deviceID:(NSString *)deviceID
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置按键开关机功能
/// @param isOn isOn
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configSwitchByButtonStatus:(BOOL)isOn
                              deviceID:(NSString *)deviceID
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// 解除过载状态
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_clearOverloadStatusWithDeviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// 解除过压状态
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_clearOvervoltageStatusWithDeviceID:(NSString *)deviceID
                                    macAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// 解除欠压状态
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_clearUndervoltageStatusWithDeviceID:(NSString *)deviceID
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// 解除过流状态
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_clearOvercurrentStatusWithDeviceID:(NSString *)deviceID
                                    macAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;
    
/// 配置开关状态
/// @param isOn isOn
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configSwitchStatus:(BOOL)isOn
                      deviceID:(NSString *)deviceID
                    macAddress:(NSString *)macAddress
                         topic:(NSString *)topic
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置倒计时
/// @param second 1s~86400s
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configCountdown:(NSInteger)second
                   deviceID:(NSString *)deviceID
                 macAddress:(NSString *)macAddress
                      topic:(NSString *)topic
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// 清除电能数据
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_clearAllEnergyDatasWithdeviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// 恢复出厂设置
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_resetDeviceWithdeviceID:(NSString *)deviceID
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// OTA upgrade host firmware.
/// @param host 1-64 Characters
/// @param port 1~65535
/// @param filePath 1-100 Characters
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_otaFirmware:(NSString *)host
                   port:(NSInteger)port
               filePath:(NSString *)filePath
               deviceID:(NSString *)deviceID
             macAddress:(NSString *)macAddress
                  topic:(NSString *)topic
               sucBlock:(void (^)(id returnData))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// OTA CA certificate.
/// @param host 1-64 Characters
/// @param port 1~65535
/// @param filePath 1-100 Characters
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_otaCACertificate:(NSString *)host
                        port:(NSInteger)port
                    filePath:(NSString *)filePath
                    deviceID:(NSString *)deviceID
                  macAddress:(NSString *)macAddress
                       topic:(NSString *)topic
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// OTA Self signed server certificates.
/// @param host 1-64 Characters
/// @param port 1~65535
/// @param caFilePath 1-100 Characters
/// @param clientKeyPath 1-100 Characters
/// @param clientCertPath 1-100 Characters
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_otaSelfSignedCertificates:(NSString *)host
                                 port:(NSInteger)port
                           caFilePath:(NSString *)caFilePath
                        clientKeyPath:(NSString *)clientKeyPath
                       clientCertPath:(NSString *)clientCertPath
                             deviceID:(NSString *)deviceID
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置设备UTC时间
/// @param timestamp 时间戳
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configDeviceUTCTime:(long long)timestamp
                       deviceID:(NSString *)deviceID
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - 服务器参数
/// MQTT 服务器参数
/// @param protocol protocol
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configMQTTServer:(id <nbj_updateMQTTServerProtocol>)protocol
                    deviceID:(NSString *)deviceID
                  macAddress:(NSString *)macAddress
                       topic:(NSString *)topic
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// MQTT 遗嘱参数
/// @param protocol protocol
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configMQTTLWTParams:(id <nbj_updateLWTProtocol>)protocol
                       deviceID:(NSString *)deviceID
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// APN配置
/// @param protocol protocol
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configAPNParams:(id <nbj_updateAPNSettingsProtocol>)protocol
                   deviceID:(NSString *)deviceID
                 macAddress:(NSString *)macAddress
                      topic:(NSString *)topic
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置网络制式
/// @param priority priority
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configNetworkPriority:(mk_nbj_mqtt_networkPriority)priority
                         deviceID:(NSString *)deviceID
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// MQTT参数配置完成
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_configMQTTServerParamsCompleteWithDeviceID:(NSString *)deviceID
                                            macAddress:(NSString *)macAddress
                                                 topic:(NSString *)topic
                                              sucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// 设备开始切换服务器
/// @param deviceID deviceID,1-32 Characters
/// @param macAddress Mac address of the device
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)nbj_reconnectMQTTServerWithDeviceID:(NSString *)deviceID
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
