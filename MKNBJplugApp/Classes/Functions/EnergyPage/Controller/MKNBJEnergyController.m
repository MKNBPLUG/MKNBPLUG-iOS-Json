//
//  MKNBJEnergyController.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/3/28.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJEnergyController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UISegmentedControl+MKAdd.h"

#import "MKHudManager.h"
#import "MKAlertView.h"

#import "MKNBJEnergyModel.h"

#import "MKNBJEnergyHourlyView.h"
#import "MKNBJEnergyDailyView.h"
#import "MKNBJEnergyTotalView.h"

static CGFloat const segmentWidth = 240.f;
static CGFloat const segmentHeight = 30.f;

#define segmentOffset_Y (defaultTopInset + 20.f)
#define tableViewOffset_Y (segmentOffset_Y + segmentHeight + 5.f)
#define tableViewHeight (kViewHeight - VirtualHomeHeight - tableViewOffset_Y - 49.f)

@interface MKNBJEnergyController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UISegmentedControl *segment;

@property (nonatomic, strong)MKNBJEnergyHourlyView *hourView;

@property (nonatomic, strong)MKNBJEnergyDailyView *dailyView;

@property (nonatomic, strong)MKNBJEnergyTotalView *totalView;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)MKNBJEnergyModel *dataModel;

@property (nonatomic, assign)BOOL isScrolling;

@end

@implementation MKNBJEnergyController

- (void)dealloc {
    NSLog(@"MKNBJEnergyController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method

- (void)rightButtonMethod {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self clearAllEnergyDatas];
    }];
    NSString *msg = @"After reset, all energy data will be deleted, please confirm again whether to reset it？";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Reset Energy Data" message:msg notificationName:@"mk_nbj_needDismissAlert"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isScrolling) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / kViewWidth;
    if (index == self.segment.selectedSegmentIndex) {
        return;
    }
    [self.segment setSelectedSegmentIndex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.isScrolling = NO;
}

#pragma mark - event method
- (void)segmentValueChanged {
    NSInteger index = self.scrollView.contentOffset.x / kViewWidth;
    if (index == self.segment.selectedSegmentIndex) {
        return;
    }
    self.isScrolling = YES;
    [self.scrollView setContentOffset:CGPointMake(self.segment.selectedSegmentIndex * kViewWidth, 0) animated:YES];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateViewState];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)clearAllEnergyDatas {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel clearEnergyDatasWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self readDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)updateViewState {
    [self.hourView updateHourlyDatas:self.dataModel.hourlyDic];
    [self.dailyView updateDailyDatas:self.dataModel.dailyDic];
    [self.totalView updateTotalEnergy:self.dataModel.totalEnergy];
}

- (void)loadSubViews {
    self.defaultTitle = self.dataModel.deviceName;
    [self.rightButton setImage:LOADICON(@"MKNBJplugApp", @"MKNBJEnergyController", @"nbj_deleteIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.segment];
    [self.segment setFrame:CGRectMake((kViewWidth - segmentWidth) / 2, segmentOffset_Y, segmentWidth, segmentHeight)];
    [self.view addSubview:self.scrollView];
    [self.scrollView setFrame:CGRectMake(0, tableViewOffset_Y, kViewWidth, tableViewHeight)];
    [self.scrollView addSubview:self.hourView];
    [self.hourView setFrame:CGRectMake(0, 0, kViewWidth, tableViewHeight)];
    [self.scrollView addSubview:self.dailyView];
    [self.dailyView setFrame:CGRectMake(kViewWidth, 0, kViewWidth, tableViewHeight)];
    [self.scrollView addSubview:self.totalView];
    [self.totalView setFrame:CGRectMake(2 * kViewWidth, 0, kViewWidth, tableViewHeight)];
}

#pragma mark - getter
- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"Hourly",@"Daily",@"Total"]];
        [_segment mk_setTintColor:NAVBAR_COLOR_MACROS];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self
                     action:@selector(segmentValueChanged)
           forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(3 * kViewWidth, 0);
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (MKNBJEnergyHourlyView *)hourView {
    if (!_hourView) {
        _hourView = [[MKNBJEnergyHourlyView alloc] init];
    }
    return _hourView;
}

- (MKNBJEnergyDailyView *)dailyView {
    if (!_dailyView) {
        _dailyView = [[MKNBJEnergyDailyView alloc] init];
    }
    return _dailyView;
}

- (MKNBJEnergyTotalView *)totalView {
    if (!_totalView) {
        _totalView = [[MKNBJEnergyTotalView alloc] init];
    }
    return _totalView;
}

- (MKNBJEnergyModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKNBJEnergyModel alloc] init];
    }
    return _dataModel;
}

@end
