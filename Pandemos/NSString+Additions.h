//
//  NSString+Additions.h
//  Pandemos
//
//  Created by Michael Sevy on 4/8/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+(NSString *)timeFromData:(NSDate*)date;
-(NSString *)ageFromBirthday:(NSString *)birthday;

@end
