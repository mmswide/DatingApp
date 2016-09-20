//
//  MatchViewController.h
//  Pandemos
//
//  Created by Michael Sevy on 6/8/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface MatchViewController : UIViewController

@property (strong, nonatomic) NSString *currentCityState;
@property (strong, nonatomic) UserManager *userManager;
@end
