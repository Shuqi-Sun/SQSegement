//
//  GXSegmentTitleView.m
//  ScrollDemo
//
//  Created by 孙树琪 on 2019/3/12.
//  Copyright © 2019年 琪琪. All rights reserved.
//

#import "GXSegmentTitleView.h"
#import "AudioHelp.h"

@interface GXSegmentTitleView()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *itemBtnArr;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, assign) GXIndicatorType indicatorType;


@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation GXSegmentTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<GXSegmentTitleViewDelegate>)delegate indicatorType:(GXIndicatorType)incatorType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithProperty];
        self.titlesArr = titlesArr;
        self.delegate = delegate;
        self.indicatorType = incatorType;
    }
    return self;
}
//初始化默认属性值
- (void)initWithProperty
{
    self.itemMargin = 20;
    self.selectIndex = 0;
    self.titleNormalColor = [UIColor blackColor];
    self.titleSelectColor = [UIColor redColor];
    self.titleFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    self.indicatorColor = self.titleSelectColor;
    self.titleSelectFont = self.titleFont;
}
//重新布局frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    if (self.itemBtnArr.count == 0) {
        return;
    }
    CGFloat totalBtnWidth = 0.0;
    UIFont *titleFont = _titleFont;
    
    if (_titleFont != _titleSelectFont) {
        for (int idx = 0; idx < self.titlesArr.count; idx++) {
            UIButton *btn = self.itemBtnArr[idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [GXSegmentTitleView getWidthWithString:self.titlesArr[idx] font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    else
    {
        for (NSString *title in self.titlesArr) {
            CGFloat itemBtnWidth = [GXSegmentTitleView getWidthWithString:title font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    if (totalBtnWidth <= CGRectGetWidth(self.bounds)) {//不能滑动
        CGFloat itemBtnWidth = CGRectGetWidth(self.bounds)/self.itemBtnArr.count;
        CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
        [self.itemBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(idx * itemBtnWidth, 0, itemBtnWidth, itemBtnHeight);
        }];
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.scrollView.bounds));
    }else{//超出屏幕 可以滑动
        CGFloat currentX = 0;
        for (int idx = 0; idx < self.titlesArr.count; idx++) {
            UIButton *btn = self.itemBtnArr[idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [GXSegmentTitleView getWidthWithString:self.titlesArr[idx] font:titleFont] + self.itemMargin;
            CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
            btn.frame = CGRectMake(currentX, 0, itemBtnWidth, itemBtnHeight);
            currentX += itemBtnWidth;
        }
        self.scrollView.contentSize = CGSizeMake(currentX, CGRectGetHeight(self.scrollView.bounds));
    }
    [self moveIndicatorView:YES];
}

- (void)moveIndicatorView:(BOOL)animated
{
    UIFont *titleFont = _titleFont;
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    titleFont = selectBtn.isSelected?_titleSelectFont:_titleFont;
    CGFloat indicatorWidth = [GXSegmentTitleView getWidthWithString:self.titlesArr[self.selectIndex] font:titleFont];
    [UIView animateWithDuration:(animated?0.05:0) animations:^{
        switch (self.indicatorType) {
            case GXIndicatorTypeDefault:
//                self.indicatorView.frame = CGRectMake(selectBtn.center.x - widthWith6(15) , CGRectGetHeight(self.scrollView.bounds) - 2, widthWith6(30), 2);
                break;
            case GXIndicatorTypeEqualTitle:
//                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
//                self.indicatorView.bounds = CGRectMake(0, 0, widthWith6(30), 2);
                break;
            case GXIndicatorTypeNone:
//                self.indicatorView.frame = CGRectZero;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self scrollSelectBtnCenter:animated];
    }];
}

- (void)scrollSelectBtnCenter:(BOOL)animated
{
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    CGRect centerRect = CGRectMake(selectBtn.center.x - CGRectGetWidth(self.scrollView.bounds)/2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    [self.scrollView scrollRectToVisible:centerRect animated:animated];
}


#pragma mark --LazyLoad

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)setProgress:(CGFloat)progress{
//    if (!_progress) {
        _progress = progress;
    
    //   line需要滑动的总共距离 = 70，初始化状态origin.x = 25，滑到最右端时最右侧的坐标 = 135
//    CGFloat off_center = (70.0/ScreenW)*scrollView.contentOffset.x;
//
//    if (off_center < 35 && off_center > 0) {
//
//        self.tempLine.frame = CGRectMake(25, TopSpace-8, 40+off_center*2, 3);
//
//    }else if (off_center > 35 && off_center < 70) {
//        self.tempLine.frame = CGRectMake(25+(off_center*2-70), TopSpace-8, 110-(off_center*2-70), 3);
//    }
    
//    CGFloat itemBtnWidth = CGRectGetWidth(self.bounds)/self.itemBtnArr.count;
    //    CGFloat off_center = (70.0/ScreenW)*scrollView.contentOffset.x;

    CGFloat itemBtnWidth = (CGRectGetWidth(self.bounds)/self.itemBtnArr.count);

        CGFloat off_center = _progress * itemBtnWidth;
    CGFloat padding = (Main_Screen_Width - widthWith6(30) * self.itemBtnArr.count)/ (self.itemBtnArr.count + 1);
    self.indicatorView.frame = CGRectMake(padding + (padding + self.indicatorView.frame.size.width)*progress, self.indicatorView.frame.origin.y, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
//    self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x + off_center, self.indicatorView.frame.origin.y, widthWith6(30), 3);

//        if (off_center < itemBtnWidth / 2 && off_center > 0) {
//
//            self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x, self.indicatorView.frame.origin.y, widthWith6(30)+off_center*2, 3);
//            self.maxWidth = CGRectGetWidth(self.indicatorView.frame);
//        }else if (off_center > itemBtnWidth / 2 && off_center <= itemBtnWidth) {
////            NSLog(@"xxxxxx ===== %f",self.indicatorView.frame.origin.x+(off_center*2-itemBtnWidth));
////            NSLog(@"width ===== %f",widthWith6(30) + (CGRectGetWidth(self.bounds) / self.itemBtnArr.count)-(off_center*2-itemBtnWidth));
//            NSLog(@"maxwidth ===== %f",self.maxWidth);
//            NSLog(@"offcenter%f",off_center);
//            NSLog(@"qianxxxxxx=====%f",self.indicatorView.frame.origin.x);
//
//            NSLog(@"contentOffSet ======= %f",(off_center*2-itemBtnWidth));
//            self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x+(off_center*2-itemBtnWidth), self.indicatorView.frame.origin.y,self.maxWidth -(off_center*2-itemBtnWidth), 3);
//            NSLog(@"xxxxxx=====%f",self.indicatorView.frame.origin.x);
//            NSLog(@"width ======= %f",self.indicatorView.frame.size.width);
//        }
//        if (_progress < 0.5 && _progress > 0) {
//
//            self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x,self.indicatorView.frame.origin.y, self.indicatorView.frame.size.width+off_center*0.01, 3);
//
//        }else if (progress >= 0.5 && progress <= 1) {
//            self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x+(off_center*0.01), self.indicatorView.frame.origin.y, self.indicatorView.frame.size.width - off_center*0.01, 3);
//        }
//    }
}
- (NSMutableArray<UIButton *>*)itemBtnArr
{
    if (!_itemBtnArr) {
        _itemBtnArr = [[NSMutableArray alloc]init];
    }
    return _itemBtnArr;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]init];
        [self.scrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark --Setter

- (void)setTitlesArr:(NSArray *)titlesArr
{
    _titlesArr = titlesArr;
    [self.itemBtnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtnArr = nil;
    for (NSString *title in titlesArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemBtnArr.count + 666;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xC8161E) forState:UIControlStateSelected];
        btn.titleLabel.font = APPDEFAULTFONT(widthWith6(14));
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.itemBtnArr.count == self.selectIndex) {
            btn.selected = YES;
            btn.titleLabel.font = APPDEFAULTFONT(widthWith6(17));

        }
        [self.itemBtnArr addObject:btn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItemMargin:(CGFloat)itemMargin
{
    _itemMargin = itemMargin;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex == selectIndex||_selectIndex < 0||_selectIndex > self.itemBtnArr.count - 1) {
        return;
    }
    UIButton *lastBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    lastBtn.selected = NO;
    lastBtn.titleLabel.font = APPDEFAULTFONT(widthWith6(14));
    [lastBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _selectIndex = selectIndex;
    UIButton *currentBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    currentBtn.selected = YES;
    currentBtn.titleLabel.font = APPBOLDFONT(widthWith6(17));
    [currentBtn setTitleColor:UIColorFromRGB(0xC8161E) forState:UIControlStateNormal];
    //    [self moveIndicatorView:YES];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont
{
    
    if (_titleFont == titleSelectFont) {
        _titleSelectFont = _titleFont;
        return;
    }
    
    _titleSelectFont = titleSelectFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = btn.isSelected?titleSelectFont:_titleFont;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = [UIColor redColor];
}

#pragma mark --Btn

- (void)btnClick:(UIButton *)btn
{
    NSInteger index = btn.tag - 666;
    if (index == self.selectIndex) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(GXSegmentTitleView:startIndex:endIndex:)]) {
        [self.delegate GXSegmentTitleView:self startIndex:self.selectIndex endIndex:index];
    }
    self.selectIndex = index;
}

#pragma mark Private
/**
 计算字符串长度
 
 @param string string
 @param font font
 @return 字符串长度
 */
+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

/**
 随机色
 
 @return 调试用
 */
+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
