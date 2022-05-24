//
//  MKNBJSwitchViewButton.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJSwitchViewButtonModel : NSObject

@property (nonatomic, strong)UIImage *icon;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, strong)UIColor *msgColor;

@end

@interface MKNBJSwitchViewButton : UIControl

@property (nonatomic, strong)MKNBJSwitchViewButtonModel *dataModel;

@end

NS_ASSUME_NONNULL_END
