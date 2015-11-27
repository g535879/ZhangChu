//
//  SearchResultCollectionViewCell.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/27.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCollectionViewCell : UICollectionViewCell
/**
 *  菜谱图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *cookImageView;
/**
 *  菜名
 */
@property (weak, nonatomic) IBOutlet UILabel *cookName;

@end
