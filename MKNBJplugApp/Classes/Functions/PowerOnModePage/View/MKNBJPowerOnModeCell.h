//
//  MKNBJPowerOnModeCell.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJPowerOnModeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@interface MKNBJPowerOnModeCell : MKBaseCell

@property (nonatomic, strong)MKNBJPowerOnModeCellModel *dataModel;

+ (MKNBJPowerOnModeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
