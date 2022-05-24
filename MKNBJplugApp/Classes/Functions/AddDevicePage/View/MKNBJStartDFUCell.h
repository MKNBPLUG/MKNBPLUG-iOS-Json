//
//  MKNBJStartDFUCell.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/4/15.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJStartDFUCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKNBJStartDFUCellDelegate <NSObject>

- (void)nbj_startDfuButtonPressed;

@end

@interface MKNBJStartDFUCell : MKBaseCell

@property (nonatomic, strong)MKNBJStartDFUCellModel *dataModel;

@property (nonatomic, weak)id <MKNBJStartDFUCellDelegate>delegate;

+ (MKNBJStartDFUCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
