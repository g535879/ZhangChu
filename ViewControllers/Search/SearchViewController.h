//
//  SearchViewController.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/25.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "BasicViewController.h"

@interface SearchViewController : BasicViewController

/**
 *  搜索表格视图
 */
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

/**
 *  当前IP
 */
@property (nonatomic, copy) NSString * hostIP;
@end
