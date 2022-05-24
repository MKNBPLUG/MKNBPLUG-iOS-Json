//
//  MKNBJDeviceListDatabaseManager.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/14.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJDeviceListDatabaseManager.h"

#import <FMDB/FMDB.h>

#import "MKMacroDefines.h"

#import "MKNBJDeviceModel.h"

@implementation MKNBJDeviceListDatabaseManager

+ (BOOL)initDataBase {
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"NBJDeviceDB")];
    if (![db open]) {
        return NO;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists NBJDeviceTable (deviceID text,clientID text,deviceName text,localName text,subscribedTopic text,publishedTopic text,macAddress text,deviceType text)"];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        return NO;
    }
    return YES;
}

+ (void)insertDeviceList:(NSArray <MKNBJDeviceModel *>*)deviceList
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!deviceList) {
        [self operationInsertFailedBlock:failedBlock];
        return ;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"NBJDeviceDB")];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists NBJDeviceTable (deviceID text,clientID text,deviceName text,localName text,subscribedTopic text,publishedTopic text,macAddress text,deviceType text)"];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"NBJDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        for (MKNBJDeviceModel *device in deviceList) {
            BOOL exist = NO;
            FMResultSet * result = [db executeQuery:@"select * from NBJDeviceTable where macAddress = ?",device.macAddress];
            while (result.next) {
                if ([device.macAddress isEqualToString:[result stringForColumn:@"macAddress"]]) {
                    exist = YES;
                }
            }
            if (exist) {
                //存在该设备，更新设备
                [db executeUpdate:@"UPDATE NBJDeviceTable SET deviceID = ?, clientID = ?, deviceName = ? , localName = ? ,subscribedTopic = ? ,publishedTopic = ? ,deviceType = ? WHERE macAddress = ?",SafeStr(device.deviceID),SafeStr(device.clientID),SafeStr(device.deviceName),SafeStr(device.localName),SafeStr(device.subscribedTopic),SafeStr(device.publishedTopic),SafeStr(device.deviceType),SafeStr(device.macAddress)];
            }else{
                //不存在，插入设备
                [db executeUpdate:@"INSERT INTO NBJDeviceTable (deviceID,clientID,deviceName,localName,subscribedTopic,publishedTopic,macAddress,deviceType) VALUES (?,?,?,?,?,?,?,?)",SafeStr(device.deviceID),SafeStr(device.clientID),SafeStr(device.deviceName),SafeStr(device.localName),SafeStr(device.subscribedTopic),SafeStr(device.publishedTopic),SafeStr(device.macAddress),SafeStr(device.deviceType)];
            }
        }
        
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)deleteDeviceWithMacAddress:(NSString *)macAddress
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(macAddress)) {
        [self operationDeleteFailedBlock:failedBlock];
        return;
    }
    
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"NBJDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:@"DELETE FROM NBJDeviceTable WHERE macAddress = ?",macAddress];
        if (!result) {
            [self operationDeleteFailedBlock:failedBlock];
            return;
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)readLocalDeviceWithSucBlock:(void (^)(NSArray <MKNBJDeviceModel *>*deviceList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"NBJDeviceDB")];
    if (![db open]) {
        [self operationGetDataFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"NBJDeviceDB")] inDatabase:^(FMDatabase *db) {
        NSMutableArray *tempDataList = [NSMutableArray array];
        FMResultSet * result = [db executeQuery:@"SELECT * FROM NBJDeviceTable"];
        while ([result next]) {
            MKNBJDeviceModel *dataModel = [[MKNBJDeviceModel alloc] init];
            dataModel.deviceID = SafeStr([result stringForColumn:@"deviceID"]);
            dataModel.clientID = SafeStr([result stringForColumn:@"clientID"]);
            dataModel.deviceName = SafeStr([result stringForColumn:@"deviceName"]);
            dataModel.subscribedTopic = SafeStr([result stringForColumn:@"subscribedTopic"]);
            dataModel.publishedTopic = SafeStr([result stringForColumn:@"publishedTopic"]);
            dataModel.macAddress = SafeStr([result stringForColumn:@"macAddress"]);
            dataModel.deviceType = SafeStr([result stringForColumn:@"deviceType"]);
            dataModel.localName = SafeStr([result stringForColumn:@"localName"]);
        
            [tempDataList addObject:dataModel];
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock(tempDataList);
            });
        }
        [db close];
    }];
}

+ (void)updateLocalName:(NSString *)localName
             macAddress:(NSString *)macAddress
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(localName) || !ValidStr(macAddress)) {
        [self operationDeleteFailedBlock:failedBlock];
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"NBJDeviceDB")];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"NBJDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        BOOL exist = NO;
        FMResultSet * result = [db executeQuery:@"select * from NBJDeviceTable where macAddress = ?",macAddress];
        while (result.next) {
            if ([macAddress isEqualToString:[result stringForColumn:@"macAddress"]]) {
                exist = YES;
            }
        }
        if (!exist) {
            [self operationUpdateFailedBlock:failedBlock];
            [db close];
            return;
        }
        //存在该设备，更新设备
        [db executeUpdate:@"UPDATE NBJDeviceTable SET deviceName = ? WHERE macAddress = ?",localName,macAddress];
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)updateClientID:(NSString *)clientID
       subscribedTopic:(NSString *)subscribedTopic
        publishedTopic:(NSString *)publishedTopic
            macAddress:(NSString *)macAddress
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(clientID) || !ValidStr(macAddress) || !ValidStr(subscribedTopic) || !ValidStr(publishedTopic)) {
        [self operationDeleteFailedBlock:failedBlock];
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"NBJDeviceDB")];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"NBJDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        BOOL exist = NO;
        FMResultSet * result = [db executeQuery:@"select * from NBJDeviceTable where macAddress = ?",macAddress];
        while (result.next) {
            if ([macAddress isEqualToString:[result stringForColumn:@"macAddress"]]) {
                exist = YES;
            }
        }
        if (!exist) {
            [self operationUpdateFailedBlock:failedBlock];
            [db close];
            return;
        }
        //存在该设备，更新设备
        [db executeUpdate:@"UPDATE NBJDeviceTable SET clientID = ?, subscribedTopic = ? ,publishedTopic = ? WHERE macAddress = ?",SafeStr(clientID),SafeStr(subscribedTopic),SafeStr(publishedTopic),SafeStr(macAddress)];
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)operationFailedBlock:(void (^)(NSError *error))block msg:(NSString *)msg{
    if (block) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.databaseOperation"
                                                    code:-111111
                                                userInfo:@{@"errorInfo":msg}];
        moko_dispatch_main_safe(^{
            block(error);
        });
    }
}

+ (void)operationInsertFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"insert data error"];
}

+ (void)operationUpdateFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"update data error"];
}

+ (void)operationDeleteFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"fail to delete"];
}

+ (void)operationGetDataFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"get data error"];
}

@end
