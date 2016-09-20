//
//  NotificationManager.m
//  Pandemos
//
//  Created by Michael Sevy on 6/6/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "NotificationManager.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation NotificationManager

-(void)registerForNotifications
{
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];

    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)scheduleNotificationNowFromUser:(User*)user
{
    //setup the intallation object
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

        if (succeeded)
        {
            NSLog(@"push installation object was saved with: %@", user.objectId);

            [self sendPushUsingQuery:user];
//            [self scheduleNotificationWithDate:[NSDate date]
//                                       message:[NSString stringWithFormat:@"New message from %@", usersGivenName]];
        }
    }];
}

-(void)sendPushUsingQuery:(User*)recipeint
{
    NSArray *userArray = @[recipeint];
    //assign it query then send the query
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"user" containsAllObjectsInArray:userArray];

    // Find devices associated with these users
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"recipientUser" containedIn:userArray];

    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:[NSString stringWithFormat:@"Ally: You have a Message from %@", recipeint.objectId]];

    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

        if (succeeded)
        {
            NSLog(@"push sent");
        }
    }];
}


//NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
//                      @“Ne messages available!!”, @"alert",
//                      @"Increment", @"badge",
//                      nil];
//
//// Now we’ll need to query all saved installations to find those of our recipients
//// Create our Installation query using the self.recipients array we already have
//PFQuery *pushQuery = [PFInstallation query];
//[pushQuery whereKey:@"installationUser" containedIn:self.recipients];
//
//// Send push notification to our query
//PFPush *push = [[PFPush alloc] init];
//[push setQuery:pushQuery];
//[push setData:data];
//[push sendPushInBackground];
//}
//}];



//delayed notification for girls only alerting them of a confirm match able to speak with
-(void)scheduleDelayedNotification:(long)count withMatched:(User *)matched
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *laterDate = [calendar dateByAddingUnit:NSCalendarUnitMinute value:30.0 toDate:[NSDate date] options:NSCalendarMatchStrictly];

    [self scheduleNotificationWithDate:laterDate
                               message:[NSString stringWithFormat:@"You have a match"]];
}

-(void)scheduleNotificationWithDate:(NSDate*)date message:(NSString*)message
{
    //who and how are we sending the push notif too???
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.timeZone = [NSTimeZone localTimeZone];
    //notification.repeatInterval = calendarUnit;
    notification.alertBody = message;
    notification.hasAction = NO;
    //notification.category = category;
    //notification.userInfo for putting in the 700 reminder
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


@end
