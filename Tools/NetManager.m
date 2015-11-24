//
//  NetManager.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "NetManager.h"

@interface NetManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager * manager;
/**
 当前IP地址
 */
@property (copy, nonatomic) NSString * currentIPAddr;

@end
static NetManager * singltonManager = nil;

@implementation NetManager

+ (instancetype)defaultManager {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singltonManager = [[super alloc] init];
    });
    return singltonManager;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singltonManager = [super allocWithZone:zone];
    });
    
    return singltonManager;
}


- (AFHTTPRequestOperationManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return _manager;
}


//判断当前ip是否存在
+ (void)loadDataWithUrlStr:(NSString *)urlStr block:(SuccessCallBackData)success withFaile:(FailureCallBackData)failure {
    
    NetManager * m = [self defaultManager];
    
    if (!m.currentIPAddr) {
        
//        //获取最新IP
        [m.manager GET:URL_HOSTIP parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            m.currentIPAddr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //获取数据
            [m loadDataWithCurrenIPAndUrlStr:[NSString stringWithFormat:@"http://%@%@",m.currentIPAddr,urlStr] success:^(id successData) {
                
                //成功回调
                success(successData);
                
            } failure:^(NSError *error) {
                //失败回调
                failure(error);
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            failure(error);
        }];
        
    }else{
        [m loadDataWithCurrenIPAndUrlStr:[NSString stringWithFormat:@"http://%@%@",m.currentIPAddr,urlStr] success:^(id successData) {
            
            success(successData);
            
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
    
}

//加载数据
- (void)loadDataWithCurrenIPAndUrlStr:(NSString *)strUrl success:(SuccessCallBackData)successResponse failure:(FailureCallBackData) failure {
    
    [self.manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //回调获取的数据
        successResponse(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        //失败回调
        failure(error);
    }];
}
@end
