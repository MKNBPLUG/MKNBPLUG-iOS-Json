//
//  MKNBJElectricityModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJElectricityModel : NSObject

@property (nonatomic, copy)NSString *voltage;

@property (nonatomic, copy)NSString *current;

@property (nonatomic, copy)NSString *power;

@property (nonatomic, copy)NSString *factor;

@property (nonatomic, copy)NSString *frequency;

@property (nonatomic, copy)void (^receiveElectricityBlock)(void);

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
