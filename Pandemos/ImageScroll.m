//
//  ImageScroll.m
//  Pandemos
//
//  Created by Michael Sevy on 6/2/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "ImageScroll.h"

@implementation ImageScroll

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
