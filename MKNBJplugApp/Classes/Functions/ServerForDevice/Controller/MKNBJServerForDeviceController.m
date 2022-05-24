//
//  MKNBJServerForDeviceController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJServerForDeviceController.h"

#import <MessageUI/MessageUI.h>

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKCustomUIAdopter.h"
#import "MKProgressView.h"
#import "MKCAFileSelectController.h"

#import "MKNBJConnectSuccessController.h"
#import "MKNBJImportServerController.h"

#import "MKNBJExcelDataManager.h"

#import "MKNBJServerConfigDeviceFooterView.h"

#import "MKNBJServerForDeviceModel.h"

#import "MKNBJDeviceModel.h"

#import "MKNBJCentralManager.h"

#import "MKNBJMQTTServerManager.h"

@interface MKNBJServerForDeviceController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKNBJServerConfigDeviceFooterViewDelegate,
MKCAFileSelectControllerDelegate,
MFMailComposeViewControllerDelegate,
MKNBJImportServerControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *sectionHeaderList;

@property (nonatomic, strong)MKNBJServerForDeviceModel *dataModel;

@property (nonatomic, strong)MKNBJServerConfigDeviceFooterView *sslParamsView;

@property (nonatomic, strong)MKNBJServerConfigDeviceFooterViewModel *sslParamsModel;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)MKProgressView *progressView;

@property (nonatomic, strong)dispatch_source_t connectTimer;

@property (nonatomic, assign)NSInteger timeCount;

@end

@implementation MKNBJServerForDeviceController

- (void)dealloc {
    NSLog(@"MKNBJServerForDeviceController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MKNBJCentralManager shared] disconnect];
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    NSString *errorMsg = [self.dataModel checkParams];
    if (ValidStr(errorMsg)) {
        [self.view showCentralToast:errorMsg];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self configServerParamsComplete];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)leftButtonMethod {
    [self popToViewControllerWithClassName:@"MKNBJScanPageController"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKTextFieldCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    header.headerModel = self.sectionHeaderList[section];
    return header;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionHeaderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //host
        self.dataModel.host = value;
        MKTextFieldCellModel *cellModel = self.section0List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Port
        self.dataModel.port = value;
        MKTextFieldCellModel *cellModel = self.section0List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //clientID
        self.dataModel.clientID = value;
        MKTextFieldCellModel *cellModel = self.section0List[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Subscribe
        self.dataModel.subscribeTopic = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 4) {
        //Publish
        self.dataModel.publishTopic = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKNBJServerConfigDeviceFooterViewDelegate
/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl    2:lwtStatus  3:lwtRetain  4:debugMode
- (void)nbj_mqtt_serverForDevice_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID {
    if (statusID == 0) {
        //cleanSession
        self.dataModel.cleanSession = isOn;
        self.sslParamsModel.cleanSession = isOn;
        return;
    }
    if (statusID == 1) {
        //ssl
        self.dataModel.sslIsOn = isOn;
        self.sslParamsModel.sslIsOn = isOn;
        //动态刷新footer
        [self setupSSLViewFrames];
        self.sslParamsView.dataModel = self.sslParamsModel;
        return;
    }
    if (statusID == 2) {
        //lwtStatus
        self.dataModel.lwtStatus = isOn;
        self.sslParamsModel.lwtStatus = isOn;
        return;
    }
    if (statusID == 3) {
        //lwtRetain
        self.dataModel.lwtRetain = isOn;
        self.sslParamsModel.lwtRetain = isOn;
        return;
    }
    if (statusID == 4) {
        //debugMode
        self.dataModel.debugMode = isOn;
        self.sslParamsModel.debugMode = isOn;
        return;
    }
}

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password    3:deviceID   4:ntpURL  5:lwtTopic   6:lwtPayload 7:APN 8:Network_Username  9:Network_Password
- (void)nbj_mqtt_serverForDevice_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID {
    if (textID == 0) {
        //keepAlive
        self.dataModel.keepAlive = text;
        self.sslParamsModel.keepAlive = text;
        return;
    }
    if (textID == 1) {
        //userName
        self.dataModel.userName = text;
        self.sslParamsModel.userName = text;
        return;
    }
    if (textID == 2) {
        //password
        self.dataModel.password = text;
        self.sslParamsModel.password = text;
        return;
    }
    if (textID == 3) {
        //deviceID
        self.dataModel.deviceID = text;
        self.sslParamsModel.deviceID = text;
        return;
    }
    if (textID == 4) {
        //ntpURL
        self.dataModel.ntpHost = text;
        self.sslParamsModel.ntpHost = text;
        return;
    }
    if (textID == 5) {
        //LWT Topic
        self.dataModel.lwtTopic = text;
        self.sslParamsModel.lwtTopic = text;
        return;
    }
    if (textID == 6) {
        //LWT Payload
        self.dataModel.lwtPayload = text;
        self.sslParamsModel.lwtPayload = text;
        return;
    }
    if (textID == 7) {
        //APN
        self.dataModel.apn = text;
        self.sslParamsModel.apn = text;
        return;
    }
    if (textID == 8) {
        //Network_Username
        self.dataModel.networkUsername = text;
        self.sslParamsModel.networkUsername = text;
        return;
    }
    if (textID == 9) {
        //Network_Password
        self.dataModel.networkPassword = text;
        self.sslParamsModel.networkPassword = text;
        return;
    }
}

- (void)nbj_mqtt_serverForDevice_qosChanged:(NSInteger)qos qosID:(NSInteger)qosID{
    if (qosID == 0) {
        //qos
        self.dataModel.qos = qos;
        self.sslParamsModel.qos = qos;
        return;
    }
    if (qosID == 1) {
        //lwtQos
        self.dataModel.lwtQos = qos;
        self.sslParamsModel.lwtQos = qos;
        return;
    }
}

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_serverForDevice_certificateChanged:(NSInteger)certificate {
    self.dataModel.certificate = certificate;
    self.sslParamsModel.certificate = certificate;
    //动态刷新footer
    [self setupSSLViewFrames];
    self.sslParamsView.dataModel = self.sslParamsModel;
}

/// 用户点击了证书相关按钮
/// @param fileType 0:caFaile   1:cilentKeyFile   2:client cert file
- (void)nbj_mqtt_serverForDevice_fileButtonPressed:(NSInteger)fileType {
    if (fileType == 0) {
        //caFile
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_caCertSelPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (fileType == 1) {
        //cilentKeyFile
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_clientKeySelPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (fileType == 2) {
        //client cert file
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_clientCertSelPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

/// 时区改变
/// @param timeZone -24~28
- (void)nbj_mqtt_serverForDevice_timeZoneChanged:(NSInteger)timeZone {
    self.dataModel.timeZone = timeZone;
    self.sslParamsModel.timeZone = timeZone;
}

/// 网络策略发生改变
/// @param priority
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
- (void)nbj_mqtt_serverForDevice_priorityChanged:(NSInteger)priority {
    self.dataModel.networkPriority = priority;
    self.sslParamsModel.networkPriority = priority;
}

/// 底部按钮
/// @param index 0:Export Demo File   1:Import Config File
- (void)nbj_mqtt_serverForDevice_bottomButtonPressed:(NSInteger)index {
    if (index == 0) {
        //Export Demo File
        [self exportServerConfig];
        return;;
    }
    if (index == 1) {
        //Import Config File
        MKNBJImportServerController *vc = [[MKNBJImportServerController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MKCAFileSelectControllerDelegate
- (void)mk_certSelectedMethod:(mk_certListPageType)certType certName:(NSString *)certName {
    if (certType == mk_caCertSelPage) {
        //CA File
        self.dataModel.caFileName = certName;
        self.sslParamsModel.caFileName = certName;
        
        //动态布局底部footer
        [self setupSSLViewFrames];
        
        self.sslParamsView.dataModel = self.sslParamsModel;
        return;
    }
    if (certType == mk_clientKeySelPage) {
        //客户端私钥
        self.dataModel.clientKeyName = certName;
        self.sslParamsModel.clientKeyName = certName;
        
        //动态布局底部footer
        [self setupSSLViewFrames];
        
        self.sslParamsView.dataModel = self.sslParamsModel;
        return;
    }
    if (certType == mk_clientCertSelPage) {
        //客户端证书
        self.dataModel.clientCertName = certName;
        self.sslParamsModel.clientCertName = certName;
        
        //动态布局底部footer
        [self setupSSLViewFrames];
        
        self.sslParamsView.dataModel = self.sslParamsModel;
        return;
    }
}

#pragma mark - MKNBJImportServerControllerDelegate
- (void)nbj_selectedServerParams:(NSString *)fileName {
    [MKNBJExcelDataManager parseDeviceExcel:fileName
                                   sucBlock:^(NSDictionary * _Nonnull returnData) {
        MKNBJServerForDeviceModel *model = [MKNBJServerForDeviceModel mk_modelWithJSON:returnData];
        [self.dataModel updateValue:model];
        [self.section0List removeAllObjects];
        [self.section1List removeAllObjects];
        [self.sectionHeaderList removeAllObjects];
        [self loadSectionDatas];
    }
                                failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - note
- (void)connectStatusChanged {
    if ([MKNBJCentralManager shared].connectStatus == mk_nbj_centralConnectStatusConnected) {
        return;
    }
    if (self.progressView) {
        [self.progressView dismiss];
    }
    [self.view showCentralToast:@"Device disconnect!"];
    [self performSelector:@selector(deviceDisconnect) withObject:nil afterDelay:0.5f];
}

- (void)receiveDeviceNetState:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"deviceID"]) || ![self.dataModel.deviceID isEqualToString:user[@"deviceID"]]) {
        return;
    }
    //接收到设备的网络状态上报，认为设备入网成功
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MKNBJReceiveDeviceNetStateNotification
                                                  object:nil];
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    self.timeCount = 0;
    [self.progressView setProgress:1.f animated:YES];
    [self performSelector:@selector(connectSuccess) withObject:nil afterDelay:.5f];
}

- (void)deviceDisconnect {
    [self leftButtonMethod];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(connectStatusChanged)
                                                     name:mk_nbj_peripheralConnectStateChangedNotification
                                                   object:nil];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)configServerParamsComplete {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:mk_nbj_peripheralConnectStateChangedNotification
                                                  object:nil];
    NSString *topic = @"";
    if (ValidStr([MKNBJMQTTServerManager shared].subscribeTopic)) {
        //查看是否设置了服务器的订阅topic
        topic = [MKNBJMQTTServerManager shared].subscribeTopic;
    }else {
        topic = self.dataModel.publishTopic;
    }
    [self.progressView show];
    [[MKNBJMQTTServerManager shared] subscriptions:@[topic]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceNetState:)
                                                 name:MKNBJReceiveDeviceNetStateNotification
                                               object:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timeCount = 0;
    dispatch_source_set_timer(self.connectTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.connectTimer, ^{
        @strongify(self);
        if (self.timeCount >= 90) {
            //接受数据超时
            dispatch_cancel(self.connectTimer);
            self.timeCount = 0;
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MKNBJReceiveDeviceNetStateNotification
                                                          object:nil];
            moko_dispatch_main_safe(^{
                [self.progressView dismiss];
                [self.view showCentralToast:@"Connect Failed!"];
            });
            return ;
        }
        self.timeCount ++;
        moko_dispatch_main_safe(^{
            [self.progressView setProgress:(self.timeCount / 90.f) animated:NO];
        });
    });
    dispatch_resume(self.connectTimer);
}

- (void)connectSuccess {
    if (self.progressView) {
        [self.progressView dismiss];
    }
    
    MKNBJDeviceModel *deviceModel = [[MKNBJDeviceModel alloc] init];
    deviceModel.deviceType = @"00";
    deviceModel.deviceID = self.dataModel.deviceID;
    deviceModel.clientID = self.dataModel.clientID;
    deviceModel.subscribedTopic = self.dataModel.subscribeTopic;
    deviceModel.publishedTopic = self.dataModel.publishTopic;
    deviceModel.macAddress = self.dataModel.macAddress;
    deviceModel.deviceName = self.dataModel.deviceName;
    
    [MKNBJMQTTServerManager singleDealloc];
    
    MKNBJConnectSuccessController *vc = [[MKNBJConnectSuccessController alloc] init];
    vc.deviceModel = deviceModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)exportServerConfig {
    NSString *errorMsg = [self.dataModel checkParams];
    if (ValidStr(errorMsg)) {
        [self.view showCentralToast:errorMsg];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKNBJExcelDataManager exportDeviceExcel:self.dataModel
                                    sucBlock:^{
        [[MKHudManager share] hide];
        [self sharedExcel];
    }
                                 failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)sharedExcel {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"Settings for device.xlsx"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self.view showCentralToast:@"File not exist"];
        return;
    }
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if (!ValidData(data)) {
        [self.view showCentralToast:@"Load file error"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:data
                           mimeType:@"application/xlsx"
                           fileName:@"Settings for device.xlsx"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    [self loadSectionHeaderDatas];
    [self loadFooterViewDatas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Host";
    cellModel1.textPlaceholder = @"1-64 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.host;
    cellModel1.maxLength = 64;
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Port";
    cellModel2.textPlaceholder = @"1-65535";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.port;
    cellModel2.maxLength = 5;
    [self.section0List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Client Id";
    cellModel3.textPlaceholder = @"1-64 Characters";
    cellModel3.textFieldType = mk_normal;
    cellModel3.textFieldValue = self.dataModel.clientID;
    cellModel3.maxLength = 64;
    [self.section0List addObject:cellModel3];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 3;
    cellModel1.msg = @"Subscribe";
    cellModel1.textPlaceholder = @"1-128 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.subscribeTopic;
    cellModel1.maxLength = 128;
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 4;
    cellModel2.msg = @"Publish";
    cellModel2.textPlaceholder = @"1-128 Characters";
    cellModel2.textFieldType = mk_normal;
    cellModel2.textFieldValue = self.dataModel.publishTopic;
    cellModel2.maxLength = 128;
    cellModel2.noteMsg = @"Note: Input your topics to communicate with the device or set the topics to empty.";
    [self.section1List addObject:cellModel2];
}

- (void)loadSectionHeaderDatas {
    MKTableSectionLineHeaderModel *section0Model = [[MKTableSectionLineHeaderModel alloc] init];
    section0Model.contentColor = RGBCOLOR(242, 242, 242);
    section0Model.text = @"Broker Setting";
    [self.sectionHeaderList addObject:section0Model];
    
    MKTableSectionLineHeaderModel *section0Mode2 = [[MKTableSectionLineHeaderModel alloc] init];
    section0Mode2.contentColor = RGBCOLOR(242, 242, 242);
    section0Mode2.text = @"Topics";
    [self.sectionHeaderList addObject:section0Mode2];
}

- (void)loadFooterViewDatas {
    self.sslParamsModel.cleanSession = self.dataModel.cleanSession;
    self.sslParamsModel.qos = self.dataModel.qos;
    self.sslParamsModel.keepAlive = self.dataModel.keepAlive;
    self.sslParamsModel.userName = self.dataModel.userName;
    self.sslParamsModel.password = self.dataModel.password;
    self.sslParamsModel.sslIsOn = self.dataModel.sslIsOn;
    self.sslParamsModel.certificate = self.dataModel.certificate;
    self.sslParamsModel.caFileName = self.dataModel.caFileName;
    self.sslParamsModel.clientKeyName = self.dataModel.clientKeyName;
    self.sslParamsModel.clientCertName = self.dataModel.clientCertName;
    self.sslParamsModel.timeZone = self.dataModel.timeZone;
    self.sslParamsModel.lwtStatus = self.dataModel.lwtStatus;
    self.sslParamsModel.lwtRetain = self.dataModel.lwtRetain;
    self.sslParamsModel.lwtQos = self.dataModel.lwtQos;
    self.sslParamsModel.lwtTopic = self.dataModel.lwtTopic;
    self.sslParamsModel.lwtPayload = self.dataModel.lwtPayload;
    self.sslParamsModel.deviceID = self.dataModel.deviceID;
    self.sslParamsModel.apn = self.dataModel.apn;
    self.sslParamsModel.networkUsername = self.dataModel.networkUsername;
    self.sslParamsModel.networkPassword = self.dataModel.networkPassword;
    self.sslParamsModel.networkPriority = self.dataModel.networkPriority;
    self.sslParamsModel.debugMode = self.dataModel.debugMode;
    
    //动态布局底部footer
    [self setupSSLViewFrames];
    
    self.sslParamsView.dataModel = self.sslParamsModel;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Settings for Device";
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJServerForDeviceController", @"nbj_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

- (void)setupSSLViewFrames {
    if (self.sslParamsView.superview) {
        [self.sslParamsView removeFromSuperview];
    }

    CGFloat height = [self.sslParamsView fetchHeightWithSSLStatus:self.dataModel.sslIsOn
                                                       CAFileName:self.dataModel.caFileName
                                                    clientKeyName:self.dataModel.clientKeyName
                                                   clientCertName:self.dataModel.clientCertName
                                                      certificate:self.dataModel.certificate];
    
    [self.footerView addSubview:self.sslParamsView];
    self.footerView.frame = CGRectMake(0, 0, kViewWidth, height + 70.f);
    self.sslParamsView.frame = CGRectMake(0, 0, kViewWidth, height);
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - getter

- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (MKNBJServerForDeviceModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJServerForDeviceModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)sectionHeaderList {
    if (!_sectionHeaderList) {
        _sectionHeaderList = [NSMutableArray array];
    }
    return _sectionHeaderList;
}

- (MKNBJServerConfigDeviceFooterView *)sslParamsView {
    if (!_sslParamsView) {
        _sslParamsView = [[MKNBJServerConfigDeviceFooterView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 380.f)];
        _sslParamsView.delegate = self;
    }
    return _sslParamsView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 450.f)];
        _footerView.backgroundColor = COLOR_WHITE_MACROS;
        [_footerView addSubview:self.sslParamsView];
    }
    return _footerView;
}

- (MKNBJServerConfigDeviceFooterViewModel *)sslParamsModel {
    if (!_sslParamsModel) {
        _sslParamsModel = [[MKNBJServerConfigDeviceFooterViewModel alloc] init];
    }
    return _sslParamsModel;
}

- (MKProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[MKProgressView alloc] initWithTitle:@"Connecting now!"
                                                      message:@"Make sure your device is as close to your router as possible"];
    }
    return _progressView;
}

@end
