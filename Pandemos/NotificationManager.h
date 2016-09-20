//
//  NotificationManager.h
//  Pandemos
//
//  Created by Michael Sevy on 6/6/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface NotificationManager : NSObject

-(void)registerForNotifications;
-(void)scheduleNotificationNowFromUser:(User*)user;
-(void)scheduleDelayedNotification:(long)count withMatched:(User *)matched;
@end
