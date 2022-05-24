//
//  CBPeripheral+MKNBJAdd.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKNBJAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_deviceModel;

@property (nonatomic, strong, readonly)CBCharacteristic *nbj_macAddress;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_notify;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_paramConfig;

/// W
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_debugConfig;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *nbj_log;

- (void)nbj_updateCharacterWithService:(CBService *)service;

- (void)nbj_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)nbj_connectSuccess;

- (void)nbj_setNil;

@end

NS_ASSUME_NONNULL_END
