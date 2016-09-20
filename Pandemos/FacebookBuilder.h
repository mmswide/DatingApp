//
//  FacebookBuilder.h
//  Pandemos
//
//  Created by Michael Sevy on 3/22/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface FacebookBuilder : NSObject

+(NSArray *)parseThumbnailData:(NSDictionary *)results withError:(NSError *)error;
+(NSArray *)parseUserData:(NSDictionary *)results withError:(NSError *)error;
+(NSArray *)parseThumbnailPaging:(NSDictionary *)results withError:(NSError *)error;
+(NSArray *)parsePhotoAlbums:(NSDictionary *)results withError:(NSError *)error;
+(NSArray *)parseAlbum:(NSDictionary *)results withError:(NSError *)error;
+(NSArray *)parseAlbumPaging:(NSDictionary *)results withError:(NSError *)error;
@end
