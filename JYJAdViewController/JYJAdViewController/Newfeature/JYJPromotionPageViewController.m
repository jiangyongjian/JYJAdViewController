//
//  JYJPromotionPageViewController.m
//  shanqi
//
//  Created by JYJ on 2017/9/14.
//  Copyright © 2017年 FlashBike. All rights reserved.
//

#import "JYJPromotionPageViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "ViewController.h"
#import "JYJAdDetailViewController.h"
#import "UIImage+JYJGIF.h"

@interface JYJPromotionPageViewController ()
/** 5s的定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** number */
@property (nonatomic, assign) int number;

/** skipButton */
@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation JYJPromotionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.number = 5;
    
    [self setupUI];
    
    [self addTimer];
}

#pragma mark - 私有方法

/**
 * 广告也点击
 */
- (void)adViewClick {
    // 移除定时器
    [self removeTimer];
    ViewController *homeVC = [[ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:homeVC];
    JYJAdDetailViewController *webVc = [[JYJAdDetailViewController alloc] init];
    webVc.urlString = @"https://www.baidu.com";
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
    [homeVC.navigationController pushViewController:webVc animated:YES];
}

/**
 * 跳过按钮点击
 */
- (void)skipButtonClick {
    // 移除定时器
    [self removeTimer];

    ViewController *homeVC = [[ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
    
    CATransition *anim = [CATransition animation];
    anim.duration = 0.5;
    anim.type = @"fade";
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
}

/**
 *  添加定时器
 */
- (void)addTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

/**
 * 设置超时，然后退出当前控制器回到首页
 */
- (void)timeOut {
    self.number--;
    if (self.number > 0) {
        [self.skipButton setTitle:[NSString stringWithFormat:@"%zd 跳过", self.number] forState:UIControlStateNormal];
    } else {
        [self skipButtonClick];
    }
}


/**
 *  移除定时器
 */
- (void)removeTimer {
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

/**
 * 加载缓存数据
 */
- (NSData *)imageDataFromDiskCacheWithKey:(NSString *)key {
    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:key];
    NSLog(@"%@", path);
    return [NSData dataWithContentsOfFile:path];
}


#pragma mark - 初始化

- (void)setupUI {
    
    /** 1.图片 */
    UIImageView *bottomView = [[UIImageView alloc] init];
    bottomView.image  = [self launchImageWithType:@"Portrait"];
    bottomView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:bottomView];
    
    /** 1.图片 */
    UIImageView *adView = [[UIImageView alloc] init];
    adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
    adView.contentMode = UIViewContentModeScaleAspectFill;
    adView.clipsToBounds = YES;
    [self.view addSubview:adView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adViewClick)];
    adView.userInteractionEnabled = YES;
    [adView addGestureRecognizer:tap];
    
    //pathExtension: 直接获取路径扩展名, lowercaseString: 转化为小写
    NSString *extensionName = self.item.urlString.pathExtension;

    //判断gif
    if ([extensionName.lowercaseString isEqualToString:@"gif"]) {
        NSData *data = [self imageDataFromDiskCacheWithKey:self.item.urlString];
        adView.image = [UIImage JYJ_animatedGIFWithData:data];
    } else {
        adView.image = [[SDImageCache sharedImageCache] imageFromCacheForKey:self.item.urlString];
    }
    
    UIButton *skipButton = [[UIButton alloc] init];
    [skipButton setTitle:[NSString stringWithFormat:@"%zd 跳过", self.number] forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
    skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - 70, 20, 70, 35);
    skipButton.layer.cornerRadius = 35 / 2;
    [self.view addSubview:skipButton];
    self.skipButton = skipButton;
}

- (UIImage *)launchImageWithType:(NSString *)type {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]) {
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize)) {
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
