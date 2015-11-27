//
//  SearchHeadView.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/26.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHeadView : UIView

/**
 *  close btn click 回调
 */
@property (copy, nonatomic) void (^closeBtnClick)(NSString * btnName);
/**
 *  构造方法
 *
 *  @param frame frame
 *
 *  @return view
 */
- (instancetype)initHeadViewWithFrame:(CGRect)frame;
/**
 *  创建新的标签
 *
 *  @param name 标签名
 */
- (void)addTapBtnWithName:(NSString *)name;

/**
 *  检查标签是否已经存在
 *
 *  @param name name
 *
 *  @return bool
 */
- (BOOL)checkIsExsitAtSupViewWithName:(NSString *)name;

/**
 *  替换同一分组中的标签
 *
 *  @param name  新标签名
 *  @param array 标签坐在的分组
 *  @param array 标签所在分组id
 */
- (void)replaceBtnName:(NSString *)name withSectionGroup:(NSArray<NSString *> *) array andSection:(NSInteger) section;
@end
