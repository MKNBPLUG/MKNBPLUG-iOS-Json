//
//  Target_MokoNBPlug_Json_Module.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "Target_MokoNBPlug_Json_Module.h"

#import "MKNBJDeviceListController.h"

@implementation Target_MokoNBPlug_Json_Module

- (UIViewController *)Action_MokoNBPlug_Json_Module_DeviceListController:(NSDictionary *)params {
    MKNBJDeviceListController *vc = [[MKNBJDeviceListController alloc] init];
    vc.connectServer = [params[@"connect"] boolValue];
    return vc;
}

@end
