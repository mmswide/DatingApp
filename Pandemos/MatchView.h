//
//  MatchView.h
//  Pandemos
//
//  Created by Michael Sevy on 5/15/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol MatchViewDelegate <NSObject>

-(void)didPressMatchView;

@end

@interface MatchView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIView *container;

@property(nonatomic, weak)id<MatchViewDelegate>delegate;

-(void)setMatchViewWithChatter:(NSString*)name;
-(void)setMatchViewWithChatterDetailImage:(NSString*)pic;
@end
