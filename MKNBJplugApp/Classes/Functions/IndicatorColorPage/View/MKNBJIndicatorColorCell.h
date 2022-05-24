//
//  MKNBJIndicatorColorCell.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2021/10/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJIndicatorColorCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *placeholder;

@property (nonatomic, copy)NSString *textValue;

@property (nonatomic, assign)NSInteger index;

@end

@protocol MKNBJIndicatorColorCellDelegate <NSObject>

- (void)nbj_ledColorChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKNBJIndicatorColorCell : MKBaseCell

@property (nonatomic, strong)MKNBJIndicatorColorCellModel *dataModel;

@property (nonatomic, weak)id <MKNBJIndicatorColorCellDelegate>delegate;

+ (MKNBJIndicatorColorCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
