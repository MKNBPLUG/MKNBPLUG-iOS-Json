//
//  MKNBJExcelDataManager.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/5/5.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKNBJExcelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJExcelDataManager : NSObject

+ (void)exportAppExcel:(id <MKNBJExcelAppProtocol>)protocol
              sucBlock:(void(^)(void))sucBlock
           failedBlock:(void(^)(NSError *error))failedBlock;

+ (void)parseAppExcel:(NSString *)excelName
             sucBlock:(void (^)(NSDictionary *returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)exportDeviceExcel:(id <MKNBJExcelDeviceProtocol>)protocol
                 sucBlock:(void(^)(void))sucBlock
              failedBlock:(void(^)(NSError *error))failedBlock;

+ (void)parseDeviceExcel:(NSString *)excelName
                sucBlock:(void (^)(NSDictionary *returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
