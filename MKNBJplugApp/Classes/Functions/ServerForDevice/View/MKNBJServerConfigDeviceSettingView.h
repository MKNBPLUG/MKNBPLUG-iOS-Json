//
//  MKNBJServerConfigDeviceSettingView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJServerConfigDeviceSettingViewModel : NSObject

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

@protocol MKNBJServerConfigDeviceSettingViewDelegate <NSObject>

/// 输入框内容发生改变
/// @param text 当前输入框内容
/// @param textID 0:deviceID 1:NTP URL     2:APN  3:UserName  4:Password
- (void)nbj_mqtt_deviecSetting_textChanged:(NSString *)text textID:(NSInteger)textID;

- (void)nbj_mqtt_deviecSetting_timeZoneChanged:(NSInteger)timeZone;

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
- (void)nbj_mqtt_deviecSetting_networkPriorityChanged:(NSInteger)priority;

- (void)nbj_mqtt_deviecSetting_debugModeChanged:(BOOL)isOn;

/// 底部按钮
/// @param index 0:Export Demo File   1:Import Config File
- (void)nbj_mqtt_deviecSetting_fileButtonPressed:(NSInteger)index;

@end

@interface MKNBJServerConfigDeviceSettingView : UIView

@property (nonatomic, strong)MKNBJServerConfigDeviceSettingViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJServerConfigDeviceSettingViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
