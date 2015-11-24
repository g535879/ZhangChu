//
//  AppDelegate.m
//  ZhangChu_BJ
//
//  Created by LongHuanHuan on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "CookBookViewController.h"
#import "FindViewController.h"
#import "AboutMeViewController.h"
#import "SquareViewController.h"
#import "MyNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self createTabBar];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 创建标签栏
- (MainTabBarController *)createTabBar {
    CookBookViewController * cookBookVC = [[CookBookViewController alloc] init];
    FindViewController * findVC = [[FindViewController alloc] init];
    SquareViewController * squareVC = [[SquareViewController alloc] init];
    AboutMeViewController * aboutMeVC = [[AboutMeViewController alloc] init];

    
    MyNavigationController * cookBookNVC = [[MyNavigationController alloc] initWithRootViewController:cookBookVC];
    MyNavigationController * findNVC = [[MyNavigationController alloc] initWithRootViewController:findVC];
    MyNavigationController * squareNVC = [[MyNavigationController alloc] initWithRootViewController:squareVC];
    MyNavigationController * aboutMeNVC = [[MyNavigationController alloc] initWithRootViewController:aboutMeVC];

    
    cookBookNVC.title = @"菜谱";
    findNVC.title = @"发现";
    squareNVC.title = @"广场";
    aboutMeNVC.title = @"我的";

    
    cookBookNVC.tabBarItem.selectedImage = imageNameRenderStr(@"tab_cookbook_hl");
    cookBookNVC.tabBarItem.image = imageNameRenderStr(@"tab_cookbook");
    
    findNVC.tabBarItem.selectedImage = imageNameRenderStr(@"tab_explore_hl");
    findNVC.tabBarItem.image = imageNameRenderStr(@"tab_explore");
    
    
    squareNVC.tabBarItem.selectedImage = imageNameRenderStr(@"tab_plaza_hl");
    squareNVC.tabBarItem.image = imageNameRenderStr(@"tab_plaza");
    
    aboutMeNVC.tabBarItem.selectedImage = imageNameRenderStr(@"tab_aboutme_hl");
    aboutMeNVC.tabBarItem.image = imageNameRenderStr(@"tab_aboutme");
    
    MainTabBarController * main = [[MainTabBarController alloc ]init];
    main.viewControllers = @[cookBookNVC,findNVC,squareNVC,aboutMeNVC];
    
    return main;
}

@end
