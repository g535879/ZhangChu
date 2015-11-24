//
//  BasicViewController.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 下载数据成功回调
 */
typedef void (^SuccessCallBackData)(id successData);

/**
 下载数据回调失败
 */
typedef void (^FailureCallBackData)(NSError *error);


@interface BasicViewController : UIViewController

/**
    这个是记录我们的网络状态
 */
@property (nonatomic, assign) BOOL isNetWork;
/**
    设置导航栏标题
 */

- (void)setNavTitle:(NSString *)str;


/**
    设置背景色
 */
- (void)setBgColor;


/**
    判断网络
 */
- (void)checkNetWork;

/**
    通过url下载数据
 */
- (void)loadDataByUrl:(NSString *)urlStr withdataBlock:(SuccessCallBackData) success withFailure:(FailureCallBackData)failure;

@end
