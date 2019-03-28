//
//  GXPageContentView.m
//  ScrollDemo
//
//  Created by 孙树琪 on 2019/3/12.
//  Copyright © 2019年 琪琪. All rights reserved.
//

#import "GXPageContentView.h"
#import "PrivilegeViewController.h"
#import "AudioHelp.h"
#import "AppDelegate.h"
#import "PrivilegeOneViewController.h"
#import "PrivilegeTwoViewController.h"
#import "PrivilegeThreeViewController.h"
#import "PrivilegeFourViewController.h"

static NSString *collectionCellIdentifier = @"collectionCellIdentifier";
@interface GXPageContentView()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, weak) UIViewController *parentVC;//父视图
@property (nonatomic, strong) NSArray *childsVCs;//子视图数组
@property (nonatomic, assign) CGFloat startOfGXetX;
@property (nonatomic, assign) BOOL isSelectBtn;//是否是滑动
@property (nonatomic, assign) BOOL isPush;

@end

@implementation GXPageContentView

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<GXPageContentViewDelegate>)delegate isPush:(BOOL)isPush isVip:(BOOL)isVip dataArr:(nonnull NSArray *)dataArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.isPush = isPush;
        self.isVip = isVip;
        self.parentVC = parentVC;
        self.childsVCs = childVCs;
        self.delegate = delegate;
        self.dataArr = dataArr;
        [self setupSubViews];
        
        //通知中心是个单例
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        
        // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
        [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"PrivilegeShow" object:nil];
        
    }
    return self;
}
- (void)receiveNotification:(NSNotification *)noti
{
    
    NSArray *sizes = [noti.object componentsSeparatedByString:@","];

    if (self.delegate && [self.delegate respondsToSelector:@selector(GXContenViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate GXContenViewDidEndDecelerating:self startIndex:[[sizes firstObject] integerValue] endIndex:[[sizes lastObject] integerValue]];
    }
    // NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
    NSLog(@"%@ === %@ === %@", noti.object, noti.userInfo, noti.name);
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark --LazyLoad

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark --setup
- (void)setupSubViews{
    _startOfGXetX = 0;
    _isSelectBtn = NO;
    _contentViewCanScroll = YES;
    
    for (UIViewController *childVC in self.childsVCs) {
        [self.parentVC addChildViewController:childVC];
    }
    //    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
}

- (void)setIsVip:(BOOL)isVip{
    if (_isVip != isVip) {
        _isVip = isVip;
        [self.collectionView reloadData];
    }
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childsVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];

    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVC = self.childsVCs[indexPath.item];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *childVc = self.childsVCs[indexPath.row];
//    PrivilegeViewController *vc = (PrivilegeViewController *)childVc;
    NSLog(@"%@",childVc.view);
    NSLog(@"%@",childVc.view);
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([childVc isKindOfClass:[PrivilegeOneViewController class]]) {
        PrivilegeOneViewController *vc = (PrivilegeOneViewController *)childVc;
        vc.view.frame = cell.contentView.bounds;
        vc.dic = self.dataArr[indexPath.row];
        NSLog(@"%ld",(long)indexPath.row);
        if (self.isPush) {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - widthWith6(60) - app.safeBottom);
                
            }
            
        } else {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds) - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)- widthWith6(60) - app.safeBottom);
                
            }
            
        }
//        vc.tableView.contentOffset = self.currentOffSet;
        [vc.tableView reloadData];
    } else if ([childVc isKindOfClass:[PrivilegeTwoViewController class]]) {
        PrivilegeTwoViewController *vc = (PrivilegeTwoViewController *)childVc;
        vc.view.frame = cell.contentView.bounds;
        vc.dic = self.dataArr[indexPath.row];
        NSLog(@"%ld",(long)indexPath.row);
        if (self.isPush) {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - widthWith6(60) - app.safeBottom);
                
            }
            
        } else {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds) - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)- widthWith6(60) - app.safeBottom);
                
            }
            
        }
//        vc.tableView.contentOffset = self.currentOffSet;
[vc.tableView reloadData];
    }else if ([childVc isKindOfClass:[PrivilegeThreeViewController class]]) {
        PrivilegeThreeViewController *vc = (PrivilegeThreeViewController *)childVc;
        vc.view.frame = cell.contentView.bounds;
        vc.dic = self.dataArr[indexPath.row];
        NSLog(@"%ld",(long)indexPath.row);
        if (self.isPush) {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - widthWith6(60) - app.safeBottom);
                
            }
            
        } else {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds) - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)- widthWith6(60) - app.safeBottom);
                
            }
            
        }
        vc.tableView.contentOffset = self.currentOffSet;
        [vc.tableView reloadData];
    }else if ([childVc isKindOfClass:[PrivilegeFourViewController class]]) {
        PrivilegeFourViewController *vc = (PrivilegeFourViewController *)childVc;
        vc.view.frame = cell.contentView.bounds;
        vc.dic = self.dataArr[indexPath.row];
        NSLog(@"%ld",(long)indexPath.row);
        if (self.isPush) {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)  - widthWith6(60) - app.safeBottom);
                
            }
            
        } else {
            if (self.isVip) {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds) - app.safeBottom);
                
            } else {
                vc.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(vc.view.bounds), CGRectGetHeight(vc.view.bounds)- widthWith6(60) - app.safeBottom);
                
            }
            
        }
//        vc.tableView.contentOffset = self.currentOffSet;
        [vc.tableView reloadData];
    }
    
    [cell.contentView addSubview:childVc.view];
}

#pragma mark UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isSelectBtn = NO;
    _startOfGXetX = scrollView.contentOffset.x;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GXContentViewWillBeginDragging:contentOffSet:)]) {
        [self.delegate GXContentViewWillBeginDragging:self contentOffSet:scrollView.contentOffset];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_isSelectBtn) {
        return;
    }
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOfGXetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOfGXetX/scrollView_W);
    NSInteger endIndex;
    CGFloat progress;
    if (currentOfGXetX > _startOfGXetX) {//左滑left
        progress = (currentOfGXetX - _startOfGXetX)/scrollView_W;
        endIndex = startIndex + 1;
        if (endIndex > self.childsVCs.count - 1) {
            endIndex = self.childsVCs.count - 1;
        }
    }else if (currentOfGXetX == _startOfGXetX){//没滑过去
        progress = 0;
        endIndex = startIndex;
    }else{//右滑right
        progress = (_startOfGXetX - currentOfGXetX)/scrollView_W;
        endIndex = startIndex - 1;
        endIndex = endIndex < 0?0:endIndex;
    }
    progress = (scrollView.contentOffset.x/Main_Screen_Width);
    if (self.delegate && [self.delegate respondsToSelector:@selector(GXContentViewDidScroll:startIndex:endIndex:progress:contentOffSet:)]) {
        [self.delegate GXContentViewDidScroll:self startIndex:startIndex endIndex:endIndex progress:progress contentOffSet:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollView_W = scrollView.bounds.size.width;
    CGFloat currentOfGXetX = scrollView.contentOffset.x;
    NSInteger startIndex = floor(_startOfGXetX/scrollView_W);
    NSInteger endIndex = floor(currentOfGXetX/scrollView_W);
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GXContenViewDidEndDecelerating:startIndex:endIndex:)]) {
        [self.delegate GXContenViewDidEndDecelerating:self startIndex:startIndex endIndex:endIndex];
    }
}

#pragma mark setter

- (void)setContentViewCurrentIndex:(NSInteger)contentViewCurrentIndex{
    if (_contentViewCurrentIndex < 0||_contentViewCurrentIndex > self.childsVCs.count-1) {
        return;
    }
    _isSelectBtn = YES;
    _contentViewCurrentIndex = contentViewCurrentIndex;
    if (self.isAnimation) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:contentViewCurrentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    }else{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:contentViewCurrentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

    }
}

- (void)setContentViewCanScroll:(BOOL)contentViewCanScroll{
    _contentViewCanScroll = contentViewCanScroll;
    _collectionView.scrollEnabled = _contentViewCanScroll;
}

- (void)dealloc
{
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
