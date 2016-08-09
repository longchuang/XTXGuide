//
//  XTXGuideViewController.m
//  新特性界面
//
//  Created by Long on 16/8/8.
//  Copyright © 2016年 LongChuang. All rights reserved.
//

#import "XTXGuideViewController.h"
// 1.导入第三方框架
#import "Masonry.h"
// 2.导入视图头文件
#import "XTXGuideView.h"
#define XTXImageCount  4
// 自定义sb视图类
@interface XTXGuideViewController ()

@end

@implementation XTXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置主背景图片
    [self setUpUI];
    
    [self addGuideView];
    
}

-(void)setUpUI
{
    // 创建主界面图片
    UIImageView *imageView = [[UIImageView alloc]init];
    
    // 添加图片
    imageView.image = [UIImage imageNamed:@"cozy-control-car"];
    
    // 设置图片填充模式
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 添加到父控件
     [self.view addSubview:imageView];
    
    // 给imageView添加约束,添加约束前imageView一定要被添加到父控件上
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make center];
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
}

-(NSArray *)loadData
{
    // 根据图片数量开辟对应大小的空间
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:XTXImageCount];
    // 读取图片名字

    for (NSInteger i = 1; i <=XTXImageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"common_h%zd.jpg",i];
        [arrM addObject:imageName];
    }
    return arrM;
}

-(void)addGuideView
{
    // 创建自定义界面,并同时创建滚动视图
    // self = Guide View Controller
    XTXGuideView *guideView = [[XTXGuideView alloc]initWithFrame:self.view.bounds];
    // 此处暂未使用数据模型保存数据
    guideView.imageName = [self loadData];
    
    [self.view addSubview:guideView];
}

@end














































