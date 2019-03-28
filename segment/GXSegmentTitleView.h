//
//  GXSegmentTitleView.h
//  ScrollDemo
//
//  Created by 孙树琪 on 2019/3/12.
//  Copyright © 2019年 琪琪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXSegmentTitleView;

typedef enum : NSUInteger {
    GXIndicatorTypeDefault,//默认与按钮长度相同
    GXIndicatorTypeEqualTitle,//与文字长度相同
    GXIndicatorTypeNone,
} GXIndicatorType;//指示器类型枚举

@protocol GXSegmentTitleViewDelegate <NSObject>

@optional

/**
 切换标题
 
 @param titleView GXSegmentTitleView
 @param startIndex 切换前标题索引
 @param endIndex 切换后标题索引
 */
- (void)GXSegmentTitleView:(GXSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GXSegmentTitleView : UIView

@property (nonatomic, weak) id<GXSegmentTitleViewDelegate>delegate;

/**
 标题文字间距，默认20
 */
@property (nonatomic, assign) CGFloat itemMargin;

/**
 当前选中标题索引，默认0
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 标题字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 标题选中字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleSelectFont;

/**
 标题正常颜色，默认black
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 标题选中颜色，默认red
 */
@property (nonatomic, strong) UIColor *titleSelectColor;

/**
 指示器颜色，默认与titleSelectColor一样,在GXIndicatorTypeNone下无效
 */
@property (nonatomic, strong) UIColor *indicatorColor;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) NSArray *titlesArr;


/**
 对象方法创建GXSegmentTitleView
 
 @param frame frame
 @param titlesArr 标题数组
 @param delegate delegate
 @param incatorType 指示器类型
 @return GXSegmentTitleView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<GXSegmentTitleViewDelegate>)delegate indicatorType:(GXIndicatorType)incatorType;

@end

NS_ASSUME_NONNULL_END
