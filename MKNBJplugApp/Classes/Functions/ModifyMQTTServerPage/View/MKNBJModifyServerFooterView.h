//
//  MKNBJModifyServerFooterView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/6.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJModifyServerFooterViewModel : NSObject

@property (nonatomic, assign)BOOL cleanSession;

@property (nonatomic, assign)NSInteger qos;

@property (nonatomic, copy)NSString *keepAlive;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA certificate     1:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

/// 证书所在服务器Host
@property (nonatomic, copy)NSString *sslHost;

/// 证书所在服务器Port
@property (nonatomic, copy)NSString *sslPort;

@property (nonatomic, copy)NSString *caFilePath;

@property (nonatomic, copy)NSString *clientKeyPath;

@property (nonatomic, copy)NSString *clientCertPath;

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

/// lwtStatus is ON: 0/1/2
@property (nonatomic, assign)NSInteger lwtQos;

/// lwtStatus is ON:1-128Characters
@property (nonatomic, copy)NSString *lwtTopic;

/// lwtStatus is ON:1-128Characters
@property (nonatomic, copy)NSString *lwtPayload;

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

@end

@protocol MKNBJModifyServerFooterViewDelegate <NSObject>

/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl   2:LWT    3:LWT Retain
- (void)nbj_mqtt_modifyMQTT_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID;

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password    3:LWT Topic   4:LWT Payload  5:sslHost    6:sslPort
///  7:CA File Path    8:Client Key File   9:Client Cert  File  10:APN 11:Network_Username  12:Network_Password
- (void)nbj_mqtt_modifyMQTT_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID;

/// qos发生改变
/// @param qos qos
/// @param qosID 0:Qos   1:LWT Qos
- (void)nbj_mqtt_modifyMQTT_qosChanged:(NSInteger)qos qosID:(NSInteger)qosID;

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_modifyMQTT_certificateChanged:(NSInteger)certificate;

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
- (void)nbj_mqtt_modifyMQTT_priorityChanged:(NSInteger)priority;

@end

@interface MKNBJModifyServerFooterView : UIView

@property (nonatomic, strong)MKNBJModifyServerFooterViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJModifyServerFooterViewDelegate>delegate;

/// 动态刷新高度
/// @param isOn ssl开关是否打开
/// @param certificate 当前ssl加密规则
- (CGFloat)fetchHeightWithSSLStatus:(BOOL)isOn
                        certificate:(NSInteger)certificate;

@end

NS_ASSUME_NONNULL_END
