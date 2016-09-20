//
//  UserData.m
//  Pandemos
//
//  Created by Michael Sevy on 12/19/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import "User.h"
#import <Foundation/Foundation.h>
#import <Parse/PFConstants.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIColor+Pandemos.h"

@implementation User

+(User *)currentUser
{
    return (User *)[PFUser currentUser];
}

@dynamic image;
@dynamic faceID;
@dynamic givenName;
@dynamic lastName;
@dynamic birthday;
@dynamic age;
@dynamic gender;
@dynamic sexPref;
@dynamic currentLocation;
@dynamic milesAway;
@dynamic milesAwayInt;
@dynamic minAge;
@dynamic maxAge;
@dynamic profileImages;
@dynamic lastSchool;
@dynamic facebookLocation;
@dynamic facebookHometown;
@dynamic work;
@dynamic confidantEmail;
@dynamic aboutMe;
@dynamic username;
@dynamic likes;
@dynamic longitude;
@dynamic latitude;
@dynamic publicProfile;

-(NSString *)ageFromBirthday:(NSString *)birthday
{
    //Caculate age from birthday
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *todaysDate = [NSDate date];
    NSDate *birthdateNSDate = [formatter dateFromString:birthday];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthdateNSDate toDate:todaysDate options:0];
    NSUInteger age = ageComponents.year;
    NSString *ageStr = [NSString stringWithFormat:@"%lu", (unsigned long)age];

    return ageStr;
}

-(NSData *)stringURLToData:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];

    return data;
}
@end







