//
//  MKNBJServerConfigDeviceFooterView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJServerConfigDeviceFooterViewModel : NSObject

@property (nonatomic, assign)BOOL cleanSession;

@property (nonatomic, assign)NSInteger qos;

@property (nonatomic, copy)NSString *keepAlive;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA certificate     1:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFileName;

@property (nonatomic, copy)NSString *clientKeyName;

@property (nonatomic, copy)NSString *clientCertName;

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

@property (nonatomic, assign)NSInteger lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@property (nonatomic, copy)NSString *deviceID;

/// 0-64 Characters
@property (nonatomic, copy)NSString *ntpHost;

/// -24~28
@property (nonatomic, assign)NSInteger timeZone;

/// 0-128 Characters
@property (nonatomic, copy)NSString *apn;

/// 0-128 Characters
@property (nonatomic, copy)NSString *networkUsername;

/// 0-128 Characters
@property (nonatomic, copy)NSString *networkPassword;

/*
 0:eMTC->NB-IOT->GSM
 1:eMTC-> GSM -> NB-IOT
 2:NB-IOT->GSM-> eMTC
 3:NB-IOT-> eMTC-> GSM
 4:GSM -> NB-IOT-> eMTC
 5:GSM -> eMTC->NB-IOT
 6:eMTC->NB-IOT
 7:NB-IOT-> eMTC
 8:GSM
 9:NB-IOT
 10:eMTC
 */
@property (nonatomic, assign)NSInteger networkPriority;

@property (nonatomic, assign)BOOL debugMode;

@end

@protocol MKNBJServerConfigDeviceFooterViewDelegate <NSObject>

/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl   2:lwtStatus  3:lwtRetain  4:debugMode
- (void)nbj_mqtt_serverForDevice_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID;

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password    3:deviceID   4:ntpURL   5:lwtTopic   6:lwtPayload  7:APN 8:Network_Username  9:Network_Password
- (void)nbj_mqtt_serverForDevice_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID;

/// Qos发生改变
/// @param qos qos
/// @param qosID 0:qos   1:lwtQos
- (void)nbj_mqtt_serverForDevice_qosChanged:(NSInteger)qos qosID:(NSInteger)qosID;

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_serverForDevice_certificateChanged:(NSInteger)certificate;

/// 用户点击了证书相关按钮
/// @param fileType 0:caFaile   1:cilentKeyFile   2:client cert file
- (void)nbj_mqtt_serverForDevice_fileButtonPressed:(NSInteger)fileType;

/// 时区改变
/// @param timeZone -12~12
- (void)nbj_mqtt_serverForDevice_timeZoneChanged:(NSInteger)timeZone;

/// 网络策略发生改变
/// @param priority
/*
 0:eMTC->NB-IOT->GSM
 1:eMTC-> GSM -> NB-IOT
 2:NB-IOT->GSM-> eMTC
 3:NB-IOT-> eMTC-> GSM
 4:GSM -> NB-IOT-> eMTC
 5:GSM -> eMTC->NB-IOT
 6:eMTC->NB-IOT
 7:NB-IOT-> eMTC
 8:GSM
 9:NB-IOT
 10:eMTC
 */
- (void)nbj_mqtt_serverForDevice_priorityChanged:(NSInteger)priority;

/// 底部按钮
/// @param index 0:Export Demo File   1:Import Config File
- (void)nbj_mqtt_serverForDevice_bottomButtonPressed:(NSInteger)index;

@end

@interface MKNBJServerConfigDeviceFooterView : UIView

@property (nonatomic, strong)MKNBJServerConfigDeviceFooterViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJServerConfigDeviceFooterViewDelegate>delegate;

/// 动态刷新高度
/// @param isOn ssl开关是否打开
/// @param caFile 根证书名字
/// @param clientKeyName 客户端私钥名字
/// @param clientCertName 客户端证书
/// @param certificate 当前ssl加密规则
- (CGFloat)fetchHeightWithSSLStatus:(BOOL)isOn
                         CAFileName:(NSString *)caFile
                      clientKeyName:(NSString *)clientKeyName
                     clientCertName:(NSString *)clientCertName
                        certificate:(NSInteger)certificate;

@end

NS_ASSUME_NONNULL_END
