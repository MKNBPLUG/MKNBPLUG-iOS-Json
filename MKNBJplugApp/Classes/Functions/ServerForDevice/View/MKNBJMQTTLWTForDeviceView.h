//
//  MKNBJMQTTLWTForDeviceView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJMQTTLWTForDeviceViewModel : NSObject

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

@property (nonatomic, assign)NSInteger lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@end

@protocol MKNBJMQTTLWTForDeviceViewDelegate <NSObject>

- (void)nbj_lwt_statusChanged:(BOOL)isOn;

- (void)nbj_lwt_retainChanged:(BOOL)isOn;

- (void)nbj_lwt_qosChanged:(NSInteger)qos;

- (void)nbj_lwt_topicChanged:(NSString *)text;

- (void)nbj_lwt_payloadChanged:(NSString *)text;

@end

@interface MKNBJMQTTLWTForDeviceView : UIView

@property (nonatomic, strong)MKNBJMQTTLWTForDeviceViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJMQTTLWTForDeviceViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
