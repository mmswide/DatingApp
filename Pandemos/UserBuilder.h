//
//  UserBuilder.h
//  Pandemos
//
//  Created by Michael Sevy on 4/10/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserBuilder : NSObject

+(NSArray *)parsedUserData:(NSArray *)userArray withError:(NSError *)error;
@end
