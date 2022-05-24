//
//  MKNBJDeviceListCell.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKNBJDeviceModel;

@protocol MKNBJDeviceListCellDelegate <NSObject>

/// 用户点击开关按钮
/// @param deviceModel deviceModel
- (void)nbj_deviceStateChanged:(MKNBJDeviceModel *)deviceModel;

/**
 删除
 
 @param index 所在index
 */
- (void)nbj_cellDeleteButtonPressed:(NSInteger)index;

@end

@interface MKNBJDeviceListCell : MKBaseCell

@property (nonatomic, strong)MKNBJDeviceModel *dataModel;

@property (nonatomic, weak)id <MKNBJDeviceListCellDelegate>delegate;

+ (MKNBJDeviceListCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
