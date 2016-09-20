//
//  MessageDetailViewCon.h
//  Pandemos
//
//  Created by Michael Sevy on 1/13/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "AppDelegate.h"

@interface MessageDetailViewCon : UIViewController

@property (strong, nonatomic) User *recipient;

@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) UITextField *activeTextField;

@end
