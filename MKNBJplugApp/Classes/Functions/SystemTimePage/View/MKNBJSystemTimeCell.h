//
//  MKNBJSystemTimeCell.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/12/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJSystemTimeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKNBJSystemTimeCellDelegate <NSObject>

- (void)nbj_systemTimeButtonPressed:(NSInteger)index;

@end

@interface MKNBJSystemTimeCell : MKBaseCell

@property (nonatomic, strong)MKNBJSystemTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKNBJSystemTimeCellDelegate>delegate;

+ (MKNBJSystemTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
