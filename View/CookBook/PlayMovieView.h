//
//  PlayMovieView.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayMovieView : UIView


@property (copy, nonatomic) void (^movieButtonBlock)(UIButton *);

@property (copy, nonatomic) void (^threedButtonBlock)(UIButton *);

/**
 *  蔬菜id
 */
@property (copy, nonatomic) NSString * vegtablesId;

/**
 *  构造方法。初始化背景图url
 *
 *  @param frame
 *  @param url
 *  @param vegatablesId
 *  @return self
 */
- (id)initWithFrame:(CGRect)frame andButtonBgImageUrl:(NSString *)url;

- (id)initWithFrame:(CGRect)frame andButtonBgImageUrl:(NSString *)url
                                         vegatablesId:(NSString *)vId
                                 withMovieButtonBlock:(void(^)(UIButton *)) movieButtonBlock
                                  andThreeButtonBlock:(void(^)(UIButton *)) threeBlock;

/**
 *  显示视频框
 */
- (void)showbgImageView;

@end
