//
//  MKNBJMQTTServerManager.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTServerManager.h"

#import "MQTTSSLSecurityPolicyTransport.h"
#import "MQTTSSLSecurityPolicy.h"

#import "MKMacroDefines.h"

#import "MKMQTTServerSDKDefines.h"
#import "MKNetworkManager.h"

#import "MKNBJServerParamsModel.h"
#import "MKNBJMQTTOperation.h"

NSString *const MKNBJMQTTSessionManagerStateChangedNotification = @"MKNBJMQTTSessionManagerStateChangedNotification";

//设备上报的状态信息
NSString *const MKNBJReceiveDeviceNetStateNotification = @"MKNBJReceiveDeviceNetStateNotification";

NSString *const MKNBJReceivedSwitchStateNotification = @"MKNBJReceivedSwitchStateNotification";
NSString *const MKNBJReceivedCountdownNotification = @"MKNBJReceivedCountdownNotification";
NSString *const MKNBJReceiveDeviceOTAResultNotification = @"MKNBJReceiveDeviceOTAResultNotification";
NSString *const MKNBJReceivedElectricityDataNotification = @"MKNBJReceivedElectricityDataNotification";
NSString *const MKNBJReceiveTotalEnergyDataNotification = @"MKNBJReceiveTotalEnergyDataNotification";
NSString *const MKNBJReceiveMonthlyEnergyDataNotification = @"MKNBJReceiveMonthlyEnergyDataNotification";
NSString *const MKNBJReceiveHourlyEnergyDataNotification = @"MKNBJReceiveHourlyEnergyDataNotification";

NSString *const MKNBJReceiveOverloadNotification = @"MKNBJReceiveOverloadNotification";
NSString *const MKNBJReceiveOvervoltageNotification = @"MKNBJReceiveOvervoltageNotification";
NSString *const MKNBJReceiveUndervoltageNotification = @"MKNBJReceiveUndervoltageNotification";
NSString *const MKNBJReceiveOverCurrentNotification = @"MKNBJReceiveOverCurrentNotification";
NSString *const MKNBJDeviceLoadStatusChangedNotification = @"MKNBJDeviceLoadStatusChangedNotification";

NSString *const MKNBJReceivedDownMQTTParamsDataCompleteNotification = @"MKNBJReceivedDownMQTTParamsDataCompleteNotification";


static MKNBJMQTTServerManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKNBJMQTTServerManager ()

@property (nonatomic, assign)MKNBJMQTTSessionManagerState state;

@property (nonatomic, strong)MKNBJServerParamsModel *paramsModel;

@property (nonatomic, strong)NSOperationQueue *operationQueue;

@end

@implementation MKNBJMQTTServerManager

- (void)dealloc{
    NSLog(@"MKNBJMQTTServerManager销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init{
    if (self = [super init]) {
        [[MKMQTTServerManager shared] loadDataManager:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                       selector:@selector(networkStateChanged)
                                           name:MKNetworkStatusChangedNotification
                                         object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                       selector:@selector(networkStateChanged)
                                           name:UIApplicationDidBecomeActiveNotification
                                         object:nil];
    }
    return self;
}

+ (MKNBJMQTTServerManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKNBJMQTTServerManager new];
        }
    });
    return manager;
}

+ (void)singleDealloc {
    [[MKMQTTServerManager shared] removeDataManager:manager];
    onceToken = 0;
    manager = nil;
}

#pragma mark - MKMQTTServerProtocol

- (void)sessionManager:(MQTTSessionManager *)sessionManager
     didReceiveMessage:(NSData *)data
               onTopic:(NSString *)topic
              retained:(BOOL)retained {
    if (!ValidStr(topic) || !ValidData(data)) {
        return;
    }
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (!ValidDict(dataDic) || !ValidNum(dataDic[@"msg_id"]) || !ValidStr(dataDic[@"device_info"][@"device_id"])) {
        return;
    }
    NSString *deviceID = dataDic[@"device_info"][@"device_id"];
    //无论是什么消息，都抛出该通知，证明设备在线
    [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveDeviceNetStateNotification
                                                        object:nil
                                                      userInfo:@{@"deviceID":deviceID}];
    NSInteger msgID = [dataDic[@"msg_id"] integerValue];
    if (msgID == 3065) {
        //开关状态
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceivedSwitchStateNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3066) {
        //倒计时
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceivedCountdownNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3067) {
        //电量信息
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveDeviceOTAResultNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3068) {
        //电量信息
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceivedElectricityDataNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3069) {
        //总累计电能
        NSString *energyValue = [NSString stringWithFormat:@"%.2f",([dataDic[@"data"][@"energy"] integerValue] * 0.01)];
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveTotalEnergyDataNotification
                                                            object:nil
                                                          userInfo:@{@"total":energyValue}];
        return;
    }
    if (msgID == 3070) {
        //最近30天电能
        NSDictionary *dic = [self parseEnergyDataDic:dataDic[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveMonthlyEnergyDataNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if (msgID == 3071) {
        //当天每小时电能
        NSDictionary *dic = [self parseEnergyDataDic:dataDic[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveHourlyEnergyDataNotification
                                                            object:nil
                                                          userInfo:dic];
        return;
    }
    if (msgID == 3072) {
        //过载保护
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveOverloadNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3073) {
        //过压保护
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveOvervoltageNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3074) {
        //欠压保护
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveUndervoltageNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3075) {
        //过流保护
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceiveOverCurrentNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3076) {
        //负载状态改变
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJDeviceLoadStatusChangedNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    if (msgID == 3077) {
        //入网准备完成通知
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJReceivedDownMQTTParamsDataCompleteNotification
                                                            object:nil
                                                          userInfo:dataDic];
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (NSOperation <MKNBJMQTTOperationProtocol>*operation in operations) {
            if (operation.executing) {
                [operation didReceiveMessage:dataDic onTopic:topic];
                break;
            }
        }
    }
}

- (void)sessionManager:(MQTTSessionManager *)sessionManager didChangeState:(MKMQTTSessionManagerState)newState {
    self.state = newState;
    [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJMQTTSessionManagerStateChangedNotification object:nil];
}

#pragma mark - note
- (void)networkStateChanged {
    if (![self.paramsModel paramsCanConnectServer]) {
        //服务器连接参数缺失
        return;
    }
    if (![[MKNetworkManager sharedInstance] currentNetworkAvailable]) {
        //如果是当前网络不可用，则断开当前手机与mqtt服务器的连接操作
        [[MKMQTTServerManager shared] disconnect];
        self.state = MKNBJMQTTSessionManagerStateStarting;
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNBJMQTTSessionManagerStateChangedNotification object:nil];
        return;
    }
    if ([MKMQTTServerManager shared].managerState == MKMQTTSessionManagerStateConnected
        || [MKMQTTServerManager shared].managerState == MKMQTTSessionManagerStateConnecting) {
        //已经连接或者正在连接，直接返回
        return;
    }
    //如果网络可用，则连接
    [self connect];
}

#pragma mark - public method

- (BOOL)saveServerParams:(id <MKNBJServerParamsProtocol>)protocol {
    return [self.paramsModel saveServerParams:protocol];
}

- (BOOL)clearLocalData {
    return [self.paramsModel clearLocalData];
}

- (void)disconnect {
    [[MKMQTTServerManager shared] disconnect];
}

- (void)subscriptions:(NSArray <NSString *>*)topicList {
    [[MKMQTTServerManager shared] subscriptions:topicList qosLevel:MQTTQosLevelAtLeastOnce];
}

- (void)unsubscriptions:(NSArray <NSString *>*)topicList {
    [[MKMQTTServerManager shared] unsubscriptions:topicList];
}

- (id<MKNBJServerParamsProtocol>)currentServerParams {
    return self.paramsModel;
}

- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
        deviceID:(NSString *)deviceID
          taskID:(mk_nbj_serverOperationID)taskID
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    
    MKNBJMQTTOperation *operation = [self generateOperationWithTaskID:taskID
                                                                topic:topic
                                                             deviceID:deviceID
                                                                 data:data
                                                             sucBlock:sucBlock
                                                          failedBlock:failedBlock];
    if (!operation) {
        return;
    }
    [self.operationQueue addOperation:operation];
}

- (void)startWork {
    [self networkStateChanged];
}

#pragma mark - *****************************服务器交互部分******************************

- (BOOL)connect {
    if (![self.paramsModel paramsCanConnectServer]) {
        return NO;
    }
    MQTTSSLSecurityPolicy *securityPolicy = nil;
    NSArray *certList = nil;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (self.paramsModel.sslIsOn) {
        //需要ssl验证
//        if (self.paramsModel.certificate == 0) {
//            //不需要CA根证书
//            securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeNone];
//        }
        if (self.paramsModel.certificate == 0 || self.paramsModel.certificate == 1) {
            //需要CA证书
            NSString *filePath = [document stringByAppendingPathComponent:self.paramsModel.caFileName];
            NSData *clientCert = [NSData dataWithContentsOfFile:filePath];
            if (MKMQTTValidData(clientCert)) {
                securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeCertificate];
                securityPolicy.pinnedCertificates = @[clientCert];
            }else {
                //未加载到CA证书
                securityPolicy = [MQTTSSLSecurityPolicy policyWithPinningMode:MQTTSSLPinningModeNone];
            }
        }
        if (self.paramsModel.certificate == 1) {
            //双向验证
            NSString *filePath = [document stringByAppendingPathComponent:self.paramsModel.clientFileName];
            certList = [MQTTSSLSecurityPolicyTransport clientCertsFromP12:filePath passphrase:@"123456"];
        }
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        securityPolicy.validatesCertificateChain = NO;
    }
    [[MKMQTTServerManager shared] connectTo:self.paramsModel.host
                                       port:[self.paramsModel.port integerValue]
                                        tls:self.paramsModel.sslIsOn
                                  keepalive:[self.paramsModel.keepAlive integerValue]
                                      clean:self.paramsModel.cleanSession
                                       auth:YES
                                       user:self.paramsModel.userName
                                       pass:self.paramsModel.password
                                       will:NO
                                  willTopic:nil
                                    willMsg:nil
                                    willQos:0
                             willRetainFlag:NO
                               withClientId:self.paramsModel.clientID
                             securityPolicy:securityPolicy
                               certificates:certList
                              protocolLevel:MQTTProtocolVersion311
                             connectHandler:nil];
    return YES;
}

- (NSString *)currentSubscribeTopic {
    return [MKNBJMQTTServerManager shared].serverParams.subscribeTopic;
}

- (NSString *)currentPublishedTopic {
    return [MKNBJMQTTServerManager shared].serverParams.publishTopic;
}

#pragma mark - private method

- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
        sucBlock:(void (^)(void))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    [[MKMQTTServerManager shared] sendData:data
                                     topic:topic
                                  qosLevel:MQTTQosLevelAtMostOnce
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

- (MKNBJMQTTOperation *)generateOperationWithTaskID:(mk_nbj_serverOperationID)taskID
                                              topic:(NSString *)topic
                                           deviceID:(NSString *)deviceID
                                               data:(NSDictionary *)data
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidDict(data)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failedBlock];
        return nil;
    }
    if (!ValidStr(topic) || topic.length > 128) {
        [self operationFailedBlockWithMsg:@"Topic error" failedBlock:failedBlock];
        return nil;
    }
    if (!ValidStr(deviceID) || deviceID.length > 32) {
        [self operationFailedBlockWithMsg:@"ClientID error" failedBlock:failedBlock];
        return nil;
    }
    if ([MKMQTTServerManager shared].managerState != MKMQTTSessionManagerStateConnected) {
        [self operationFailedBlockWithMsg:@"MTQQ Server disconnect" failedBlock:failedBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKNBJMQTTOperation *operation = [[MKNBJMQTTOperation alloc] initOperationWithID:taskID deviceID:deviceID commandBlock:^{
        [self sendData:data topic:topic sucBlock:nil failedBlock:nil];
    } completeBlock:^(NSError * _Nonnull error, id  _Nonnull returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            moko_dispatch_main_safe(^{
                if (failedBlock) {
                    failedBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failedBlock];
            return ;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock(returnData);
            }
        });
    }];
    return operation;
}

- (NSDictionary *)parseEnergyDataDic:(NSDictionary *)dic {
    NSString *timestamp = dic[@"timestamp"];
    NSArray *timestampList = [timestamp componentsSeparatedByString:@"T"];
    NSString *year = @"";
    NSString *month = @"";
    NSString *day = @"";
    NSString *hour = @"";
    if (ValidArray(timestampList) && timestampList.count == 2) {
        NSString *dateString = timestampList[0];
        NSArray *dateList = [dateString componentsSeparatedByString:@"-"];
        if (ValidArray(dateList) && dateList.count == 3) {
            year = dateList[0];
            month = dateList[1];
            day = dateList[2];
        }
        NSString *timeString = timestampList[1];
        NSArray *timeList = [timeString componentsSeparatedByString:@"+"];
        if (ValidArray(timeList) && timeList.count == 2) {
            NSString *tempString = timeList[0];
            NSArray *hourList = [tempString componentsSeparatedByString:@":"];
            if (ValidArray(hourList) && hourList.count == 3) {
                hour = hourList[0];
            }
        }
    }
    NSString *num = [NSString stringWithFormat:@"%@",dic[@"num"]];
    NSArray *tempList = dic[@"energy"];
    NSMutableArray *energyList = [NSMutableArray array];
    for (NSInteger i = 0; i < tempList.count; i ++) {
        NSNumber *value = tempList[i];
        NSString *energyValue = [NSString stringWithFormat:@"%.2f",([value integerValue] * 0.01)];
        [energyList addObject:energyValue];
    }
    NSDictionary *resultDic = @{
        @"year":year,
        @"month":month,
        @"day":day,
        @"hour":hour,
        @"number":num,
        @"energyList":energyList,
    };
    return resultDic;
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.MKNBJMQTTManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    moko_dispatch_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

#pragma mark - getter
- (MKNBJServerParamsModel *)paramsModel {
    if (!_paramsModel) {
        _paramsModel = [[MKNBJServerParamsModel alloc] init];
    }
    return _paramsModel;
}

- (NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
