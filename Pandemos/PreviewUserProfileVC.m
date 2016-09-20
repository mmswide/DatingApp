//
//  PreviewUserProfileVC.m
//  Pandemos
//
//  Created by Michael Sevy on 2/1/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "PreviewUserProfileVC.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "UIColor+Pandemos.h"
#import "UIButton+Additions.h"
#import "NSString+Additions.h"
#import "UIImageView+Additions.h"
#import "UIImage+Additions.h"
#import "User.h"
#import "UserManager.h"
#import "ProfileImageView.h"

@interface PreviewUserProfileVC ()<
UIScrollViewDelegate,
UserManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toMatches;

@property (strong, nonatomic) NSString *currentCityAndState;
@property (strong, nonatomic) User *currentUser;

@property (strong, nonatomic) UserManager *userManager;
@property (strong, nonatomic) NSMutableArray *profileImages;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) PFGeoPoint *pfGeoCoded;
@property int count;

@property (strong, nonatomic) ProfileImageView *piv;
@property (strong, nonatomic) UIScrollView *imageScroll;

@end

@implementation PreviewUserProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.userManager = [UserManager new];
    self.userManager.delegate = self;
    
    self.currentUser = [User currentUser];
    self.profileImages = [NSMutableArray new];

    [self navBarSetup];
    self.piv.v1.hidden = YES;
    self.piv.v2.hidden = YES;
    self.piv.v3.hidden = YES;
    self.piv.v4.hidden = YES;
    self.piv.v5.hidden = YES;
    self.piv.v6.hidden = YES;

 }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    self.count = 0;

    [self setupManagersProfileVCForCurrentUser];
}


#pragma mark -- USER MANAGER DELEGATE
-(void)setupManagersProfileVCForCurrentUser
{
    self.piv = [[ProfileImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.piv];

    [self.userManager queryForUserData:self.currentUser.objectId withUser:^(User *user, NSError *error) {

        NSString *bday = user[@"birthday"];
        NSString *nameAndAge = [NSString stringWithFormat:@"%@, %@", user[@"givenName"], [bday ageFromBirthday:bday]];
        self.piv.nameLabel.text = nameAndAge;
        self.piv.schoolLabel.text = user[@"lastSchool"];
        self.profileImages = user[@"profileImages"];

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
//        switch ((int)self.profileImages.count)
//        {
//            case 1:
//                self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height);
//                self.piv.profileImageView.image = [UIImage imageWithString:[self.profileImages objectAtIndex:0]];
//                self.piv.v1.hidden = NO;
//                [self.piv.v2 removeFromSuperview];
//                [self.piv.v3 removeFromSuperview];
//                [self.piv.v4 removeFromSuperview];
//                [self.piv.v5 removeFromSuperview];
//                [self.piv.v6 removeFromSuperview];
//                break;
//            case 2:
//                self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 2);
//                self.piv.profileImageView.image = [UIImage imageWithString:[self.profileImages objectAtIndex:0]];
//                self.piv.profileImageView2.image = [UIImage imageWithString:[self.profileImages objectAtIndex:1]];
//                self.piv.v1.hidden = NO;
//                self.piv.v2.hidden = NO;
//                [self.piv.v3 removeFromSuperview];
//                [self.piv.v4 removeFromSuperview];
//                [self.piv.v5 removeFromSuperview];
//                [self.piv.v6 removeFromSuperview];
//                break;
//            case 3:
//                self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 3);
//                self.piv.profileImageView.image = [UIImage imageWithString:[self.profileImages objectAtIndex:0]];
//                self.piv.profileImageView2.image = [UIImage imageWithString:[self.profileImages objectAtIndex:1]];
//                self.piv.profileImageView3.image = [UIImage imageWithString:[self.profileImages objectAtIndex:2]];
//                self.piv.v1.hidden = NO;
//                self.piv.v2.hidden = NO;
//                self.piv.v3.hidden = NO;
//                [self.piv.v4 removeFromSuperview];
//                [self.piv.v5 removeFromSuperview];
//                [self.piv.v6 removeFromSuperview];
//                break;
//            case 4:
//                self.piv.imageScroll.contentSize = CGSizeMake(self.piv.frame.size.width, self.piv.frame.size.height * 4);
//                self.piv.profileImageView.image = [UIImage imageWithString:[self.profileImages objectAtIndex:0]];
//                self.piv.profileImageView2.image = [UIImage imageWithString:[self.profileImages objectAtIndex:1]];
//                self.piv.profileImageView3.image = [UIImage imageWithString:[self.profileImages objectAtIndex:2]];
//                self.piv.profileImageView4.image = [UIImage imageWithString:[self.profileImages objectAtIndex:3]];
//                self.piv.v1.hidden = NO;
//                self.piv.v2.hidden = NO;


#pragma mark -- NAV
- (IBAction)onCloseButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toMatches:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toMatches" sender:self];
}


#pragma mark -- CLLocation delegate methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{

}



-(void)setupLocationInDelegate:(CLLocation*)location
{

    NSLog(@"array of cuurent locations: %@", location);
    //double latitude = self.locationManager.location.coordinate.latitude;
    //double longitude = self.locationManager.location.coordinate.longitude;

    [self.locationManager stopUpdatingLocation];

    //get city and location from a CLPlacemark object
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *city = placemark.locality;
            NSDictionary *stateDict = placemark.addressDictionary;
            NSString *state = stateDict[@"State"];
            self.currentCityAndState = [NSString stringWithFormat:@"%@, %@", city, state];
        }
    }];
}

#pragma mark -- HELPERS
-(void)navBarSetup
{
    self.navigationController.navigationBar.barTintColor = [UIColor yellowGreen];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor unitedNationBlue],
                                 NSFontAttributeName :[UIFont fontWithName:@"GeezaPro" size:20.0]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    UIImage *closeNavBarButton = [UIImage imageWithImage:[UIImage imageNamed:@"Close"] scaledToSize:CGSizeMake(25.0, 25.0)];
    [self.navigationItem.leftBarButtonItem setImage:closeNavBarButton];
    self.closeBarButton.tintColor = [UIColor darkGrayColor];

    UIImage *matchesNavBarButton = [UIImage imageWithImage:[UIImage imageNamed:@"Forward"] scaledToSize:CGSizeMake(25.0, 25.0)];
    [self.navigationItem.rightBarButtonItem setImage:matchesNavBarButton];
    self.toMatches.tintColor = [UIColor darkGrayColor];

    self.navigationItem.title = @"Your Ally Profile";
}
@end