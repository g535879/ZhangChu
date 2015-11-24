//
//  CookBookAdModel.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "BasicModel.h"

@interface CookBookAdModel : BasicModel

/**
    当前广告ID
 */
proInteger(adId);

/**
    图片地址
 */
proStr(imageFilename);

/**
    类型
 */
proInteger(type);
@end
