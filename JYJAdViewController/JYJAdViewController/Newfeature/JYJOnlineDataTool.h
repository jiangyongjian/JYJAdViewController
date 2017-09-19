//
//  JYJOnlineDataTool.h
//  shanqi
//
//  Created by JYJ on 2017/9/14.
//  Copyright © 2017年 FlashBike. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYJPromotionItem;
@interface JYJOnlineDataTool : NSObject

/**
 * 加载闪屏也广告
 */
- (void)loadPromotionPageData;


/**
 * 返回广告数据模型
 */
- (JYJPromotionItem *)getPromotionItem;


@end
