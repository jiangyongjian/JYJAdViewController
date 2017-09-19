//
//  JYJPromotionItem.h
//  shanqi
//
//  Created by JYJ on 2017/9/18.
//  Copyright © 2017年 FlashBike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJPromotionItem : NSObject
/** urlString */
@property (nonatomic, copy) NSString *urlString;

/** 是否过期 */
@property (nonatomic, assign) BOOL isTimeOut;

@end
