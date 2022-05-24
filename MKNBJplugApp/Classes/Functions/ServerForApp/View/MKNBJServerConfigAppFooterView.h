//
//  MKNBJServerConfigAppFooterView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJServerConfigAppFooterViewModel : NSObject

@property (nonatomic, assign)BOOL cleanSession;

@property (nonatomic, assign)NSInteger qos;

@property (nonatomic, copy)NSString *keepAlive;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA certificate     1:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFileName;

@property (nonatomic, copy)NSString *clientFileName;

@end

@protocol MKNBJServerConfigAppFooterViewDelegate <NSObject>

/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl
- (void)nbj_mqtt_serverForApp_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID;

- (void)nbj_mqtt_serverForApp_qosChanged:(NSInteger)qos;

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password
- (void)nbj_mqtt_serverForApp_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID;

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_serverForApp_certificateChanged:(NSInteger)certificate;

/// 用户点击了证书相关按钮
/// @param fileType 0:caFaile   1:P12证书
- (void)nbj_mqtt_serverForApp_fileButtonPressed:(NSInteger)fileType;

/// 底部按钮点击事件
/// @param index 0:Export Demo File   1:Import Config File
- (void)nbj_mqtt_serverForApp_bottomButtonPressed:(NSInteger)index;

@end

@interface MKNBJServerConfigAppFooterView : UIView

@property (nonatomic, strong)MKNBJServerConfigAppFooterViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJServerConfigAppFooterViewDelegate>delegate;

/// 动态刷新高度
/// @param isOn ssl开关是否打开
/// @param caFile 根证书名字
/// @param clientName 设备证书名字
/// @param certificate 当前ssl加密规则
- (CGFloat)fetchHeightWithSSLStatus:(BOOL)isOn
                         CAFileName:(NSString *)caFile
                         clientName:(NSString *)clientName
                        certificate:(NSInteger)certificate;

@end

NS_ASSUME_NONNULL_END
