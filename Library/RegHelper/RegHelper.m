//
//  RegHelper.m
//  homework09_19
//
//  Created by 古玉彬 on 15/9/19.
//  Copyright (c) 2015年 guyubin. All rights reserved.
//

#import "RegHelper.h"

@implementation RegHelper

+ (NSArray *)regHelper:(NSString *)str andPattern:(NSString *)pattern;
{
    NSMutableArray * resultArray = [@[] mutableCopy];
    
    NSArray *rangeArray = [self arrayOfpatternStrWithPattern:pattern str:str];
    
    for(NSTextCheckingResult *res in rangeArray){
        //返回的是符合条件的范围。（res.range）
        NSString *m_str1 = [[NSString alloc ]initWithString:[str substringWithRange:res.range]];
        [resultArray addObject:m_str1];
    }
    return resultArray;
}


+ (NSString *)replaceGivenStr:(NSString *)givenStr withStr:(NSString *)newStr withPattern:(NSString *)pattern {
    
    NSMutableString * rtnStr = [givenStr mutableCopy];
    
    NSArray * resultArray = [self arrayOfpatternStrWithPattern:pattern str:givenStr];
    
    for (NSTextCheckingResult * res in resultArray) {
        
        [rtnStr replaceCharactersInRange:res.range withString:newStr];
    }
    
    return rtnStr;
}


/**
 *  返回符合条件的数组范围
 *
 *  @param pattern 正则语法
 *  @param str     需要匹配的字符串
 *
 *  @return 匹配字符串所在原数组的范围数组
 */

+ (NSArray *)arrayOfpatternStrWithPattern:(NSString *) pattern str:(NSString *)str {
    
    //转成oc语法
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * resultArray = [regular matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    return resultArray;
}
@end
