//
//  VideoPlayViewController.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/28.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "BasicViewController.h"

@interface VideoPlayViewController : BasicViewController

/**
 *  菜名
 */
@property (nonatomic, copy) NSString * videoName;

/**
 *  图片地址
 */
@property (nonatomic, copy) NSString * imageUrl;

/**
 *  蔬菜Id
 */
@property (nonatomic, copy) NSString * vegetableId;
@end
