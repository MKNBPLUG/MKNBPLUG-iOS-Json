//
//  MKNBJSystemTimeModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJSystemTimeModel : NSObject

@property (nonatomic, assign)NSInteger timezone;

@property (nonatomic, copy)NSString *currentTime;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configTimezone:(NSInteger)timezone
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
