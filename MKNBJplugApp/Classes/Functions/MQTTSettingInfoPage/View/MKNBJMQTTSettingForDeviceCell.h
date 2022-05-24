//
//  MKNBJMQTTSettingForDeviceCell.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/27.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJMQTTSettingForDeviceCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *rightMsg;

- (CGFloat)fetchCellHeight;

@end

@interface MKNBJMQTTSettingForDeviceCell : MKBaseCell

@property (nonatomic, strong)MKNBJMQTTSettingForDeviceCellModel *dataModel;

+ (MKNBJMQTTSettingForDeviceCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
