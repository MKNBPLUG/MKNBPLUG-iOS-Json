//
//  MKNBJUserCredentialsView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKNBJUserCredentialsViewDelegate <NSObject>

- (void)nbj_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)nbj_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKNBJUserCredentialsView : UIView

@property (nonatomic, strong)MKNBJUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKNBJUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
