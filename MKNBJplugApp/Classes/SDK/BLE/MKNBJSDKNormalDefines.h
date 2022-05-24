
typedef NS_ENUM(NSInteger, mk_nbj_centralConnectStatus) {
    mk_nbj_centralConnectStatusUnknow,                                           //未知状态
    mk_nbj_centralConnectStatusConnecting,                                       //正在连接
    mk_nbj_centralConnectStatusConnected,                                        //连接成功
    mk_nbj_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_nbj_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_nbj_centralManagerStatus) {
    mk_nbj_centralManagerStatusUnable,                           //不可用
    mk_nbj_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_nbj_connectMode) {
    mk_nbj_connectMode_TCP,                                          //TCP
    mk_nbj_connectMode_CACertificate,                                //SSL.Verify the server's certificate
    mk_nbj_connectMode_SelfSignedCertificates,                       //SSL.Two-way authentication
};

//Quality of MQQT service
typedef NS_ENUM(NSInteger, mk_nbj_mqttServerQosMode) {
    mk_nbj_mqttQosLevelAtMostOnce,      //At most once. The message sender to find ways to send messages, but an accident and will not try again.
    mk_nbj_mqttQosLevelAtLeastOnce,     //At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.
    mk_nbj_mqttQosLevelExactlyOnce,     //Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
};

typedef NS_ENUM(NSInteger, mk_nbj_networkPriority) {
    mk_nbj_networkPriority_eMTC_nbj_IOT_GSM,
    mk_nbj_networkPriority_eMTC_GSM_nbj_IOT,
    mk_nbj_networkPriority_nbj_IOT_GSM_eMTC,
    mk_nbj_networkPriority_nbj_IOT_eMTC_GSM,
    mk_nbj_networkPriority_GSM_nbj_IOT_eMTC,
    mk_nbj_networkPriority_GSM_eMTC_nbj_IOT,
    mk_nbj_networkPriority_eMTC_nbj_IOT,
    mk_nbj_networkPriority_nbj_IOT_eMTC,
    mk_nbj_networkPriority_GSM,
    mk_nbj_networkPriority_nbj_IOT,
    mk_nbj_networkPriority_eMTC,
};

typedef NS_ENUM(NSInteger, mk_nbj_dataFormat) {
    mk_nbj_dataFormat_json,                   //JSON
    mk_nbj_dataFormat_hex,                    //HEX
};

typedef NS_ENUM(NSInteger, mk_nbj_workMode) {
    mk_nbj_workMode_rc,                       //RC
    mk_nbj_workMode_debug,                    //Debug
};



@class CBCentralManager,CBPeripheral;

@protocol mk_nbj_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
/*
 @{
     @"rssi":rssi,
     @"peripheral":peripheral,
     @"deviceName":@"MOKO",
     @"macAddress":@"AA:BB:CC:DD:EE:FF",
     @"deviceType":@"00",
     @"firmware":@"V1.2.3",
     @"connectable":@(YES),
     @"mode":@"0",      //@"0":Production test mode.    @"1":configuration mode.    @"2":Debug mode.
 };
 */
- (void)mk_nbj_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_nbj_startScan;

/// Stops scanning equipment.
- (void)mk_nbj_stopScan;

@end

@protocol mk_nbj_centralManagerLogDelegate <NSObject>

- (void)mk_nbj_receiveLog:(NSString *)deviceLog;

@end
