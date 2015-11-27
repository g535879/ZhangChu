//
//  SearchViewController.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/25.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCategoryModel.h"
#import "SearchCategoryDetailModel.h"
#import "SearchDetailTableViewCell.h"
#import "SearchResultViewController.h"

#import "SearchResultModel.h"

//头视图
#import "SearchHeadView.h"

//单元格内子视图间距
#define  SUBVIEW_SPACE 10.0f * scale_screen

#define  CELL_HEIGHT 85.0f * scale_screen

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,SearchCellDelegate,UITextFieldDelegate>
/**
 *  cell开启状态数据
 */
@property (strong, nonatomic) NSMutableArray *isOpenStatus;
/**
 *  cell中选中文字容器
 */
@property (strong, nonatomic) NSMutableArray <NSString *> * cellSelectedName;
/**
 *  表格头视图
 */
@property (strong, nonatomic) SearchHeadView * headView;

/**
 *  存放数据容器
 */
@property (strong, nonatomic) NSMutableArray * searchDataArray;
/**
 *  搜索文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

/**
 *  搜索按钮点击
 */
- (IBAction)SearchBtnClick;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏左侧按钮
    [self leftNavItem];
    
    //背景色
    [self setBgColor];
    
    //处理plist文件
    [self loadDataWithPlist];
    
    //布局
    [self createLayout];

}

#pragma mark - 处理plist文件

- (void)loadDataWithPlist {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"SearchCategorys" ofType:@"plist"];
    NSDictionary * plistDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //解析数据
    for (int i = 0; i < [plistDic[@"order_titles"] count]; i++) {
        NSString * currentDicName = plistDic[@"order_titles"][i];
        NSDictionary * currentDic = plistDic[currentDicName];
        
        //建立模型
        SearchCategoryModel * cModel = [SearchCategoryModel new];
        [cModel setValuesForKeysWithDictionary:currentDic];
        [self.searchDataArray addObject:cModel];
        
    }
    
    //刷新表格
    [self.searchTableView reloadData];
}


#pragma mark -  布局
- (void)createLayout {
    
    //头视图
    self.headView = [[SearchHeadView alloc] initHeadViewWithFrame:CGRectMake(0, 0, screen_Width, screen_Height / 5)];
    
    //回调tap点击事件
    __weak SearchViewController * weakSelf = self;
    [self.headView setCloseBtnClick:^(NSString * tapStr) {
        
        [weakSelf closeBtnClickWithName:tapStr];
    }];
    
    self.searchTableView.tableHeaderView = self.headView;
    //注册tableview  cell
    [self.searchTableView registerNib:[UINib nibWithNibName:@"SearchDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellReuseIdentifier"];
    
    //底部搜索框
    [self.view bringSubviewToFront:self.bottomSearchView];
    
    //设置搜索背景图片拉伸
    UIButton * btn = (UIButton *)[self.bottomSearchView.subviews objectAtIndex:1];
    if ([btn respondsToSelector:@selector(setBackgroundImage:forState:)]) {
        [btn setBackgroundImage:[imageStar(@"search_inputview") stretchableImageWithLeftCapWidth:40.0f topCapHeight:0] forState:UIControlStateNormal];
    }
    
    //背景色
    [self.bottomSearchView setBackgroundColor:[UIColor colorWithPatternImage:imageStar(@"homeview_bg")]];
//    [self.bottomSearchView setBackgroundColor:[UIColor blueColor]];
    
    //监听键盘弹起通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.isOpenStatus[section] boolValue] ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    SearchDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuseIdentifier"];
    cell.delegate = self;
    cell.currentSelectedItemName = self.cellSelectedName[indexPath.section];
    cell.modelArray = (NSArray *)[self.searchDataArray[indexPath.section] data];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 保存单元格状态
}

//返回头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [self createSectionViewWithTag:100 + section Title:[self.searchDataArray[section] title]];
}


- (NSMutableArray *)isOpenStatus {
    
    
    if (!_isOpenStatus) {
        
        _isOpenStatus = [@[] mutableCopy];
        for ( int i = 0; i < 5; i++) {
            
            if (i == 0) { //默认第一个打开
                [_isOpenStatus addObject:[NSNumber numberWithBool:YES]];
            }
            else{
                [_isOpenStatus addObject:[NSNumber numberWithBool:NO]];
            }
            
        }
    }
    
    return _isOpenStatus;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - sectionView

/**
 *  工厂模式创建头视图
 *
 *  @param tag   tag
 *  @param title 标题
 *
 *  @return 工厂模式创建头视图
 */
-(UIButton *)createSectionViewWithTag:(NSInteger)tag Title:(NSString *)title {
    
    UIButton * headViewBtn = [MyCustomView createButtonWithFrame:CGRectMake(0, 0, self.searchTableView.frame.size.width, 35)
                                                          target:self SEL:@selector(sectionBtnClick:)
                                                 backgroundImage:imageStar(@"search_section_bg")
                                                           title:title
                                                    forwardImage:nil];
    headViewBtn.titleLabel.font = fontSize14;
    [headViewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headViewBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [headViewBtn setBackgroundImage:imageStar(@"search_section_bg_hl") forState:UIControlStateSelected];
    headViewBtn.tag = tag;
    headViewBtn.selected = [self.isOpenStatus[tag - 100] boolValue];
    return headViewBtn;
}

#pragma mark -  分组标题点击事件
- (void)sectionBtnClick:(UIButton *)btn{
    //得到点击分组头视图下标
    NSInteger currentIndex = btn.tag - 100;
    
    BOOL isOpen = [self.isOpenStatus[currentIndex] boolValue];
    
    if (currentIndex >=0 && currentIndex < self.isOpenStatus.count) {
        
        //关闭其他组
        for (NSNumber * bookNumber in [self.isOpenStatus copy]) {
            if ([bookNumber boolValue]) { //开启状态
                
                //当前下标
                NSInteger cIndex = [self.isOpenStatus indexOfObject:bookNumber];
                
                btn.selected = NO;
                //关闭状体啊
                [self.isOpenStatus replaceObjectAtIndex:cIndex withObject:[NSNumber numberWithBool:NO]];
                
                //关闭单元格
                [self.searchTableView reloadSections:[NSIndexSet indexSetWithIndex:cIndex] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
        //修改当前分组开启状态
        [self.isOpenStatus replaceObjectAtIndex:currentIndex withObject:[NSNumber numberWithBool:!isOpen]];
        
        //选中状态
        btn.selected = YES;
        
        //关闭单元格
        [self.searchTableView reloadSections:[NSIndexSet indexSetWithIndex:currentIndex] withRowAnimation:UITableViewRowAnimationFade];
       
    }
}

#pragma mark - lazy init

- (NSMutableArray *)searchDataArray {
    if (!_searchDataArray) {
        _searchDataArray = [@[] mutableCopy];
    }
    return _searchDataArray;
}

- (NSMutableArray *)cellSelectedName {
    if (!_cellSelectedName) {
        _cellSelectedName = [@[] mutableCopy];
        
        for ( int i = 0 ; i < 5; i++) {
            //默认名字为空
            [_cellSelectedName addObject:@""];
        }
    }
    return _cellSelectedName;
}
#pragma mark - delegate 单元格内button点击事件

- (void)cellBtnClickWithBtnName:(NSString *)name andCell:(UITableViewCell *)cell {
    
//    //当前cell组index
    NSInteger section = [[self.searchTableView indexPathForCell:cell] section];
    
//    //判断标签是否已经存在
    if ([self.headView checkIsExsitAtSupViewWithName:name]) {
        //已存在
        return;
    }
    
//    //判断该组是否已经有元素点击，有则替换
    if ([[self.cellSelectedName objectAtIndex:section] length]) { //存在
        
        //替换已存在button名为新添加button名
        [self.headView replaceBtnName:name withSectionGroup:self.cellSelectedName andSection:section];
    }
    else{
        //添加新标签
        [self.headView addTapBtnWithName:name];
    }

    
    //保存当前点击button名到cellSelectedName
    
    [self.cellSelectedName replaceObjectAtIndex:section withObject:name];
}

#pragma mark - closeBtnClick

//标签关闭事件
- (void)closeBtnClickWithName:(NSString *)tapStr{
    
    for (NSString * str in [self.cellSelectedName copy]) {
        if ([str isEqualToString: tapStr]) { //找到该标签
            NSInteger section = [self.cellSelectedName indexOfObject:str];
            [self.cellSelectedName replaceObjectAtIndex:section withObject:@""];
            
            
            //关闭其他组
            for (NSNumber * bookNumber in [self.isOpenStatus copy]) {
                if ([bookNumber boolValue]) { //开启状态
                    
                    //当前下标
                    NSInteger cIndex = [self.isOpenStatus indexOfObject:bookNumber];
                    
                    //关闭状态
                    [self.isOpenStatus replaceObjectAtIndex:cIndex withObject:[NSNumber numberWithBool:NO]];
                    
                    //关闭单元格
                    [self.searchTableView reloadSections:[NSIndexSet indexSetWithIndex:cIndex] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            //开启当前cell
            [self.isOpenStatus replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:YES]];
            
            //刷新表格
            //关闭单元格
            [self.searchTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
    }
}

#pragma mark - textField delegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

#pragma mark - 通知中心。键盘弹起

- (void)keyBoardShow : (NSNotification *)notification{
    
    if (self.searchTextField.isFirstResponder) {
        
        CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

        CGRect searchViewFrame = self.bottomSearchView.frame;
        
        NSLog(@"%@",NSStringFromCGRect(searchViewFrame));
        searchViewFrame.origin.y -= keyBoardRect.size.height;
        searchViewFrame.origin.y += 49;
        UIButton * btn = self.bottomSearchView.subviews[1];
        if (btn.selected) {
            return;
        }
        btn.selected = YES;
        self.bottomSearchView.frame = searchViewFrame;
    }
    
}

#pragma mark - 通知中心。 键盘回收
- (void)keyBoardHidden:(NSNotification *)notification {
    [self.searchTextField becomeFirstResponder];
    
    CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect searchViewFrame = self.bottomSearchView.frame;
    searchViewFrame.origin.y += keyBoardRect.size.height ;
    searchViewFrame.origin.y -= 49;
    
    self.bottomSearchView.frame = searchViewFrame;
    UIButton * btn = self.bottomSearchView.subviews[1];
    btn.selected = NO;
}

#pragma mark - 搜索按钮点击

- (IBAction)SearchBtnClick {
    
    [self.view endEditing:YES];
    NSString * searchKey = self.searchTextField.text;

    NSMutableString * requestUrl = [@"" mutableCopy];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"SearchCategorys" ofType:@"plist"];
    NSDictionary * plistDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    for (int i = 0 ; i < self.cellSelectedName.count; i++) {
        NSString * cStr = [self.cellSelectedName objectAtIndex:i];
        if (i == 0 && cStr.length) {
            cStr = [cStr stringByAppendingString:@"菜"];
        }
        [requestUrl appendFormat:@"&%@=%@",plistDic[@"order_titles"][i],cStr];
    }
    
    //拼接url
    NSString  * urlStr = [NSString stringWithFormat:
                          @"%@"
                          "%@"
                          "&name=%@"
                          "&user_id=0"
                          "&is_traditional=0"
                          "&page=1"
                          "&pageRecord=10"
                          "&is_traditional=0"
                          "&phonetype=1",URL_VEGETABLE_INFO,requestUrl,searchKey];
    //网络请求
    
    __weak SearchViewController *weakSelf = self;
    
    [self loadDataByUrl:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] withdataBlock:^(id successData) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        
        //有结果
        if ([jsonObj[@"status"] isEqualToString:@"0"]) {
            
            NSMutableArray * resultArray = [@[] mutableCopy];
            for (NSDictionary * dic in jsonObj[@"data"]) {
                SearchResultModel * model = [[SearchResultModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [resultArray addObject:model];
            }
        
            
            SearchResultViewController * svc = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
            
            if ([svc isKindOfClass:[SearchResultViewController class]]) {
                
                [svc setTitle:@"搜索结果"];
                svc.dataArray = resultArray;
                
                if (self.searchTextField.text) {
                    svc.orderName = self.searchTextField.text;
                }
                svc.keysArray = self.cellSelectedName;
                svc.urlStr = urlStr;
                [weakSelf.navigationController pushViewController:svc animated:YES];
            }
           
            
        }
        else{
            [self showMyAlertView:jsonObj[@"message"]];
        }
        
    } withFailure:^(NSError *error) {
        [self showMyAlertView:@"网络请请求失败"];
        NSLog(@"%@",error);
    }];
}
@end
