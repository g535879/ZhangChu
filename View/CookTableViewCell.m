//
//  CookTableViewCell.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "CookTableViewCell.h"
#import "CookBookDetailModel.h"

@implementation CookTableViewCell

- (void)awakeFromNib {


}

- (void)setModel:(CookBookCategoryModel *)model {
    [self.categoryImage setImageWithURL:[NSURL URLWithString:model.imageFilename]];
    self.categoryTitle.text = model.name;
    
    NSInteger index = 3 <= model.vegetables.count ? 3 : model.vegetables.count;
    for (int i = 0; i < index; i++) {
        CookBookDetailModel * dModel = model.vegetables[i];
        UIImageView *imageView = (UIImageView *)[self viewWithTag:100+i];
        UILabel * label = (UILabel *)[self viewWithTag:1000 + i];
        [imageView setImageWithURL:[NSURL URLWithString:dModel.imagePathThumbnails]];
        label.text = dModel.name;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
