//
//  FacebookManager.h
//  Pandemos
//
//  Created by Michael Sevy on 3/22/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookNetwork.h"
#import "User.h"
#import "Facebook.h"

@class User;

@protocol FacebookManagerDelegate <NSObject>

@optional
-(void)didReceiveParsedThumbnails:(NSArray *)thumbnails;
-(void)failedToReceiveParsedThumbs:(NSError *)error;
-(void)didReceiveParsedThumbPaging:(NSArray *)thumbPaging;
-(void)failedToReceiveParsedThumbPaging:(NSError *)error;
-(void)didReceiveParsedAlbumList:(NSArray *)photoAlbums;
-(void)didReceiveParsedUserData:(NSArray*)data;
-(void)failedToReceiveUserData:(NSError *)error;
-(void)failedToReceiveParsedPhotoAlbums:(NSError *)error;
-(void)didReceiveParsedAlbum:(NSArray *)album;
-(void)failedToReceiveParsedAlbum:(NSError *)error;
-(void)didReceiveParsedAlbumPaging:(NSArray *)albumPaging;
-(void)failedToReceiveParsedAlbumPaging:(NSError *)error;
-(void)didReceiveParsedPhotoSource:(NSString*)photoURL;
-(void)didReceiveParsedPhotoSourceData:(NSData*)photoData;
-(void)didReceiveNextPagePhotos:(NSArray*)nextPhotos;
@end

@interface FacebookManager : NSObject<FacebookNetworkDelegate>

@property(nonatomic, strong)User *currentUser;
@property(nonatomic, strong)NSMutableArray<User*> *allUsers;
@property(nonatomic, strong)NSMutableArray<User*> *pendingMatches;
@property(nonatomic, strong)NSMutableArray<User*> *matchingUsers;
//@property(nonatomic, strong)NSMutableArray<Facebook*> *facebookAlbums;



@property (strong, nonatomic) FacebookNetwork *facebookNetworker;
@property (weak, nonatomic) id<FacebookManagerDelegate>delegate;

+(FacebookManager*)sharedSettings;

-(void)loadParsedFacebookThumbnails;
-(void)loadParsedUserData;
-(void)loadParsedFBPhotoAlbums;
-(void)loadParsedFBAlbum:(NSString *)albumID;
-(void)loadPhotoSource:(NSString *)photoSource;
-(void)loadNextPage:(NSString *)nextPageURL;
@end
