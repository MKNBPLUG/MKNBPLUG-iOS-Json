//
//  MKNBJDebuggerController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJDebuggerController.h"

#import <MessageUI/MessageUI.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKAlertController.h"
#import "MKHudManager.h"

#import "MKNBJLogDatabaseManager.h"

#import "MKNBJCentralManager.h"
#import "MKNBJInterface+MKNBJConfig.h"

#import "MKNBJDebuggerButton.h"
#import "MKNBJDebuggerCell.h"

@interface MKNBJDebuggerController ()<UITableViewDelegate,
UITableViewDataSource,
MFMailComposeViewControllerDelegate,
mk_nbj_centralManagerLogDelegate,
MKNBJDebuggerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)NSMutableArray *contentList;

@property (nonatomic, strong)UIButton *startButton;

@property (nonatomic, strong)UIImageView *syncIcon;

@property (nonatomic, strong)MKNBJDebuggerButton *deleteButton;

@property (nonatomic, strong)MKNBJDebuggerButton *exportButton;

@property (nonatomic, assign)BOOL isLoading;

@property (nonatomic, strong)NSDateFormatter *formatter;

@property (nonatomic, strong)NSString *logStartTime;

/// 用户是否是点击了返回按钮
@property (nonatomic, assign)BOOL leftAction;

@property (nonatomic, strong)UIButton *exitButton;

/// 用户是否选择了退出debug模式
@property (nonatomic, assign)BOOL exitDebug;

@end

@implementation MKNBJDebuggerController

- (void)dealloc {
    NSLog(@"MKNBJDebuggerController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKNBJCentralManager shared] disconnect];
        if (self.exitDebug && self.deviceExitDebugModeBlock) {
            self.deviceExitDebugModeBlock();
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [MKNBJCentralManager shared].logDelegate = self;
    [self readDataFromLocal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceDisconnect)
                                                 name:mk_nbj_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    //当前设备正常连接，返回上一级页面
    self.leftAction = YES;
    [[MKNBJCentralManager shared] notifyLogData:NO];
    if (self.contentList.count > 0) {
        //将当前contentList数据保存到本地
        [self saveConteneDatas];
    }else {
        //当前没有需要保存的数据，则直接返回
        [super leftButtonMethod];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNBJDebuggerCell *cell = [MKNBJDebuggerCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
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

#pragma mark - mk_nbj_centralManagerLogDelegate
- (void)mk_nbj_receiveLog:(NSString *)deviceLog {
    if (!self.isLoading || !ValidStr(deviceLog)) {
        //没有加载数据，则不接收
        return;
    }
    self.textView.text = [self.textView.text stringByAppendingString:deviceLog];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    [self.contentList addObject:deviceLog];
}

#pragma mark - MKNBJDebuggerCellDelegate
- (void)nbj_debuggerCellSelectedChanged:(NSInteger)index selected:(BOOL)selected {
    if (self.isLoading) {
        //正在加载，不允许操作
        [self.tableView reloadData];
        return;
    }
    MKNBJDebuggerCellModel *cellModel = self.dataList[index];
    cellModel.selected = selected;
    [self updateTopButtonState];
}

#pragma mark - note
- (void)deviceDisconnect {
    //设备断开连接
    self.startButton.selected = NO;
    [self.syncIcon.layer removeAnimationForKey:@"mk_nbj_syncAnimation"];
    self.isLoading = NO;
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    [[MKNBJCentralManager shared] notifyLogData:NO];
    if (self.contentList.count > 0) {
        //将当前contentList数据保存到本地
        [self saveConteneDatas];
        return;
    }
    [super leftButtonMethod];
}

#pragma mark - event method
- (void)startButtonPressed {
    if (self.dataList.count >= 10) {
        [self showTipsAlert:@"Up to 10 log files can be stored, please delete the useless logs first!"];
        return;
    }
    if ([MKNBJCentralManager shared].connectStatus != mk_nbj_centralConnectStatusConnected) {
        [self showTipsAlert:@"The device is disconnected."];
        return;
    }
    self.startButton.selected = !self.startButton.selected;
    [self.syncIcon.layer removeAnimationForKey:@"mk_nbj_syncAnimation"];
    self.isLoading = self.startButton.selected;
    if (!self.startButton.selected) {
        //停止
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [[MKNBJCentralManager shared] notifyLogData:NO];
        //将当前contentList数据保存到本地
        [self saveConteneDatas];
        return;
    }
    //开始监听
    self.textView.text = @"";
    self.logStartTime = [self.formatter stringFromDate:[NSDate date]];
    self.deleteButton.enabled = NO;
    self.exportButton.enabled = NO;
    self.deleteButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_delete_disableIcon.png");
    self.exportButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_export_disableIcon.png");
    [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.contentList removeAllObjects];
    [[MKNBJCentralManager shared] notifyLogData:YES];
    [self.syncIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:1.f]
                               forKey:@"mk_nbj_syncAnimation"];
}

- (void)deleteButtonPressed {
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@""
                                                                       message:@"Please confirm whether to delete the files?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_nbj_needDismissAlert";
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteLogDatas];
    }];
    [alertView addAction:confirmAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
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
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDebuggerCellModel *cellModel = self.dataList[i];
        if (cellModel.selected) {
            //选中要发送的数据
            NSString *stringToWrite = cellModel.logInfo;
            NSData *stringData = [stringToWrite dataUsingEncoding:NSUTF8StringEncoding];
            NSString *fileName = [NSString stringWithFormat:@"%@ %@.txt",self.macAddress,cellModel.timeMsg];
            [mailComposer addAttachmentData:stringData
                                   mimeType:@"application/txt"
                                   fileName:fileName];
        }
    }
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)exitButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKNBJInterface nbj_exitDebugModeWithSucBlock:^{
        [[MKHudManager share] hide];
        self.exitDebug = YES;
        [self leftButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)readDataFromLocal {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKNBJLogDatabaseManager readLocalLogsWithMacAddress:self.macAddress sucBlock:^(NSArray<NSDictionary *> * _Nonnull logList) {
        [[MKHudManager share] hide];
        [self loadTableViewDatas:logList];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadTableViewDatas:(NSArray *)logList {
    NSMutableArray *tempDataList = [NSMutableArray array];
    for (NSInteger i = 0; i < logList.count; i ++) {
        NSDictionary *dic = logList[i];
        MKNBJDebuggerCellModel *cellModel = [[MKNBJDebuggerCellModel alloc] init];
        cellModel.index = logList.count - 1 - i;
        cellModel.logInfo = dic[@"logDetails"];
        cellModel.timeMsg = dic[@"date"];
        [tempDataList addObject:cellModel];
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeMsg" ascending:NO];
    NSArray *tempArray = [tempDataList sortedArrayUsingDescriptors:@[descriptor]];
    [self.dataList addObjectsFromArray:tempArray];
    
    [self.tableView reloadData];
}

- (void)saveConteneDatas {
    if (self.contentList.count == 0) {
        [self showTipsAlert:@"No debug logs are sent during this process!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    NSString *text = @"";
    for (NSInteger i = 0; i < self.contentList.count; i ++) {
        NSString *tempString = [NSString stringWithFormat:@"\n%@",self.contentList[i]];
        text = [text stringByAppendingString:tempString];
    }
    MKNBJDebuggerCellModel *cellModel = [[MKNBJDebuggerCellModel alloc] init];
    cellModel.selected = NO;
    cellModel.logInfo = text;
    cellModel.timeMsg = self.logStartTime;
    if (self.dataList.count == 0) {
        cellModel.index = 0;
        [self.dataList addObject:cellModel];
    }else {
        [self.dataList insertObject:cellModel atIndex:0];
        NSMutableArray *tempList = [NSMutableArray arrayWithArray:self.dataList];
        [self.dataList removeAllObjects];
        for (NSInteger i = 0; i < tempList.count; i ++) {
            MKNBJDebuggerCellModel *tempModel = tempList[i];
            tempModel.index = i;
            [self.dataList addObject:tempModel];
        }
    }
    
    [self saveDataListToLocal];
    [self.contentList removeAllObjects];
}

- (void)saveDataListToLocal {
    NSMutableArray *tempList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKNBJDebuggerCellModel *cellModel = self.dataList[i];
        NSDictionary *dic = @{
            @"date":cellModel.timeMsg,
            @"logDetails":cellModel.logInfo,
        };
        [tempList addObject:dic];
    }
    [MKNBJLogDatabaseManager insertLogDatas:tempList macAddress:self.macAddress sucBlock:^{
        [[MKHudManager share] hide];
        if (self.leftAction || [MKNBJCentralManager shared].connectStatus != mk_nbj_centralConnectStatusConnected) {
            //用户点击返回按钮，由于有未保存的数据，所以走数据保存流程，保存成功才会返回上一级页面
            //设备断开连接
            [super leftButtonMethod];
            return;
        }else {
            [self updateTopButtonState];
            [self.tableView reloadData];
        }
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateTopButtonState {
    BOOL enable = NO;
    for (MKNBJDebuggerCellModel *cellModel in self.dataList) {
        if (cellModel.selected) {
            enable = YES;
            break;
        }
    }
    self.deleteButton.enabled = enable;
    self.exportButton.enabled = enable;
    if (enable) {
        //选中了，可以删除或者导出
        self.deleteButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_delete_enableIcon.png");
        self.exportButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_export_enableIcon.png");
        return;
    }
    //不存在选中的
    self.deleteButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_delete_disableIcon.png");
    self.exportButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_export_disableIcon.png");
}

- (void)deleteLogDatas {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKNBJLogDatabaseManager deleteDatasWithMacAddress:self.macAddress sucBlock:^{
        NSMutableArray *tempList = [NSMutableArray array];
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            MKNBJDebuggerCellModel *cellModel = self.dataList[i];
            if (!cellModel.selected) {
                //未选中的就是保留的
                cellModel.index = tempList.count;
                [tempList addObject:cellModel];
            }
        }
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:tempList];
        [self saveDataListToLocal];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)showTipsAlert:(NSString *)msg {
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Tips!"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_nbj_needDismissAlert";
    
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Debug Mode";
    UIView *headerView = [self tableHeaderView];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(defaultTopInset);
        make.height.mas_equalTo(90.f);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(250.f);
    }];
    [self.view addSubview:self.exitButton];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 20.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(self.exitButton.mas_top).mas_offset(-10.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _tableView.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _tableView.layer.cornerRadius = 5.f;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = COLOR_WHITE_MACROS;
        _textView.font = MKFont(13.f);
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.editable = NO;
        _textView.textColor = DEFAULT_TEXT_COLOR;
    }
    return _textView;
}

- (NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray array];
    }
    return _contentList;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [MKCustomUIAdopter customButtonWithTitle:@"Start"
                                                         target:self
                                                         action:@selector(startButtonPressed)];
    }
    return _startButton;
}

- (UIImageView *)syncIcon {
    if (!_syncIcon) {
        _syncIcon = [[UIImageView alloc] init];
        _syncIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_sync_disableIcon.png");
    }
    return _syncIcon;
}

- (MKNBJDebuggerButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[MKNBJDebuggerButton alloc] init];
        _deleteButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_delete_disableIcon.png");
        _deleteButton.msgLabel.text = @"Delete";
        _deleteButton.enabled = NO;
        [_deleteButton addTarget:self
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (MKNBJDebuggerButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [[MKNBJDebuggerButton alloc] init];
        _exportButton.topIcon.image = LOADICON(@"MKNBJplugApp", @"MKNBJDebuggerController", @"nbj_export_disableIcon.png");
        _exportButton.msgLabel.text = @"Export";
        _exportButton.enabled = NO;
        [_exportButton addTarget:self
                          action:@selector(exportButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    }
    return _formatter;
}

- (UIView *)tableHeaderView {
    CGFloat headerViewHeight = 90.f;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, headerViewHeight)];
    tableHeaderView.backgroundColor = COLOR_WHITE_MACROS;
    
    CGFloat buttonIconWidth = 70.f;
    CGFloat buttonIconHeight = 45.f;
    
    [tableHeaderView addSubview:self.startButton];
    [self.startButton setFrame: CGRectMake(20.f, (headerViewHeight - 40.f) / 2, 80.f, 40.f)];
    
    [tableHeaderView addSubview:self.syncIcon];
    [self.syncIcon setFrame:CGRectMake(20.f + 80.f + 20.f, (headerViewHeight - 25.f) / 2, 25.f, 25.f)];
    
    [tableHeaderView addSubview:self.deleteButton];
    [self.deleteButton setFrame:CGRectMake(20.f + 80.f + 20.f + 25.f + 20.f, (headerViewHeight - buttonIconHeight) / 2, buttonIconWidth, buttonIconHeight)];
    
    [tableHeaderView addSubview:self.exportButton];
    [self.exportButton setFrame:CGRectMake(20.f + 80.f + 20.f + 25.f + 20.f + buttonIconHeight + 20.f, (headerViewHeight - buttonIconHeight) / 2, buttonIconWidth, buttonIconHeight)];
    
    return tableHeaderView;
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [MKCustomUIAdopter customButtonWithTitle:@"Exit debug mode"
                                                        target:self
                                                        action:@selector(exitButtonPressed)];
    }
    return _exitButton;
}

@end
