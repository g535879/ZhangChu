//
//  PlayerSectionHeaderView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "PlayerSectionHeaderView.h"

@interface PlayerSectionHeaderView (){
    
    UIImageView * _leftImageView;
    UILabel * _titleLable;
    UIImageView * _rightImageView;
}

@end
@implementation PlayerSectionHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self viewConfig];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTouch:)]];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
    
}

- (void)viewConfig {
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, self.frame.size.height - 20)];
    [self addSubview:_leftImageView];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame), _leftImageView.frame.origin.y+5, self.frame.size.width - CGRectGetMaxX(_leftImageView.frame), _leftImageView.frame.size.height)];
    [self addSubview:_titleLable];
    
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, 30)];
    [self addSubview:_rightImageView];
    _rightImageView.image = imageStar(@"nav_back");
    _rightImageView.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, -1);
    //底部背景色
    UIView * bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
    [bgView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:bgView];
    
}

- (void)setLeftImageStr:(NSString *)leftImageStr {
    
    _leftImageView.image = imageStar(leftImageStr);
}

- (void)setTitle:(NSString *)title {
    
    _titleLable.text = title;
}

#pragma mark - section touch 

- (void)sectionTouch:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if ([self.delegate respondsToSelector:@selector(sectionclick:)]) {
            [self.delegate sectionclick:self.idx];
        }
    }
}

@end
