//
//  MKNBJInterface.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJInterface.h"

#import "MKNBJCentralManager.h"
#import "MKNBJOperationID.h"
#import "MKNBJOperation.h"
#import "CBPeripheral+MKNBJAdd.h"

#define centralManager [MKNBJCentralManager shared]
#define peripheral ([MKNBJCentralManager shared].peripheral)

@implementation MKNBJInterface

+ (void)nbj_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    
    [self readDataWithTaskID:mk_nbj_taskReadDeviceNameOperation
                     cmdFlag:@"4e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)nbj_readDeviceMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_nbj_taskReadDeviceMacAddressOperation
                     cmdFlag:@"4f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark - private method

+ (void)readDataWithTaskID:(mk_nbj_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.nbj_paramConfig
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
