//
//  UIButton+Additions.m
//  Pandemos
//
//  Created by Michael Sevy on 3/14/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UIButton+Additions.h"
#import "UIColor+Pandemos.h"
#import <QuartzCore/QuartzCore.h>

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees) ((pi * degrees) / 180)
#define ROUND_BUTTON_WIDTH_HEIGHT 11.0


@implementation UIButton (Additions)

+(UIButton*)circleButtonEdges:(UIButton *)button
{
    button.clipsToBounds = YES;
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor blackColor].CGColor];
    return button;
}

+(void)setUpButton:(UIButton *)button
{
    button.layer.cornerRadius = 7.5;
    button.clipsToBounds = YES;
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor blackColor].CGColor];
    [button setTitleColor:[UIColor facebookBlue] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setEnabled:YES];
}

+(void)setUpLargeButton:(UIButton *)button
{
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:[UIColor blackColor].CGColor];
    [button setTitleColor:[UIColor facebookBlue] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setEnabled:YES];
}

+(void)changeButtonState:(UIButton *)button
{
    [button setHighlighted:YES];
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor yellowGreen] forState:UIControlStateNormal];
}

+(void)changeButtonStateForSingleButton:(UIButton*)button
{
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

+(void)changeOtherButton:(UIButton *)button
{
    [button setHighlighted:NO];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

+(void)rotateRightButton:(UIButton *)button
{
    button.transform = CGAffineTransformMakeRotation(M_PI / 180 * 10);
    button.layer.cornerRadius = 20;
}

+(void)rotateLeftButton:(UIButton *)button
{
    button.transform = CGAffineTransformMakeRotation(M_PI / 180 * -10);
    button.layer.cornerRadius = 20;
}

+(void)setIndicatorLight:(UIButton*)light l2:(UIButton*)light2 l3:(UIButton*)light3 l4:(UIButton*)light4 l5:(UIButton*)light5 l6:(UIButton*)light6 forCount:(long)count
{
    switch (count)
    {
        case 0:
            light.backgroundColor = [UIColor yellowGreen];
            light2.backgroundColor = nil;
            light3.backgroundColor = nil;
            light4.backgroundColor = nil;
            light5.backgroundColor = nil;
            light6.backgroundColor = nil;
            break;
        case 1:
            light.backgroundColor = nil;
            light2.backgroundColor = [UIColor yellowGreen];
            light3.backgroundColor = nil;
            light4.backgroundColor = nil;
            light5.backgroundColor = nil;
            light6.backgroundColor = nil;
            break;
        case 2:
            light.backgroundColor = nil;
            light2.backgroundColor = nil;
            light3.backgroundColor = [UIColor yellowGreen];
            light4.backgroundColor = nil;
            light5.backgroundColor = nil;
            light6.backgroundColor = nil;
            break;
        case 3:
            light.backgroundColor = nil;
            light2.backgroundColor = nil;
            light3.backgroundColor = nil;
            light4.backgroundColor = [UIColor yellowGreen];
            light5.backgroundColor = nil;
            light6.backgroundColor = nil;
            break;
        case 4:
            light.backgroundColor = nil;
            light2.backgroundColor = nil;
            light3.backgroundColor = nil;
            light4.backgroundColor = nil;
            light5.backgroundColor = [UIColor yellowGreen];
            light6.backgroundColor = nil;
            break;
        case 5:
            light.backgroundColor = nil;
            light2.backgroundColor = nil;
            light3.backgroundColor = nil;
            light4.backgroundColor = nil;
            light5.backgroundColor = nil;
            light6.backgroundColor = [UIColor yellowGreen];
            break;
        default:
            NSLog(@"image beyond bounds");
            break;
    }
}

+(void)loadIndicatorLightsForProfileImages:(UIButton*)profileImage image2:(UIButton*)pI2 image3:(UIButton*)pI3 image4:(UIButton*)pI4 image5:(UIButton*)pI5 image6:(UIButton*)pI6 imageCount:(int)count
{
    switch (count)
    {
        case 0:
            profileImage.hidden = YES;
            pI2.hidden = YES;
            pI3.hidden = YES;
            pI4.hidden = YES;
            pI5.hidden = YES;
            pI6.hidden = YES;
            break;
        case 1:
            [UIButton circleButtonEdges:profileImage];
            profileImage.hidden = NO;
            pI2.hidden = YES;
            pI3.hidden = YES;
            pI4.hidden = YES;
            pI5.hidden = YES;
            pI6.hidden = YES;
            break;
        case 2:
            [UIButton circleButtonEdges:profileImage];
            [UIButton circleButtonEdges:pI2];
            profileImage.hidden = NO;
            pI2.hidden = NO;
            pI3.hidden = YES;
            pI4.hidden = YES;
            pI5.hidden = YES;
            pI6.hidden = YES;
            break;
        case 3:
            [UIButton circleButtonEdges:profileImage];
            [UIButton circleButtonEdges:pI2];
            [UIButton circleButtonEdges:pI3];
            profileImage.hidden = NO;
            pI2.hidden = NO;
            pI3.hidden = NO;
            pI4.hidden = YES;
            pI5.hidden = YES;
            pI6.hidden = YES;
            break;
        case 4:
            [UIButton circleButtonEdges:profileImage];
            [UIButton circleButtonEdges:pI2];
            [UIButton circleButtonEdges:pI3];
            [UIButton circleButtonEdges:pI4];
            profileImage.hidden = NO;
            pI2.hidden = NO;
            pI3.hidden = NO;
            pI4.hidden = NO;
            pI5.hidden = YES;
            pI6.hidden = YES;
            break;
        case 5:
            [UIButton circleButtonEdges:profileImage];
            [UIButton circleButtonEdges:pI2];
            [UIButton circleButtonEdges:pI3];
            [UIButton circleButtonEdges:pI4];
            [UIButton circleButtonEdges:pI5];
            profileImage.hidden = NO;
            pI2.hidden = NO;
            pI3.hidden = NO;
            pI4.hidden = NO;
            pI5.hidden = NO;
            pI6.hidden = YES;
            break;
        case 6:
            [UIButton circleButtonEdges:profileImage];
            [UIButton circleButtonEdges:pI2];
            [UIButton circleButtonEdges:pI3];
            [UIButton circleButtonEdges:pI4];
            [UIButton circleButtonEdges:pI5];
            [UIButton circleButtonEdges:pI6];
            profileImage.hidden = NO;
            pI2.hidden = NO;
            pI3.hidden = NO;
            pI4.hidden = NO;
            pI5.hidden = NO;
            pI6.hidden = NO;
            break;
        default:
            NSLog(@"indicator light error");
            break;
    }
}
@end
