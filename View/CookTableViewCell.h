//
//  CookTableViewCell.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookBookCategoryModel.h"

@interface CookTableViewCell : UITableViewCell

/**
    分类图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
/**
    分裂名
 */
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
/**
    ’更多‘图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *moreInfoImage;
/**
    左侧图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftContentImageView;
/**
    中间图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *centerContentImageView;
/**
    右侧图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightContentImageView;
/**
    左侧内容
 */
@property (weak, nonatomic) IBOutlet UILabel *leftContentLabel;
/**
    中间内容
 */
@property (weak, nonatomic) IBOutlet UILabel *centerContentLabel;
/**
    右侧内容
 */
@property (weak, nonatomic) IBOutlet UILabel *rightContentLabel;
/**
    赋值
 */
- (void)setModel:(CookBookCategoryModel *)model;
@end
