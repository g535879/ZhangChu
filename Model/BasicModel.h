//
//  BasicModel.h
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/24.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import <Foundation/Foundation.h>

#define proStr(str) @property (nonatomic, copy) NSString * (str)

#define proArr(arr) @property (nonatomic, copy) NSArray * (arr)

#define proInteger(i) @property (nonatomic, assign) NSInteger (i)

#define proMuArr(muArr) @property (nonatomic, strong) NSMutableArray * (muArr)

@interface BasicModel : NSObject

@end
