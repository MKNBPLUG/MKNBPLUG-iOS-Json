//
//  MKNBJIndicatorSettingModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJIndicatorSettingModel : NSObject

@property (nonatomic, assign)BOOL connecting;

/// 0:OFF   1:Solid blue for 5 seconds    2:Solid blue
@property (nonatomic, assign)NSInteger connected;

@property (nonatomic, assign)BOOL indicatorStatus;

@property (nonatomic, assign)BOOL protectionSignal;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configServerConnecting:(BOOL)isOn
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configIndicatorStatus:(BOOL)isOn
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configProtectionSignal:(BOOL)isOn
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置指示灯状态
/// @param status 0:Off  1:Solid blue for 5 seconds  2:Solid blue
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)configServerConnectedIndicatorStatus:(NSInteger)status
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
