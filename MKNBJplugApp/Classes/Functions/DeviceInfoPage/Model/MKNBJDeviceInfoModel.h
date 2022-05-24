//
//  MKNBJDeviceInfoModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/24.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJDeviceInfoModel : NSObject

@property (nonatomic, copy)NSString *productModel;

@property (nonatomic, copy)NSString *manufacturer;

@property (nonatomic, copy)NSString *hardware;

@property (nonatomic, copy)NSString *firmware;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *imei;

@property (nonatomic, copy)NSString *iccid;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
