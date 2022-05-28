//
//  MKNBJModifyServerFooterView.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/6.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJModifyServerFooterView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKMQTTGeneralParamsView.h"
#import "MKMQTTUserCredentialsView.h"

#import "MKNBJModifyServerSSLView.h"
#import "MKNBJModifyServerSettingView.h"
#import "MKNBJModifyServerLWTView.h"

@implementation MKNBJModifyServerFooterViewModel
@end

static CGFloat const buttonWidth = 100.f;
static CGFloat const buttonHeight = 30.f;
static CGFloat const settingViewHeight = 200.f;
static CGFloat const defaultScrollViewHeight = 330.f;

@interface MKNBJModifyServerFooterView ()<UIScrollViewDelegate,
MKMQTTGeneralParamsViewDelegate,
MKMQTTUserCredentialsViewDelegate,
MKNBJModifyServerSSLViewDelegate,
MKNBJModifyServerSettingViewDelegate,
MKNBJModifyServerLWTViewDelegate>

@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UIButton *generalButton;

@property (nonatomic, strong)UIButton *credentialsButton;

@property (nonatomic, strong)UIButton *sslButton;

@property (nonatomic, strong)UIButton *lwtButton;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIView *containerView;

@property (nonatomic, strong)MKMQTTGeneralParamsView *generalView;

@property (nonatomic, strong)MKMQTTUserCredentialsView *credentialsView;

@property (nonatomic, strong)MKNBJModifyServerSSLView *sslView;

@property (nonatomic, strong)MKNBJModifyServerLWTView *lwtView;

@property (nonatomic, strong)MKNBJModifyServerSettingView *settingView;

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKNBJModifyServerFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40.f);
    }];
    CGFloat buttonWidth = (self.frame.size.width - 5 * 10.f) / 4;
    [self.generalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.topLineView.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.credentialsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.generalButton.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.generalButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.sslButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.credentialsButton.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.generalButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.lwtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.f);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.generalButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topLineView.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(self.settingView.mas_top);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView);       //水平滚动高度固定
    }];
    [self.generalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.containerView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(0);
    }];
    [self.credentialsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.containerView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(self.generalView.mas_right);
    }];
    [self.sslView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.containerView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(self.credentialsView.mas_right);
    }];
    [self.lwtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.containerView);
        make.width.equalTo(self.scrollView);
        make.left.mas_equalTo(self.sslView.mas_right);
    }];
    // 设置过渡视图的右距（此设置将影响到scrollView的contentSize）这个也是关键的一步
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lwtView.mas_right);
    }];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(settingViewHeight);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.index = scrollView.contentOffset.x / kViewWidth;
    [self loadButtonUI];
}

#pragma mark - MKMQTTGeneralParamsViewDelegate
- (void)mk_mqtt_generalParams_cleanSessionStatusChanged:(BOOL)isOn {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_switchStatusChanged:statusID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_switchStatusChanged:isOn statusID:0];
    }
}

- (void)mk_mqtt_generalParams_qosChanged:(NSInteger)qos {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_qosChanged:qosID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_qosChanged:qos qosID:0];
    }
}

- (void)mk_mqtt_generalParams_KeepAliveChanged:(NSString *)keepAlive {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:keepAlive textID:0];
    }
}

#pragma mark - MKMQTTUserCredentialsViewDelegate

- (void)mk_mqtt_userCredentials_userNameChanged:(NSString *)userName {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:userName textID:1];
    }
}

- (void)mk_mqtt_userCredentials_passwordChanged:(NSString *)password {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:password textID:2];
    }
}

#pragma mark - MKNBJModifyServerSSLViewDelegate
- (void)nbj_mqtt_sslParams_modifyDevice_sslStatusChanged:(BOOL)isOn {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_switchStatusChanged:statusID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_switchStatusChanged:isOn statusID:1];
    }
}

/// 用户选择了加密方式
/// @param certificate 0:CA certificate     1:Self signed certificates
- (void)nbj_mqtt_sslParams_modifyDevice_certificateChanged:(NSInteger)certificate {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_certificateChanged:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_certificateChanged:certificate];
    }
}

/// 用户输入事件
/// @param index 0:Host         1:Port         2:CA File Path     3:Client Key File           4:Client Cert  File
/// @param value value
- (void)nbj_mqtt_sslParams_modifyDevice_textFieldValueChanged:(NSInteger)index value:(NSString *)value {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:value textID:(index + 5)];
    }
}

#pragma mark - MKNBJModifyServerSettingViewDelegate
/// 输入框内容发生改变
/// @param text 当前输入框内容
/// @param textID 0:APN  1:UserName  2:Password
- (void)nbj_mqtt_modifyDevice_textChanged:(NSString *)text textID:(NSInteger)textID {
    if (textID == 0) {
        //APN
        if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
            [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:text textID:10];
        }
        return;
    }
    if (textID == 1) {
        //Network_Username
        if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
            [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:text textID:11];
        }
        return;
    }
    if (textID == 2) {
        //Network_Password
        if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
            [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:text textID:12];
        }
        return;
    }
}

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
- (void)nbj_mqtt_modifyDevice_networkPriorityChanged:(NSInteger)priority {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_priorityChanged:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_priorityChanged:priority];
    }
}

#pragma mark - MKNBJModifyServerLWTViewDelegate
- (void)nbj_lwt_modifyDevice_statusChanged:(BOOL)isOn {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_switchStatusChanged:statusID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_switchStatusChanged:isOn statusID:2];
    }
}

- (void)nbj_lwt_modifyDevice_retainChanged:(BOOL)isOn {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_switchStatusChanged:statusID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_switchStatusChanged:isOn statusID:3];
    }
}

- (void)nbj_lwt_modifyDevice_qosChanged:(NSInteger)qos {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_qosChanged:qosID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_qosChanged:qos qosID:1];
    }
}

- (void)nbj_lwt_modifyDevice_topicChanged:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:text textID:3];
    }
}

- (void)nbj_lwt_modifyDevice_payloadChanged:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(nbj_mqtt_modifyMQTT_textFieldValueChanged:textID:)]) {
        [self.delegate nbj_mqtt_modifyMQTT_textFieldValueChanged:text textID:4];
    }
}

#pragma mark - event method
- (void)generalButtonPressed {
    if (self.index == 0) {
        return;
    }
    self.index = 0;
    [self loadButtonUI];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)credentialsButtonPressed {
    if (self.index == 1) {
        return;
    }
    self.index = 1;
    [self loadButtonUI];
    [self.scrollView setContentOffset:CGPointMake(kViewWidth, 0) animated:YES];
}

- (void)sslButtonPressed {
    if (self.index == 2) {
        return;
    }
    self.index = 2;
    [self loadButtonUI];
    [self.scrollView setContentOffset:CGPointMake(2 * kViewWidth, 0) animated:YES];
}

- (void)lwtButtonPressed {
    if (self.index == 3) {
        return;
    }
    self.index = 3;
    [self loadButtonUI];
    [self.scrollView setContentOffset:CGPointMake(3 * kViewWidth, 0) animated:YES];
}

#pragma mark - public method
- (CGFloat)fetchHeightWithSSLStatus:(BOOL)isOn
                        certificate:(NSInteger)certificate {
    if (!isOn || certificate == 0) {
        //ssl关闭或者不需要证书
        return defaultScrollViewHeight + settingViewHeight;
    }
    if (certificate == 1) {
        //CA 证书
        return defaultScrollViewHeight + settingViewHeight + 35.f;
    }
    if (certificate == 2) {
        //CA证书和client key证书、client cert证书
        return defaultScrollViewHeight + settingViewHeight + 3 * 35.f;
    }
    return defaultScrollViewHeight + settingViewHeight;
}

#pragma mark - setter
- (void)setDataModel:(MKNBJModifyServerFooterViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNBJModifyServerFooterViewModel.class]) {
        return;
    }
    MKMQTTGeneralParamsViewModel *generalModel = [[MKMQTTGeneralParamsViewModel alloc] init];
    generalModel.clean = _dataModel.cleanSession;
    generalModel.qos = _dataModel.qos;
    generalModel.keepAlive = _dataModel.keepAlive;
    self.generalView.dataModel = generalModel;
    
    MKMQTTUserCredentialsViewModel *credentialsViewModel = [[MKMQTTUserCredentialsViewModel alloc] init];
    credentialsViewModel.userName = _dataModel.userName;
    credentialsViewModel.password = _dataModel.password;
    self.credentialsView.dataModel = credentialsViewModel;
    
    MKNBJModifyServerSSLViewModel *sslModel = [[MKNBJModifyServerSSLViewModel alloc] init];
    sslModel.sslIsOn = _dataModel.sslIsOn;
    sslModel.certificate = _dataModel.certificate;
    sslModel.caFilePath = _dataModel.caFilePath;
    sslModel.clientKeyPath = _dataModel.clientKeyPath;
    sslModel.sslHost = _dataModel.sslHost;
    sslModel.sslPort = _dataModel.sslPort;
    sslModel.clientCertPath = _dataModel.clientCertPath;
    self.sslView.dataModel = sslModel;
    
    MKNBJModifyServerLWTViewModel *lwtModel = [[MKNBJModifyServerLWTViewModel alloc] init];
    lwtModel.lwtStatus = _dataModel.lwtStatus;
    lwtModel.lwtRetain = _dataModel.lwtRetain;
    lwtModel.lwtQos = _dataModel.lwtQos;
    lwtModel.lwtTopic = _dataModel.lwtTopic;
    lwtModel.lwtPayload = _dataModel.lwtPayload;
    self.lwtView.dataModel = lwtModel;
    
    MKNBJModifyServerSettingViewModel *settingModel = [[MKNBJModifyServerSettingViewModel alloc] init];
    settingModel.apn = _dataModel.apn;
    settingModel.networkUsername = _dataModel.networkUsername;
    settingModel.networkPassword = _dataModel.networkPassword;
    settingModel.networkPriority = _dataModel.networkPriority;
    self.settingView.dataModel = settingModel;
    
    [self loadSubViews];
    [self setNeedsLayout];
}

#pragma mark - private method
- (void)loadButtonUI {
    if (self.index == 0) {
        [self.generalButton setTitleColor:NAVBAR_COLOR_MACROS forState:UIControlStateNormal];
        [self.credentialsButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.sslButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.lwtButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        return;
    }
    if (self.index == 1) {
        [self.generalButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.credentialsButton setTitleColor:NAVBAR_COLOR_MACROS forState:UIControlStateNormal];
        [self.sslButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.lwtButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        return;
    }
    if (self.index == 2) {
        [self.generalButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.credentialsButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.sslButton setTitleColor:NAVBAR_COLOR_MACROS forState:UIControlStateNormal];
        [self.lwtButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        return;
    }
    if (self.index == 3) {
        [self.generalButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.credentialsButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.sslButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self.lwtButton setTitleColor:NAVBAR_COLOR_MACROS forState:UIControlStateNormal];
        return;
    }
}

- (void)loadSubViews {
    if (self.topLineView.superview) {
        [self.topLineView removeFromSuperview];
    }
    if (self.generalButton.superview) {
        [self.generalButton removeFromSuperview];
    }
    if (self.credentialsButton.superview) {
        [self.credentialsButton removeFromSuperview];
    }
    if (self.sslButton.superview) {
        [self.sslButton removeFromSuperview];
    }
    if (self.lwtButton.superview) {
        [self.lwtButton removeFromSuperview];
    }
    if (self.scrollView.superview) {
        [self.scrollView removeFromSuperview];
    }
    if (self.containerView.superview) {
        [self.containerView removeFromSuperview];
    }
    if (self.generalView.superview) {
        [self.generalView removeFromSuperview];
    }
    if (self.credentialsView.superview) {
        [self.credentialsView removeFromSuperview];
    }
    if (self.sslView.superview) {
        [self.sslView removeFromSuperview];
    }
    if (self.lwtView) {
        [self.lwtView removeFromSuperview];
    }
    if (self.settingView.superview) {
        [self.settingView removeFromSuperview];
    }
    [self addSubview:self.topLineView];
    [self.topLineView addSubview:self.generalButton];
    [self.topLineView addSubview:self.credentialsButton];
    [self.topLineView addSubview:self.sslButton];
    [self.topLineView addSubview:self.lwtButton];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.generalView];
    [self.containerView addSubview:self.credentialsView];
    [self.containerView addSubview:self.sslView];
    [self.containerView addSubview:self.lwtView];
    [self addSubview:self.settingView];
}

#pragma mark - getter
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _topLineView;
}

- (UIButton *)generalButton {
    if (!_generalButton) {
        _generalButton = [self loadButtonWithTitle:@"General" action:@selector(generalButtonPressed)];
        [_generalButton setTitleColor:NAVBAR_COLOR_MACROS forState:UIControlStateNormal];
    }
    return _generalButton;
}

- (MKMQTTGeneralParamsView *)generalView {
    if (!_generalView) {
        _generalView = [[MKMQTTGeneralParamsView alloc] init];
        _generalView.delegate = self;
    }
    return _generalView;
}

- (UIButton *)credentialsButton {
    if (!_credentialsButton) {
        _credentialsButton = [self loadButtonWithTitle:@"Credentials" action:@selector(credentialsButtonPressed)];
    }
    return _credentialsButton;
}

- (MKMQTTUserCredentialsView *)credentialsView {
    if (!_credentialsView) {
        _credentialsView = [[MKMQTTUserCredentialsView alloc] init];
        _credentialsView.delegate = self;
    }
    return _credentialsView;
}

- (UIButton *)sslButton {
    if (!_sslButton) {
        _sslButton = [self loadButtonWithTitle:@"SSL/TLS" action:@selector(sslButtonPressed)];
    }
    return _sslButton;
}

- (MKNBJModifyServerSSLView *)sslView {
    if (!_sslView) {
        _sslView = [[MKNBJModifyServerSSLView alloc] init];
        _sslView.delegate = self;
    }
    return _sslView;
}

- (UIButton *)lwtButton {
    if (!_lwtButton) {
        _lwtButton = [self loadButtonWithTitle:@"LWT" action:@selector(lwtButtonPressed)];
    }
    return _lwtButton;
}

- (MKNBJModifyServerLWTView *)lwtView {
    if (!_lwtView) {
        _lwtView = [[MKNBJModifyServerLWTView alloc] init];
        _lwtView.delegate = self;
    }
    return _lwtView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (MKNBJModifyServerSettingView *)settingView {
    if (!_settingView) {
        _settingView = [[MKNBJModifyServerSettingView alloc] init];
        _settingView.delegate = self;
    }
    return _settingView;
}

- (UIButton *)loadButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    [button.titleLabel setFont:MKFont(12.f)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
