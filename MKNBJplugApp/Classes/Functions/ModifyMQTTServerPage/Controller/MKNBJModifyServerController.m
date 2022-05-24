//
//  MKNBJModifyServerController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/6.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJModifyServerController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKCustomUIAdopter.h"
#import "MKProgressView.h"

#import "MKNBJDeviceListDatabaseManager.h"

#import "MKNBJModifyServerFooterView.h"

#import "MKNBJModifyServerModel.h"

@interface MKNBJModifyServerController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKNBJModifyServerFooterViewDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *sectionHeaderList;

@property (nonatomic, strong)MKNBJModifyServerModel *dataModel;

@property (nonatomic, strong)MKNBJModifyServerFooterView *sslParamsView;

@property (nonatomic, strong)MKNBJModifyServerFooterViewModel *sslParamsModel;

@property (nonatomic, strong)UIView *footerView;

@end

@implementation MKNBJModifyServerController

- (void)dealloc {
    NSLog(@"MKNBJModifyServerController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self updateMQTTServer];
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

#pragma mark - MKNBJModifyServerFooterViewDelegate
/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl
- (void)nbj_mqtt_modifyMQTT_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID {
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
        //LWT
        self.dataModel.lwtStatus = isOn;
        self.sslParamsModel.lwtStatus = isOn;
        return;
    }
    if (statusID == 3) {
        //LWT Retain
        self.dataModel.lwtRetain = isOn;
        self.sslParamsModel.lwtRetain = isOn;
        return;
    }
}

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password    3:LWT Topic   4:LWT Payload  5:sslHost    6:sslPort   7:CA File Path    8:Client Key File
///   9:Client Cert  File   10:APN 11:Network_Username  12:Network_Password
- (void)nbj_mqtt_modifyMQTT_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID {
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
        //LWT Topic
        self.dataModel.lwtTopic = text;
        self.sslParamsModel.lwtTopic = text;
        return;
    }
    if (textID == 4) {
        //LWT Payload
        self.dataModel.lwtPayload = text;
        self.sslParamsModel.lwtPayload = text;
        return;
    }
    if (textID == 5) {
        //sslHost
        self.dataModel.sslHost = text;
        self.sslParamsModel.sslHost = text;
        return;
    }
    if (textID == 6) {
        //sslPort
        self.dataModel.sslPort = text;
        self.sslParamsModel.sslPort = text;
        return;
    }
    if (textID == 7) {
        //CA File Path
        self.dataModel.caFilePath = text;
        self.sslParamsModel.caFilePath = text;
        return;
    }
    if (textID == 8) {
        //Client Key File
        self.dataModel.clientKeyPath = text;
        self.sslParamsModel.clientKeyPath = text;
        return;
    }
    if (textID == 9) {
        //Client Cert
        self.dataModel.clientCertPath = text;
        self.sslParamsModel.clientCertPath = text;
        return;
    }
    if (textID == 10) {
        //APN
        self.dataModel.apn = text;
        self.sslParamsModel.apn = text;
        return;
    }
    if (textID == 11) {
        //Network_Username
        self.dataModel.networkUsername = text;
        self.sslParamsModel.networkUsername = text;
        return;
    }
    if (textID == 12) {
        //Network_Password
        self.dataModel.networkPassword = text;
        self.sslParamsModel.networkPassword = text;
        return;
    }
}

- (void)nbj_mqtt_modifyMQTT_qosChanged:(NSInteger)qos qosID:(NSInteger)qosID{
    if (qosID == 0) {
        //Qos
        self.dataModel.qos = qos;
        self.sslParamsModel.qos = qos;
        return;
    }
    if (qosID == 1) {
        //LWT Qos
        self.dataModel.lwtQos = qos;
        self.sslParamsModel.lwtQos = qos;
        return;
    }
}

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_modifyMQTT_certificateChanged:(NSInteger)certificate {
    self.dataModel.certificate = certificate;
    self.sslParamsModel.certificate = certificate;
    //动态刷新footer
    [self setupSSLViewFrames];
    self.sslParamsView.dataModel = self.sslParamsModel;
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
- (void)nbj_mqtt_modifyMQTT_priorityChanged:(NSInteger)priority {
    self.dataModel.networkPriority = priority;
    self.sslParamsModel.networkPriority = priority;
}

#pragma mark - 入网
/*
 1、先发送更新的服务器信息、LWT、APN、网络制式给设备，设备接收到之后会处理相关逻辑，当设备上报3077的时候表明已经处理完毕。
 2、如果上报3077的通知里面的下载结果成功，则需要发送设备重入网指令给设备
 3、当重入网指令发送成功之后，直接跳转到设备列表页面(首页)
 */
- (void)updateMQTTServer {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel updateServerWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateLocal];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Set up failed!"];
    }];
}

- (void)updateLocal {
    [MKNBJDeviceListDatabaseManager updateClientID:self.dataModel.clientID
                                   subscribedTopic:[self.dataModel currentSubscribeTopic]
                                    publishedTopic:[self.dataModel currentPublishTopic]
                                        macAddress:self.dataModel.macAddress
                                          sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Set up succeed!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_nbj_deviceModifyMQTTServerSuccessNotification"
                                                            object:nil
                                                          userInfo:@{
            @"macAddress":self.dataModel.macAddress,
            @"clientID":self.dataModel.clientID,
            @"subscribedTopic":[self.dataModel currentSubscribeTopic],
            @"publishedTopic":[self.dataModel currentPublishTopic],
        }];
        [self performSelector:@selector(popAction) withObject:nil afterDelay:0.5f];
    }
                                       failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Set up failed!"];
    }];
}

- (void)popAction {
    [self popToViewControllerWithClassName:@"MKNBJDeviceListController"];
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
    self.sslParamsModel.caFilePath = self.dataModel.caFilePath;
    self.sslParamsModel.clientKeyPath = self.dataModel.clientKeyPath;
    self.sslParamsModel.clientCertPath = self.dataModel.clientCertPath;
    self.sslParamsModel.sslHost = self.dataModel.sslHost;
    self.sslParamsModel.sslPort = self.dataModel.sslPort;
    self.sslParamsModel.lwtStatus = self.dataModel.lwtStatus;
    self.sslParamsModel.lwtRetain = self.dataModel.lwtRetain;
    self.sslParamsModel.lwtQos = self.dataModel.lwtQos;
    self.sslParamsModel.lwtTopic = self.dataModel.lwtTopic;
    self.sslParamsModel.lwtPayload = self.dataModel.lwtPayload;
    
    //动态布局底部footer
    [self setupSSLViewFrames];
    
    self.sslParamsView.dataModel = self.sslParamsModel;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Modify Network and MQTT";
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJModifyServerController", @"nbj_saveIcon.png") forState:UIControlStateNormal];
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

- (MKNBJModifyServerModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJModifyServerModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)sectionHeaderList {
    if (!_sectionHeaderList) {
        _sectionHeaderList = [NSMutableArray array];
    }
    return _sectionHeaderList;
}

- (MKNBJModifyServerFooterView *)sslParamsView {
    if (!_sslParamsView) {
        _sslParamsView = [[MKNBJModifyServerFooterView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 380.f)];
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

- (MKNBJModifyServerFooterViewModel *)sslParamsModel {
    if (!_sslParamsModel) {
        _sslParamsModel = [[MKNBJModifyServerFooterViewModel alloc] init];
    }
    return _sslParamsModel;
}

@end
