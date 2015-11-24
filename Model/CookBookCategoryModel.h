//
//  CookBookCategoryModel.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "BasicModel.h"

@interface CookBookCategoryModel : BasicModel

/**
    分类名
 */

proStr(name);
/**
 分类图片
 */

proStr(imageFilename);
/**
 分类类型
 */

proStr(type);


//食物数组
proMuArr(vegetables);

@end
