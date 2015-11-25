//
//  CookBookCategoryModel.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "CookBookCategoryModel.h"
#import "CookBookDetailModel.h"

@implementation CookBookCategoryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"vegetableList"]) {
        
        for (NSDictionary  * dic in value) {
            
            CookBookDetailModel * model = [[CookBookDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.vegetables addObject:model];
            
        }
    }
}

- (NSMutableArray *)vegetables {
    
    if (!_vegetables) {
        _vegetables = [@[] mutableCopy];
    }
    
    return _vegetables;
}

@end
