//
//  UIButton+Additions.h
//  Pandemos
//
//  Created by Michael Sevy on 3/14/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Additions)

+(UIButton*)circleButtonEdges:(UIButton *)button;
+(void)setUpButton:(UIButton *)button;
+(void)setUpLargeButton:(UIButton *)button;
+(void)changeButtonState:(UIButton *)button;
+(void)changeButtonStateForSingleButton:(UIButton*)button;
+(void)changeOtherButton:(UIButton *)button;
+(void)rotateRightButton:(UIButton *)button;
+(void)rotateLeftButton:(UIButton *)button;
+(void)setIndicatorLight:(UIButton*)light l2:(UIButton*)light2 l3:(UIButton*)light3 l4:(UIButton*)light4 l5:(UIButton*)light5 l6:(UIButton*)light6 forCount:(long)count;
+(void)loadIndicatorLightsForProfileImages:(UIButton*)profileImage image2:(UIButton*)pI2 image3:(UIButton*)pI3 image4:(UIButton*)pI4 image5:(UIButton*)pI5 image6:(UIButton*)pI6 imageCount:(int)count;
@end
