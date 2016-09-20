//
//  AppConstants.h
//  Pandemos
//
//  Created by Michael Sevy on 5/30/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, AppLaunchStatus)
{
    APP_LAUNCH_STATUS_USER_AUTHENTICATED,
    APP_LAUNCH_STATUS_USER_NEEDS_REGISTRATION,
    APP_LAUNCH_STATUS_USER_LOGIN_FAIL,
    APP_LAUNCH_STATUS_LAYER_CONNECTION_FAILURE,
    APP_LAUNCH_STATUS_LOGIN_SUCCESS,
    APP_LAUNCH_STATUS_LOGIN_FAILURE,
    APP_LAUNCH_STATUS_LOGIN_FAILED_REGISTRATION
};

#define APP_TITLE @"Ally"

#define STARTCLOCK clock_t start, end; double cpu_time_used; start = clock();
#define RESETCLOCK start = clock();
#define ENDCLOCK end = clock(); cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC; NSLog(@"[CLOCK] Deltatime : %f", (float)cpu_time_used);

#define IS_LANDSCAPE         ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)
#define IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE4           (IS_IPHONE && KeyWindowBounds().size.height < 568.0)
#define IS_IPHONE5           (IS_IPHONE && KeyWindowBounds().size.height == 568.0)
#define IS_IPHONE6           (IS_IPHONE && KeyWindowBounds().size.height == 667.0)
#define IS_IPHONE6PLUS       (IS_IPHONE && KeyWindowBounds().size.height == 736.0 || KeyWindowBounds().size.width == 736.0) // Both orientations
#define IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IS_IOS9_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

#define KEYBOARD_NOTIFICATION_DEBUG     DEBUG && 0  // Logs every keyboard notification being sent

//PARSE
#define PARSE_APPLICATION_ID @"dCNWcarB6Tv1iW8vCT1c7UATrEwZ3AFq7OzwAs7A"

#define PARSE_CLIENT_KEY @"Fm7fN3AP4Efbcq6265D8Bh4ReICvjbHkgmRiQucl"

#if __has_attribute(objc_designated_initializer)
#define DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#endif

#ifndef AppConstants_h

static NSString *TextViewControllerDomain = @"com.benji.conversationcontroller";

inline static CGRect KeyWindowBounds()
{
    return [[UIApplication sharedApplication] keyWindow].bounds;
}

inline static CGRect RectInvert(CGRect rect)
{
    CGRect invert = CGRectZero;

    invert.origin.x = rect.origin.y;
    invert.origin.y = rect.origin.x;
    invert.size.width = rect.size.height;
    invert.size.height = rect.size.width;

    return invert;
}


inline static CGRect keyWindowBounds()
{
    return [[UIApplication sharedApplication] keyWindow].bounds;
}

typedef NS_OPTIONS(NSInteger, InviteStatus)
{
    CONTACT_REQUEST_NULL,
    CONTACT_REQUEST_SENT
};

static NSString * const kAlertKey = @"alert";
static NSString * const kBadgeKey = @"badge";
static NSString * const kSoundKey = @"sound";
static NSString * const kContentAvailableKey = @"content-available"; //Set to 1 for content
static NSString * const kCategoryKey = @"category";
static NSString * const kFileKey = @"fileID";
static NSString * const kTextKey = @"text";
static NSString * const kGivenNameKey = @"givenName";
static NSString * const kFamilyNameKey = @"familyName";
static NSString * const kDate = @"date";
static NSString * const kMessageId = @"messageId";
static NSString * const kFromId = @"fromId";

static NSString *kApproved = @"approved";

static NSString  *kUserSearchSegue = @"userSearchSegue";
static NSString  *kContactInviteSegue = @"contactInviteSegue";
static NSString  *kPendingSegue = @"pendingSegue";


#define AppConstants_h


#endif /* AppConstants_h */
