//
//  SearchDetailTableViewCell.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/25.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "SearchDetailTableViewCell.h"

#import "SearchCategoryDetailModel.h"


//单元格内子视图间距
#define  SUBVIEW_SPACE 10.0f * scale_screen

#define  CELL_HEIGHT 85.0f * scale_screen

@interface SearchDetailTableViewCell ()

/**
 *  内部滚动视图
 */
@property (strong, nonatomic) UIScrollView * subScrollView;
@end
@implementation SearchDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)drawRect:(CGRect)rect {
    
    
   
}

//赋值数据。建立视图
- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    
    //判断是否有滚动视图。
    if (!self.subScrollView) { //没有滚动视图
        
        self.subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 0, screen_Width - 30, CELL_HEIGHT)];
        self.subScrollView.showsHorizontalScrollIndicator = NO;
        self.subScrollView.showsVerticalScrollIndicator = NO;
        
        [self.contentView addSubview:self.subScrollView];
        
    }
    //清除滚动视图子视图
    for (UIView * view in self.subScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    //创建本次滚动视图子视图
    [self createScrollViewWithcontentArray:self.modelArray subViewWidth:CELL_HEIGHT];
    self.subScrollView.contentSize = CGSizeMake((CELL_HEIGHT + SUBVIEW_SPACE) * self.modelArray.count, CELL_HEIGHT);
}

//本次滚动视图子视图
- (void)createCustomSubView {
    
}

#pragma mark - 单元格内部滚动视图

/**
 *  生成单元格内滚动视图子视图
 *
 *  @param dataArray 内部数据源
 *  @param width     子视图宽度
 *
 *  @return 滚动视图子视图
 */

- (void)createScrollViewWithcontentArray:(NSArray *)dataArray subViewWidth:(CGFloat) width{
    
    //子视图
    for (int i = 0; i < dataArray.count; i++) {
        
        SearchCategoryDetailModel * dModel = dataArray[i];
        
        UIButton * btn = [MyCustomView createButtonWithFrame:CGRectMake(i * (width + SUBVIEW_SPACE ), 0, CELL_HEIGHT, CELL_HEIGHT) target:self SEL:@selector(cellSubBtnClick:) backgroundImage:nil title:dModel.name forwardImage:nil];
        
        [btn setImage:imageStar(dModel.iconName) forState:UIControlStateNormal];
        [btn setImage:imageStar(dModel.hlIconName) forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:50 * scale_screen]];
        [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        if (dModel.iconName.length) {
            [btn.titleLabel setFont:[UIFont systemFontOfSize:20 * scale_screen]];
            [btn.titleLabel setContentMode:UIViewContentModeLeft];
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(45* scale_screen,-CELL_HEIGHT+19 * scale_screen, 0, 0)];
            
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-5 * scale_screen, 6 * scale_screen, 0, 0)];
        }
        [self.subScrollView addSubview:btn];
    }
}

/**
 *  根据文本和字体返回高度
 *
 *  @param str  文本
 *  @param font 字体
 *
 *  @return 字体大小
 */
- (CGSize)sizeOfGivenText:(NSString *)str andFontSize:(UIFont *) font {
    
    return [str sizeWithAttributes:@{NSFontAttributeName : font}];
}


- (void)cellSubBtnClick:(UIButton *)btn {
    
    //取消所有button选中状态
    for (UIButton * b in self.subScrollView.subviews) {
        if (b.selected) {
            b.selected = NO;
            [b setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    btn.selected = YES;
    [btn setBackgroundColor:[UIColor colorWithRed:0.72f green:0.40f blue:0.24f alpha:1.00f]];
    
    //传递button点击事件
    
    if ([self.delegate respondsToSelector:@selector(cellBtnClickWithBtnName:andCell:)]) {
        
        [self.delegate cellBtnClickWithBtnName:btn.currentTitle andCell:self];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
