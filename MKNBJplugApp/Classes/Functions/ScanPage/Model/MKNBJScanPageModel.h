//
//  MKNBJScanPageModel.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKNBJScanPageModel : NSObject

@property (nonatomic, copy)NSString *deviceType;

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *firmware;

@property (nonatomic, assign)BOOL connectable;

/// @"0":Production test mode.    @"1":configuration mode.    @"2":Debug mode.
@property (nonatomic, copy)NSString *mode;

@end

NS_ASSUME_NONNULL_END
