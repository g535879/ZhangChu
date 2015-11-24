//
//  NetManager.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetManager : NSObject
/**
 下载数据成功回调
 */
typedef void (^SuccessCallBackData)(id successData);

/**
 下载数据回调失败
 */
typedef void (^FailureCallBackData)(NSError *error);

/**
 单例对象
 */

+ (instancetype)defaultManager;

/**
    获取数据
 */
+ (void)loadDataWithUrlStr:(NSString *)urlStr block:(SuccessCallBackData) success withFaile:(FailureCallBackData) failure;

@end
