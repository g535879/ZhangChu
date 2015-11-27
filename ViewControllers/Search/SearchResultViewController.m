//
//  SearchResultViewController.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/27.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "SearchResultViewController.h"
#import "UIAlertView+Blocks.h"
#import "SearchResultModel.h"
#import "SearchResultCollectionViewCell.h"

@interface SearchResultViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**
 *  当前页
 */
@property (assign, nonatomic) NSInteger currentPageIndex;
/**
 *  搜索词
 */

@property (weak, nonatomic) IBOutlet UILabel *searhKeyLabel;

/**
 *  滚动视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBgColor];
    
    [self leftNavItem];
    
    //拼接搜索词标签栏
    [self setKeysTitle];
    
    //布局
    [self createLayout];
    
    //当前页
    self.currentPageIndex = 1;


    
    
}


- (void)setKeysTitle {
    
    //搜索词拼接
    if (self.keysArray) {
        NSMutableString * keyStr = [NSMutableString stringWithFormat:@"%@",_orderName.length ? [NSString stringWithFormat:@"%@ 搜索组合:",_orderName] : @"搜索组合: "];
        
        for (int i = 0; i < self.keysArray.count; i++) {
            NSString * cStr = self.keysArray[i];
            if (cStr.length) {
                if (i == 0) {
                    cStr = [cStr stringByAppendingString:@"菜 "];
                }
                [keyStr appendString:[NSString stringWithFormat:@"%@ ",cStr]];
            }
            
        }
        
        self.searhKeyLabel.text = keyStr;
    }
}

#pragma mark - 布局
- (void)createLayout {
   
//    //注册cell
    [self.searchCollectionView registerNib:[UINib nibWithNibName:@"SearchResultCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellReuseId"];
//
    
    //设置刷新控件
    [self setrefresh];
    
}


#pragma mark - loadData

- (void)loadData {
    
    if (self.currentPageIndex == 1) { //下拉刷新
        [self.dataArray removeAllObjects];
    }
    
    self.urlStr = [RegHelper replaceGivenStr:self.urlStr withStr:[NSString stringWithFormat:@"%ld",self.currentPageIndex] withPattern:@"(?<=page=).*?(?=&)"];

    [self loadDataByUrl:[self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]withdataBlock:^(id successData) {
        
        //结束刷新
        [self endrefresh];
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:successData options:NSJSONReadingMutableContainers error:nil];
        
        //有结果
        if ([jsonObj[@"status"] isEqualToString:@"0"]) {
            
            for (NSDictionary * dic in jsonObj[@"data"]) {
                SearchResultModel * model = [[SearchResultModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            [self.searchCollectionView reloadData];
        }
        else{
            [self showMyAlertView:@"已经没有更多数据"];
        }
        
    } withFailure:^(NSError *error) {
        //结束刷新
        [self endrefresh];
        
        [self showMyAlertView:@"加载数据失败 ！"];
        NSLog(@"error");
    }];
}

#pragma mark - 刷新控件
- (void)setrefresh {
    

    self.searchCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.currentPageIndex = 1;
        [self loadData];
        
    }];
    
    self.searchCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.currentPageIndex++;
        [self loadData];
    }];

}


#pragma mark -  collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellId = @"cellReuseId";
    
    SearchResultCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    SearchResultModel * model = self.dataArray[indexPath.row];
    [cell.cookImageView setImageWithURL:[NSURL URLWithString:model.imagePathThumbnails]];
    [cell.cookName setText:model.name];
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((screen_Width - 30 ) / 2, 2 * (screen_Width - 30 ) / 6);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 关闭控件刷新
- (void)endrefresh {
    
    [self.searchCollectionView.header endRefreshing];
    [self.searchCollectionView.footer endRefreshing];
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
