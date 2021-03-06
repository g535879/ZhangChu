//
//  CookBookTableViewCell.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/24.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "CookBookTableViewCell.h"
#import "CookBookDetailModel.h"

@implementation CookBookTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //比例适配
    self.iconHeight.constant = self.iconHeight.constant * scale_screen;
    
    //分类名
    self.categoryTitle.font = [UIFont boldSystemFontOfSize:scale_screen * 16.0f];
//    //机型匹配
//    if (screen_Width == iphone4s) {
//        //do something
//    }
}


- (void)setModel:(CookBookCategoryModel *)model {
    [self.categoryImage setImageWithURL:[NSURL URLWithString:model.imageFilename]];
    self.categoryTitle.text = model.name;
    
    if ([model.type isEqualToString:@"6"]) {
        self.hotImageView.hidden = NO;
    }else{
        self.hotImageView.hidden = YES;
    }
    
    NSInteger index = 3 <= model.vegetables.count ? 3 : model.vegetables.count;
    for (int i = 0; i < index; i++) {
        CookBookDetailModel * dModel = model.vegetables[i];
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        UILabel * label = (UILabel *)[self viewWithTag:1000 + i];
        [btn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:dModel.imagePathThumbnails]];
        label.text = dModel.name;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
