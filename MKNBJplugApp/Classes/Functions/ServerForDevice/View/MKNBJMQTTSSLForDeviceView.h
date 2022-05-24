//
//  MKNBJMQTTSSLForDeviceView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJMQTTSSLForDeviceViewModel : NSObject

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA certificate     1:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFileName;

@property (nonatomic, copy)NSString *clientKeyName;

@property (nonatomic, copy)NSString *clientCertName;

@end

@protocol MKNBJMQTTSSLForDeviceViewDelegate <NSObject>

- (void)nbj_mqtt_sslParams_device_sslStatusChanged:(BOOL)isOn;

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_sslParams_device_certificateChanged:(NSInteger)certificate;

/// 用户点击选择了caFaile按钮
- (void)nbj_mqtt_sslParams_device_caFilePressed;

/// 用户点击选择了Client Key按钮
- (void)nbj_mqtt_sslParams_device_clientKeyPressed;

/// 用户点击了Client Cert File按钮
- (void)nbj_mqtt_sslParams_device_clientCertPressed;

@end

@interface MKNBJMQTTSSLForDeviceView : UIView

@property (nonatomic, strong)MKNBJMQTTSSLForDeviceViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJMQTTSSLForDeviceViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
