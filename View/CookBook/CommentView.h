//
//  CommentView.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  commentDelegate <NSObject>

/**
 *  评论按钮点击事件
 *
 *  @param btn 评论按钮
 */
- (void)commonClick:(UIButton *)btn;

@end
@interface CommentView : UIView

@property (assign, nonatomic) id<commentDelegate> delegate;
@end
