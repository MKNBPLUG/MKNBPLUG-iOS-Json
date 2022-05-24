//
//  MKNBJSettingPageBleModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJSettingPageBleModel : NSObject

- (void)connectDeviceWithMacAddress:(NSString *)macAddress
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
