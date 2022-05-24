//
//  MKNBJProtectionConfigModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/3/30.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKNBJProtectionConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJProtectionConfigModel : NSObject

/// 0:欧法   1:美规  2:英规
@property (nonatomic, assign)NSInteger specification;

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *overThreshold;

@property (nonatomic, copy)NSString *timeThreshold;

- (instancetype)initWithType:(nbj_protectionConfigType)type;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
