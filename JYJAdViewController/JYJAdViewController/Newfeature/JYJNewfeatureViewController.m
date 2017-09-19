//
//  JYJNewfeatureViewController.m
//  BaoXianDaiDai
//
//  Created by JYJ on 15/6/1.
//  Copyright (c) 2015年 baobeikeji.cn. All rights reserved.
//



#import "JYJNewfeatureViewController.h"

#import "ViewController.h"

#define FBNewfeatureImageCount 4

@interface JYJNewfeatureViewController ()<UIScrollViewDelegate>

@end



@implementation JYJNewfeatureViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加UIScrollView
    [self setupScrollView];
}

/**
 *  添加UIScrollView
 */
- (void)setupScrollView {
    // 1.添加scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int i = 0; i < FBNewfeatureImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor grayColor];
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"Intro_Screen_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        NSLog(@"%@", name);
        // 设置frame
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        // 在最后一个图片上面添加按钮
        if (i == FBNewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }

    }
    
    // 设置其他属性
    scrollView.contentSize = CGSizeMake(imageW * FBNewfeatureImageCount, 0);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

/**
 *  设置最后一页的图片
 */
- (void)setupLastImageView:(UIImageView *)imageView {
    // 让UIImageView可以跟用户交互
    imageView.userInteractionEnabled = YES;
    // 1. 添加开始按钮
    [self setupStartButton:imageView];
}
/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView {

    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [startButton setTitle:@"开始蹂躏" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imageView addSubview:startButton];
    
    // 2.设置按钮属性
    CGFloat startButtonY = self.view.bounds.size.height - 20 - 50;
    CGFloat startButtonW = 145 ;
    CGFloat startButtonH = 50;
    CGFloat startButtonX = (self.view.bounds.size.width - startButtonW) / 2;
    startButton.frame = CGRectMake(startButtonX, startButtonY, startButtonW, startButtonH);
    startButton.layer.cornerRadius = 3;
    startButton.backgroundColor = [UIColor redColor];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

- (void)start {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 创建首页
    ViewController *homeVC = [[ViewController alloc] init];
    // 包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    window.rootViewController = nav;
}

@end
