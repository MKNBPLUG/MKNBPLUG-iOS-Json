//
//  MKNBJServerForAppController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJServerForAppController.h"

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
#import "MKAlertController.h"
#import "MKCAFileSelectController.h"

#import "MKNBJMQTTServerManager.h"

#import "MKNBJExcelDataManager.h"

#import "MKNBJServerConfigAppFooterView.h"

#import "MKNBJServerForAppModel.h"

#import "MKNBJImportServerController.h"

@interface MKNBJServerForAppController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKNBJServerConfigAppFooterViewDelegate,
MKCAFileSelectControllerDelegate,
MKNBJImportServerControllerDelegate,
MFMailComposeViewControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *sectionHeaderList;

@property (nonatomic, strong)MKNBJServerForAppModel *dataModel;

@property (nonatomic, strong)MKNBJServerConfigAppFooterView *sslParamsView;

@property (nonatomic, strong)MKNBJServerConfigAppFooterViewModel *sslParamsModel;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)dispatch_source_t connectTimer;

@property (nonatomic, assign)NSInteger connectCount;

@end

@implementation MKNBJServerForAppController

- (void)dealloc {
    NSLog(@"MKNBJServerForAppController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)rightButtonMethod {
    NSString *errorMsg = [self.dataModel checkParams];
    if (ValidStr(errorMsg)) {
        [self.view showCentralToast:errorMsg];
        return;
    }
    [[MKNBJMQTTServerManager shared] saveServerParams:self.dataModel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverManagerStateChanged)
                                                 name:MKNBJMQTTSessionManagerStateChangedNotification
                                               object:nil];
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    self.leftButton.enabled = NO;
    [[MKNBJMQTTServerManager shared] connect];
}

- (void)leftButtonMethod {
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@""
                                                                       message:@"Please confirm whether to save the modified parameters?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [super leftButtonMethod];
    }];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self rightButtonMethod];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
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

#pragma mark - MKNBJServerConfigAppFooterViewDelegate
/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl
- (void)nbj_mqtt_serverForApp_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID {
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
}

- (void)nbj_mqtt_serverForApp_qosChanged:(NSInteger)qos {
    self.dataModel.qos = qos;
    self.sslParamsModel.qos = qos;
}

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password
- (void)nbj_mqtt_serverForApp_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID {
    if (textID == 0) {
        //keep alive
        self.dataModel.keepAlive = text;
        self.sslParamsModel.keepAlive = text;
        return;
    }
    if (textID == 1) {
        //user name
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
}

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_serverForApp_certificateChanged:(NSInteger)certificate {
    self.dataModel.certificate = certificate;
    self.sslParamsModel.certificate = certificate;
    //动态刷新footer
    [self setupSSLViewFrames];
    self.sslParamsView.dataModel = self.sslParamsModel;
}

/// 用户点击了证书相关按钮
/// @param fileType 0:caFaile   1:P12证书
- (void)nbj_mqtt_serverForApp_fileButtonPressed:(NSInteger)fileType {
    if (fileType == 0) {
        //caFaile
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_caCertSelPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (fileType == 1) {
        //P12证书
        MKCAFileSelectController *vc = [[MKCAFileSelectController alloc] init];
        vc.pageType = mk_clientP12CertPage;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

/// 底部按钮点击事件
/// @param index 0:Export Demo File   1:Import Config File
- (void)nbj_mqtt_serverForApp_bottomButtonPressed:(NSInteger)index {
    if (index == 0) {
        //Export Demo File
        [self exportServerConfig];
        return;
    }
    if (index == 1) {
        //Import Config File
        MKNBJImportServerController *vc = [[MKNBJImportServerController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
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
    if (certType == mk_clientP12CertPage) {
        //P12
        self.dataModel.clientFileName = certName;
        self.sslParamsModel.clientFileName = certName;
        
        //动态布局底部footer
        [self setupSSLViewFrames];
        
        self.sslParamsView.dataModel = self.sslParamsModel;
        return;
    }
}

#pragma mark - MKNBJImportServerControllerDelegate
- (void)nbj_selectedServerParams:(NSString *)fileName {
    [MKNBJExcelDataManager parseAppExcel:fileName
                                sucBlock:^(NSDictionary * _Nonnull returnData) {
        MKNBJServerForAppModel *model = [MKNBJServerForAppModel mk_modelWithJSON:returnData];
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
- (void)serverManagerStateChanged {
    if ([MKNBJMQTTServerManager shared].state == MKMQTTSessionManagerStateConnecting) {
        [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
        [self startReceiveTimer];
        self.leftButton.enabled = NO;
        return;
    }
    if ([MKNBJMQTTServerManager shared].state == MKMQTTSessionManagerStateConnected) {
        [self.view showCentralToast:@"Connect Success"];
        [[MKHudManager share] hide];
        self.leftButton.enabled = YES;
        if (self.connectTimer) {
            dispatch_cancel(self.connectTimer);
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MKNBJMQTTSessionManagerStateChangedNotification
                                                      object:nil];
        [self performSelector:@selector(backAction) withObject:nil afterDelay:0.5f];
        return;
    }
    if ([MKNBJMQTTServerManager shared].state == MKMQTTSessionManagerStateError) {
        [self connectFailed];
        return;
    }
}

#pragma mark - private method
- (void)exportServerConfig {
    NSString *errorMsg = [self.dataModel checkParams];
    if (ValidStr(errorMsg)) {
        [self.view showCentralToast:errorMsg];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKNBJExcelDataManager exportAppExcel:self.dataModel
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
    NSString *path = [documentPath stringByAppendingPathComponent:@"Settings for APP.xlsx"];
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
                           fileName:@"Settings for APP.xlsx"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connectFailed {
    [self.view showCentralToast:@"Connect Failed"];
    [[MKHudManager share] hide];
    self.leftButton.enabled = YES;
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MKNBJMQTTSessionManagerStateChangedNotification
                                                  object:nil];
}

- (void)startReceiveTimer{
    @weakify(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.connectTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.connectTimer, ^{
        @strongify(self);
        if (self.connectCount >= 20) {
            //连接超时
            self.connectCount = 0;
            dispatch_cancel(self.connectTimer);
            moko_dispatch_main_safe(^{
                [self connectFailed];
            });
            return ;
        }
        self.connectCount ++;
    });
    dispatch_resume(self.connectTimer);
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
    cellModel1.textPlaceholder = @"0-128 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.subscribeTopic;
    cellModel1.maxLength = 128;
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 4;
    cellModel2.msg = @"Publish";
    cellModel2.textPlaceholder = @"0-128 Characters";
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
    self.sslParamsModel.clientFileName = self.dataModel.clientFileName;
    
    //动态布局底部footer
    [self setupSSLViewFrames];
    
    self.sslParamsView.dataModel = self.sslParamsModel;
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Settings for APP";
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJServerForAppController", @"nbj_saveIcon.png") forState:UIControlStateNormal];
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
                                                       clientName:self.dataModel.clientFileName
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

- (MKNBJServerForAppModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJServerForAppModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray *)sectionHeaderList {
    if (!_sectionHeaderList) {
        _sectionHeaderList = [NSMutableArray array];
    }
    return _sectionHeaderList;
}

- (MKNBJServerConfigAppFooterView *)sslParamsView {
    if (!_sslParamsView) {
        _sslParamsView = [[MKNBJServerConfigAppFooterView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 230.f)];
        _sslParamsView.delegate = self;
    }
    return _sslParamsView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 300.f)];
        _footerView.backgroundColor = COLOR_WHITE_MACROS;
        [_footerView addSubview:self.sslParamsView];
    }
    return _footerView;
}

- (MKNBJServerConfigAppFooterViewModel *)sslParamsModel {
    if (!_sslParamsModel) {
        _sslParamsModel = [[MKNBJServerConfigAppFooterViewModel alloc] init];
    }
    return _sslParamsModel;
}

@end
