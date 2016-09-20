//
//  AcceptedMatchView.m
//  Pandemos
//
//  Created by Michael Sevy on 6/12/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "AcceptedMatchView.h"

@implementation AcceptedMatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor orangeColor];


        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.width / 2, 50, 50)];
        button.layer.cornerRadius = 25;
        [button setTitle:@"Chat" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blueColor];
        [self addSubview:button];
    }

    return self;
}
@end
