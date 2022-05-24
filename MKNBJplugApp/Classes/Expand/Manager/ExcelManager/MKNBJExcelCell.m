//
//  MKNBJExcelCell.m
//  MKNBJplugApp_Example
//
//  Created by aa on 2022/5/6.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKNBJExcelCell.h"

@implementation MKNBJExcelCell

-(void)setCellDic:(NSDictionary *)cellDic
{
    _cellDic = cellDic;
    
    [self refreshData];
    
}


-(void)setMergeCellColumAndRowStr:(NSString *)mergeCellColumAndRowStr
{
    _mergeCellColumAndRowStr = mergeCellColumAndRowStr;
    
    if(mergeCellColumAndRowStr && [mergeCellColumAndRowStr isKindOfClass:[NSString class]] &&mergeCellColumAndRowStr.length > 0)
    {
        self.cellIsMerge = YES;
        
        NSString *rowStr = [MKNBJExcelCell getNumberFromStr:mergeCellColumAndRowStr];
        
        self.mergeRow = [rowStr integerValue];
        
        NSString *column = [MKNBJExcelCell getLetterFromStr:mergeCellColumAndRowStr];
        
        self.mergeColumn = column;
    }
}


-(void)refreshData
{
    NSDictionary *v = [self.cellDic objectForKey:@"v"];
    
    //解析下标
    if(v && [v isKindOfClass:[NSDictionary class]])
    {
        self.stringValueIndex = [[v objectForKey:@"text"] integerValue];
        
        self.indexAnalysisSuccess = YES;
    }
    
    NSString *r = [self.cellDic objectForKey:@"r"];
    
    NSString *rowStr = [MKNBJExcelCell getNumberFromStr:r];
    
    self.row = [rowStr integerValue];
    
    NSString *column = [MKNBJExcelCell getLetterFromStr:r];
    
    self.column = column;
}


-(void)setStringValue:(NSString *)stringValue
{
    if(self.indexAnalysisSuccess)
    {
        _stringValue = stringValue;
    }
}


/**
 获取字符串内数字
 */
+(NSString *)getNumberFromStr:(NSString *)str
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}



/**
 获取字符串内字母
 */
+(NSString *)getLetterFromStr:(NSString *)str
{
    NSString *numStr = [self getNumberFromStr:str];
    
    NSString *letterStr = [str substringWithRange:NSMakeRange(0, str.length - numStr.length)];
    
    return letterStr;
    
}

@end
