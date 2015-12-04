//
//  MovieDetailModel.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "BasicModel.h"

@interface MovieDetailModel : BasicModel
/**
 *  原料
 */
proStr(fittingRestriction);

/**
 *  调料
 */
proStr(method);

/**
 *  视频
 */
proStr(materialVideoPath);
@end
