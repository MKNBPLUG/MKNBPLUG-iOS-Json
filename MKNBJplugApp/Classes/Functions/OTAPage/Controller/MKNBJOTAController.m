//
//  MKNBJOTAController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJOTAController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKTextFieldCell.h"
#import "MKPickerView.h"

#import "MKNBJOTADataModel.h"

@interface MKNBJOTAController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *firmwareList;

@property (nonatomic, strong)NSMutableArray *caCertificateList;

@property (nonatomic, strong)NSMutableArray *signedCertificateList;

@property (nonatomic, strong)MKNBJOTADataModel *dataModel;

@property (nonatomic, strong)UIButton *typeButton;

@end

@implementation MKNBJOTAController

- (void)dealloc {
    NSLog(@"MKNBJOTAController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataModel.type == 0) {
        //Firmware
        return self.firmwareList.count;
    }
    if (self.dataModel.type == 1) {
        //CA certificate
        return self.caCertificateList.count;
    }
    if (self.dataModel.type == 2) {
        //Self signed server certificates
        return self.signedCertificateList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataModel.type == 0) {
        //Firmware
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.firmwareList[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.type == 1) {
        //CA certificate
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.caCertificateList[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    //Self signed server certificates
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.signedCertificateList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Firmware
        //Host
        self.dataModel.firmwareModel.host = value;
        MKTextFieldCellModel *cellModel = self.firmwareList[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Firmware
        //Port
        self.dataModel.firmwareModel.port = value;
        MKTextFieldCellModel *cellModel = self.firmwareList[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //Firmware
        //File Path
        self.dataModel.firmwareModel.filePath = value;
        MKTextFieldCellModel *cellModel = self.firmwareList[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //CA certificate
        //Host
        self.dataModel.caFileModel.host = value;
        MKTextFieldCellModel *cellModel = self.caCertificateList[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 4) {
        //CA certificate
        //Port
        self.dataModel.caFileModel.port = value;
        MKTextFieldCellModel *cellModel = self.caCertificateList[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 5) {
        //CA certificate
        //CA File Path
        self.dataModel.caFileModel.filePath = value;
        MKTextFieldCellModel *cellModel = self.caCertificateList[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 6) {
        //Self signed server certificates
        //Host
        self.dataModel.signedModel.host = value;
        MKTextFieldCellModel *cellModel = self.signedCertificateList[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 7) {
        //Self signed server certificates
        //Port
        self.dataModel.signedModel.port = value;
        MKTextFieldCellModel *cellModel = self.signedCertificateList[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 8) {
        //Self signed server certificates
        //CA File Path
        self.dataModel.signedModel.caFilePath = value;
        MKTextFieldCellModel *cellModel = self.signedCertificateList[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 9) {
        //Self signed server certificates
        //Client Key file
        self.dataModel.signedModel.clientKeyPath = value;
        MKTextFieldCellModel *cellModel = self.signedCertificateList[3];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 10) {
        //Self signed server certificates
        //Client Cert file
        self.dataModel.signedModel.clientCertPath = value;
        MKTextFieldCellModel *cellModel = self.signedCertificateList[4];
        cellModel.textFieldValue = value;
        return;
    }
}
 
#pragma mark - event method
- (void)typeButtonPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
    NSArray *typeList = @[@"Firmware",@"CA certificate",@"Self signed server certificates"];
    NSInteger index = 0;
    for (NSInteger i = 0; i < typeList.count; i ++) {
        if ([self.typeButton.titleLabel.text isEqualToString:typeList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:typeList selectedRow:index block:^(NSInteger currentRow) {
        [self.typeButton setTitle:typeList[currentRow] forState:UIControlStateNormal];
        self.dataModel.type = currentRow;
        [self.tableView reloadData];
    }];
}

- (void)startButtonPressed {
    @weakify(self);
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    self.leftButton.enabled = NO;
    [self.dataModel startUpdateWithSucBlock:^{
        @strongify(self);
        self.leftButton.enabled = YES;
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Update Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        self.leftButton.enabled = YES;
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadfirmwareDatas];
    [self loadCACertificateDatas];
    [self loadSignedCertificateDatas];
    
    [self.tableView reloadData];
}

- (void)loadfirmwareDatas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Host";
    cellModel1.textPlaceholder = @"1-64 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.maxLength = 64;
    [self.firmwareList addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Port";
    cellModel2.textPlaceholder = @"1-65535";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 5;
    [self.firmwareList addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"File Path";
    cellModel3.textPlaceholder = @"1-128 Characters";
    cellModel3.textFieldType = mk_normal;
    cellModel3.maxLength = 128;
    [self.firmwareList addObject:cellModel3];
}

- (void)loadCACertificateDatas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 3;
    cellModel1.msg = @"Host";
    cellModel1.textPlaceholder = @"1-64 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.maxLength = 64;
    [self.caCertificateList addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 4;
    cellModel2.msg = @"Port";
    cellModel2.textPlaceholder = @"1-65535";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 5;
    [self.caCertificateList addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 5;
    cellModel3.msg = @"CA File Path";
    cellModel3.textPlaceholder = @"1-128 Characters";
    cellModel3.textFieldType = mk_normal;
    cellModel3.maxLength = 128;
    [self.caCertificateList addObject:cellModel3];
}

- (void)loadSignedCertificateDatas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 6;
    cellModel1.msg = @"Host";
    cellModel1.textPlaceholder = @"1-64 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.maxLength = 64;
    [self.signedCertificateList addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 7;
    cellModel2.msg = @"Port";
    cellModel2.textPlaceholder = @"1-65535";
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.maxLength = 5;
    [self.signedCertificateList addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 8;
    cellModel3.msg = @"CA File Path";
    cellModel3.textPlaceholder = @"1-128 Characters";
    cellModel3.textFieldType = mk_normal;
    cellModel3.maxLength = 128;
    [self.signedCertificateList addObject:cellModel3];
    
    MKTextFieldCellModel *cellModel4 = [[MKTextFieldCellModel alloc] init];
    cellModel4.index = 9;
    cellModel4.msg = @"Client Key file";
    cellModel4.textPlaceholder = @"1-128 Characters";
    cellModel4.textFieldType = mk_normal;
    cellModel4.maxLength = 128;
    [self.signedCertificateList addObject:cellModel4];
    
    MKTextFieldCellModel *cellModel5 = [[MKTextFieldCellModel alloc] init];
    cellModel5.index = 10;
    cellModel5.msg = @"Client Cert file";
    cellModel5.textPlaceholder = @"1-128 Characters";
    cellModel5.textFieldType = mk_normal;
    cellModel5.maxLength = 128;
    [self.signedCertificateList addObject:cellModel5];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"OTA";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self headerView];
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
}

- (NSMutableArray *)firmwareList {
    if (!_firmwareList) {
        _firmwareList = [NSMutableArray array];
    }
    return _firmwareList;
}

- (NSMutableArray *)caCertificateList {
    if (!_caCertificateList) {
        _caCertificateList = [NSMutableArray array];
    }
    return _caCertificateList;
}

- (NSMutableArray *)signedCertificateList {
    if (!_signedCertificateList) {
        _signedCertificateList = [NSMutableArray array];
    }
    return _signedCertificateList;
}

- (MKNBJOTADataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJOTADataModel alloc] init];
    }
    return _dataModel;
}

- (UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [MKCustomUIAdopter customButtonWithTitle:@"Firmware"
                                                        target:self
                                                        action:@selector(typeButtonPressed)];
    }
    return _typeButton;
}

- (UIView *)headerView {
    CGFloat viewHeight = 90.f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, viewHeight)];
    headerView.backgroundColor = COLOR_WHITE_MACROS;
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (viewHeight - MKFont(15.f).lineHeight) / 2, 120.f, MKFont(15.f).lineHeight)];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = MKFont(15.f);
    msgLabel.text = @"Type";
    [headerView addSubview:msgLabel];
    
    self.typeButton.frame = CGRectMake(15.f + 120.f + 15.f, (viewHeight - 35.f) / 2, kViewWidth - 3 * 15.f - 120.f, 35.f);
    [headerView addSubview:self.typeButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.f, viewHeight - CUTTING_LINE_HEIGHT, kViewWidth - 2 * 15.f, CUTTING_LINE_HEIGHT)];
    lineView.backgroundColor = CUTTING_LINE_COLOR;
    [headerView addSubview:lineView];
    
    return headerView;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
    footerView.backgroundColor = COLOR_WHITE_MACROS;
    
    UIButton *startButton = [MKCustomUIAdopter customButtonWithTitle:@"Start Update"
                                                              target:self
                                                              action:@selector(startButtonPressed)];
    startButton.frame = CGRectMake(30.f, 30.f, kViewWidth - 2 * 30.f, 40.f);
    [footerView addSubview:startButton];
    
    return footerView;
}

@end
