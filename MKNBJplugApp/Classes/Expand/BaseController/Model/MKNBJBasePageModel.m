//
//  MKNBJBasePageModel.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJBasePageModel.h"

#import "MKMacroDefines.h"

#import "MKNBJDeviceModeManager.h"

#import "MKNBJMQTTServerManager.h"

@implementation MKNBJBasePageModel

- (void)dealloc {
    NSLog(@"MKNBJBasePageModel销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDeviceLoadChanged:)
                                                     name:MKNBJDeviceLoadStatusChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOverload:)
                                                     name:MKNBJReceiveOverloadNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOvercurrent:)
                                                     name:MKNBJReceiveOverCurrentNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOvervoltage:)
                                                     name:MKNBJReceiveOvervoltageNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceUndervoltage:)
                                                     name:MKNBJReceiveUndervoltageNotification
                                                   object:nil];
    }
    return self;
}

- (void)receiveDeviceLoadChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL load = ([user[@"data"][@"load"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveLoadStatusChangedBlock) {
            self.receiveLoadStatusChangedBlock(load);
        }
    });
}

- (void)deviceOverload:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL overload = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOverloadBlock) {
            self.receiveOverloadBlock(overload);
        }
    });
}

- (void)deviceOvercurrent:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL overcurrent = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOvercurrentBlock) {
            self.receiveOvercurrentBlock(overcurrent);
        }
    });
}

- (void)deviceOvervoltage:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL overvoltage = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOvervoltageBlock) {
            self.receiveOvervoltageBlock(overvoltage);
        }
    });
}

- (void)deviceUndervoltage:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"]) || ![user[@"device_info"][@"device_id"] isEqualToString:[MKNBJDeviceModeManager shared].deviceID]) {
        return;
    }
    BOOL undervoltage = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveUndervoltageBlock) {
            self.receiveUndervoltageBlock(undervoltage);
        }
    });
}

@end
