//
//  MatchView.m
//  Pandemos
//
//  Created by Michael Sevy on 5/15/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "MatchView.h"
#import "AllyAdditions.h"

@implementation MatchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSString *nibName = NSStringFromClass([self class]);
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        [self addSubview:self.container];
        self.tintColor = [UIColor yellowGreen];

        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.container addGestureRecognizer:singleFingerTap];

        self.image.layer.masksToBounds = YES;
        self.image.layer.cornerRadius = self.image.frame.size.height * .5f;
    }
    
    return self;
}

-(void)setMatchViewWithChatter:(NSString *)name
{
    self.titleLabel.text = name;
}

-(void)setMatchViewWithChatterDetailImage:(NSString*)pic
{
    self.image.image = [UIImage imageWithString:pic];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self.delegate didPressMatchView];
}
@end
