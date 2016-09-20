//
//  MessagerProfileVC.m
//  Pandemos
//
//  Created by Michael Sevy on 5/10/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "MessagerProfileVC.h"
#import <Foundation/Foundation.h>
#import "UIColor+Pandemos.h"
#import "User.h"
#import "UserManager.h"
#import "ProfileImageView.h"
#import "AllyAdditions.h"

@interface MessagerProfileVC ()<UIScrollViewDelegate,
UserManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToConversation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendMessage;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) NSString *currentCityAndState;
//@property (strong, nonatomic) NSString *aboutMe;
@property (strong, nonatomic) User *passedUser;
@property (strong, nonatomic) UserManager *userManager;
@property (strong, nonatomic) NSMutableArray<PFFile*> *profileImages;
@property (strong, nonatomic) NSString *nameAndAgeGlobal;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PFGeoPoint *pfGeoCoded;
@property int count;
@property (strong, nonatomic) UIScrollView *imageScroll;
@property (strong, nonatomic) ProfileImageView *piv;

@end

@implementation MessagerProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor yellowGreen];

    self.backToConversation.tintColor = [UIColor mikeGray];
    self.backToConversation.image = [UIImage imageWithImage:[UIImage imageNamed:@"Back"] scaledToSize:CGSizeMake(25.0, 25.0)];
    self.sendMessage.title = @"Matches";
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.userManager = [UserManager new];
    self.userManager.delegate = self;
    self.profileImages = [NSMutableArray new];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    self.count = 0;

    [self setupManagersProfileVCForMatchedUser];

}

- (IBAction)onMatchController:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)onCloseButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- USER MANAGER DELEGATE
-(void)setupManagersProfileVCForMatchedUser
{
    self.piv = [[ProfileImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.piv];

    [self.userManager queryForUserData:[UserManager sharedSettings].recipient.objectId withUser:^(User *user, NSError *error) {

        NSString *bday = user[@"birthday"];
        NSString *nameAndAge = [NSString stringWithFormat:@"%@, %@", user[@"givenName"], [bday ageFromBirthday:bday]];
        self.piv.nameLabel.text = nameAndAge;
        self.piv.schoolLabel.text = user[@"lastSchool"];
        self.navBar.title = user[@"givenName"];
        self.profileImages = user[@"profileImages"];

        self.piv.tallNameLabel.text = nameAndAge;

        if (self.profileImages.count ==1)
        {
            self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 1);

            PFFile *i0 = [self.profileImages objectAtIndex:0];
            self.piv.profileImageView.image = [UIImage imageWithString:i0.url];

            [self.piv.v2 removeFromSuperview];
            [self.piv.v3 removeFromSuperview];
            [self.piv.v4 removeFromSuperview];
            [self.piv.v5 removeFromSuperview];
            [self.piv.v6 removeFromSuperview];
        }
        else if (self.profileImages.count ==2)
        {
            self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 2);

            PFFile *i0 = [self.profileImages objectAtIndex:0];
            PFFile *i1 = [self.profileImages objectAtIndex:1];
            self.piv.profileImageView.image = [UIImage imageWithString:i0.url];
            self.piv.profileImageView2.image = [UIImage imageWithString:i1.url];

            [self.piv.v3 removeFromSuperview];
            [self.piv.v4 removeFromSuperview];
            [self.piv.v5 removeFromSuperview];
            [self.piv.v6 removeFromSuperview];
        }
        else if (self.profileImages.count ==3)
        {
            self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 3);

            PFFile *i0 = [self.profileImages objectAtIndex:0];
            PFFile *i1 = [self.profileImages objectAtIndex:1];
            PFFile *i2 = [self.profileImages objectAtIndex:2];
            self.piv.profileImageView.image = [UIImage imageWithString:i0.url];
            self.piv.profileImageView2.image = [UIImage imageWithString:i1.url];
            self.piv.profileImageView3.image = [UIImage imageWithString:i2.url];

            [self.piv.v4 removeFromSuperview];
            [self.piv.v5 removeFromSuperview];
            [self.piv.v6 removeFromSuperview];
        }
        else if (self.profileImages.count ==4)
        {
            self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 4);

            PFFile *i0 = [self.profileImages objectAtIndex:0];
            PFFile *i1 = [self.profileImages objectAtIndex:1];
            PFFile *i2 = [self.profileImages objectAtIndex:2];
            PFFile *i3 = [self.profileImages objectAtIndex:3];
            self.piv.profileImageView.image = [UIImage imageWithString:i0.url];
            self.piv.profileImageView2.image = [UIImage imageWithString:i1.url];
            self.piv.profileImageView3.image = [UIImage imageWithString:i2.url];
            self.piv.profileImageView4.image = [UIImage imageWithString:i3.url];

            [self.piv.v5 removeFromSuperview];
            [self.piv.v6 removeFromSuperview];
        }
        else if (self.profileImages.count ==5)
        {
            self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 5);

            PFFile *i0 = [self.profileImages objectAtIndex:0];
            PFFile *i1 = [self.profileImages objectAtIndex:1];
            PFFile *i2 = [self.profileImages objectAtIndex:2];
            PFFile *i3 = [self.profileImages objectAtIndex:3];
            PFFile *i4 = [self.profileImages objectAtIndex:4];
            self.piv.profileImageView.image = [UIImage imageWithString:i0.url];
            self.piv.profileImageView2.image = [UIImage imageWithString:i1.url];
            self.piv.profileImageView3.image = [UIImage imageWithString:i2.url];
            self.piv.profileImageView4.image = [UIImage imageWithString:i3.url];
            self.piv.profileImageView5.image = [UIImage imageWithString:i4.url];

            [self.piv.v6 removeFromSuperview];
        }
        else if (self.profileImages.count ==6)
        {
            self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 6);

            PFFile *i0 = [self.profileImages objectAtIndex:0];
            PFFile *i1 = [self.profileImages objectAtIndex:1];
            PFFile *i2 = [self.profileImages objectAtIndex:2];
            PFFile *i3 = [self.profileImages objectAtIndex:3];
            PFFile *i4 = [self.profileImages objectAtIndex:4];
            PFFile *i5 = [self.profileImages objectAtIndex:5];
            self.piv.profileImageView.image = [UIImage imageWithString:i0.url];
            self.piv.profileImageView2.image = [UIImage imageWithString:i1.url];
            self.piv.profileImageView3.image = [UIImage imageWithString:i2.url];
            self.piv.profileImageView4.image = [UIImage imageWithString:i3.url];
            self.piv.profileImageView5.image = [UIImage imageWithString:i4.url];
            self.piv.profileImageView6.image = [UIImage imageWithString:i5.url];
        }
    }];

}
@end