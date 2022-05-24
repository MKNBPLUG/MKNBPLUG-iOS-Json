typedef NS_ENUM(NSInteger, mk_nbj_taskOperationID) {
    mk_nbj_defaultTaskOperationID,
    
#pragma mark - 读取
    mk_nbj_taskReadDeviceNameOperation,                  //读取设备广播名称
    mk_nbj_taskReadDeviceMacAddressOperation,            //读取mac地址
    
#pragma mark - 密码特征
    mk_nbj_connectPasswordOperation,                     //连接设备时候发送密码
    
#pragma mark - 配置
    mk_nbj_taskConfigServerHostOperation,                //配置MQTT服务器地址
    mk_nbj_taskConfigServerPortOperation,                //配置MQTT服务器端口号
    mk_nbj_taskConfigServerUserNameOperation,            //配置MQTT服务器用户名
    mk_nbj_taskConfigServerPasswordOperation,            //配置MQTT服务器密码
    mk_nbj_taskConfigClientIDOperation,                  //配置MQTT通信的ClientID
    mk_nbj_taskConfigServerCleanSessionOperation,        //配置MQTT服务器cleanSession状态
    mk_nbj_taskConfigServerKeepAliveOperation,           //配置Keep Alive
    mk_nbj_taskConfigServerQosOperation,                 //配置MQTT Qos
    mk_nbj_taskConfigSubscibeTopicOperation,             //配置MQTT Subscibe Topic
    mk_nbj_taskConfigPublishTopicOperation,              //配置MQTT Publish Topic
    mk_nbj_taskConfigLWTStatusOperation,                 //配置LWT开关状态
    mk_nbj_taskConfigLWTQosOperation,                    //配置LWT Qos
    mk_nbj_taskConfigLWTRetainOperation,                 //配置LWT Retain
    mk_nbj_taskConfigLWTTopicOperation,                  //配置LWT Topic
    mk_nbj_taskConfigLWTMessageOperation,                //配置LWT Message
    mk_nbj_taskConfigDeviceIDOperation,                  //配置DeviceID
    mk_nbj_taskConfigConnectModeOperation,               //配置加密方式
    mk_nbj_taskConfigCAFileOperation,                    //配置CA File
    mk_nbj_taskConfigClientCertOperation,                //配置设备证书
    mk_nbj_taskConfigClientPrivateKeyOperation,          //配置设备私钥
    mk_nbj_taskConfigNTPServerHostOperation,             //配置NTP服务器地址
    mk_nbj_taskConfigTimeZoneOperation,                  //配置时区
    mk_nbj_taskConfigAPNOperation,                       //配置APN
    mk_nbj_taskConfigAPNUserNameOperation,               //配置APN用户名
    mk_nbj_taskConfigAPNPasswordOperation,               //配置APN密码
    mk_nbj_taskConfigNetworkPriorityOperation,           //配置网络制式
    mk_nbj_taskConfigDataFormatOperation,                //配置MQTT数据格式
    mk_nbj_taskConfigEnterProductTestModeOperation,      //配置设备进入产测模式
    mk_nbj_taskConfigWorkModeOperation,                  //配置工作模式
    mk_nbj_taskConfigExitDebugModeOperation,             //退出debug模式
};
