//
//  MKNBJScanPageCell.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKNBJScanPageModel;
@interface MKNBJScanPageCell : MKBaseCell

@property (nonatomic, strong)MKNBJScanPageModel *dataModel;

+ (MKNBJScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
