//
//  MatchRequest.h
//  Pandemos
//
//  Created by Michael Sevy on 2/28/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

@interface MatchRequest : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property(nonatomic, strong)User *toUser;
@property(nonatomic, strong)User *fromUser;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *strId;
@end
