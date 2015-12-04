//
//  DBManager.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/12/1.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CookBookDetailModel.h"

@interface DBManager : NSObject

/**
 *  构造方法
 *
 *  @return object
 */
+ (DBManager *)shareManager;

/**
 增
 */

- (void)insertDataWithModel:(CookBookDetailModel *)model;

/**
 删
 */

- (void)deleteDataWithModel:(CookBookDetailModel *)model;
/**
 改
 */
- (void)updateDataWithModel:(CookBookDetailModel *)model;

/**
 查
 */
- (NSArray *)selectDataByModel:(CookBookDetailModel *)model;

/**
 获取所有数据
 */
- (NSArray *)selectAll;

@end
