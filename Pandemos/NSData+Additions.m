//
//  NSData+Additions.m
//  Pandemos
//
//  Created by Michael Sevy on 5/4/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "NSData+Additions.h"

@implementation NSData (Additions)

+(NSData *)stringURLToData:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];

    return data;
}
@end
