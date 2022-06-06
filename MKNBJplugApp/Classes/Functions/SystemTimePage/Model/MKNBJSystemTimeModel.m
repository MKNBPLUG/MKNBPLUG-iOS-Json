//
//  MKNBJSystemTimeModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJSystemTimeModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTInterface.h"
#import "MKNBJMQTTInterface+MKNBJConfig.h"

@interface MKNBJSystemTimeModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, strong)NSArray *timeZoneList;

@property (nonatomic, strong)NSArray *timeZoneValueList;

@end

@implementation MKNBJSystemTimeModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readTimezone]) {
            [self operationFailedBlockWithMsg:@"Read Timezone Timeout" block:failedBlock];
            return;
        }
        if (![self readUTCTime]) {
            [self operationFailedBlockWithMsg:@"Read UTC Time Timeout" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configTimezone:(NSInteger)timezone
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    [MKNBJMQTTInterface nbj_configDeviceTimeZone:(timezone - 24) deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if (sucBlock) {
            sucBlock();
        }
    } failedBlock:failedBlock];
}

- (void)configUTCTimeWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    [MKNBJMQTTInterface nbj_configDeviceUTCTime:timeInterval deviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if (sucBlock) {
            sucBlock();
        }
    } failedBlock:failedBlock];
}

#pragma mark - interfae
- (BOOL)readTimezone {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readTimeZoneWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timezone = [returnData[@"data"][@"time_zone"] integerValue] + 24;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readUTCTime {
    __block BOOL success = NO;
    [MKNBJMQTTInterface nbj_readDeviceUTCTimeWithDeviceID:[MKNBJDeviceModeManager shared].deviceID macAddress:[MKNBJDeviceModeManager shared].macAddress topic:[MKNBJDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        long long timestamp = [returnData[@"data"][@"time"] integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSNumber *timeZoneValue = self.timeZoneValueList[self.timezone];
        NSInteger seconds = ([timeZoneValue integerValue] * 360);
        NSTimeZone *tempZone = [NSTimeZone timeZoneForSecondsFromGMT:seconds];
        [formatter setTimeZone:tempZone];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSString *timeString = [formatter stringFromDate:date];
                
        self.currentTime = [NSString stringWithFormat:@"Device time:%@ %@",timeString,self.timeZoneList[self.timezone]];
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
        NSError *error = [[NSError alloc] initWithDomain:@"sysTimeParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
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
        _readQueue = dispatch_queue_create("sysTimeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

- (NSArray *)timeZoneList {
    if (!_timeZoneList) {
        _timeZoneList = @[@"UTC-12:00",@"UTC-11:30",@"UTC-11:00",@"UTC-10:30",@"UTC-10:00",@"UTC-09:30",
                          @"UTC-09:00",@"UTC-08:30",@"UTC-08:00",@"UTC-07:30",@"UTC-07:00",@"UTC-06:30",
                          @"UTC-06:00",@"UTC-05:30",@"UTC-05:00",@"UTC-04:30",@"UTC-04:00",@"UTC-03:30",
                          @"UTC-03:00",@"UTC-02:30",@"UTC-02:00",@"UTC-01:30",@"UTC-01:00",@"UTC-00:30",
                          @"UTC+00:00",@"UTC+00:30",@"UTC+01:00",@"UTC+01:30",@"UTC+02:00",@"UTC+02:30",
                          @"UTC+03:00",@"UTC+03:30",@"UTC+04:00",@"UTC+04:30",@"UTC+05:00",@"UTC+05:30",
                          @"UTC+06:00",@"UTC+06:30",@"UTC+07:00",@"UTC+07:30",@"UTC+08:00",@"UTC+08:30",
                          @"UTC+09:00",@"UTC+09:30",@"UTC+10:00",@"UTC+10:30",@"UTC+11:00",@"UTC+11:30",
                          @"UTC+12:00",@"UTC+12:30",@"UTC+13:00",@"UTC+13:30",@"UTC+14:00"];
    }
    return _timeZoneList;
}

- (NSArray *)timeZoneValueList {
    if (!_timeZoneValueList) {
        _timeZoneValueList = @[@(-120),@(-115),@(-110),@(-105),@(-100),@(-95),
                               @(-90),@(-85),@(-80),@(-75),@(-70),@(-65),
                               @(-60),@(-55),@(-50),@(-45),@(-40),@(-35),
                               @(-30),@(-25),@(-20),@(-15),@(-10),@(-5),
                               @(0),@(5),@(10),@(15),@(20),@(25),
                               @(30),@(35),@(40),@(45),@(50),@(55),
                               @(60),@(65),@(70),@(75),@(80),@(85),
                               @(90),@(95),@(100),@(105),@(110),@(115),
                               @(120),@(125),@(130),@(135),@(140)];
    }
    return _timeZoneValueList;
}

@end
