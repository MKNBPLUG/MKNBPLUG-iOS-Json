//
//  MKNBJExcelDataManager.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/5/5.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJExcelDataManager.h"

#import <xlsxwriter/xlsxwriter.h>

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKNBJExcelWookbook.h"

static NSString *const defaultKeyValueString = @"value:";

@implementation MKNBJExcelDataManager

+ (void)exportAppExcel:(id <MKNBJExcelAppProtocol>)protocol
              sucBlock:(void(^)(void))sucBlock
           failedBlock:(void(^)(NSError *error))failedBlock {
    if (![self checkExcelAppProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
        return;
    }
    //设置excel文件名和路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"Settings for APP.xlsx"];
    //创建新xlsx文件
    lxw_workbook *workbook = workbook_new([path UTF8String]);
    //创建sheet
    lxw_sheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    //设置列宽
    /*
     五个参数分别是:
     worksheet          Pointer to a lxw_worksheet instance to be uodated.
     first_col          The zero indexed first column.
     last_col           The zero indexed last column.
     width              The width of the column(s).
     format             A pointer to a format instance or NULL.
     */
    worksheet_set_column(worksheet, 0, 2, 50, NULL);
    
    //添加格式
    lxw_format *format = workbook_add_format(workbook);
    //设置格式
    format_set_bold(format);
    //水平居中
//    format_set_align(format, LXW_ALIGN_CENTER);
    //垂直居中
    format_set_align(format, LXW_ALIGN_VERTICAL_CENTER);
    
    //写入数据
    /*
     第一个参数是工作表
     第二个参数是行数(索引从0开始)
     第三个参数是列数(索引从0开始)
     第四个参数是写入的内容
     第五个参数是单元格样式，可为NULL.
     */
    worksheet_write_string(worksheet, 0, 0, "Config_Item", NULL);
    worksheet_write_string(worksheet, 0, 1, "Config_value", NULL);
    worksheet_write_string(worksheet, 0, 2, "Remark", NULL);
    
    //Host
    worksheet_write_string(worksheet, 1, 0, "Host", NULL);
    NSString *hostString = [defaultKeyValueString stringByAppendingString:protocol.host];
    worksheet_write_string(worksheet, 1, 1, [hostString UTF8String], NULL);
    worksheet_write_string(worksheet, 1, 2, "1-64 characters", NULL);
    
    //Port
    worksheet_write_string(worksheet, 2, 0, "Port", NULL);
    NSString *portString = [defaultKeyValueString stringByAppendingString:protocol.port];
    worksheet_write_string(worksheet, 2, 1, [portString UTF8String], NULL);
    worksheet_write_string(worksheet, 2, 2, "Range: 1-65535", NULL);
    
    //Client id
    worksheet_write_string(worksheet, 3, 0, "Client id", NULL);
    NSString *clientIDString = [defaultKeyValueString stringByAppendingString:protocol.clientID];
    worksheet_write_string(worksheet, 3, 1, [clientIDString UTF8String], NULL);
    worksheet_write_string(worksheet, 3, 2, "1-64 characters", NULL);
    
    //Subscribe Topic
    worksheet_write_string(worksheet, 4, 0, "Subscribe Topic", NULL);
    NSString *subscribeTopicString = @"";
    if (ValidStr(protocol.subscribeTopic)) {
        subscribeTopicString = [defaultKeyValueString stringByAppendingString:protocol.subscribeTopic];
    }
    worksheet_write_string(worksheet, 4, 1, [subscribeTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 4, 2, "0-128 characters", NULL);
    
    //Publish Topic
    worksheet_write_string(worksheet, 5, 0, "Publish Topic", NULL);
    NSString *publishTopicString = @"";
    if (ValidStr(protocol.publishTopic)) {
        publishTopicString = [defaultKeyValueString stringByAppendingString:protocol.publishTopic];
    }
    worksheet_write_string(worksheet, 5, 1, [publishTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 5, 2, "0-128 characters", NULL);
    
    //Clean Session
    const char *sessionMsg = "Range: 0/1 \n0:NO \n1:YES";
    worksheet_write_string(worksheet, 6, 0, "Clean Session", NULL);
    NSString *cleanSessionString = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.cleanSession) {
        cleanSessionString = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 6, 1, [cleanSessionString UTF8String], NULL);
    worksheet_write_string(worksheet, 6, 2, sessionMsg, format);
    
    //Qos
    const char *qosMsg = "Range: 0/1/2 \n0:qos0 \n1:qos1 \n2:qos2";
    NSString *qos = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)protocol.qos];
    worksheet_write_string(worksheet, 7, 0, "Qos", NULL);
    worksheet_write_string(worksheet, 7, 1, [qos UTF8String], NULL);
    worksheet_write_string(worksheet, 7, 2, qosMsg, format);
    
    //Keep Alive
    worksheet_write_string(worksheet, 8, 0, "Keep Alive", NULL);
    NSString *keepString = [defaultKeyValueString stringByAppendingString:protocol.keepAlive];
    worksheet_write_string(worksheet, 8, 1, [keepString UTF8String], NULL);
    worksheet_write_string(worksheet, 8, 2, "Range: 10-120, unit: second", NULL);
    
    //MQTT Username
    worksheet_write_string(worksheet, 9, 0, "MQTT Username", NULL);
    NSString *usernameString = @"";
    if (ValidStr(protocol.userName)) {
        usernameString = [defaultKeyValueString stringByAppendingString:protocol.userName];
    }
    worksheet_write_string(worksheet, 9, 1, [usernameString UTF8String], NULL);
    worksheet_write_string(worksheet, 9, 2, "0-128 characters", NULL);
    
    //MQTT Password
    worksheet_write_string(worksheet, 10, 0, "MQTT Password", NULL);
    NSString *passwordString = @"";
    if (ValidStr(protocol.password)) {
        passwordString = [defaultKeyValueString stringByAppendingString:protocol.password];
    }
    worksheet_write_string(worksheet, 10, 1, [passwordString UTF8String], NULL);
    worksheet_write_string(worksheet, 10, 2, "0-128 characters", NULL);
    
    //SSL/TLS
    const char *sslMsg = "Range: 0/1 \n0:Disable SSL (TCP mode) \n1:Enable SSL";
    worksheet_write_string(worksheet, 11, 0, "SSL/TLS", NULL);
    NSString *sslStatus = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.sslIsOn) {
        sslStatus = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 11, 1, [sslStatus UTF8String], NULL);
    worksheet_write_string(worksheet, 11, 2, sslMsg, format);
    
    //Certificate type
    const char *certlMsg = "Valid when SSL is enabled, range: 1/2 \n1: CA certificate file \n2: Self signed certificates";
    NSString *certValue = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)(protocol.certificate + 1)];
    worksheet_write_string(worksheet, 12, 0, "Certificate type", NULL);
    worksheet_write_string(worksheet, 12, 1, [certValue UTF8String], NULL);
    worksheet_write_string(worksheet, 12, 2, certlMsg, format);
    
//    const char *noteMsg = "Tips:\n1. Users just need fill the config_value column.\n2. If SSL/TLS is enabled, please manually upload the certificates from your phone.";
//
//    lxw_format *format1 = workbook_add_format(workbook);
//    //设置格式
//    format_set_bold(format1);
//    //垂直居中
//    format_set_align(format1, LXW_ALIGN_VERTICAL_CENTER);
//    format_set_font_color(format1, LXW_COLOR_RED);
//    worksheet_write_string(worksheet, 13, 0, noteMsg, format1);
    
    
    //关闭，保存文件
    lxw_error errorCode = workbook_close(workbook);
    if (errorCode != LXW_NO_ERROR) {
        //写失败
        [self operationFailedBlockWithMsg:@"Export Failed" block:failedBlock];
        return;
    }
    //写成功
    if (sucBlock) {
        sucBlock();
    }
}

+ (void)parseAppExcel:(NSString *)excelName
             sucBlock:(void (^)(NSDictionary *returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(excelName)) {
        [self operationFailedBlockWithMsg:@"File Name Cannot be empty" block:failedBlock];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:excelName];
    NSURL *excelUrl = [[NSURL alloc] initFileURLWithPath:path];
    if (!excelUrl) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKNBJExcelWookbook *workbook = [[MKNBJExcelWookbook alloc] initWithExcelFilePathUrl:excelUrl];
    if (!workbook || workbook.sheetArray.count == 0) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKNBJExcelSheet *sheet = workbook.sheetArray.firstObject;
    if (![sheet isKindOfClass:MKNBJExcelSheet.class]) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    NSArray *list = sheet.cellArray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //根据横竖坐标，获取单元格
    //Host
    MKNBJExcelCell *hostCell = [sheet getCellWithColumn:@"B" row:2 error:nil];
    NSString *host = [SafeStr(hostCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(host) forKey:@"host"];
    //Port
    MKNBJExcelCell *portCell = [sheet getCellWithColumn:@"B" row:3 error:nil];
    NSString *port = [SafeStr(portCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    port = [port stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic setObject:SafeStr(port) forKey:@"port"];
    //Client id
    MKNBJExcelCell *clientIDCell = [sheet getCellWithColumn:@"B" row:4 error:nil];
    NSString *clientID = [SafeStr(clientIDCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(clientID) forKey:@"clientID"];
    //Subscribe Topic
    MKNBJExcelCell *subTopicCell = [sheet getCellWithColumn:@"B" row:5 error:nil];
    NSString *subTopic = [SafeStr(subTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(subTopic) forKey:@"subscribeTopic"];
    //Publish Topic
    MKNBJExcelCell *pubTopicCell = [sheet getCellWithColumn:@"B" row:6 error:nil];
    NSString *pubTopic = [SafeStr(pubTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(pubTopic) forKey:@"publishTopic"];
    //Clean Session
    MKNBJExcelCell *cleanSessionCell = [sheet getCellWithColumn:@"B" row:7 error:nil];
    NSString *sessionString = [SafeStr(cleanSessionCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    sessionString = [sessionString stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL cleanSession = ([sessionString isEqualToString:@"1"]);
    [dic setObject:@(cleanSession) forKey:@"cleanSession"];
    //Qos
    MKNBJExcelCell *qosCell = [sheet getCellWithColumn:@"B" row:8 error:nil];
    NSString *tempQos = [SafeStr(qosCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    tempQos = [tempQos stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger qosValue = [tempQos integerValue];
    if (qosValue < 0 || qosValue > 2) {
        //默认值
        qosValue = 1;
    }
    [dic setObject:@(qosValue) forKey:@"qos"];
    //Keep Alive
    MKNBJExcelCell *keepAliveCell = [sheet getCellWithColumn:@"B" row:9 error:nil];
    NSString *keepAlive = [SafeStr(keepAliveCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    keepAlive = [keepAlive stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger keepValue = [keepAlive integerValue];
    if (keepValue < 10 || keepValue > 120) {
        //默认值
        keepValue = 60;
    }
    [dic setObject:@(keepValue) forKey:@"keepAlive"];
    //MQTT Username
    MKNBJExcelCell *usernameCell = [sheet getCellWithColumn:@"B" row:10 error:nil];
    NSString *username = [SafeStr(usernameCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(username) forKey:@"userName"];
    //MQTT Password
    MKNBJExcelCell *passwordCell = [sheet getCellWithColumn:@"B" row:11 error:nil];
    NSString *password = [SafeStr(passwordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(password) forKey:@"password"];
    //SSL/TLS
    MKNBJExcelCell *sslCell = [sheet getCellWithColumn:@"B" row:12 error:nil];
    NSString *sslString = [SafeStr(sslCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    sslString = [sslString stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL ssl = ([sslString isEqualToString:@"1"]);
    [dic setObject:@(ssl) forKey:@"sslIsOn"];
    //Certificate type
    MKNBJExcelCell *certificateCell = [sheet getCellWithColumn:@"B" row:13 error:nil];
    NSString *certString = [SafeStr(certificateCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    certString = [certString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger certValue = [certString integerValue] - 1;
    if (certValue < 0 || certValue > 1) {
        certValue = 0;
    }
    [dic setObject:@(certValue) forKey:@"certificate"];
    if (sucBlock) {
        sucBlock(dic);
    }
}

+ (void)exportDeviceExcel:(id <MKNBJExcelDeviceProtocol>)protocol
                 sucBlock:(void(^)(void))sucBlock
              failedBlock:(void(^)(NSError *error))failedBlock {
    if (![self checkExcelDeviceProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
        return;
    }
    //设置excel文件名和路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"Settings for device.xlsx"];
    //创建新xlsx文件
    lxw_workbook *workbook = workbook_new([path UTF8String]);
    //创建sheet
    lxw_sheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    //设置列宽
    /*
     五个参数分别是:
     worksheet          Pointer to a lxw_worksheet instance to be uodated.
     first_col          The zero indexed first column.
     last_col           The zero indexed last column.
     width              The width of the column(s).
     format             A pointer to a format instance or NULL.
     */
    worksheet_set_column(worksheet, 0, 2, 50, NULL);
    
    //添加格式
    lxw_format *format = workbook_add_format(workbook);
    //设置格式
    format_set_bold(format);
    //水平居中
//    format_set_align(format, LXW_ALIGN_CENTER);
    //垂直居中
    format_set_align(format, LXW_ALIGN_VERTICAL_CENTER);
    
    //写入数据
    /*
     第一个参数是工作表
     第二个参数是行数(索引从0开始)
     第三个参数是列数(索引从0开始)
     第四个参数是写入的内容
     第五个参数是单元格样式，可为NULL.
     */
    worksheet_write_string(worksheet, 0, 0, "Config_Item", NULL);
    worksheet_write_string(worksheet, 0, 1, "Config_value", NULL);
    worksheet_write_string(worksheet, 0, 2, "Remark", NULL);
    
    //Host
    worksheet_write_string(worksheet, 1, 0, "Host", NULL);
    NSString *hostString = [defaultKeyValueString stringByAppendingString:protocol.host];
    worksheet_write_string(worksheet, 1, 1, [hostString UTF8String], NULL);
    worksheet_write_string(worksheet, 1, 2, "1-64 characters", NULL);
    
    //Port
    worksheet_write_string(worksheet, 2, 0, "Port", NULL);
    NSString *portString = [defaultKeyValueString stringByAppendingString:protocol.port];
    worksheet_write_string(worksheet, 2, 1, [portString UTF8String], NULL);
    worksheet_write_string(worksheet, 2, 2, "Range: 1-65535", NULL);
    
    //Client id
    worksheet_write_string(worksheet, 3, 0, "Client id", NULL);
    NSString *clientIDString = [defaultKeyValueString stringByAppendingString:protocol.clientID];
    worksheet_write_string(worksheet, 3, 1, [clientIDString UTF8String], NULL);
    worksheet_write_string(worksheet, 3, 2, "1-64 characters", NULL);
    
    //Subscribe Topic
    worksheet_write_string(worksheet, 4, 0, "Subscribe Topic", NULL);
    NSString *subscribeTopicString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.subscribeTopic)];
    worksheet_write_string(worksheet, 4, 1, [subscribeTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 4, 2, "1-128 characters", NULL);
    
    //Publish Topic
    worksheet_write_string(worksheet, 5, 0, "Publish Topic", NULL);
    NSString *publishTopicString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.publishTopic)];
    worksheet_write_string(worksheet, 5, 1, [publishTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 5, 2, "1-128 characters", NULL);
    
    //Clean Session
    const char *sessionMsg = "Range: 0/1 \n0:NO \n1:YES";
    worksheet_write_string(worksheet, 6, 0, "Clean Session", NULL);
    NSString *cleanSessionString = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.cleanSession) {
        cleanSessionString = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 6, 1, [cleanSessionString UTF8String], NULL);
    worksheet_write_string(worksheet, 6, 2, sessionMsg, format);
    
    //Qos
    const char *qosMsg = "Range: 0/1/2 \n0:qos0 \n1:qos1 \n2:qos2";
    NSString *qos = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)protocol.qos];
    worksheet_write_string(worksheet, 7, 0, "Qos", NULL);
    worksheet_write_string(worksheet, 7, 1, [qos UTF8String], NULL);
    worksheet_write_string(worksheet, 7, 2, qosMsg, format);
    
    //Keep Alive
    worksheet_write_string(worksheet, 8, 0, "Keep Alive", NULL);
    NSString *keepString = [defaultKeyValueString stringByAppendingString:protocol.keepAlive];
    worksheet_write_string(worksheet, 8, 1, [keepString UTF8String], NULL);
    worksheet_write_string(worksheet, 8, 2, "Range: 10-120, unit: second", NULL);
    
    //MQTT Username
    worksheet_write_string(worksheet, 9, 0, "MQTT Username", NULL);
    NSString *usernameString = @"";
    if (ValidStr(protocol.userName)) {
        usernameString = [defaultKeyValueString stringByAppendingString:protocol.userName];
    }
    worksheet_write_string(worksheet, 9, 1, [usernameString UTF8String], NULL);
    worksheet_write_string(worksheet, 9, 2, "0-128 characters", NULL);
    
    //MQTT Password
    worksheet_write_string(worksheet, 10, 0, "MQTT Password", NULL);
    NSString *passwordString = @"";
    if (ValidStr(protocol.password)) {
        passwordString = [defaultKeyValueString stringByAppendingString:protocol.password];
    }
    worksheet_write_string(worksheet, 10, 1, [passwordString UTF8String], NULL);
    worksheet_write_string(worksheet, 10, 2, "0-128 characters", NULL);
    
    //SSL/TLS
    const char *sslMsg = "Range: 0/1 \n0:Disable SSL (TCP mode) \n1:Enable SSL";
    worksheet_write_string(worksheet, 11, 0, "SSL/TLS", NULL);
    NSString *sslStatus = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.sslIsOn) {
        sslStatus = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 11, 1, [sslStatus UTF8String], NULL);
    worksheet_write_string(worksheet, 11, 2, sslMsg, format);
    
    //Certificate type
    const char *certlMsg = "Valid when SSL is enabled, range: 1/2 \n1: CA certificate file \n2: Self signed certificates";
    NSString *certValue = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)(protocol.certificate + 1)];
    worksheet_write_string(worksheet, 12, 0, "Certificate type", NULL);
    worksheet_write_string(worksheet, 12, 1, [certValue UTF8String], NULL);
    worksheet_write_string(worksheet, 12, 2, certlMsg, format);
    
    //LWT
    const char *lwtStatusMsg = "Range: 0/1 \n0:Disable \n1:Enable";
    worksheet_write_string(worksheet, 13, 0, "LWT", NULL);
    NSString *lwtString = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.lwtStatus) {
        lwtString = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 13, 1, [lwtString UTF8String], NULL);
    worksheet_write_string(worksheet, 13, 2, lwtStatusMsg, format);
    
    //LWT Retain
    const char *lwtRetainMsg = "Range: 0/1 \n0:NO \n1:YES";
    worksheet_write_string(worksheet, 14, 0, "LWT Retain", NULL);
    NSString *lwtRetainString = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.lwtRetain) {
        lwtRetainString = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 14, 1, [lwtRetainString UTF8String], NULL);
    worksheet_write_string(worksheet, 14, 2, lwtRetainMsg, format);
    
    //Qos
    const char *lwtQosMsg = "Range: 0/1/2 \n0:qos0 \n1:qos1 \n2:qos2";
    NSString *lwtQos = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)protocol.lwtQos];
    worksheet_write_string(worksheet, 15, 0, "LWT Qos", NULL);
    worksheet_write_string(worksheet, 15, 1, [lwtQos UTF8String], NULL);
    worksheet_write_string(worksheet, 15, 2, lwtQosMsg, format);
    
    //LWT Topic
    const char *lwtTopicMsg = "1-128 characters (When LWT is enabled) ";
    worksheet_write_string(worksheet, 16, 0, "LWT Topic", NULL);
    NSString *lwtTopicString = @"";
    if (ValidStr(protocol.lwtTopic)) {
        lwtTopicString = [defaultKeyValueString stringByAppendingString:protocol.lwtTopic];
    }
    worksheet_write_string(worksheet, 16, 1, [lwtTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 16, 2, lwtTopicMsg, format);
    
    //LWT Payload
    const char *lwtPayloadMsg = "1-128 characters (When LWT is enabled) ";
    worksheet_write_string(worksheet, 17, 0, "LWT Payload", NULL);
    NSString *lwtPayloadString = @"";
    if (ValidStr(protocol.lwtPayload)) {
        lwtPayloadString = [defaultKeyValueString stringByAppendingString:protocol.lwtPayload];
    }
    worksheet_write_string(worksheet, 17, 1, [lwtPayloadString UTF8String], NULL);
    worksheet_write_string(worksheet, 17, 2, lwtPayloadMsg, format);
    
    //Device id
    const char *deviceIDMsg = "1-32 characters";
    worksheet_write_string(worksheet, 18, 0, "Device id", NULL);
    NSString *deviceIDString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.deviceID)];
    worksheet_write_string(worksheet, 18, 1, [deviceIDString UTF8String], NULL);
    worksheet_write_string(worksheet, 18, 2, deviceIDMsg, format);
    
    //NTP URL
    const char *ntpMsg = "0-64 characters";
    worksheet_write_string(worksheet, 19, 0, "NTP URL", NULL);
    NSString *ntpString = @"";
    if (ValidStr(protocol.ntpHost)) {
        ntpString = [defaultKeyValueString stringByAppendingString:protocol.ntpHost];
    }
    worksheet_write_string(worksheet, 19, 1, [ntpString UTF8String], NULL);
    worksheet_write_string(worksheet, 19, 2, ntpMsg, format);
    
    //Timezone
    const char *timezoneMsg = "Range: -24~+28, step by half timezone \n1 For example: 16- UTC+8";
    worksheet_write_string(worksheet, 20, 0, "Timezone", NULL);
    NSString *timezoneString = [NSString stringWithFormat:@"%@%@",defaultKeyValueString,@(protocol.timeZone - 24)];
    worksheet_write_string(worksheet, 20, 1, [timezoneString UTF8String], NULL);
    worksheet_write_string(worksheet, 20, 2, timezoneMsg, format);
    
    //APN URL
    const char *apnMsg = "0-100 characters";
    worksheet_write_string(worksheet, 21, 0, "APN", NULL);
    NSString *apnString = @"";
    if (ValidStr(protocol.apn)) {
        apnString = [defaultKeyValueString stringByAppendingString:protocol.apn];
    }
    worksheet_write_string(worksheet, 21, 1, [apnString UTF8String], NULL);
    worksheet_write_string(worksheet, 21, 2, apnMsg, format);
    
    //APN Username
    const char *apnUsernameMsg = "0-127 characters";
    worksheet_write_string(worksheet, 22, 0, "APN Username", NULL);
    NSString *apnUsernameString = @"";
    if (ValidStr(protocol.networkUsername)) {
        apnUsernameString = [defaultKeyValueString stringByAppendingString:protocol.networkUsername];
    }
    worksheet_write_string(worksheet, 22, 1, [apnUsernameString UTF8String], NULL);
    worksheet_write_string(worksheet, 22, 2, apnUsernameMsg, format);
    
    //APN Password
    const char *apnPasswordMsg = "0-127 characters";
    worksheet_write_string(worksheet, 23, 0, "APN Password", NULL);
    NSString *apnPasswordString = @"";
    if (ValidStr(protocol.networkPassword)) {
        apnPasswordString = [defaultKeyValueString stringByAppendingString:protocol.networkPassword];
    }
    worksheet_write_string(worksheet, 23, 1, [apnPasswordString UTF8String], NULL);
    worksheet_write_string(worksheet, 23, 2, apnPasswordMsg, format);
    
    //Network Priority
    const char *priorityMsg = "Range: 0-10 \n0:eMTC->NB-IOT->GSM \n1:eMTC-> GSM -> NB-IOT \n2:NB-IOT->GSM-> eMTC \n3:NB-IOT-> eMTC-> GSM \n4:GSM -> NB-IOT-> eMTC \n5:GSM -> eMTC->NB-IOT \n6:eMTC->NB-IOT \n7:NB-IOT-> eMTC \n8:GSM \n9:NB-IOT \n10:eMTC";
    worksheet_write_string(worksheet, 24, 0, "Network Priority", NULL);
    NSString *priorityString = [NSString stringWithFormat:@"%@%@",defaultKeyValueString,@(protocol.networkPriority)];
    worksheet_write_string(worksheet, 24, 1, [priorityString UTF8String], NULL);
    worksheet_write_string(worksheet, 24, 2, priorityMsg, format);
    
    //Debug mode
    const char *debugMsg = "Range: 0/1 \n0:Disable \n1:Enable";
    worksheet_write_string(worksheet, 25, 0, "Debug mode", NULL);
    NSString *debugString = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.debugMode) {
        debugString = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 25, 1, [debugString UTF8String], NULL);
    worksheet_write_string(worksheet, 25, 2, debugMsg, format);
    
//    const char *noteMsg = "Tips:\n1. Users just need fill the config_value column.\n2. If SSL/TLS is enabled, please manually upload the certificates from your phone.";
//
//    lxw_format *format1 = workbook_add_format(workbook);
//    //设置格式
//    format_set_bold(format1);
//    //垂直居中
//    format_set_align(format1, LXW_ALIGN_VERTICAL_CENTER);
//    format_set_font_color(format1, LXW_COLOR_RED);
//    worksheet_write_string(worksheet, 13, 0, noteMsg, format1);
    
    
    //关闭，保存文件
    lxw_error errorCode = workbook_close(workbook);
    if (errorCode != LXW_NO_ERROR) {
        //写失败
        [self operationFailedBlockWithMsg:@"Export Failed" block:failedBlock];
        return;
    }
    //写成功
    if (sucBlock) {
        sucBlock();
    }
}

+ (void)parseDeviceExcel:(NSString *)excelName
                sucBlock:(void (^)(NSDictionary *returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(excelName)) {
        [self operationFailedBlockWithMsg:@"File Name Cannot be empty" block:failedBlock];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:excelName];
    NSURL *excelUrl = [[NSURL alloc] initFileURLWithPath:path];
    if (!excelUrl) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKNBJExcelWookbook *workbook = [[MKNBJExcelWookbook alloc] initWithExcelFilePathUrl:excelUrl];
    if (!workbook || workbook.sheetArray.count == 0) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKNBJExcelSheet *sheet = workbook.sheetArray.firstObject;
    if (![sheet isKindOfClass:MKNBJExcelSheet.class]) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    NSArray *list = sheet.cellArray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //根据横竖坐标，获取单元格
    //Host
    MKNBJExcelCell *hostCell = [sheet getCellWithColumn:@"B" row:2 error:nil];
    NSString *host = [SafeStr(hostCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(host) forKey:@"host"];
    //Port
    MKNBJExcelCell *portCell = [sheet getCellWithColumn:@"B" row:3 error:nil];
    NSString *port = [SafeStr(portCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(port) forKey:@"port"];
    //Client id
    MKNBJExcelCell *clientIDCell = [sheet getCellWithColumn:@"B" row:4 error:nil];
    NSString *clientID = [SafeStr(clientIDCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(clientID) forKey:@"clientID"];
    //Subscribe Topic
    MKNBJExcelCell *subTopicCell = [sheet getCellWithColumn:@"B" row:5 error:nil];
    NSString *subTopic = [SafeStr(subTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(subTopic) forKey:@"subscribeTopic"];
    //Publish Topic
    MKNBJExcelCell *pubTopicCell = [sheet getCellWithColumn:@"B" row:6 error:nil];
    NSString *pubTopic = [SafeStr(pubTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(pubTopic) forKey:@"publishTopic"];
    //Clean Session
    MKNBJExcelCell *cleanSessionCell = [sheet getCellWithColumn:@"B" row:7 error:nil];
    NSString *sessionString = [SafeStr(cleanSessionCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL cleanSession = ([sessionString isEqualToString:@"1"]);
    [dic setObject:@(cleanSession) forKey:@"cleanSession"];
    //Qos
    MKNBJExcelCell *qosCell = [sheet getCellWithColumn:@"B" row:8 error:nil];
    NSString *tempQos = [SafeStr(qosCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger qosValue = [tempQos integerValue];
    if (qosValue < 0 || qosValue > 2) {
        //默认值
        qosValue = 1;
    }
    [dic setObject:@(qosValue) forKey:@"qos"];
    //Keep Alive
    MKNBJExcelCell *keepAliveCell = [sheet getCellWithColumn:@"B" row:9 error:nil];
    NSString *keepAlive = [SafeStr(keepAliveCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger keepValue = [keepAlive integerValue];
    if (keepValue < 10 || keepValue > 120) {
        //默认值
        keepValue = 60;
    }
    [dic setObject:@(keepValue) forKey:@"keepAlive"];
    //MQTT Username
    MKNBJExcelCell *usernameCell = [sheet getCellWithColumn:@"B" row:10 error:nil];
    NSString *username = [SafeStr(usernameCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(username) forKey:@"userName"];
    //MQTT Password
    MKNBJExcelCell *passwordCell = [sheet getCellWithColumn:@"B" row:11 error:nil];
    NSString *password = [SafeStr(passwordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(password) forKey:@"password"];
    //SSL/TLS
    MKNBJExcelCell *sslCell = [sheet getCellWithColumn:@"B" row:12 error:nil];
    NSString *sslString = [SafeStr(sslCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL ssl = ([sslString isEqualToString:@"1"]);
    [dic setObject:@(ssl) forKey:@"sslIsOn"];
    //Certificate type
    MKNBJExcelCell *certificateCell = [sheet getCellWithColumn:@"B" row:13 error:nil];
    NSString *certString = [SafeStr(certificateCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger certValue = [certString integerValue] - 1;
    if (certValue < 0 || certValue > 1) {
        certValue = 0;
    }
    [dic setObject:@(certValue) forKey:@"certificate"];
    //LWT
    MKNBJExcelCell *lwtCell = [sheet getCellWithColumn:@"B" row:14 error:nil];
    NSString *lwtString = [SafeStr(lwtCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL lwt = ([lwtString isEqualToString:@"1"]);
    [dic setObject:@(lwt) forKey:@"lwtStatus"];
    //LWT Retain
    MKNBJExcelCell *lwtRetainCell = [sheet getCellWithColumn:@"B" row:15 error:nil];
    NSString *lwtRetainString = [SafeStr(lwtRetainCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL lwtRetain = ([lwtRetainString isEqualToString:@"1"]);
    [dic setObject:@(lwtRetain) forKey:@"lwtRetain"];
    //LWT Qos
    MKNBJExcelCell *lwtQosCell = [sheet getCellWithColumn:@"B" row:16 error:nil];
    NSString *tempLWTQos = [SafeStr(lwtQosCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger lwtQosValue = [tempLWTQos integerValue];
    if (lwtQosValue < 0 || lwtQosValue > 2) {
        //默认值
        lwtQosValue = 1;
    }
    [dic setObject:@(lwtQosValue) forKey:@"lwtQos"];
    //LWT Topic
    MKNBJExcelCell *lwtTopicCell = [sheet getCellWithColumn:@"B" row:17 error:nil];
    NSString *lwtTopic = [SafeStr(lwtTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(lwtTopic) forKey:@"lwtTopic"];
    //LWT Payload
    MKNBJExcelCell *lwtPayloadCell = [sheet getCellWithColumn:@"B" row:18 error:nil];
    NSString *lwtPayload = [SafeStr(lwtPayloadCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(lwtPayload) forKey:@"lwtPayload"];
    //Device id
    MKNBJExcelCell *deviceIDCell = [sheet getCellWithColumn:@"B" row:19 error:nil];
    NSString *deviceID = [SafeStr(deviceIDCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(deviceID) forKey:@"deviceID"];
    //NTP URL
    MKNBJExcelCell *ntpCell = [sheet getCellWithColumn:@"B" row:20 error:nil];
    NSString *ntp = [SafeStr(ntpCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(ntp) forKey:@"ntpHost"];
    //Timezone
    MKNBJExcelCell *timezoneCell = [sheet getCellWithColumn:@"B" row:21 error:nil];
    NSString *timezone = [SafeStr(timezoneCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger timezoneValue = [timezone integerValue];
    if (timezoneValue < -24 || timezoneValue > 28) {
        //默认值
        timezoneValue = 16;
    }
    //注意，在时区数组里面是从0开始的，所以此处需要加上24
    timezoneValue += 24;
    [dic setObject:@(timezoneValue) forKey:@"timeZone"];
    //APN
    MKNBJExcelCell *apnCell = [sheet getCellWithColumn:@"B" row:22 error:nil];
    NSString *apn = [SafeStr(apnCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(apn) forKey:@"apn"];
    //APN Username
    MKNBJExcelCell *apnUsernameCell = [sheet getCellWithColumn:@"B" row:23 error:nil];
    NSString *apnUsername = [SafeStr(apnUsernameCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(apnUsername) forKey:@"networkUsername"];
    //APN Password
    MKNBJExcelCell *apnPasswordCell = [sheet getCellWithColumn:@"B" row:24 error:nil];
    NSString *apnPassword = [SafeStr(apnPasswordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(apnPassword) forKey:@"networkPassword"];
    //Network Priority
    MKNBJExcelCell *priorityCell = [sheet getCellWithColumn:@"B" row:25 error:nil];
    NSString *priority = [SafeStr(priorityCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger priorityValue = [priority integerValue];
    if (priorityValue < 0 || priorityValue > 10) {
        //默认值
        priorityValue = 0;
    }
    [dic setObject:@(priorityValue) forKey:@"networkPriority"];
    //Debug mode
    MKNBJExcelCell *debugModeCell = [sheet getCellWithColumn:@"B" row:26 error:nil];
    NSString *debugModeString = [SafeStr(debugModeCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL debugMode = ([debugModeString isEqualToString:@"1"]);
    [dic setObject:@(debugMode) forKey:@"debugMode"];
    
    if (sucBlock) {
        sucBlock(dic);
    }
}

#pragma mark - Private method
+ (BOOL)checkExcelAppProtocol:(id <MKNBJExcelAppProtocol>)protocol {
    if (!protocol || ![protocol conformsToProtocol:@protocol(MKNBJExcelAppProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.host) || protocol.host.length > 64 || ![protocol.host isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.port) || [protocol.port integerValue] < 1 || [protocol.port integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(protocol.clientID) || protocol.clientID.length > 64 || ![protocol.clientID isAsciiString]) {
        return NO;
    }
    if (protocol.publishTopic.length > 128 || (ValidStr(protocol.publishTopic) && ![protocol.publishTopic isAsciiString])) {
        return NO;
    }
    if (protocol.subscribeTopic.length > 128 || (ValidStr(protocol.subscribeTopic) && ![protocol.subscribeTopic isAsciiString])) {
        return NO;
    }
    if (protocol.qos < 0 || protocol.qos > 2) {
        return NO;
    }
    if (!ValidStr(protocol.keepAlive) || [protocol.keepAlive integerValue] < 10 || [protocol.keepAlive integerValue] > 120) {
        return NO;
    }
    if (protocol.userName.length > 128 || (ValidStr(protocol.userName) && ![protocol.userName isAsciiString])) {
        return NO;
    }
    if (protocol.password.length > 128 || (ValidStr(protocol.password) && ![protocol.password isAsciiString])) {
        return NO;
    }
    if (protocol.sslIsOn) {
        if (protocol.certificate < 0 || protocol.certificate > 1) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkExcelDeviceProtocol:(id <MKNBJExcelDeviceProtocol>)protocol {
    if (!protocol || ![protocol conformsToProtocol:@protocol(MKNBJExcelDeviceProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.host) || protocol.host.length > 64 || ![protocol.host isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.port) || [protocol.port integerValue] < 1 || [protocol.port integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(protocol.clientID) || protocol.clientID.length > 64 || ![protocol.clientID isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.publishTopic) || protocol.publishTopic.length > 128 || ![protocol.publishTopic isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.subscribeTopic) || protocol.subscribeTopic.length > 128 || ![protocol.subscribeTopic isAsciiString]) {
        return NO;
    }
    if (protocol.qos < 0 || protocol.qos > 2) {
        return NO;
    }
    if (!ValidStr(protocol.keepAlive) || [protocol.keepAlive integerValue] < 10 || [protocol.keepAlive integerValue] > 120) {
        return NO;
    }
    if (protocol.userName.length > 128 || (ValidStr(protocol.userName) && ![protocol.userName isAsciiString])) {
        return NO;
    }
    if (protocol.password.length > 128 || (ValidStr(protocol.password) && ![protocol.password isAsciiString])) {
        return NO;
    }
    if (protocol.sslIsOn) {
        if (protocol.certificate < 0 || protocol.certificate > 1) {
            return NO;
        }
    }
    if (protocol.lwtStatus) {
        if (!ValidStr(protocol.lwtTopic) || protocol.lwtTopic.length > 128 || ![protocol.lwtTopic isAsciiString]) {
            return NO;
        }
        if (!ValidStr(protocol.lwtPayload) || protocol.lwtPayload.length > 128 || ![protocol.lwtPayload isAsciiString]) {
            return NO;
        }
        if (protocol.lwtQos < 0 || protocol.lwtQos > 2) {
            return NO;
        }
    }
    if (!ValidStr(protocol.deviceID) || protocol.deviceID.length > 32 || ![protocol.deviceID isAsciiString]) {
        return NO;
    }
    if (protocol.ntpHost.length > 64 || (ValidStr(protocol.ntpHost) && ![protocol.ntpHost isAsciiString])) {
        return NO;
    }
    if (protocol.timeZone < 0 || protocol.timeZone > 52) {
        return NO;
    }
    if (protocol.apn.length > 100 || (ValidStr(protocol.apn) && ![protocol.apn isAsciiString])) {
        return NO;
    }
    if (protocol.networkUsername.length > 127 || (ValidStr(protocol.networkUsername) && ![protocol.networkUsername isAsciiString])) {
        return NO;
    }
    if (protocol.networkPassword.length > 127 || (ValidStr(protocol.networkPassword) && ![protocol.networkPassword isAsciiString])) {
        return NO;
    }
    if (protocol.networkPriority < 0 || protocol.networkPriority > 10) {
        return NO;
    }
    return YES;
}

+ (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"excelOperation"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

@end
