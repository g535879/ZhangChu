//
//  CustomScrollView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "CustomScrollView.h"
#import "CookBookAdModel.h"

@interface CustomScrollView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView * leftImageView;
@property (strong, nonatomic) UIImageView * centerImageView;
@property (strong, nonatomic) UIImageView * rightImageView;
@property (strong, nonatomic) UIPageControl * pageControl;
@property (strong, nonatomic) UIScrollView * scrollView; //滚动视图
@property (assign, nonatomic) float viewWidth;       //视图宽度
@property (assign, nonatomic) float viewHeight;    //视图高度
@property (assign, nonatomic) NSInteger currentPicIndex; //当前图片下标
@property (strong, nonatomic) NSTimer * autoRunTimer; //自动滚动定时器
@end

@implementation CustomScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        [self createLayout];
    }
    return self;
}

#pragma mark - 布局
- (void)createLayout {
    
    //滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(self.viewWidth, 0);
    self.scrollView.contentSize = CGSizeMake(self.viewWidth * 3, self.viewHeight);
    
    [self addSubview:self.scrollView];
    
    //scrollview contentView
    self.leftImageView = [self customImageViewWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight) WithTag:1000];
    [self.scrollView addSubview:self.leftImageView];
    
    self.centerImageView = [self customImageViewWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight) WithTag:1001];
    [self.scrollView addSubview:self.centerImageView];
    
    self.rightImageView = [self customImageViewWithFrame:CGRectMake(self.viewWidth*2, 0, self.viewWidth, self.viewHeight) WithTag:1002];
    [self.scrollView addSubview:self.rightImageView];
    
    //pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.viewHeight-40, self.viewWidth, 40)];
    
    self.pageControl.defersCurrentPageDisplay = NO;
    [self addSubview:self.pageControl];
    
}

#pragma mark - 工厂模式生成imageView
- (UIImageView *)customImageViewWithFrame:(CGRect)frame WithTag:(NSInteger)tag{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictouch:)]];
    imageView.tag = tag;
    imageView.userInteractionEnabled = YES;
    return imageView;
}


#pragma mark - 图片点击手势
- (void)pictouch:(UITapGestureRecognizer *)gestrue {
    
    if (gestrue.state == UIGestureRecognizerStateEnded) {
        //TODO ..
    }
}

#pragma mark - 属性赋值相关
- (void)setImagesArray:(NSArray *)imagesArray {
    if (_imagesArray) {
        _imagesArray = nil;
    }
    
    _imagesArray = [imagesArray mutableCopy];
    
    if (_imagesArray) {
        //pagecontrol 总数赋值
        self.pageControl.numberOfPages = self.imagesArray.count;
        
        //显示
        [self initLayout];
    }
}


- (NSTimer *)autoRunTimer {
    
    if (!_autoRunTimer || !_autoRunTimer.isValid) {
        
        _autoRunTimer = nil;
        
        _autoRunTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(netxPhoto) userInfo:nil repeats:YES];
        [_autoRunTimer setFireDate:[NSDate distantFuture]];
    }
    
    return _autoRunTimer;
}


#pragma mark - nextPhoto 
- (void)netxPhoto {
    
//    @synchronized(self) {
//        
//       
//    }
    
    [UIView animateWithDuration:1.0f animations:^{
        
        self.scrollView.contentOffset = CGPointMake(self.viewWidth * 2, 0);
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            self.currentPicIndex = [self getQuerePicIndex:self.currentPicIndex + 1];
            self.scrollView.contentOffset = CGPointMake(self.viewWidth, 0);
            [self updateImage];
        }
    }];

    
}

#pragma mark - 初始化显示
- (void)initLayout {
    
    self.currentPicIndex = 0;
    
    [self updateImage];
    
    [self performSelector:@selector(startScroll) withObject:nil afterDelay:5.0f];
    
}
#pragma mark -  update image
//更新图片
- (void)updateImage {
    
    if (!self.imagesArray.count) {
        return;
    }
    CookBookAdModel * leftModel = self.imagesArray[[self getQuerePicIndex:self.currentPicIndex-1]];
    CookBookAdModel * centerModel = self.imagesArray[[self getQuerePicIndex:self.currentPicIndex]];
    CookBookAdModel * rightModel = self.imagesArray[[self getQuerePicIndex:self.currentPicIndex+1]];
    
    [self.leftImageView setImageWithURL:[NSURL URLWithString:leftModel.imageFilename]];
    [self.centerImageView setImageWithURL:[NSURL URLWithString:centerModel.imageFilename]];
    [self.rightImageView setImageWithURL:[NSURL URLWithString:rightModel.imageFilename]];
    
    //pageControl当前页
    self.pageControl.currentPage = self.currentPicIndex;
}

//返回图片循环下标
- (NSInteger)getQuerePicIndex:(NSInteger) picIdx {
    
    if (!self.imagesArray.count) {
        
        return self.currentPicIndex;
    }
    
    return (picIdx + self.imagesArray.count) % (self.imagesArray.count);
}


#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    CGFloat offsetY = scrollView.contentOffset.x;
    
    if (fabs(offsetY-self.viewWidth) < self.viewWidth / 2) { //偏移量小于一半
        
        //检测是否需要开启定时器
        [self performSelector:@selector(startScroll) withObject:nil afterDelay:5.0f];
        return;
    }
    
    if (offsetY > self.viewWidth) {  //往右滑动
        
        self.currentPicIndex = [self getQuerePicIndex:self.currentPicIndex + 1];
    }else{
        self.currentPicIndex = [self getQuerePicIndex:self.currentPicIndex - 1];
    }
    
    
    [self.scrollView setContentOffset:CGPointMake(self.viewWidth, 0)];
    //更新图片
    [self updateImage];
    
    //检测是否需要开启定时器
   [self performSelector:@selector(startScroll) withObject:nil afterDelay:5.0f];
    
    
}

//用户拖拽。暂停计时器
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    //暂停定时器
    [self.autoRunTimer invalidate];
    self.autoRunTimer = nil;
}

#pragma mark - 开始自动滚动

- (void)startScroll{
    
    if (self.isAutoScroll) {
        
        [self.autoRunTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)dealloc {
    
    NSLog(@"delloc");
    //销毁定时器
    [self.autoRunTimer invalidate];
}
@end
