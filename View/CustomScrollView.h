//
//  CustomScrollView.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol returnClickTag <NSObject>

/**
 返回选中的视图的tag
 */
- (void)returnClickTag:(NSInteger) picIndex;

@end
@interface CustomScrollView : UIView

@property (assign, nonatomic) id<returnClickTag> delegate;

//图片数据源
@property (copy, nonatomic) NSArray * imagesArray;


@end
