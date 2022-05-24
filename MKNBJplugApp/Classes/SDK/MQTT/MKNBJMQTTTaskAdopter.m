//
//  MKNBJMQTTTaskAdopter.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTTaskAdopter.h"

#import "MKMacroDefines.h"

#import "MKNBJMQTTTaskID.h"

@implementation MKNBJMQTTTaskAdopter

+ (NSDictionary *)parseDataWithJson:(NSDictionary *)json topic:(NSString *)topic {
    NSInteger msgID = [json[@"msg_id"] integerValue];
    if (msgID >= 1000 && msgID < 2000) {
        //配置指令
        return [self parseConfigParamsWithJson:json msgID:msgID topic:topic];
    }
    if (msgID >= 2000 && msgID < 3000) {
        //读取指令
        return [self parseReadParamsWithJson:json msgID:msgID topic:topic];
    }
    
    return @{};
}

#pragma mark - private method
+ (NSDictionary *)parseConfigParamsWithJson:(NSDictionary *)json msgID:(NSInteger)msgID topic:(NSString *)topic {
    BOOL success = ([json[@"result_code"] integerValue] == 0);
    if (!success) {
        return @{};
    }
    mk_nbj_serverOperationID operationID = mk_nbj_defaultServerOperationID;
    if (msgID == 1001) {
        //设置开关上电状态
        operationID = mk_nbj_server_taskConfigPowerOnSwitchStatusOperation;
    }else if (msgID == 1002) {
        //配置开关和倒计时上报间隔
        operationID = mk_nbj_server_taskConfigPeriodicalReportOperation;
    }else if (msgID == 1003) {
        //配置电量上报信息参数
        operationID = mk_nbj_server_taskConfigPowerReportOperation;
    }else if (msgID == 1004) {
        //配置电能上报信息参数
        operationID = mk_nbj_server_taskConfigEnergyReportOperation;
    }else if (msgID == 1005) {
        //配置过载保护参数
        operationID = mk_nbj_server_taskConfigOverloadOperation;
    }else if (msgID == 1006) {
        //配置过压保护参数
        operationID = mk_nbj_server_taskConfigOvervoltageOperation;
    }else if (msgID == 1007) {
        //配置欠压保护参数
        operationID = mk_nbj_server_taskConfigUndervoltageOperation;
    }else if (msgID == 1008) {
        //配置过流保护参数
        operationID = mk_nbj_server_taskConfigOvercurrentOperation;
    }else if (msgID == 1009) {
        //配置功率指示灯颜色
        operationID = mk_nbj_server_taskConfigPowerIndicatorColorOperation;
    }else if (msgID == 1010) {
        //配置NTP服务器参数
        operationID = mk_nbj_server_taskConfigNTPServerParamsOperation;
    }else if (msgID == 1011) {
        //配置时区
        operationID = mk_nbj_server_taskConfigDeviceTimeZoneOperation;
    }else if (msgID == 1012) {
        //配置负载接入通知开关
        operationID = mk_nbj_server_taskConfigLoadNotificationSwitchOperation;
    }else if (msgID == 1013) {
        //配置连接中网络指示灯开关
        operationID = mk_nbj_server_taskConfigServerConnectingIndicatorStatusOperation;
    }else if (msgID == 1014) {
        //配置连接成功网络指示灯状态
        operationID = mk_nbj_server_taskConfigServerConnectedIndicatorStatusOperation;
    }else if (msgID == 1015) {
        //配置电源指示灯开关指示
        operationID = mk_nbj_server_taskConfigIndicatorStatusOperation;
    }else if (msgID == 1016) {
        //配置电源指示灯保护触发指示
        operationID = mk_nbj_server_taskConfigIndicatorProtectionSignalOperation;
    }else if (msgID == 1017) {
        //配置服务器重连超时重启时间
        operationID = mk_nbj_server_taskConfigConnectionTimeoutOperation;
    }else if (msgID == 1018) {
        //配置按键开关机功能
        operationID = mk_nbj_server_taskConfigSwitchByButtonStatusOperation;
    }else if (msgID == 1033) {
        //清除过载状态
        operationID = mk_nbj_server_taskClearOverloadStatusOperation;
    }else if (msgID == 1034) {
        //清除过压状态
        operationID = mk_nbj_server_taskClearOvervoltageStatusOperation;
    }else if (msgID == 1035) {
        //清除欠压状态
        operationID = mk_nbj_server_taskClearUndervoltageStatusOperation;
    }else if (msgID == 1036) {
        //清除过流状态
        operationID = mk_nbj_server_taskClearOvercurrentStatusOperation;
    }else if (msgID == 1037) {
        //配置开关状态
        operationID = mk_nbj_server_taskConfigSwitchStatusOperation;
    }else if (msgID == 1039) {
        //配置倒计时
        operationID = mk_nbj_server_taskConfigCountdownOperation;
    }else if (msgID == 1040) {
        //清除电能数据
        operationID = mk_nbj_server_taskClearAllEnergyDatasOperation;
    }else if (msgID == 1041) {
        //恢复出厂设置
        operationID = mk_nbj_server_taskResetDeviceOperation;
    }else if (msgID == 1042) {
        //OTA固件
        operationID = mk_nbj_server_taskConfigOTAFirmwareOperation;
    }else if (msgID == 1043) {
        //OTA单向认证
        operationID = mk_nbj_server_taskConfigOTACACertificateOperation;
    }else if (msgID == 1044) {
        //OTA双向认证
        operationID = mk_nbj_server_taskConfigOTASelfSignedCertificatesOperation;
    }else if (msgID == 1052) {
        //配置UTC时间
        operationID = mk_nbj_server_taskConfigDeviceUTCTimeOperation;
    }else if (msgID == 1097) {
        //配置新的MQTT服务器信息
        operationID = mk_nbj_server_taskConfigMQTTServerOperation;
    }else if (msgID == 1098) {
        //配置新的MQTT遗嘱功能
        operationID = mk_nbj_server_taskConfigMQTTLWTParamsOperation;
    }else if (msgID == 1099) {
        //配置APN
        operationID = mk_nbj_server_taskConfigAPNParamsOperation;
    }else if (msgID == 1100) {
        //配置网络制式
        operationID = mk_nbj_server_taskConfigNetworkPriorityOperation;
    }else if (msgID == 1101) {
        //MQTT参数配置完成
        operationID = mk_nbj_server_taskConfigMQTTServerParamsCompleteOperation;
    }else if (msgID == 1102) {
        //设备切网
        operationID = mk_nbj_server_taskReconnectMQTTServerOperation;
    }
    return [self dataParserGetDataSuccess:json operationID:operationID];
}

+ (NSDictionary *)parseReadParamsWithJson:(NSDictionary *)json msgID:(NSInteger)msgID topic:(NSString *)topic {
    mk_nbj_serverOperationID operationID = mk_nbj_defaultServerOperationID;
    if (msgID == 2001) {
        //读取开关上电状态
        operationID = mk_nbj_server_taskReadPowerOnSwitchStatusOperation;
    }else if (msgID == 2002) {
        //读取开关和倒计时上报间隔
        operationID = mk_nbj_server_taskReadPeriodicalReportingOperation;
    }else if (msgID == 2003) {
        //读取电量上报信息参数
        operationID = mk_nbj_server_taskReadPowerReportingOperation;
    }else if (msgID == 2004) {
        //读取电能上报信息参数
        operationID = mk_nbj_server_taskReadEnergyReportingOperation;
    }else if (msgID == 2005) {
        //读取过载保护参数
        operationID = mk_nbj_server_taskReadOverloadProtectionDataOperation;
    }else if (msgID == 2006) {
        //读取过压保护参数
        operationID = mk_nbj_server_taskReadOvervoltageProtectionDataOperation;
    }else if (msgID == 2007) {
        //读取欠压保护参数
        operationID = mk_nbj_server_taskReadUndervoltageProtectionDataOperation;
    }else if (msgID == 2008) {
        //读取过流保护参数
        operationID = mk_nbj_server_taskReadOvercurrentProtectionDataOperation;
    }else if (msgID == 2009) {
        //读取功率指示灯颜色
        operationID = mk_nbj_server_taskReadPowerIndicatorColorOperation;
    }else if (msgID == 2010) {
        //读取NTP服务器参数
        operationID = mk_nbj_server_taskReadNTPServerParamsOperation;
    }else if (msgID == 2011) {
        //读取时区
        operationID = mk_nbj_server_taskReadTimeZoneOperation;
    }else if (msgID == 2012) {
        //读取负载接入通知开关
        operationID = mk_nbj_server_taskReadLoadNotificationSwitchOperation;
    }else if (msgID == 2013) {
        //读取连接中网络指示灯开关
        operationID = mk_nbj_server_taskReadServerConnectingIndicatorStatusOperation;
    }else if (msgID == 2014) {
        //读取连接成功网络指示灯状态
        operationID = mk_nbj_server_taskReadServerConnectedIndicatorStatusOperation;
    }else if (msgID == 2015) {
        //读取电源指示灯开关状态
        operationID = mk_nbj_server_taskReadIndicatorStatusOperation;
    }else if (msgID == 2016) {
        //读取电源指示灯保护触发指示
        operationID = mk_nbj_server_taskReadIndicatorProtectionSignalOperation;
    }else if (msgID == 2017) {
        //读取服务器重连超时重启时间
        operationID = mk_nbj_server_taskReadConnectionTimeoutOperation;
    }else if (msgID == 2018) {
        //读取按键开关机功能
        operationID = mk_nbj_server_taskReadSwitchByButtonStatusOperation;
    }else if (msgID == 2038) {
        //读取开关状态
        operationID = mk_nbj_server_taskReadSwitchStatusOperation;
    }else if (msgID == 2045) {
        //读取当前设备状态
        operationID = mk_nbj_server_taskReadDeviceUpdateStateOperation;
    }else if (msgID == 2046) {
        //读取电量信息
        operationID = mk_nbj_server_taskReadElectricityDataOperation;
    }else if (msgID == 2047) {
        //读取总累计电能
        operationID = mk_nbj_server_taskReadTotalEnergyDataOperation;
    }else if (msgID == 2048) {
        //读取最近30天电能数据
        operationID = mk_nbj_server_taskReadMonthlyEnergyDataOperation;
    }else if (msgID == 2049) {
        //读取当天每小时电能数据
        operationID = mk_nbj_server_taskReadHourlyEnergyDataOperation;
    }else if (msgID == 2050) {
        //读取设备信息
        operationID = mk_nbj_server_taskReadDeviceInfoOperation;
    }else if (msgID == 2051) {
        //读取设备规格
        operationID = mk_nbj_server_taskReadSpecificationsOfDeviceOperation;
    }else if (msgID == 2052) {
        //读取UTC时间
        operationID = mk_nbj_server_taskReadDeviceUTCTimeOperation;
    }else if (msgID == 2053) {
        //读取设备工作模式
        operationID = mk_nbj_server_taskReadDeviceWorkModeOperation;
    }else if (msgID == 2097) {
        //读取MQTT服务器参数
        operationID = mk_nbj_server_taskReadDeviceMQTTServerInfoOperation;
    }else if (msgID == 2098) {
        //读取MQTT遗嘱参数
        operationID = mk_nbj_server_taskReadDeviceMQTTLWTParamsOperation;
    }
    return [self dataParserGetDataSuccess:json operationID:operationID];
}

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_nbj_serverOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
