//
//  BasicViewController.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DBManager shareManager];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];

    
    self.navigationController.navigationBar.translucent = NO;
    
    if (isiOS7) {
        
        //白色标题
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
    }

    //检测网络状态
    [self checkNetWork];
    
    
    //    if (isiOS8) {
    //        UIAlertController
    //    }else{
    //        UIAlertView
    //    }
    
}

#pragma mark - 设置导航栏上面的文字
- (void)setNavTitle:(NSString *)str {
    
    UILabel * label = [MyCustomView createLabelWithFrame:CGRectMake(0, 0, screen_Width, 44.0f) textString:str withFont:20.f textColor:[UIColor whiteColor]];
    
    self.navigationItem.titleView = label;
    

    
}


#pragma mark - 设置背景色
- (void)setBgColor{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"homeview_bg"]]];
}


#pragma mark - 这里进行网路判断
- (void)checkNetWork {
    
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    //开启检测网络
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                //未知
                self.isNetWork = YES;
                [self showMyAlertView:notNetWorkString];
                //发送一个有网的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:isnetWorkNotificationYes object:nil];
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable: {
                //没网
                self.isNetWork = NO;
                [self showMyAlertView:notNetWorkString];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:isnetWorkNotificationNo object:nil];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //3g 4g /gprs
                self.isNetWork = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:isnetWorkNotificationYes object:nil];
            }
                break;
           
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                //wifi
                
                self.isNetWork = YES;
                
//                [self showMyAlertView:@"网来啦!!!!"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:isnetWorkNotificationYes object:nil];

            }
                break;
            default:
                break;
        }
    }];
    
}


#pragma mark - loadData

- (void)loadDataByUrl:(NSString *)urlStr withdataBlock:(SuccessCallBackData)success withFailure:(FailureCallBackData)failure {
    
    //状态栏显示加载框
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //显示加载框
    [self.hud showInRect:CGRectMake(0, 0, screen_Width, screen_Height) inView:self.view]; //放置autolayout导致显示不正确
    
    [NetManager loadDataWithUrlStr:urlStr block:^(id successData) {
        //隐藏加载框
        [self.hud dismissAnimated:YES];
        //状态栏关闭加载框
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(successData);
        
    } withFaile:^(NSError *error) {
        
        //隐藏加载框
        [self.hud dismissAnimated:YES];
        //状态栏关闭加载框
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error);
    }];
}


#pragma mark -  构造方法

- (JGProgressHUD *)hud {
    if (!_hud) {
        _hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        _hud.textLabel.text = @"正在加载....";
    }
    
    return _hud;
}

/**
 *  导航栏左侧返回按钮
 */
- (void)leftNavItem {
    //nav_back Btn
    
    UIButton * btn = [MyCustomView createButtonWithFrame:CGRectMake(0, 0, 35, 35)
                                                  target:self SEL:@selector(leftNavItemClick)
                                         backgroundImage:imageStar(@"nav_back")];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = item;
}


#pragma mark - left navItem click
- (void)leftNavItemClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
