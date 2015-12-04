//
//  PlayMovieView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "PlayMovieView.h"
#import "DBManager.h"

@interface PlayMovieView ()

/**
 *  视频背景图
 */
@property (strong, nonatomic) UIButton * bgImageView;

@end
@implementation PlayMovieView

- (instancetype)initWithFrame:(CGRect)frame andButtonBgImageUrl:(NSString *)url {
    
    if (self = [super initWithFrame:frame]) {
        
    self.bgImageView = [MyCustomView createButtonWithFrame:CGRectMake(0, 0, frame.size.width, scale_screen * 200) target:self SEL:@selector(playMovieButtonClick:) backgroundImage:nil];

        [self.bgImageView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:url]];
        [self.bgImageView setImage:imageNameRenderStr(@"video_play") forState:UIControlStateNormal];
        
        [self.bgImageView setHidden:YES];
        [self addSubview:self.bgImageView];
        
        
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame andButtonBgImageUrl:(NSString *)url vegatablesId:(NSString *)vId withMovieButtonBlock:(void (^)(UIButton *))movieButtonBlock andThreeButtonBlock:(void (^)(UIButton *))threeBlock {
    
    if (self = [self initWithFrame:frame andButtonBgImageUrl:url]) {
        
        //设置block指针
        self.movieButtonBlock = movieButtonBlock;
        self.threedButtonBlock = threeBlock;
        
        //蔬菜id
        self.vegtablesId = vId;
        
        //创建三个按钮
        NSMutableArray * titleArray = [@[@"收藏",@"缓存",@"分享"] mutableCopy];
        NSArray * imageArray = @[@"detail_collect",@"detail_cache",@"detail_share"];
        
        for (int i = 0; i < titleArray.count; i++) {
            
            if (i == 0) { //判断是否已经收藏
                DBManager * manager = [DBManager shareManager];
                CookBookDetailModel * model = [CookBookDetailModel new];
                model.vegetable_id = self.vegtablesId;
                if ([[manager selectDataByModel:model] count]) { //有结果
                    [titleArray replaceObjectAtIndex:i withObject:[@"已" stringByAppendingString:titleArray[0]]];
                }
            }
            UIButton * btn = [MyCustomView  createButtonWithFrame:CGRectMake(frame.size.width / 3.0f * i, CGRectGetMaxY(self.bgImageView.frame), screen_Width / 3.0f - 2, scale_screen * 35.0f) target:self SEL:@selector(threeButtonClick:) backgroundImage:nil title:titleArray[i] forwardImage:[UIImage imageNamed:imageArray[i]]];
            
            btn.tag = 500 + i;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:fontSize14];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -60 * scale_screen, 0, 0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 60 * scale_screen, 0, 0)];
            [self addSubview:btn];
            
            //放置竖线
            if (i < titleArray.count - 1) {
                
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), btn.frame.origin.y + 2, 2, btn.frame.size.height - 4)];
                [lineView setBackgroundColor:[UIColor grayColor]];
                [self addSubview:lineView];
            }
        }
    }
    return self;
}
#pragma mark - playMovieButtonClick
- (void)playMovieButtonClick :(UIButton *)btn{
    
    if (self.movieButtonBlock) {
        self.movieButtonBlock(btn);
    }
}
#pragma mark - threeButtonClick 
- (void)threeButtonClick:(UIButton *)btn {
    
    self.threedButtonBlock(btn);
}


#pragma mark - showBgImageView
- (void)showbgImageView {
    
    [self.bgImageView setHidden:NO];
}
@end
;