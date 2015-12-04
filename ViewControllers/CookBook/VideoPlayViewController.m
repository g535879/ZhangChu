//
//  VideoPlayViewController.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/28.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "PlayMovieView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MovieDetailModel.h"
#import "CommentView.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "PlayerSectionHeaderView.h"

@interface VideoPlayViewController ()<UITableViewDataSource,UITableViewDelegate,sectionDelegate>

/**
 *  播放视频对象
 */
@property (strong, nonatomic) MPMoviePlayerController * playerMovieController;

/**
 *  顶部视频播放控件
 */
@property (strong, nonatomic) PlayMovieView * playMovieView;

/**
 *  底部评论视图
 */
@property (strong, nonatomic) CommentView * commentView;

/**
 *  表格视图
 */
@property (strong, nonatomic) UITableView * infoTableView;

/**
 *  数据对象
 */
@property (strong, nonatomic) MovieDetailModel * detailModel;
/**
 *  tableview 数据源
 */
@property (strong, nonatomic) NSMutableArray * dataArray;
/**
 *  tableview 分组名
 */
@property (copy, nonatomic) NSArray * sectionTitleArray;
/**
 *  tableview分组点击状态
 */
@property (copy, nonatomic) NSMutableArray * sectionStateArray;

/**
 *  数据库管理对象
 */
@property (copy,nonatomic) DBManager * dbManager;
@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏相关
    [self setnaVigationRefer];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //监听视频加载通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieWillPlay)
                                                 name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                               object:nil];
    
    //监听视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieDidFinish)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    //监听键盘弹起事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardUp:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //监听键盘回收事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardDown:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //监听将要全屏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieWillFull)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:nil];
    //监听将要退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieWillExitFull)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    
    
//    [self createPlayMovieUI];
    //加载数据
    [self loadData];
}


#pragma mark - 视频加载完成
- (void)movieWillPlay {
    
    //隐藏加载框
    [self.hud dismiss];
}

#pragma mark - 播放结束通知
- (void)movieDidFinish{
    
    //显示视频缩略图
    [self.playMovieView showbgImageView];
    
    //隐藏视频播放器
    self.playerMovieController.view.hidden = YES;
}

//视频将要全屏
- (void)movieWillFull {
    AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.allowRotation = YES;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

//视频将要退出全屏
- (void)movieWillExitFull {
    
}

#pragma mark - loadData 
- (void)loadData {
    [self loadDataByUrl:[NSString stringWithFormat:@"%@vegetable_id=%@&user_id=0&is_traditional=0&phonetype=1",URL_VEGETABLE_DETAIL_INFO,self.vegetableId] withdataBlock:^(id successData) {
        
        //布局
        [self createPlayMovieUI];
        
        //显示播放按钮
        [self.playMovieView showbgImageView];
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        
        if ([jsonObj[@"status"] isEqualToString:@"0"]) {
            
            [self.detailModel setValuesForKeysWithDictionary:[jsonObj[@"data"] firstObject]];
        }
        else{
            //提示错信信息
            [self showMyAlertView:jsonObj[@"message"]];
        }
    } withFailure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showMyAlertView:@"获取视频数据失败"];
    }];
    
    
    //加载制作方法相关数据
    /*
     选择的菜谱的对应信息
     
     vegetable_id       菜谱ID
     type               1，所需原料。2.制作步骤。3.相宜。4.相关常识
     
     
     固定参数：
     phonetype=0
     is_traditional=0
     */
#define URL_VEGETABLE_DETAIL @"/HandheldKitchen/api/vegetable/tblvegetable!getIntelligentChoice.do?"
    
    __weak VideoPlayViewController * weadSelf = self;
    
    for (int i = 0; i < self.sectionTitleArray.count-1; i++) {
        
        //加载数据
        [self loadDataByUrl:[NSString stringWithFormat:@"%@vegetable_id=%@&type=%@&phonetype=0&is_traditional=0",URL_VEGETABLE_DETAIL,self.vegetableId,[NSString stringWithFormat:@"%d",i+1]] withdataBlock:^(id successData) {
            
            id josonObj = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@",josonObj);
        } withFailure:^(NSError *error) {
            
            [weadSelf showMyAlertView:@"加载数据出错"];
            NSLog(@"%@",error);
        }];
        
    }
}

#pragma mark - createPlayMovieUI 

- (void)createPlayMovieUI {
    
    //视频播放器
    self.playMovieView = [[PlayMovieView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 200 * scale_screen + 35 * scale_screen) andButtonBgImageUrl:self.imageUrl vegatablesId:self.vegetableId withMovieButtonBlock:^(UIButton *btn){
        
        btn.hidden = YES;
        
        //显示播放器
        self.playerMovieController.view.hidden = NO;
        //播放视频
        [self.playerMovieController play];
        
        
        if (!self.playerMovieController.readyForDisplay) {
            //显示加载框
            [self.hud showInView:self.playerMovieController.view];
        }
        
        
    } andThreeButtonBlock:^(UIButton *btn) {
        
        switch (btn.tag - 500) {
            case 0: {
                
                //查询是否已收藏
                CookBookDetailModel * model = [CookBookDetailModel new];
                model.vegetable_id = self.vegetableId;
                model.imagePathThumbnails = self.imageUrl;
                model.name = self.videoName;
                NSString * stateTitle;
                if ([[self.dbManager selectDataByModel:model] count]) { //有数据。已收藏
                    //取消收藏
                    [self.dbManager deleteDataWithModel:model];
                    //改变按钮状态
                    stateTitle = @"收藏";
                }
                else{
                    //收藏
                    [self.dbManager insertDataWithModel:model];
                    stateTitle = @"已收藏";
                    
                }
                
                //改变按钮状态
                [btn setTitle:stateTitle forState:UIControlStateNormal];
            }
                break;
            case 1 :
                break;
            case 2:
                break;
            default:
                break;
        }
    }];
    [self.view addSubview:self.playMovieView];
    
    //tableview
    
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playMovieView.frame), screen_Width, screen_Height-CGRectGetMaxY(self.playMovieView.frame)-49-64) style:UITableViewStylePlain];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.infoTableView];
    
    
    //底部评论视图
    self.commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, screen_Height-64-49, screen_Width, 49)];
    [self.commentView setBackgroundColor:[UIColor colorWithPatternImage:imageStar(@"homeview_bg")]];
    [self.view addSubview:self.commentView];
}

- (void)setnaVigationRefer {
    //导航栏返回按钮
    [self leftNavItem];
    
    //标题
    self.title = self.videoName;
    
    //导航栏背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 构造方法
- (MovieDetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [MovieDetailModel new];
    }
    return _detailModel;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [@[] mutableCopy];
        
        for ( int i = 0; i < self.sectionTitleArray.count; i++) {
            [_dataArray addObject:[@[] mutableCopy]];
        }
    }
    return _dataArray;
}

- (MPMoviePlayerController *)playerMovieController {
    
    if (!_playerMovieController) {
        
        _playerMovieController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.detailModel.materialVideoPath]];
        
        //覆盖图片所在的位置
        _playerMovieController.view.frame = CGRectMake(0, 0, screen_Width, self.playMovieView.frame.size.height - 35 * scale_screen);
        
        //缩放比例
        self.playerMovieController.scalingMode = MPMovieScalingModeFill;
        
        
        self.playerMovieController.view.hidden = YES;
        
        //保存到视图中
        [self.view addSubview:self.playerMovieController.view];

    }
    
    return _playerMovieController;
}

- (NSArray *)sectionTitleArray {
    
    if (!_sectionTitleArray) {

        _sectionTitleArray = @[@"所需材料",@"制作步骤",@"相关常识",@"相宜相克",@"相关评论"];
    }
    
    return _sectionTitleArray;
}

- (NSMutableArray *)sectionStateArray {
    
    if (!_sectionStateArray) {
        _sectionStateArray = [@[] mutableCopy];
        for ( int i = 0; i < self.sectionTitleArray.count; i++) {
            
            [_sectionStateArray addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return _sectionStateArray;
}
- (DBManager *)dbManager {
    
    if (!_dbManager) {
        _dbManager = [DBManager shareManager];
    }
    return _dbManager;
}
#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return  [self.sectionStateArray[section] boolValue] ? [self.dataArray[section] count] : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlayerSectionHeaderView * headView = [[PlayerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, 50)];
    headView.title = self.sectionTitleArray[section];
    headView.idx = section;
    headView.delegate = self;
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = @"111";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

#pragma mark - 键盘事件

//键盘弹起
- (void)keyBoardUp:(NSNotification *)notification {
    
    CGFloat offsetY = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect commentViewFrame = self.commentView.frame;
    commentViewFrame.origin.y -= offsetY;
    self.commentView.frame = commentViewFrame;
}

//键盘回收
- (void)keyBoardDown:(NSNotification *)notiificaiton {
    
    CGFloat offsetY = [[notiificaiton.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect commentViewFrame = self.commentView.frame;
    commentViewFrame.origin.y += offsetY;
    self.commentView.frame = commentViewFrame;
}

- (void)leftNavItemClick {
    
    [self.playerMovieController stop];
    
    self.playerMovieController = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - section click delegate

- (void)sectionclick:(NSInteger)idx {
    
    BOOL isOpen = [self.sectionStateArray[idx] boolValue];
    //改变分组可点击状态
    [self.sectionStateArray replaceObjectAtIndex:idx withObject:[NSNumber numberWithBool:!isOpen]];
    //刷新分组
    [self.infoTableView reloadSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)dealloc {
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
