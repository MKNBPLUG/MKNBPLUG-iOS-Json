
typedef NS_ENUM(NSInteger, mk_nbj_serverOperationID) {
    mk_nbj_defaultServerOperationID,
    
#pragma mark - 配置
    mk_nbj_server_taskConfigPowerOnSwitchStatusOperation,       //配置开关上电状态
    mk_nbj_server_taskConfigPeriodicalReportOperation,          //配置开关和倒计时上报间隔
    mk_nbj_server_taskConfigPowerReportOperation,               //配置电量上报信息
    mk_nbj_server_taskConfigEnergyReportOperation,              //配置电能上报信息
    mk_nbj_server_taskConfigOverloadOperation,                  //配置过载保护参数
    mk_nbj_server_taskConfigOvervoltageOperation,               //配置过压保护参数
    mk_nbj_server_taskConfigUndervoltageOperation,              //配置欠压保护参数
    mk_nbj_server_taskConfigOvercurrentOperation,               //配置过流保护参数
    mk_nbj_server_taskConfigPowerIndicatorColorOperation,       //配置功率指示灯颜色
    mk_nbj_server_taskConfigNTPServerParamsOperation,           //配置NTP服务器参数
    mk_nbj_server_taskConfigDeviceTimeZoneOperation,            //配置时区
    mk_nbj_server_taskConfigLoadNotificationSwitchOperation,    //配置负载接入通知开关
    mk_nbj_server_taskConfigServerConnectingIndicatorStatusOperation,       //配置连接中网络指示灯开关
    mk_nbj_server_taskConfigServerConnectedIndicatorStatusOperation,        //配置连接成功网络指示灯状态
    mk_nbj_server_taskConfigIndicatorStatusOperation,           //配置电源指示灯开关指示
    mk_nbj_server_taskConfigIndicatorProtectionSignalOperation, //配置电源指示灯保护触发指示
    mk_nbj_server_taskConfigConnectionTimeoutOperation,         //配置服务器重连超时重启时间
    mk_nbj_server_taskConfigSwitchByButtonStatusOperation,      //配置按键开关机功能
    mk_nbj_server_taskClearOverloadStatusOperation,             //清除过载状态
    mk_nbj_server_taskClearOvervoltageStatusOperation,          //清除过压状态
    mk_nbj_server_taskClearUndervoltageStatusOperation,         //清除欠压状态
    mk_nbj_server_taskClearOvercurrentStatusOperation,          //清除过流状态
    mk_nbj_server_taskConfigSwitchStatusOperation,              //配置开关状态
    mk_nbj_server_taskConfigCountdownOperation,                 //配置倒计时
    mk_nbj_server_taskClearAllEnergyDatasOperation,             //清除电能数据
    mk_nbj_server_taskResetDeviceOperation,                     //恢复出厂设置
    mk_nbj_server_taskConfigOTAFirmwareOperation,               //OTA固件
    mk_nbj_server_taskConfigOTACACertificateOperation,          //OTA单项认证
    mk_nbj_server_taskConfigOTASelfSignedCertificatesOperation, //OTA双向认证
    mk_nbj_server_taskConfigDeviceUTCTimeOperation,             //配置UTC时间
    
#pragma mark - 服务器参数
    mk_nbj_server_taskConfigMQTTServerOperation,                //配置新的MQTT服务器信息
    mk_nbj_server_taskConfigMQTTLWTParamsOperation,             //配置MQTT遗嘱功能
    mk_nbj_server_taskConfigAPNParamsOperation,                 //配置APN功能
    mk_nbj_server_taskConfigNetworkPriorityOperation,           //配置网络制式
    mk_nbj_server_taskConfigMQTTServerParamsCompleteOperation,  //配置MQTT参数完成
    mk_nbj_server_taskReconnectMQTTServerOperation,             //设备切网
    
#pragma mark - 读取
    mk_nbj_server_taskReadPowerOnSwitchStatusOperation,         //读取开关上电状态
    mk_nbj_server_taskReadPeriodicalReportingOperation,         //读取开关和倒计时上报间隔
    mk_nbj_server_taskReadPowerReportingOperation,              //读取电量上报信息
    mk_nbj_server_taskReadEnergyReportingOperation,             //读取电能上报信息
    mk_nbj_server_taskReadOverloadProtectionDataOperation,      //读取过载保护参数
    mk_nbj_server_taskReadOvervoltageProtectionDataOperation,   //读取过压保护参数
    mk_nbj_server_taskReadUndervoltageProtectionDataOperation,  //读取欠压保护参数
    mk_nbj_server_taskReadOvercurrentProtectionDataOperation,   //读取过流保护参数
    mk_nbj_server_taskReadPowerIndicatorColorOperation,         //读取功率指示灯颜色
    mk_nbj_server_taskReadNTPServerParamsOperation,             //读取NTP服务器参数
    mk_nbj_server_taskReadTimeZoneOperation,                    //读取时区
    mk_nbj_server_taskReadLoadNotificationSwitchOperation,      //读取负载接入通知开关状态
    mk_nbj_server_taskReadServerConnectingIndicatorStatusOperation, //读取连接中网络指示灯开关
    mk_nbj_server_taskReadServerConnectedIndicatorStatusOperation,  //读取连接成功网络指示灯状态
    mk_nbj_server_taskReadIndicatorStatusOperation,                 //读取电源指示灯开关状态
    mk_nbj_server_taskReadIndicatorProtectionSignalOperation,       //读取电源指示灯保护触发指示
    mk_nbj_server_taskReadConnectionTimeoutOperation,           //读取服务器重连超时重启时间
    mk_nbj_server_taskReadSwitchByButtonStatusOperation,        //读取按键开关机功能
    mk_nbj_server_taskReadSwitchStatusOperation,                //读取开关状态
    mk_nbj_server_taskReadDeviceUpdateStateOperation,           //读取当前设备状态
    mk_nbj_server_taskReadElectricityDataOperation,             //读取电量信息
    mk_nbj_server_taskReadTotalEnergyDataOperation,             //读取总累计电能
    mk_nbj_server_taskReadMonthlyEnergyDataOperation,           //读取最近30天电能数据
    mk_nbj_server_taskReadHourlyEnergyDataOperation,            //读取当天每小时电能
    mk_nbj_server_taskReadDeviceInfoOperation,                  //读取设备信息
    mk_nbj_server_taskReadSpecificationsOfDeviceOperation,      //读取设备规格
    mk_nbj_server_taskReadDeviceUTCTimeOperation,               //读取设备UTC时间
    mk_nbj_server_taskReadDeviceWorkModeOperation,              //读取设备工作模式
    
#pragma mark - 服务器参数
    mk_nbj_server_taskReadDeviceMQTTServerInfoOperation,        //读取设备MQTT服务器参数
    mk_nbj_server_taskReadDeviceMQTTLWTParamsOperation,         //读取设备MQTT遗嘱参数
};
