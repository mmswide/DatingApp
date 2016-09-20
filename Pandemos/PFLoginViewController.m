//  PFLoginViewController.m
//  Pandemos
//
//  Created by Michael Sevy on 12/16/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import "PFLoginViewController.h"
#import <Foundation/Foundation.h>
#import <Bolts/BFTask.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <ParseFacebookUtilsV4.h>
#import <Parse/PFConstants.h>
#import "ProfileViewController.h"
#import "User.h"
#import "UserManager.h"
#import "InitialWalkThroughViewController.h"
#import "AppDelegate.h"
#import "AllyAdditions.h"

@interface PFLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) UserManager *userManager;
@end

@implementation PFLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Facebook Login";
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowGreen];
    self.navigationController.navigationItem.leftBarButtonItem.title = @"";

    // Add a custom login button to your app
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 289, 62)];
    myLoginButton.backgroundColor = [UIColor facebookBlue];
    //myLoginButton.center = self.view.center;
    [myLoginButton setImage:[UIImage imageWithImage:[UIImage imageNamed:@"loginFB"] scaledToSize:CGSizeMake(289, 62)] forState:UIControlStateNormal];
    myLoginButton.layer.cornerRadius = 30;
    myLoginButton.layer.masksToBounds = YES;
    myLoginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:myLoginButton];

    // Handle clicks on the button
    [myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    // Add the button to the view

    UILabel *buttonLabel = [UILabel new];
    buttonLabel.text = @"We will never post anything to Facebook";
    buttonLabel.textColor = [UIColor facebookBlue];
    buttonLabel.translatesAutoresizingMaskIntoConstraints = NO;
    buttonLabel.center = self.view.center;
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:buttonLabel];

    NSDictionary *viewDict = @{@"button":myLoginButton, @"label":buttonLabel};

    NSArray *centerButtonCon = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[button]-|"
                                                                 options:NSLayoutFormatAlignAllCenterX | NSLayoutAttributeCenterY
                                                                 metrics:nil views:viewDict];

    NSArray *topCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(halfwayDown)-[button]-10-[label]"
                                                              options:0
                                                              metrics:@{@"halfwayDown":@(self.view.frame.size.height / 2)}
                                                                views:viewDict];

    NSArray *sideCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|"
                                                              options:0
                                                              metrics:nil
                                                                views:viewDict];
    [self.view addConstraints:topCon];
    [self.view addConstraints:centerButtonCon];
    [self.view addConstraints:sideCon];
}



-(void)loginButtonClicked
{
    //need user work and education history paths
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"user_about_me", @"user_birthday", @"user_location", @"user_photos", @"user_hometown", @"user_likes", @"pages_show_list", @"user_education_history", @"user_work_history"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

        if (!user)
        {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        }
        else if (user.isNew)
        {
            [self.userManager signUp:user];
            NSLog(@"User signed up and logged in through Facebook!");

            [self performSegueWithIdentifier:@"InitialLogIn" sender:self];
        }
        else
        {
            //for users where facebook cache has saved their prefereces

            NSLog(@"User logged in through Facebook!");
            //for testing
            [self performSegueWithIdentifier:@"InitialLogIn" sender:self];
            //real login will segue to matchViewController
        }
    }];
}

- (IBAction)onInitialWalkThrough:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"InitialLogIn" sender:self];
}
@end
