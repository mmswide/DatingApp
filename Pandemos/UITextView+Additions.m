//
//  UITextView+Additions.m
//  Pandemos
//
//  Created by Michael Sevy on 4/1/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "UITextView+Additions.h"

@implementation UITextView (Additions)

+(void)setup:(UITextView *)textView
{
    textView.layer.cornerRadius = 10;
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor grayColor].CGColor];
}
@end