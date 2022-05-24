//
//  MKNBJMQTTOperation.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJMQTTOperation.h"

#import "MKMacroDefines.h"

#import "MKNBJMQTTTaskAdopter.h"

@interface MKNBJMQTTOperation ()

@property (nonatomic, strong)dispatch_source_t receiveTimer;

/**
 线程ID
 */
@property (nonatomic, assign)mk_nbj_serverOperationID operationID;

/**
 线程结束时候的回调
 */
@property (nonatomic, copy)void (^completeBlock) (NSError *error, id returnData);

@property (nonatomic, copy)void (^commandBlock)(void);

/**
 超时标志
 */
@property (nonatomic, assign)BOOL timeout;

/**
 接受数据超时个数
 */
@property (nonatomic, assign)NSInteger receiveTimerCount;

@property (nonatomic, copy)NSString *deviceID;

@end

@implementation MKNBJMQTTOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)dealloc{
    NSLog(@"MKNBJMQTTOperation销毁");
}

- (instancetype)initOperationWithID:(mk_nbj_serverOperationID)operationID
                           deviceID:(NSString *)deviceID
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, id returnData))completeBlock {
    if (self = [super init]) {
        _executing = NO;
        _finished = NO;
        _operationID = operationID;
        _deviceID = deviceID;
        _commandBlock = commandBlock;
        _completeBlock = completeBlock;
    }
    return self;
}

#pragma mark - super method

- (void)start{
    if (self.isFinished || self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    if (self.commandBlock) {
        self.commandBlock();
    }
    [self startReceiveTimer];
}

#pragma mark - MKNBJMQTTOperationProtocol

- (void)didReceiveMessage:(NSDictionary *)data onTopic:(NSString *)topic {
    if (!ValidDict(data) || !ValidStr(topic) || topic.length > 128) {
        return;
    }
    NSString *deviceID = data[@"device_info"][@"device_id"];
    if (!ValidStr(deviceID) || deviceID.length > 32 || ![deviceID isEqualToString:self.deviceID]) {
        return;
    }
    [self dataParserReceivedData:[MKNBJMQTTTaskAdopter parseDataWithJson:data topic:topic]];
}

#pragma mark - Private method
- (void)startReceiveTimer{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.receiveTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.receiveTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.receiveTimer, ^{
        __strong typeof(self) sself = weakSelf;
        if (sself.timeout || sself.receiveTimerCount >= 20) {
            //接受数据超时
            sself.receiveTimerCount = 0;
            [sself communicationTimeout];
            return ;
        }
        sself.receiveTimerCount ++;
    });
    if (self.isCancelled) {
        return;
    }
    dispatch_resume(self.receiveTimer);
}

- (void)finishOperation{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)communicationTimeout{
    self.timeout = YES;
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
    [self finishOperation];
    if (self.completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.operationError"
                                                    code:-999
                                                userInfo:@{@"errorInfo":@"Communication timeout"}];
        self.completeBlock(error, nil);
    }
}

- (void)dataParserReceivedData:(NSDictionary *)dataDic{
    if (self.isCancelled || !_executing || !ValidDict(dataDic) || self.timeout) {
        return;
    }
    mk_nbj_serverOperationID operationID = [dataDic[@"operationID"] integerValue];
    if (operationID == mk_nbj_defaultServerOperationID || operationID != self.operationID) {
        return;
    }
    NSDictionary *returnData = dataDic[@"returnData"];
    if (!ValidDict(returnData)) {
        return;
    }
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
    [self finishOperation];
    if (self.completeBlock) {
        self.completeBlock(nil, returnData);
    }
}

#pragma mark - getter
- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isFinished{
    return _finished;
}

- (BOOL)isExecuting{
    return _executing;
}

@end
