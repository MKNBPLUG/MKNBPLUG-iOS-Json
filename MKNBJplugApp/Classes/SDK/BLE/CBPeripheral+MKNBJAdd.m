//
//  CBPeripheral+MKNBJAdd.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKNBJAdd.h"

#import <objc/runtime.h>

static const char *nbj_manufacturerKey = "nbj_manufacturerKey";
static const char *nbj_macAddressKey = "nbj_macAddressKey";
static const char *nbj_deviceModelKey = "nbj_deviceModelKey";
static const char *nbj_hardwareKey = "nbj_hardwareKey";
static const char *nbj_softwareKey = "nbj_softwareKey";
static const char *nbj_firmwareKey = "nbj_firmwareKey";

static const char *nbj_passwordKey = "nbj_passwordKey";
static const char *nbj_notifyKey = "nbj_notifyKey";
static const char *nbj_paramConfigKey = "nbj_paramConfigKey";
static const char *nbj_debugConfigKey = "nbj_debugConfigKey";
static const char *nbj_logKey = "nbj_logKey";

static const char *nbj_passwordNotifySuccessKey = "nbj_passwordNotifySuccessKey";
static const char *nbj_notifyNotifySuccessKey = "nbj_notifyNotifySuccessKey";
static const char *nbj_paramConfigNotifySuccessKey = "nbj_paramConfigNotifySuccessKey";
static const char *nbj_debugConfigNotifySuccessKey = "nbj_debugConfigNotifySuccessKey";

@implementation CBPeripheral (MKNBJAdd)

- (void)nbj_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &nbj_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
                objc_setAssociatedObject(self, &nbj_macAddressKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &nbj_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &nbj_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &nbj_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &nbj_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &nbj_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &nbj_notifyKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &nbj_paramConfigKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                objc_setAssociatedObject(self, &nbj_debugConfigKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
                objc_setAssociatedObject(self, &nbj_logKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
}

- (void)nbj_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &nbj_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &nbj_notifyNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &nbj_paramConfigNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        objc_setAssociatedObject(self, &nbj_debugConfigNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)nbj_connectSuccess {
    if (![objc_getAssociatedObject(self, &nbj_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &nbj_notifyNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &nbj_paramConfigNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &nbj_debugConfigNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.nbj_manufacturer || !self.nbj_macAddress || !self.nbj_deviceModel || !self.nbj_hardware || !self.nbj_software || !self.nbj_firmware) {
        return NO;
    }
    if (!self.nbj_password || !self.nbj_notify || !self.nbj_paramConfig || !self.nbj_debugConfig || !self.nbj_log) {
        return NO;
    }
    return YES;
}

- (void)nbj_setNil {
    objc_setAssociatedObject(self, &nbj_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_macAddressKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &nbj_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_notifyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_paramConfigKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_debugConfigKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_logKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &nbj_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_notifyNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_paramConfigNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &nbj_debugConfigNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)nbj_manufacturer {
    return objc_getAssociatedObject(self, &nbj_manufacturerKey);
}

- (CBCharacteristic *)nbj_macAddress {
    return objc_getAssociatedObject(self, &nbj_macAddressKey);
}

- (CBCharacteristic *)nbj_deviceModel {
    return objc_getAssociatedObject(self, &nbj_deviceModelKey);
}

- (CBCharacteristic *)nbj_hardware {
    return objc_getAssociatedObject(self, &nbj_hardwareKey);
}

- (CBCharacteristic *)nbj_software {
    return objc_getAssociatedObject(self, &nbj_softwareKey);
}

- (CBCharacteristic *)nbj_firmware {
    return objc_getAssociatedObject(self, &nbj_firmwareKey);
}

- (CBCharacteristic *)nbj_password {
    return objc_getAssociatedObject(self, &nbj_passwordKey);
}

- (CBCharacteristic *)nbj_notify {
    return objc_getAssociatedObject(self, &nbj_notifyKey);
}

- (CBCharacteristic *)nbj_paramConfig {
    return objc_getAssociatedObject(self, &nbj_paramConfigKey);
}

- (CBCharacteristic *)nbj_debugConfig {
    return objc_getAssociatedObject(self, &nbj_debugConfigKey);
}

- (CBCharacteristic *)nbj_log {
    return objc_getAssociatedObject(self, &nbj_logKey);
}

@end
