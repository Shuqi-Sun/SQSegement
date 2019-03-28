//
//  GXPageContentView.h
//  ScrollDemo
//
//  Created by 孙树琪 on 2019/3/12.
//  Copyright © 2019年 琪琪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXPageContentView;

@protocol GXPageContentViewDelegate <NSObject>

@optional

/**
 GXPageContentView开始滑动
 
 @param contentView GXPageContentView
 */
- (void)GXContentViewWillBeginDragging:(GXPageContentView *)contentView contentOffSet:(CGPoint)contentOffSet;

/**
 GXPageContentView滑动调用
 
 @param contentView GXPageContentView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)GXContentViewDidScroll:(GXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress contentOffSet:(CGPoint)contentOffSet;

/**
 GXPageContentView结束滑动
 
 @param contentView GXPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)GXContenViewDidEndDecelerating:(GXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GXPageContentView : UIView

/**
 对象方法创建GXPageContentView
 
 @param frame frame
 @param childVCs 子VC数组
 @param parentVC 父视图VC
 @param delegate delegate
 @return GXPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<GXPageContentViewDelegate>)delegate isPush:(BOOL)isPush isVip:(BOOL)isVip dataArr:(NSArray *)dataArr;

@property (nonatomic, weak) id<GXPageContentViewDelegate>delegate;

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 
 
 */

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL contentViewCanScroll;

@property (nonatomic, assign) BOOL isVip;

@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, assign) CGPoint currentOffSet;

@property (nonatomic, strong) NSArray *dataArr;


@end

NS_ASSUME_NONNULL_END
