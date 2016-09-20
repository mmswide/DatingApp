//
//  FacebookNetwork.h
//  Pandemos
//
//  Created by Michael Sevy on 3/22/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol FacebookNetworkDelegate<NSObject>

-(void)receivedFBThumbnail:(NSDictionary *)facebookThumbnails;
-(void)failedToFetchFBThumbs:(NSError *)error;
-(void)receivedFBThumbPaging:(NSDictionary *)facebookThumbPaging;
-(void)failedToFetchFBThumbPaging:(NSError *)error;
-(void)receivedFBUserInfo:(NSDictionary *)facebookUserInfo andUser:(User*)user;
-(void)failedToFetchUserInfo:(NSError *)error;
-(void)receivedFBPhotoAlbums:(NSDictionary *)facebookAlbums;
-(void)failedToFetchFBPhotoAlbums:(NSError *)error;
-(void)receivedFBPhotoAlbum:(NSDictionary *)album;
-(void)failedToFetchFBAlbum:(NSError *)error;
-(void)receivedFBAlbumPaging:(NSDictionary *)albumPaging;
-(void)failedToFetchFBAlbumPaging:(NSError *)error;
-(void)receivedPhotoSource:(NSDictionary*)facebookPhotoSource;
-(void)receivedNextPage:(NSArray*)imageArray;
//-(void)failedToFetchPagnation:(NSError*)error;
@end

@interface FacebookNetwork : NSObject

typedef void (^resultBlockWithSuccess)(BOOL success, NSError *error);

@property (weak, nonatomic) id<FacebookNetworkDelegate>delegate;

-(void)loadFacebookThumbnails:(resultBlockWithSuccess)results;
-(void)loadFacebookUserData:(resultBlockWithSuccess)results;
-(void)loadFacebookPhotoAlbums:(resultBlockWithSuccess)results;
-(void)loadFacebookPhotoAlbum:(NSString *)albumID withSuccess:(resultBlockWithSuccess)results;
-(void)loadFacebookSourcePhoto:(NSString *)photoId withSuccess:(resultBlockWithSuccess)results;
-(void)loadNextPrevPage:(NSString *)pageURLString;
@end
