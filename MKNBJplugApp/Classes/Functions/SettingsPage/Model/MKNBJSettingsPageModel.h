//
//  MKNBJSettingsPageModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJSettingsPageModel : NSObject

@property (nonatomic, assign)BOOL debugMode;

@property (nonatomic, assign)BOOL switchByButton;

- (NSString *)macAddress;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configSwitchByButton:(BOOL)isOn
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

- (void)resetDeviceWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
