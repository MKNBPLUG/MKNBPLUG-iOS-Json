//
//  MKNBJEasyShowView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJEasyShowView : UIView

- (void)showText:(NSString *)text
       superView:(UIView *)superView
        animated:(BOOL)animated;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
