//
//  UserBuilder.m
//  Pandemos
//
//  Created by Michael Sevy on 4/10/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "UserBuilder.h"

@implementation UserBuilder

+(NSArray *)parsedUserData:(NSArray *)data withError:(NSError *)error
{
    NSError *localError = nil;

    if (localError != nil)
    {
        error = localError;
        return nil;
    }
    
    NSMutableArray *userData = [NSMutableArray new];

    if (data)
    {
        for (NSDictionary *dict in data)
        {
            User *user = [User new];
            user.work = dict[@"work"];
            user.birthday = dict[@"birthday"];
            user.lastSchool = dict[@"lastSchool"];
            user.givenName = dict[@"givenName"];
            user.aboutMe = dict[@"aboutMe"];
            user.facebookLocation = dict[@"faceboookLocation"];
            user.profileImages = dict[@"profileImages"];

            [userData addObject:user];
        }
    }

    return @[userData];
}
@end
