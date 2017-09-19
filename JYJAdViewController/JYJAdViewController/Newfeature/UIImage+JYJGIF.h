//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JYJGIF)

+ (UIImage *)JYJ_animatedGIFNamed:(NSString *)name;

+ (UIImage *)JYJ_animatedGIFWithData:(NSData *)data;

- (UIImage *)JYJ_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
