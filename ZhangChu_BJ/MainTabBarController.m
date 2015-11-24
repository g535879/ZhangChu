//
//  MainTabBarController.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "MainTabBarController.h"

@interface
MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIView *v in self.tabBar.subviews) {
        v.hidden = YES;
    }
    
    
    float w = screen_Width / 4.0f;
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIViewController * vc = self.viewControllers[i];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w * i, 0, w+1, tabBar_Height);
        
        [btn setBackgroundImage:vc.tabBarItem.image forState:UIControlStateNormal];
        
        [btn setBackgroundImage:vc.tabBarItem.selectedImage forState:UIControlStateSelected];
        //设置按钮选中状态颜色(设置高亮，点一下反弹)
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        
        //正常状态颜色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:fontSize14];
        
        //把文字下移
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(23.0f, 0, 0, 0)];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        
        //默认选中
        if (i == 0) {
            btn.selected = YES;
        }
        //tag 值
        btn.tag = 300 + i;
        //点击事件
        [btn addTarget:self action:@selector(tabbarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBar addSubview:btn];
    }
}


#pragma mark - tabbarBtn click events

- (void)tabbarBtnClick:(UIButton *)btn {
    btn.selected = YES;
    self.selectedIndex = btn.tag - 300;

    
    for ( int i = 0 ; i < self.viewControllers.count; i++) {
        
        UIButton * b = (UIButton * )[self.tabBar viewWithTag:300+i];
        if (btn != b) {
            b.selected = NO;
        }
    }
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
