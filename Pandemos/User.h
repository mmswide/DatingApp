//
//  User.h
//  Pandemos
//
//  Created by Michael Sevy on 12/19/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFConstants.h>
#import <Parse/PFUser.h>

@interface User : PFUser<PFSubclassing>
//Parse User Data
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *faceID;
@property (strong, nonatomic) NSString *givenName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *sexPref;
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSString *milesAway;
@property double milesAwayInt;
@property (strong, nonatomic) NSString *minAge;
@property (strong, nonatomic) NSString *maxAge;
@property (strong, nonatomic) NSString *publicProfile;
@property (strong, nonatomic) NSString *lastSchool;
@property (strong, nonatomic) NSString *facebookLocation;
@property (strong, nonatomic) NSString *facebookHometown;
@property (strong, nonatomic) NSString *work;
@property (strong, nonatomic) NSString *confidantEmail;
@property (strong, nonatomic) NSString *aboutMe;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;

@property (strong, nonatomic) NSArray *likes;
@property (strong, nonatomic) NSArray *profileImages;

+(User *)currentUser;

-(NSString *)ageFromBirthday:(NSString *)birthday;
-(NSData *)stringURLToData:(NSString *)urlString;
@end





