//
//  UIImage+Additions.h
//  Pandemos
//
//  Created by Michael Sevy on 5/5/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage *)imageWithData:(NSData *)data scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToScale:(float)scale;
+ (UIImage *)imageWithString:(NSString*)image;
@end
