//
//  MKNBJBasePageModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJBasePageModel : NSObject

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

@end

NS_ASSUME_NONNULL_END
