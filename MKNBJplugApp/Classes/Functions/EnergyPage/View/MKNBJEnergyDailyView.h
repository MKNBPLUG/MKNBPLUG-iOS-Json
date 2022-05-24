//
//  MKNBJEnergyDailyView.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/1.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJEnergyDailyView : UIView

/// 更新UI
/// @param dic 参考说明
/*
 @{
     @"year":year,
     @"month":month,
     @"day":day,
     @"hour":hour,
     @"number":@"1",        //How many days of energy data are currently stored.
     @"energyList":energyList,      //The first one in the array represents the energy data of the current day (year-month-day), the second represents the energy data of the previous day, the third represents the energy data of the previous two days, and so on.
 };
 */
- (void)updateDailyDatas:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
