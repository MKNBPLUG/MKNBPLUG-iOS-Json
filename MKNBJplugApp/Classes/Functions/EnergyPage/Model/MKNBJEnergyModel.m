//
//  MKNBJEnergyModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJEnergyModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTServerManager.h"
#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJEnergyModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKNBJEnergyModel

- (NSString *)deviceName {
    return [MKNBJDeviceModeManager shared].deviceName;
}

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readHourlyDatas]) {
            [self operationFailedBlockWithMsg:@"Read Hourly Data Timeout" block:failedBlock];
            return;
        }
        if (![self readDailyDatas]) {
            [self operationFailedBlockWithMsg:@"Read Daily Data Timeout" block:failedBlock];
            return;
        }
        if (![self readTotalEnergy]) {
            [self operationFailedBlockWithMsg:@"Read Total Data Timeout" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)clearEnergyDatasWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_clearAllEnergyDatasWithdeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if (sucBlock) {
            sucBlock();
        }
    } failedBlock:failedBlock];
}

#pragma mark - interface

- (BOOL)readHourlyDatas {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readHourlyEnergyDataWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.hourlyDic = [self fetchEnergyDataDic:returnData[@"data"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDailyDatas {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readMonthlyEnergyDataWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dailyDic = [self fetchEnergyDataDic:returnData[@"data"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTotalEnergy {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readTotalEnergyDataWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger totalValue = [returnData[@"data"][@"energy"] integerValue];
        self.totalEnergy = [NSString stringWithFormat:@"%.2f",(totalValue * 0.01)];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"EnergyPageParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (NSDictionary *)fetchEnergyDataDic:(NSDictionary *)dic {
    NSString *timestamp = dic[@"timestamp"];
    NSArray *timestampList = [timestamp componentsSeparatedByString:@"T"];
    NSString *year = @"";
    NSString *month = @"";
    NSString *day = @"";
    NSString *hour = @"";
    if (ValidArray(timestampList) && timestampList.count == 2) {
        NSString *dateString = timestampList[0];
        NSArray *dateList = [dateString componentsSeparatedByString:@"-"];
        if (ValidArray(dateList) && dateList.count == 3) {
            year = dateList[0];
            month = dateList[1];
            day = dateList[2];
        }
        NSString *timeString = timestampList[1];
        NSArray *timeList = [timeString componentsSeparatedByString:@"+"];
        if (ValidArray(timeList) && timeList.count == 2) {
            NSString *tempString = timeList[0];
            NSArray *hourList = [tempString componentsSeparatedByString:@":"];
            if (ValidArray(hourList) && hourList.count == 3) {
                hour = hourList[0];
            }
        }
    }
    NSString *num = [NSString stringWithFormat:@"%@",dic[@"num"]];
    NSArray *tempList = dic[@"energy"];
    NSMutableArray *energyList = [NSMutableArray array];
    for (NSInteger i = 0; i < tempList.count; i ++) {
        NSNumber *value = tempList[i];
        NSString *energyValue = [NSString stringWithFormat:@"%.2f",([value integerValue] * 0.01)];
        [energyList addObject:energyValue];
    }
    NSDictionary *resultDic = @{
        @"year":year,
        @"month":month,
        @"day":day,
        @"hour":hour,
        @"number":num,
        @"energyList":energyList,
    };
    return resultDic;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("EnergyPageQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
