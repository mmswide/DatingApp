//
//  UIColor+Pandemos.m
//  Pandemos
//
//  Created by Michael Sevy on 2/23/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UIColor+Pandemos.h"

@implementation UIColor (Pandemos)

+(UIColor *)rubyRed
{
    return [UIColor colorWithRed:255.0/255.0 green:84.0/255.0 blue:95.0/255.0 alpha:1.0];
}
+(UIColor *)uclaBlue
{
    return [UIColor colorWithRed:50.0/255.0 green:132.0/255.0 blue:191.0/255.0 alpha:1.0];
}
+(UIColor *)yellowGreen
{
    return [UIColor colorWithRed:242.0/255.0 green:255.0/255.0 blue:118.0/255.0 alpha:1.0];
}
+(UIColor *)facebookBlue
{
    return [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
}

+(UIColor*)mikeGray
{
    return [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
}

+(UIColor *)spartyGreen
{
    return [UIColor colorWithRed:24.0/255.0 green:69.0/255.0 blue:59.0/255.0 alpha:1.0];
}

+(UIColor *)unitedNationBlue
{
    return [UIColor colorWithRed:88.0/255.0 green:144.0/255.0 blue:232.0/255.0 alpha:1.0];
}

+ (UIColor*)colorWithHexValue:(NSString*)hexValue
{
    UIColor *defaultResult = [UIColor blackColor];

    // Strip leading # if there is one
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }

    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
        componentLength = 1;
    else if ([hexValue length] == 6)
        componentLength = 2;
    else
        return defaultResult;

    BOOL isValid = YES;
    CGFloat components[3];

    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 256.0;
    }

    if (!isValid) {
        return defaultResult;
    }

    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}
@end
