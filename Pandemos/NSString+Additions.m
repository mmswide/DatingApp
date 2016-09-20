//
//  NSString+Additions.m
//  Pandemos
//
//  Created by Michael Sevy on 4/8/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

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

+(NSString *)timeFromData:(NSDate*)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMM dd hh:mm a"];

    float timingDiff = [[NSDate date] timeIntervalSinceDate:date];

    if (timingDiff < 1)
    {
        return [NSString stringWithFormat:@"just now"];
    }
    else if (timingDiff < 60)
    {
        return @"a min ago";
    }
    else if (timingDiff < 3600)
    {
        int diffRound = round(timingDiff / 60);
        return [NSString stringWithFormat:@"%dmins ago", diffRound];
    }
    else if (timingDiff < 86400)
    {
        int diffRound = round(timingDiff / 60 / 60);
        int secs = (int)timingDiff;
        int mins = (secs / 60) % 60;
        return [NSString stringWithFormat:@"%dh %dmins ago", diffRound, mins];
    }
    else
    {
        return [formatter stringFromDate:date];
    }
    return @"a long time ago";
}

@end
