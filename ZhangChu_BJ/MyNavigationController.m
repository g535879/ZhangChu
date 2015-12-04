//
//  MyNavigationController.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()<UIGestureRecognizerDelegate>
/**
 *  当前根视图控制器
 */
@property (weak, nonatomic) UIViewController * rootVC;
@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        self.interactivePopGestureRecognizer.delegate = self;
        self.rootVC = rootViewController;
    }
    
    return self;
}

/**
 *  确定手势是否有效
 *
 *  @param gestureRecognizer
 *
 *  @return
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return !(self.rootVC == self.topViewController);
}




//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
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
