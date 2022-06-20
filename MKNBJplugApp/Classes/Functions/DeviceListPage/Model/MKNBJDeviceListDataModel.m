//
//  MKNBJDeviceListDataModel.m
//  MKNBPlugApp
//
//  Created by aa on 2022/6/18.
//

#import "MKNBJDeviceListDataModel.h"

#import "MKMacroDefines.h"

#import "MKNBJMQTTServerManager.h"

@implementation MKNBJDeviceListDataModel

- (void)dealloc {
    NSLog(@"MKNBJDeviceListDataModel销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDeviceOnlineState:)
                                                     name:MKNBJReceiveDeviceNetStateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDeviceStateChanged:)
                                                     name:MKNBJReceivedSwitchStateNotification
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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDeviceNameChanged:)
                                                     name:@"mk_nbj_deviceNameChangedNotification"
                                                   object:nil];
    }
    return self;
}

#pragma mark - notes
- (void)receiveDeviceOnlineState:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"deviceID"])) {
        return;
    }
    moko_dispatch_main_safe(^{
        if (self.deviceOnlineBlock) {
            self.deviceOnlineBlock(user[@"deviceID"]);
        }
    });
}

- (void)receiveDeviceStateChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"])) {
        return;
    }
    moko_dispatch_main_safe(^{
        if (self.switchStateChangedBlock) {
            self.switchStateChangedBlock(user[@"data"],user[@"device_info"][@"device_id"]);
        }
    });
}

- (void)deviceOverload:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"])) {
        return;
    }
    BOOL overload = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOverloadBlock) {
            self.receiveOverloadBlock(overload,user[@"device_info"][@"device_id"]);
        }
    });
}

- (void)deviceOvercurrent:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"])) {
        return;
    }
    BOOL overcurrent = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOvercurrentBlock) {
            self.receiveOvercurrentBlock(overcurrent,user[@"device_info"][@"device_id"]);
        }
    });
}

- (void)deviceOvervoltage:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"])) {
        return;
    }
    BOOL overvoltage = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveOvervoltageBlock) {
            self.receiveOvervoltageBlock(overvoltage,user[@"device_info"][@"device_id"]);
        }
    });
}

- (void)deviceUndervoltage:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"device_id"])) {
        return;
    }
    BOOL undervoltage = ([user[@"data"][@"state"] integerValue] == 1);
    moko_dispatch_main_safe(^{
        if (self.receiveUndervoltageBlock) {
            self.receiveUndervoltageBlock(undervoltage,user[@"device_info"][@"device_id"]);
        }
    });
}

- (void)receiveDeviceNameChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || !ValidStr(user[@"deviceName"])) {
        return;
    }
    moko_dispatch_main_safe(^{
        if (self.receiveDeviceNameChangedBlock) {
            self.receiveDeviceNameChangedBlock(user[@"macAddress"], user[@"deviceName"]);
        }
    });
}

@end
