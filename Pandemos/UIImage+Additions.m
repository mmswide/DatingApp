//
//  UIImage+Additions.m
//  Pandemos
//
//  Created by Michael Sevy on 5/5/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UIImage+Additions.h"
#import <QuartzCore/QuartzCore.h>

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees) ((pi * degrees) / 180)

@implementation UIImage (Additions)

+ (UIImage *)imageWithData:(NSData *)data scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIImage *image = [UIImage imageWithData:data];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToScale:(float)scale
{
    // grab the original image
    UIImage *originalImage = image;
    // scaling set to 2.0 makes the image 1/2 the size.
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[originalImage CGImage]
                        scale:(originalImage.scale * scale)
                  orientation:(originalImage.imageOrientation)];
    return scaledImage;
}

+(UIImage *)imageWithString:(NSString*)image
{
    NSURL *url = [NSURL URLWithString:image];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}
@end
