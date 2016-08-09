//
//  XTXGuideView.m
//  新特性界面
//
//  Created by Long on 16/8/8.
//  Copyright © 2016年 LongChuang. All rights reserved.
//

#import "XTXGuideView.h"
#import "Masonry.h"
@interface XTXGuideView()<UIScrollViewDelegate>

// 滚动视图
@property(nonatomic,weak)UIScrollView *scrollView;
// 翻页控制器
@property(nonatomic,weak)UIPageControl *pageControl;

@end

@implementation XTXGuideView

// 创建自定义View视图的时候,同时创建Scrollview
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


-(void)setUpUI
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [self  addSubview:scrollView];
    self.scrollView = scrollView;
    // 隐藏两个滑动条
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置分页
    scrollView.pagingEnabled = YES;
    
    // 关闭弹簧效果
    scrollView.bounces =YES;
    
    // 设置scrollview代理
    scrollView.delegate = self;
    
    // 创建分页指示器
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    
    // 给属性赋值
    self.pageControl = pageControl;
    
    
    // 设置当前页
    pageControl.currentPage = 0;
    
    // 设置其他页的颜色
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    // 设置当前页的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    
    // 把分页指示器添加到自定义视图上不要加在scrollview上
    [self addSubview:pageControl];
    
    // 设置分页指示器的偏移
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        // 设置x与父物体x对齐
        [make centerX];
        // 下部向上偏移20
        make.bottom.offset(-20);
    }];
    
    // 设置分页指示器不能点击
    pageControl.enabled = NO;
}

// 控制器视图中通过model层的保存的数据给view层赋值的时候,调用改set方法
-(void)setImageName:(NSArray *)imageName
{
    _imageName = imageName;
    for (NSInteger i = 0 ; i < imageName.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        // uiimageview的图片以及大小
        imageView.frame = CGRectOffset(self.bounds, i*self.bounds.size.width, 0);
        imageView.image = [UIImage imageNamed:imageName[i]];
        [self.scrollView addSubview:imageView];
        // 开启交互
        imageView.userInteractionEnabled = YES;
        // 添加按钮
        [self makeLoadMoreBtn:imageView];

    }
    // 多出一页,用于显示主页面,为其增加可滑动的条件
    self.scrollView.contentSize = CGSizeMake((imageName.count + 1) * self.bounds.size.width, 0);
    
    // 三 设置分页指示器的总个数
    self.pageControl.numberOfPages = imageName.count;
}


// 添加按钮
- (void)makeLoadMoreBtn:(UIImageView *)imageView {
    // 1.创建按钮
    UIButton *loadMoreBtn = [[UIButton alloc] init];
    // 2.设置图片
    [loadMoreBtn setImage:[UIImage imageNamed:@"common_more_black"] forState:UIControlStateNormal];
    [loadMoreBtn setImage:[UIImage imageNamed:@"common_more_white"] forState:UIControlStateHighlighted];
    
    // 3.添加到父控件上
    [imageView addSubview:loadMoreBtn];
    // 让按钮的尺寸根据图片的大小自适应
    [loadMoreBtn sizeToFit];
    
    // 4.给加载更多按钮添加约束
    [loadMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.bottom.offset(-50);
    }];
    
    
    // 5.给加载更多按钮添加监听事件
    [loadMoreBtn addTarget:self action:@selector(loadMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 加载更多按钮监听方法
- (void)loadMoreBtnClick:(UIButton *)btn {
    // 1.把当前被点击的加载更多按钮隐藏
    btn.hidden = YES;
    // 2.动画的方式让imageView放大及完全透明
    [UIView animateWithDuration:0.2 animations:^{
        // 让按钮的父控件,也就当前点击的按钮所在的imageView放大
        btn.superview.transform = CGAffineTransformMakeScale(2, 2);
        // 让imageView透明
        btn.superview.alpha = 0;
    } completion:^(BOOL finished) {
        // 让新特性界面自定义视图直接从父控件上移除
        // 3.动画完成之后把自定义的新特性view直接从父控件中移除
        [self removeFromSuperview];
    }];
    
    
    
    
}

#pragma mark - UIScrollViewDelegate
// 正在滚动中一直会调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    // 当新的一页已经出来一大半就让分页指示器显示到新的一页
    NSInteger pageNo = page + 0.4999;
    self.pageControl.currentPage = pageNo;
    
    // 把当前的页数设置给scrollView的tag
    scrollView.tag = pageNo;

    self.pageControl.hidden = (pageNo == _imageName.count);
}

#pragma mark - 手动拖拽并且有降速过程,降速完成之后就会来调用此方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 如果滚动到最后一页并停在了空白的这一页上时,把自定义新特性界面移除
    if (scrollView.tag == _imageName.count) {
        [self removeFromSuperview];
    }
}





























@end
