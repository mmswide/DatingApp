//
//  UIImageView+Additions.m
//  Pandemos
//
//  Created by Michael Sevy on 4/8/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

+(void)setupFullSizedImage:(UIImageView *)image
{
    image.layer.cornerRadius = 8;
    image.clipsToBounds = YES;
}
@end
