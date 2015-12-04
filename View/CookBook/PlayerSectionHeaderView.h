//
//  PlayerSectionHeaderView.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sectionDelegate <NSObject>

/**
 *  头视图点击事件
 *
 *  @param idx section id
 */
- (void)sectionclick:(NSInteger) idx;

@end
@interface PlayerSectionHeaderView : UIView

@property (assign, nonatomic) id<sectionDelegate> delegate;

/**
 *  左侧图片
 */
@property (copy, nonatomic) NSString * leftImageStr;

/**
 *  分组标题
 */
@property (copy, nonatomic) NSString * title;

/**
 *  section 所在下标
 */
@property (assign, nonatomic) NSInteger idx;
@end
