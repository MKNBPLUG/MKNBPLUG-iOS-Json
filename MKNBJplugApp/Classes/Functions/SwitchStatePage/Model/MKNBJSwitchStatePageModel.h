//
//  MKNBJSwitchStatePageModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJSwitchStatePageModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL overload;

@property (nonatomic, assign)BOOL overcurrent;

@property (nonatomic, assign)BOOL overvoltage;

@property (nonatomic, assign)BOOL undervoltage;

#pragma mark - 数据回调

/// 设备上报开关状态回调
@property (nonatomic, copy)void (^switchStateChangedBlock)(NSDictionary *dataDic);

/// 设备上报倒计时回调
@property (nonatomic, copy)void (^receiveCountdownDataBlock)(NSDictionary *dataDic);

/// 设备过载回调
@property (nonatomic, copy)void (^receiveOverloadBlock)(BOOL overload);

/// 设备过压回调
@property (nonatomic, copy)void (^receiveOvervoltageBlock)(BOOL overvoltage);

/// 设备欠压回调
@property (nonatomic, copy)void (^receiveUndervoltageBlock)(BOOL undervoltage);

/// 设备过流回调
@property (nonatomic, copy)void (^receiveOvercurrentBlock)(BOOL overcurrent);

/// 设备负载发生改变回调
@property (nonatomic, copy)void (^receiveLoadStatusChangedBlock)(BOOL load);

#pragma mark -

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configSwitchStatus:(BOOL)isOn
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configCountdown:(NSInteger)second
               sucBlock:(void (^)(id returnData))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

- (void)clearOverloadWithSucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

- (void)clearOvercurrentWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

- (void)clearOvervoltageWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

- (void)clearUndervoltageWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
