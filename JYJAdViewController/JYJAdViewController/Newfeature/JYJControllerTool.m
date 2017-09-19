//
//  JYJControllerTool.m
//  FBInsurenceBroker
//
//  Created by JYJ on 16/2/22.
//  Copyright © 2016年 baobeikeji. All rights reserved.
//

#import "JYJControllerTool.h"
#import "JYJNewfeatureViewController.h"
#import "MJExtension.h"
#import "ViewController.h"
#import "JYJOnlineDataTool.h"
#import "JYJPromotionItem.h"
#import "JYJPromotionPageViewController.h"

@implementation JYJControllerTool

+ (void)chooseRootViewController {
    NSString *versionkey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号（取出上次的使用记录）
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionkey];
    
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionkey];
    
    BOOL isNewVersion = ![currentVersion isEqualToString:lastVersion];
    
    if (isNewVersion) {
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:versionkey];
        [defaults synchronize];
    }
    
    // 是否显示引导页
    BOOL showNewFeature = !lastVersion || ([JYJControllerTool compareVersion:lastVersion oldVersion:@"1.0.0" ] < 0);

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!showNewFeature) {
        JYJPromotionItem *item = [[[JYJOnlineDataTool alloc] init] getPromotionItem];
        // 判断是否加载广告
        if (item) {
            JYJPromotionPageViewController *vc = [[JYJPromotionPageViewController alloc] init];
            vc.item = item;
            window.rootViewController = vc;
        } else {
            ViewController *homeVC = [[ViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:homeVC];
            window.rootViewController = navi;
        }
    } else {
        JYJNewfeatureViewController *vc = [[JYJNewfeatureViewController alloc] init];
        window.rootViewController = vc;
    }
}

+ (NSInteger)compareVersion:(NSString *)lastVersion oldVersion:(NSString *)oldVersion {
    NSArray *leftPartitions = [lastVersion componentsSeparatedByString:@"."];
    NSArray *rightPartitions = [oldVersion componentsSeparatedByString:@"."];
    for (int i = 0; i < leftPartitions.count && i < rightPartitions.count; i++) {
        NSString *leftPartition = [leftPartitions objectAtIndex:i];
        NSString *rightPartition = [rightPartitions objectAtIndex:i];
        if (leftPartition.integerValue != rightPartition.integerValue) {
            return leftPartition.integerValue - rightPartition.integerValue;
        }
    }
    return 0;
}

@end
