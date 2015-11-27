//
//  SearchResultViewController.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/27.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "BasicViewController.h"

@interface SearchResultViewController : BasicViewController


/**
 *  搜索词组合
 */
@property (nonatomic, copy) NSArray * keysArray;

/**
 *  搜索关键字
 */
@property (nonatomic, copy) NSString * orderName;

/**
 *  搜索结果数据源
 */
@property (nonatomic, strong) NSMutableArray * dataArray;

/**
 *  请求url
 */
@property (nonatomic, copy) NSString * urlStr;
@end
