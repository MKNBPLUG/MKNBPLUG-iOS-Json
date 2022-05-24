//
//  MKNBJEnergyHourlyView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/1.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJEnergyHourlyView : UIView

/// 更新UI
/// @param dic 参考说明
/*
 @{
     @"year":year,
     @"month":month,
     @"day":day,
     @"hour":hour,
     @"number":@"1",        //How many hours of energy data have been accumulated for the day.
     @"energyList":energyList,      //Each data represents one hour's electric energy data, the first one represents 0:00-1:00, the second 2:00-2:00, and so on.
 };
 */
- (void)updateHourlyDatas:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
