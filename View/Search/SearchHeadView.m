//
//  SearchHeadView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/26.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "SearchHeadView.h"

//单元格内子视图间距
#define  SUBVIEW_SPACE 10.0f * scale_screen

#define  CELL_HEIGHT 85.0f * scale_screen

@interface SearchHeadView()
/**
 *  背景图
 */
@property (strong, nonatomic) UIView * bgView;

@end
@implementation SearchHeadView


- (instancetype)initHeadViewWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createBgView];
    }
    return self;
}


- (void)createBgView {
    //头视图
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    [self setBackgroundColor:[UIColor clearColor]];
    
    //头视图子视图
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, screen_Width - 30, self.frame.size.height - 20)];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.bgView];
    
}

//获取bgView中最后一个位置坐标点
- (CGPoint)subViewHeightOfHeadView {
    //
    NSInteger width = self.bgView.frame.size.width;
    
    //获取最后一个tabView 坐标
    CGRect lastframe = [[self.bgView subviews] lastObject].frame;
    
    NSInteger currentX = (NSInteger)(CGRectGetMaxX(lastframe) + 10) % width;
    NSInteger currentY = lastframe.origin.y + (10 + lastframe.size.height) * ((NSInteger)(CGRectGetMaxX(lastframe) + 10) / width);
    if (currentX + lastframe.size.width > width) { //超过边界 , 往下移动一行
        currentX = (NSInteger)(currentX + lastframe.size.width) % width;
        currentY += 10 + lastframe.size.height;
    }
    if (currentY == 0) {
        currentY = 5;
    }
    if (currentX == 10) {
        currentX = 5;
    }
    return CGPointMake(currentX, currentY);
}

- (void)addTapBtnWithName:(NSString *)name {
    
    //创建标签视图
    //获取子视图最后一个坐标位置
    CGPoint currentPoint = [self subViewHeightOfHeadView];
    UIImageView * tabView = [[UIImageView alloc] initWithFrame:CGRectMake(currentPoint.x, CGRectGetMaxY(self.bgView.frame)+50, CELL_HEIGHT, 30)];
    tabView.userInteractionEnabled = YES;
    [tabView setImage:imageStar(@"search_btn_intelligent")];
    tabView.layer.cornerRadius = 5;
    tabView.layer.masksToBounds = YES;
    [self.bgView addSubview:tabView];
    
    //关闭按钮
    UIButton * closeBtn = [MyCustomView createButtonWithFrame:CGRectMake(tabView.frame.size.width - 20, 5, 20,20) target:self SEL:@selector(closeBtnClick:) backgroundImage:imageStar(@"search_header_rmbtn")];
    [closeBtn setBackgroundImage:imageStar(@"search_header_rmbtn_hl") forState:UIControlStateHighlighted];
    [tabView addSubview:closeBtn];
    
    //创建标签button
    UILabel *label = [MyCustomView createLabelWithFrame:CGRectMake(10, closeBtn.frame.origin.y, CELL_HEIGHT-closeBtn.frame.size.width-10, 20) textString:name withFont:14.0f textColor:[UIColor blackColor]];
    [label setAdjustsFontSizeToFitWidth:YES];
    label.textAlignment = NSTextAlignmentCenter;
    [tabView addSubview:label];
    
    //动画
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    tabView.frame = CGRectMake(currentPoint.x, currentPoint.y, CELL_HEIGHT, 30);
        
    } completion:nil];
}

#pragma mark - tapBtn ClickEvent

- (void)closeBtnClick:(UIButton *)btn {
    
    UIView * supTapView = self.bgView;
    
    //当前被删除的标签在父视图的位置
    NSInteger currentIndex = [supTapView.subviews indexOfObject:btn.superview];
    
    //修改删除后的坐标值。后面的往前移动
    for (NSInteger i = supTapView.subviews.count - 1; i > currentIndex; i--) {
        
        //传递frame
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [supTapView.subviews objectAtIndex:i].frame = [supTapView.subviews objectAtIndex:i-1].frame;
        } completion:nil];
        
    }
    //删除标签视图
    [btn.superview removeFromSuperview];
    
    //得到标签名
    NSString * tapStr = [[[btn.superview subviews] lastObject] text];
    
    //回调
    if (self.closeBtnClick) {
        
        self.closeBtnClick(tapStr);
    }
}

#pragma mark - 检查标签是否已经存在
- (BOOL)checkIsExsitAtSupViewWithName:(NSString *)name {
    
    for (UIView  * v in self.bgView.subviews) {
        
        if ([[(UILabel *)[[v subviews] lastObject] text] isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}



- (void)replaceBtnName:(NSString *)name withSectionGroup:(NSArray<NSString *> *)array andSection:(NSInteger)section {
    
    for (UIView  * v in self.bgView.subviews) {
        if ([[(UILabel *)[[v subviews] lastObject] text] isEqualToString:[array objectAtIndex:section]]) {
            //替换为最新的名字
            [(UILabel *)[[v subviews] lastObject] setText:name];
            break;
        }
    }
}

@end
