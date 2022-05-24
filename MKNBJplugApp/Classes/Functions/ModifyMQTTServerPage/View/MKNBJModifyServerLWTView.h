//
//  MKNBJModifyServerLWTView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJModifyServerLWTViewModel : NSObject

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

@property (nonatomic, assign)NSInteger lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@end

@protocol MKNBJModifyServerLWTViewDelegate <NSObject>

- (void)nbj_lwt_modifyDevice_statusChanged:(BOOL)isOn;

- (void)nbj_lwt_modifyDevice_retainChanged:(BOOL)isOn;

- (void)nbj_lwt_modifyDevice_qosChanged:(NSInteger)qos;

- (void)nbj_lwt_modifyDevice_topicChanged:(NSString *)text;

- (void)nbj_lwt_modifyDevice_payloadChanged:(NSString *)text;

@end

@interface MKNBJModifyServerLWTView : UIView

@property (nonatomic, strong)MKNBJModifyServerLWTViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJModifyServerLWTViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
