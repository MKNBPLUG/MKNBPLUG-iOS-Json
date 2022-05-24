
@protocol MKNBJExcelAppProtocol <NSObject>

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

/// 0:CA certificate     1:Self signed certificates    仅对sslIsOn=YES情况下有效
@property (nonatomic, assign)NSInteger certificate;

@end






@protocol MKNBJExcelDeviceProtocol <NSObject>

/// 1-64 Characters
@property (nonatomic, copy)NSString *host;

/// 1~65535
@property (nonatomic, copy)NSString *port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

/// 1-128 Characters
@property (nonatomic, copy)NSString *subscribeTopic;

/// 1-128 Characters
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
/// 仅对sslIsOn=YES情况下有效
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

@property (nonatomic, assign)NSInteger lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@property (nonatomic, copy)NSString *deviceID;

/// 0-64 Characters
@property (nonatomic, copy)NSString *ntpHost;

/// 0~52(半小时为单位,对应-24~28)
@property (nonatomic, assign)NSInteger timeZone;

/// 0-100 Characters
@property (nonatomic, copy)NSString *apn;

/// 0-127 Characters
@property (nonatomic, copy)NSString *networkUsername;

/// 0-127 Characters
@property (nonatomic, copy)NSString *networkPassword;

/*
 0:eMTC->NB-IOT->GSM
 1:eMTC-> GSM -> NB-IOT
 2:NB-IOT->GSM-> eMTC
 3:NB-IOT-> eMTC-> GSM
 4:GSM -> NB-IOT-> eMTC
 5:GSM -> eMTC->NB-IOT
 6:eMTC->NB-IOT
 7:NB-IOT-> eMTC
 8:GSM
 9:NB-IOT
 10:eMTC
 */
@property (nonatomic, assign)NSInteger networkPriority;

@property (nonatomic, assign)BOOL debugMode;

@end

