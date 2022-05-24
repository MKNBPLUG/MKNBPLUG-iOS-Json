//
//  MKNBJEnergyModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJEnergyModel : NSObject

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
@property (nonatomic, strong)NSDictionary *hourlyDic;

/*
 @{
     @"date":2022-04-28
     @"number":@"1",        //How many days of energy data are currently stored.
     @"energyList":energyList,      //The first one in the array represents the energy data of the current day (year-month-day), the second represents the energy data of the previous day, the third represents the energy data of the previous two days, and so on.
 };
 */
@property (nonatomic, strong)NSDictionary *dailyDic;

@property (nonatomic, strong)NSString *totalEnergy;

- (NSString *)deviceName;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)clearEnergyDatasWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
