//
//  MKNBJLogDatabaseManager.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJLogDatabaseManager.h"

#import <FMDB/FMDB.h>

#import "MKMacroDefines.h"

@implementation MKNBJLogDatabaseManager

+ (void)insertLogDatas:(NSArray <NSDictionary *>*)logList
            macAddress:(NSString *)macAddress
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (!logList) {
        [self operationInsertFailedBlock:failedBlock];
        return ;
    }
    NSString *databaseName = [NSString stringWithFormat:@"%@.Table",macAddress];
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(databaseName)];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists MKNBJLogDataTable (key text,date text,logDetails text)"];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(databaseName)] inDatabase:^(FMDatabase *db) {
        
        for (NSDictionary *logDic in logList) {
            BOOL exist = NO;
            FMResultSet * result = [db executeQuery:@"select * from MKNBJLogDataTable where key = ?",SafeStr(logDic[@"key"])];
            while (result.next) {
                if ([logDic[@"key"] isEqualToString:[result stringForColumn:@"key"]]) {
                    exist = YES;
                }
            }
            if (exist) {
                //存在该设备，更新设备
                [db executeUpdate:@"UPDATE MKNBJLogDataTable SET logDetails = ?, date = ? WHERE key = ?",SafeStr(logDic[@"logDetails"]),SafeStr(logDic[@"date"]),SafeStr(logDic[@"key"])];
            }else{
                //不存在，插入设备
                [db executeUpdate:@"INSERT INTO MKNBJLogDataTable (key,date,logDetails) VALUES (?,?,?)",SafeStr(logDic[@"key"]),SafeStr(logDic[@"date"]),SafeStr(logDic[@"logDetails"])];
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

+ (void)readLocalLogsWithMacAddress:(NSString *)macAddress
                           sucBlock:(void (^)(NSArray <NSDictionary *>*logList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *databaseName = [NSString stringWithFormat:@"%@.Table",macAddress];
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(databaseName)];
    if (![db open]) {
        [self operationGetDataFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(databaseName)] inDatabase:^(FMDatabase *db) {
        NSMutableArray *tempDataList = [NSMutableArray array];
        FMResultSet * result = [db executeQuery:@"SELECT * FROM MKNBJLogDataTable"];
        while ([result next]) {
            NSDictionary *dic = @{
                @"key":SafeStr([result stringForColumn:@"key"]),
                @"logDetails":SafeStr([result stringForColumn:@"logDetails"]),
                @"date":SafeStr([result stringForColumn:@"date"]),
            };
        
            [tempDataList addObject:dic];
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock(tempDataList);
            });
        }
        [db close];
    }];
}

+ (void)deleteDatasWithMacAddress:(NSString *)macAddress
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *databaseName = [NSString stringWithFormat:@"%@.Table",macAddress];
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(databaseName)] inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"DELETE FROM MKNBJLogDataTable"];
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