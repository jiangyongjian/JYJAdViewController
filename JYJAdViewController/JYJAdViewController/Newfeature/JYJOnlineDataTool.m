//
//  JYJOnlineDataTool.m
//  shanqi
//
//  Created by JYJ on 2017/9/14.
//  Copyright © 2017年 FlashBike. All rights reserved.
//

#import "JYJOnlineDataTool.h"
#import "UIImageView+WebCache.h"
#import "JYJPromotionItem.h"
#import "MJExtension.h"

static NSString *const kLastPromotionPageFile = @"LastPromotionPageFile.data";

@interface JYJOnlineDataTool ()

/** 启动页 */
@property (nonatomic, copy) NSString *lastPromotionPageFile;

@end

@implementation JYJOnlineDataTool


/**
 * 加载闪屏也广告
 */
- (void)loadPromotionPageData {
//    网络请求
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@""] = @"";
//    param[@""] = @"";
//    [[AFHTTPSessionManager manager] post:@"" params:param success:^(id responseObj) {
//        if (Success) {
//            NSDictionary *dict = responseObj;
            // 开始下载图片
            NSString *urlString = @"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif";
    
//    NSString *urlString = @"http://c.hiphotos.baidu.com/image/pic/item/4d086e061d950a7b78c4e5d703d162d9f2d3c934.jpg";
            NSURL *url = [NSURL URLWithString:urlString];
            // 开始下载图片
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    // 开始存储图片
                    [[SDImageCache sharedImageCache] storeImage:image imageData:data forKey:urlString toDisk:YES completion:nil];
                    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"promotion.plist" ofType:nil]];
                    // 数据写入文件
                    NSData *contentData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
                    [contentData writeToFile:self.lastPromotionPageFile atomically:YES];
            }];
//        }
//    } failure:^(NSString *error) {
//        
//    }];
}


/**
 * 返回广告数据模型
 */
- (JYJPromotionItem *)getPromotionItem {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.lastPromotionPageFile]) {
        // 读取数据
        NSData *data = [NSData dataWithContentsOfFile:self.lastPromotionPageFile];
        if (data) {
            // 进行序列化
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
            JYJPromotionItem *item = [JYJPromotionItem mj_objectWithKeyValues:dict];
            if (!item.isTimeOut) { // 如果没过期就返回
                return item;
            } else { // 过期就清除数据
                [self clearImageForKey:item.urlString];
            }
        }
    }
    return nil;
}


/**
 * 清除缓存的iamge
 */
- (void)clearImageForKey:(NSString *)key {
    [[SDImageCache sharedImageCache] removeImageForKey:key withCompletion:nil];
}


/**
 * 上次信息
 */
- (NSString *)lastPromotionPageFile {
    if (!_lastPromotionPageFile) {
        NSString *path = [self pathWithDocumentName:@"OtherData"];
        self.lastPromotionPageFile = [path stringByAppendingPathComponent:kLastPromotionPageFile];
    }
    return _lastPromotionPageFile;
}

// 搜索数据对应的路径
- (NSString *)pathWithDocumentName:(NSString *)documentName {
    // 获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    // 拼接文件夹
    NSString *path = [documentDirectory stringByAppendingPathComponent:documentName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 判断文件夹是否存在
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


@end
