//
//  DragBackground.h
//  Pandemos
//
//  Created by Michael Sevy on 6/8/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DragView.h"
#import "UserManager.h"

@interface DragBackground : UIView <DragViewDelegate, UserManagerDelegate>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@property (strong, nonatomic) NSArray<User*> *potentialMatchData;
@property (strong, nonatomic) NSMutableArray* allCards; //%%% the labels the cards
@property (strong, nonatomic) DragView *dragView;
@property (strong, nonatomic) UserManager *userManager;
@property (strong, nonatomic) NSArray<PFFile*> *profileImages;

@property BOOL alreadyMatched;
@property NSInteger userCount;

@property (strong, nonatomic) User *currentMatch;
//matching
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *sexPref;
@property (strong, nonatomic) NSString *milesAway;
@property (strong, nonatomic) NSString *minAge;
@property (strong, nonatomic) NSString *maxAge;
@property (strong, nonatomic) NSString *userImageForMatching;

@end
