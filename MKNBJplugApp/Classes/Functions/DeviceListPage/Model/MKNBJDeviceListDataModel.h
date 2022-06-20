//
//  MKNBJDeviceListDataModel.h
//  MKNBPlugApp
//
//  Created by aa on 2022/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJDeviceListDataModel : NSObject

/// 设备上线通知
@property (nonatomic, copy)void (^deviceOnlineBlock)(NSString *deviceID);

/// 设备上报开关状态回调
@property (nonatomic, copy)void (^switchStateChangedBlock)(NSDictionary *dataDic, NSString *deviceID);

/// 设备过载回调
@property (nonatomic, copy)void (^receiveOverloadBlock)(BOOL overload, NSString *deviceID);

/// 设备过压回调
@property (nonatomic, copy)void (^receiveOvervoltageBlock)(BOOL overvoltage, NSString *deviceID);

/// 设备欠压回调
@property (nonatomic, copy)void (^receiveUndervoltageBlock)(BOOL undervoltage, NSString *deviceID);

/// 设备过流回调
@property (nonatomic, copy)void (^receiveOvercurrentBlock)(BOOL overcurrent, NSString *deviceID);

/// 修改了设备在本地的存储名称回调
@property (nonatomic, copy)void (^receiveDeviceNameChangedBlock)(NSString *macAddress, NSString *deviceName);

@end

NS_ASSUME_NONNULL_END
