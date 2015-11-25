//
//  SearchCategoryModel.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/25.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "SearchCategoryModel.h"
#import "SearchCategoryDetailModel.h"

@implementation SearchCategoryModel

@synthesize data = _data;


- (void)setData:(NSMutableArray *)data {
    
    for (NSDictionary * dic in data) {
        SearchCategoryDetailModel * model = [[SearchCategoryDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        
        [self.data addObject:model];
    }
}


- (NSMutableArray *)data {
    
    if (!_data) {
        
        _data = [@[] mutableCopy];
    }
    return _data;
}

@end
