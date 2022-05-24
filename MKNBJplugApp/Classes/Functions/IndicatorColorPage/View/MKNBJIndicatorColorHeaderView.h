//
//  MKNBJIndicatorColorHeaderView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/10/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKNBJIndicatorColorHeaderViewDelegate <NSObject>

/// 用户选择了color
/// @param colorType 对应的结果如下:
/*
 nbj_ledColorTransitionDirectly,
 nbj_ledColorTransitionSmoothly,
 nbj_ledColorWhite,
 nbj_ledColorRed,
 nbj_ledColorGreen,
 nbj_ledColorBlue,
 nbj_ledColorOrange,
 nbj_ledColorCyan,
 nbj_ledColorPurple,
 */
- (void)nbj_colorSettingPickViewTypeChanged:(NSInteger)colorType;

@end

@interface MKNBJIndicatorColorHeaderView : UIView

@property (nonatomic, weak)id <MKNBJIndicatorColorHeaderViewDelegate>delegate;

/// 更新当前选中的color
/// @param colorType 对应的结果如下:
/*
 nbj_ledColorTransitionDirectly,
 nbj_ledColorTransitionSmoothly,
 nbj_ledColorWhite,
 nbj_ledColorRed,
 nbj_ledColorGreen,
 nbj_ledColorBlue,
 nbj_ledColorOrange,
 nbj_ledColorCyan,
 nbj_ledColorPurple,
 */
- (void)updateColorType:(NSInteger)colorType;

@end

NS_ASSUME_NONNULL_END
