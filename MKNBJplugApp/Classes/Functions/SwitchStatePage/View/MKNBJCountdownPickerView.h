//
//  MKNBJCountdownPickerView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJCountdownPickerViewModel : NSObject

@property (nonatomic, copy)NSString *hour;

@property (nonatomic, copy)NSString *minutes;

@property (nonatomic, copy)NSString *titleMsg;

@end

@interface MKNBJCountdownPickerView : UIView

@property (nonatomic, strong)MKNBJCountdownPickerViewModel *timeModel;

- (void)showTimePickViewBlock:(void (^)(MKNBJCountdownPickerViewModel *timeModel))Block;

@end

NS_ASSUME_NONNULL_END
