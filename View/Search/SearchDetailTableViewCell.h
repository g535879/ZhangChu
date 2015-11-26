//
//  SearchDetailTableViewCell.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/25.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchDetailTableViewCell;

@protocol SearchCellDelegate <NSObject>

/**
 *  协议方法响应cell内button点击事件
 *
 *  @param name button所在名
 *  @param cell 当前单元格
 */
- (void)cellBtnClickWithBtnName:(NSString *)name andCell:(SearchDetailTableViewCell *)cell;

@end


@interface SearchDetailTableViewCell : UITableViewCell

/**
 *  代理对象
 */
@property (assign, nonatomic) id<SearchCellDelegate> delegate;
/**
 *  赋值
 */
@property (copy, nonatomic) NSArray * modelArray;

/**
 *  当前选中的按钮
 */
@property (copy, nonatomic) NSString * currentSelectedItemName;
@end
