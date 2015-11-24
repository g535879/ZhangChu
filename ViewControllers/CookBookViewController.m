//
//  CookBookViewController.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "CookBookViewController.h"
#import "CookBookAdModel.h"
#import "CustomScrollView.h"
#import "CookBookCategoryModel.h"
#import "CookTableViewCell.h"


#define headViewHeight 225.0f

@interface CookBookViewController ()<UITableViewDataSource,UITableViewDelegate> {
    
    UITableView * _cookBookTableView;
}

//看这里是没网的UI
@property (strong, nonatomic) UILabel * netWorkLabel;

@property (strong, nonatomic) CustomScrollView * adScrollView;//广告栏滚动视图

@property (strong, nonatomic) NSMutableArray * adArray; //广告数据源

@property (strong, nonatomic) UIView * headView; //头部视图

@property (strong, nonatomic) NSMutableArray * cookDataArray; //菜谱数据源
@end


@implementation CookBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置标题
    [self setNavTitle:viewControllerTitleString];
    
    
    //导航栏右侧搜索按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    
    //设置背景色
    [self setBgColor];
    
    //监听网络状态回调
    
    //没有网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isnotNetWork) name:isnetWorkNotificationNo object:nil];
    //有网络
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isNetWorkYes) name:isnetWorkNotificationYes object:nil];
    
    //布局
    [self createLayout];

    
    //加载数据
    [self loadData];
    
}


#pragma mark -  布局

- (void)createLayout {
    
    //tableview
    [self createTableView];
    
    //headView
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, scale_screen * (headViewHeight-5) + 5)];
    [self.headView setBackgroundColor:[UIColor clearColor]];
    
    _cookBookTableView.tableHeaderView = self.headView;
    
}
#pragma mark - tableview 
- (void)createTableView {
    
    _cookBookTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-nav_Height-tabBar_Height-10) style:UITableViewStylePlain];
    _cookBookTableView.delegate = self;
    _cookBookTableView.dataSource = self;
    _cookBookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_cookBookTableView setBackgroundColor:[UIColor clearColor]];
    _cookBookTableView.showsVerticalScrollIndicator = NO;
    _cookBookTableView.showsHorizontalScrollIndicator = NO;
    
    //注册cell
    [_cookBookTableView registerNib:[UINib nibWithNibName:@"CookTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellReuseidentifier"];
    
    [self.view addSubview:_cookBookTableView];
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CookTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuseidentifier"];
    
    [cell setModel:self.cookDataArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cookDataArray.count;
}


#pragma mark - 网络状态发生改变

- (void)isnotNetWork {
    
    self.netWorkLabel.text = @"没有网络";
    [self.view addSubview:self.netWorkLabel];
}

- (void)isNetWorkYes {
    
    if (_netWorkLabel) {
        [_netWorkLabel removeFromSuperview];
        _netWorkLabel = nil;
    }
}





#pragma mark - 构造方法

- (UILabel *)netWorkLabel {
    if (!_netWorkLabel) {
        _netWorkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
        [_netWorkLabel setTextColor:[UIColor whiteColor]];
        _netWorkLabel.backgroundColor = [UIColor blackColor];
    }
    return _netWorkLabel;
}


- (NSMutableArray *)adArray {
    if (!_adArray) {
        _adArray = [@[] mutableCopy];
    }
    return _adArray;
}

- (NSMutableArray *)cookDataArray {
    
    if (!_cookDataArray) {
        _cookDataArray = [@[] mutableCopy];
    }
    return _cookDataArray;
}

#pragma mark - loadData
- (void)loadData {
    
    //加载广告数据
    [self loadDataByUrl:[NSString stringWithFormat:@"%@is_traditional=0&phonetype=1",URL_COOKBOOK_AD] withdataBlock:^(id successData) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        if (![jsonObj[@"status"] integerValue]) {
            id arrObj = jsonObj[@"data"];
            if ([arrObj isKindOfClass:[NSArray class]]) {
                for (NSDictionary * dic in arrObj) {
                    CookBookAdModel * model = [[CookBookAdModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.adArray addObject:model];
                }
                
                if (self.adArray.count) {
                    
                    //赋值给广告栏滚动视图
                    self.adScrollView.imagesArray = self.adArray;
                }
            }
        }else{ //有错误
            [self showMyAlertView:jsonObj[@"message"]];
        }

        
    } withFailure:^(NSError *error) {
        NSLog(@"%@",error);
        
        //提示错误信息
        [self showMyAlertView:@"请求信息出错!"];
    }];
    
    
    //加载菜谱数据
    
    [self loadDataByUrl:[NSString stringWithFormat:@"%@pageRecord=3&page=1&phonetype=1&is_traditional=0",URL_COOKBOOK] withdataBlock:^(id successData) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        if (![jsonObj[@"status"] integerValue]) {
            id arrObj = jsonObj[@"data"];
            if ([arrObj isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary * dic in arrObj) {
                    CookBookCategoryModel * model = [[CookBookCategoryModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.cookDataArray addObject:model];
                }
                
                //刷新数据
                [_cookBookTableView reloadData];
            }
        }
        else{
            
            //错误提示信息
            [self showMyAlertView:jsonObj[@"message"]];
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"%@",error);
        
        //提示错误信息
        [self showMyAlertView:@"请求信息出错!"];
    }];
}

#pragma mark - create Ad scrollview

- (void)createAdScrollview {
    
    // 广告栏
    self.adScrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(10, 5, screen_Width-20, self.headView.frame.size.height)];
    
    [self.headView addSubview:self.adScrollView];
    
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
