
typedef NS_ENUM(NSInteger, MKNBJMQTTSessionManagerState) {
    MKNBJMQTTSessionManagerStateStarting,
    MKNBJMQTTSessionManagerStateConnecting,
    MKNBJMQTTSessionManagerStateError,
    MKNBJMQTTSessionManagerStateConnected,
    MKNBJMQTTSessionManagerStateClosing,
    MKNBJMQTTSessionManagerStateClosed
};

typedef NS_ENUM(NSInteger, mk_nbj_switchStatus) {
    mk_nbj_switchStatusPowerOff,        //the switch state is off when the device is just powered on.
    mk_nbj_switchStatusPowerOn,         //the switch state is on when the device is just powered on
    mk_nbj_switchStatusRevertLast,      //when the device is just powered on, the switch returns to the state before the power failure.
};

typedef NS_ENUM(NSInteger, mk_nbj_productModel) {
    mk_nbj_productModel_FE,                        //Europe and France
    mk_nbj_productModel_America,                  //America
    mk_nbj_productModel_UK,                      //UK
};

typedef NS_ENUM(NSInteger, mk_nbj_indicatorBleConnectedStatus) {
    mk_nbj_indicatorBleConnectedStatus_off,                            //off
    mk_nbj_indicatorBleConnectedStatus_solidBlueForFiveSeconds,        //Solid blue for 5 seconds
    mk_nbj_indicatorBleConnectedStatus_solidBlue,                      //Solid blue
};

typedef NS_ENUM(NSInteger, mk_nbj_ledColorType) {
    mk_nbj_ledColorTransitionDirectly,
    mk_nbj_ledColorTransitionSmoothly,
    mk_nbj_ledColorWhite,
    mk_nbj_ledColorRed,
    mk_nbj_ledColorGreen,
    mk_nbj_ledColorBlue,
    mk_nbj_ledColorOrange,
    mk_nbj_ledColorCyan,
    mk_nbj_ledColorPurple,
};

typedef NS_ENUM(NSInteger, mk_nbj_mqtt_networkPriority) {
    mk_nbj_mqtt_networkPriority_eMTC_NB_IOT_GSM,
    mk_nbj_mqtt_networkPriority_eMTC_GSM_NB_IOT,
    mk_nbj_mqtt_networkPriority_NB_IOT_GSM_eMTC,
    mk_nbj_mqtt_networkPriority_NB_IOT_eMTC_GSM,
    mk_nbj_mqtt_networkPriority_GSM_NB_IOT_eMTC,
    mk_nbj_mqtt_networkPriority_GSM_eMTC_NB_IOT,
    mk_nbj_mqtt_networkPriority_eMTC_NB_IOT,
    mk_nbj_mqtt_networkPriority_NB_IOT_eMTC,
    mk_nbj_mqtt_networkPriority_GSM,
    mk_nbj_mqtt_networkPriority_NB_IOT,
    mk_nbj_mqtt_networkPriority_eMTC,
};

@protocol mk_nbj_ledColorConfigProtocol <NSObject>

/*
 Blue.
 European and French specifications:2 <=  b_color <= 4411.
 American specifications:2 <=  b_color <= 2155.
 British specifications:2 <=  b_color <= 3584.
 */
@property (nonatomic, assign)NSInteger b_color;

/*
 Green.
 European and French specifications:b_color < g_color <= 4412.
 American specifications:b_color < g_color <= 2156.
 British specifications:b_color < g_color <= 3584.
 */
@property (nonatomic, assign)NSInteger g_color;

/*
 Yellow.
 European and French specifications:g_color < y_color <= 4413.
 American specifications:g_color < y_color <= 2157.
 British specifications:g_color < y_color <= 3585.
 */
@property (nonatomic, assign)NSInteger y_color;

/*
 Orange.
 European and French specifications:y_color < o_color <= 4414.
 American specifications:y_color < o_color <= 2158.
 British specifications:y_color < o_color <= 3586.
 */
@property (nonatomic, assign)NSInteger o_color;

/*
 Red.
 European and French specifications:o_color < r_color <= 4415.
 American specifications:o_color < r_color <= 2159.
 British specifications:o_color < r_color <= 3587.
 */
@property (nonatomic, assign)NSInteger r_color;

/*
 Purple.
 European and French specifications:r_color < p_color <=  4416.
 American specifications:r_color < p_color <=  2160.
 British specifications:r_color < p_color <=  3588.
 */
@property (nonatomic, assign)NSInteger p_color;

@end



@protocol nbj_updateMQTTServerProtocol <NSObject>

/// mqtt host  1-64 Characters
@property (nonatomic, copy)NSString *mqtt_host;

/// mqtt port   0-65535
@property (nonatomic, assign)NSInteger mqtt_port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

/// 1-128 Characters
@property (nonatomic, copy)NSString *subscribeTopic;

/// 1-128 Characters
@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL cleanSession;

/// 0:Qos0 1:Qos1 2:Qos2
@property (nonatomic, assign)NSInteger qos;

/// 10s~120s
@property (nonatomic, assign)NSInteger keepAlive;

/// 0-256 Characters
@property (nonatomic, copy)NSString *mqtt_userName;

/// 0-256 Characters
@property (nonatomic, copy)NSString *mqtt_password;

/// 0:TCP    1:CA signed server certificate     2:CA certificate     3:Self signed certificates
@property (nonatomic, assign)NSInteger connect_mode;

/// Host of the server where the certificate is located.1-64 Characters
@property (nonatomic, copy)NSString *sslHost;

/// Port of the server where the certificate is located.0~65535
@property (nonatomic, assign)NSInteger sslPort;

/// The path of the CA certificate on the ssl certificate server.1-128Characters
@property (nonatomic, copy)NSString *caFilePath;

/// The path of the Client Private Key on the ssl certificate server.1-128Characters
@property (nonatomic, copy)NSString *clientKeyPath;

/// The path of the Client certificate on the ssl certificate server.1-128Characters
@property (nonatomic, copy)NSString *clientCertPath;

@end



@protocol nbj_updateLWTProtocol <NSObject>

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

/// lwtStatus is ON: 0/1/2
@property (nonatomic, assign)NSInteger lwtQos;

/// lwtStatus is ON:1-128Characters
@property (nonatomic, copy)NSString *lwtTopic;

/// lwtStatus is ON:1-128Characters
@property (nonatomic, copy)NSString *lwtPayload;

@end



@protocol nbj_updateAPNSettingsProtocol <NSObject>

/// 0-127 Characters
@property (nonatomic, copy)NSString *apn;

/// 0-127 Characters
@property (nonatomic, copy)NSString *networkUsername;

/// 0-127 Characters
@property (nonatomic, copy)NSString *networkPassword;

@end

#pragma mark ****************************************连接参数************************************************

@protocol MKNBJServerParamsProtocol <NSObject>

/// 1-64 Characters
@property (nonatomic, copy)NSString *host;

/// 1~65535
@property (nonatomic, copy)NSString *port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

/// 0-128 Characters
@property (nonatomic, copy)NSString *subscribeTopic;

/// 0-128 Characters
@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL cleanSession;

/// 0、1、2
@property (nonatomic, assign)NSInteger qos;

/// 10-120
@property (nonatomic, copy)NSString *keepAlive;

/// 0-128 Characters
@property (nonatomic, copy)NSString *userName;

/// 0-128 Characters
@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA certificate     1:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

/// 根证书
@property (nonatomic, copy)NSString *caFileName;

/// 对于app是.p12证书
@property (nonatomic, copy)NSString *clientFileName;

@end
