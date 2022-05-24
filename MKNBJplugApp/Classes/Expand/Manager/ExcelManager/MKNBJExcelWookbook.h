//
//  MKNBJExcelWookbook.h
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/5/6.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKNBJExcelCell.h"
#import "MKNBJExcelSheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKNBJExcelWookbook : NSObject

@property(nonatomic,copy)NSString *wookbookName;//工作簿名

@property(nonatomic,strong)NSMutableArray <MKNBJExcelSheet *>*sheetArray;//工作表数组

/**
 初始化工作簿
 @param pathUrl 文件路径url
 @return 解析好的工作簿模型
 */
-(instancetype)initWithExcelFilePathUrl:(NSURL *)pathUrl;



/**
 根据工作表名获取工作表
 @param sheetName 工作表名
 @return 工作表
 */
-(MKNBJExcelSheet *)getSheetWithSheetName:(NSString *)sheetName;

@end

NS_ASSUME_NONNULL_END
