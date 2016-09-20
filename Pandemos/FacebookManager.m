//
//  FacebookManager.m
//  Pandemos
//
//  Created by Michael Sevy on 3/22/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "FacebookManager.h"
#import "FacebookNetwork.h"
#import "FacebookBuilder.h"
#import "User.h"

@implementation FacebookManager

+ (id)sharedSettings
{
    static FacebookManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });

    return shared;
}

-(id)init
{
    self = [super init];

    if(self)
    {
        [self allUsers];
        [self pendingMatches];
        [self matchingUsers];
    }

    return self;
}

-(void)loadParsedFacebookThumbnails
{
    [self.facebookNetworker loadFacebookThumbnails:^(BOOL success, NSError *error) {

        if (success)
        {
            NSLog(@"loaded thumb data");
        }
        else
        {
            NSLog(@"failed to load thumb data, error: %@", error);
        }
    }];
}

-(void)loadParsedUserData
{
    [self.facebookNetworker loadFacebookUserData:^(BOOL success, NSError *error) {

        if (success)
        {
            NSLog(@"loaded facebook user data");
        }
        else
        {
            NSLog(@"failed to load thumb data");
        }
    }];
}

-(void)loadParsedFBPhotoAlbums
{
    [self.facebookNetworker loadFacebookPhotoAlbums:^(BOOL success, NSError *error) {

        if (success)
        {
            NSLog(@"loaded FB Photo albums");
        }
        else
        {
            NSLog(@"failed to load FB Photo albums");
        }
    }];
}

-(void)loadParsedFBAlbum:(NSString *)albumID
{
    [self.facebookNetworker loadFacebookPhotoAlbum:albumID withSuccess:^(BOOL success, NSError *error) {

        if (success)
        {
            NSLog(@"loaded FB Album");
        }
        else
        {
            NSLog(@"failed to load");
        }
    }];
}

-(void)loadPhotoSource:(NSString *)photoSource
{
    [self.facebookNetworker loadFacebookSourcePhoto:photoSource withSuccess:^(BOOL success, NSError *error) {

        if (success)
        {
            NSLog(@"received Photo Source");
        }
        else
        {
            NSLog(@"did not received photo source: %@", error);
        }
    }];
}

-(void)loadNextPage:(NSString *)nextPageURL
{
    [self.facebookNetworker loadNextPrevPage:nextPageURL];
}

#pragma mark -- FACEBOOK NETWORK DELEGATE
-(void)receivedFBThumbnail:(NSDictionary *)facebookThumbnails
{
    NSError *error = nil;
    NSArray *thumbnails = [FacebookBuilder parseThumbnailData:facebookThumbnails withError:error];

    if (!error)
    {
        [self.delegate didReceiveParsedThumbnails:thumbnails];
    }
    else
    {
        [self.delegate failedToReceiveParsedThumbs:error];
    }
}

-(void)failedToFetchFBThumbs:(NSError *)error
{
    [self.delegate failedToReceiveParsedThumbs:error];
}

-(void)receivedFBUserInfo:(NSDictionary *)facebookUserInfo andUser:(User *)user
{
    NSError *error = nil;
    NSArray *data = [FacebookBuilder parseUserData:facebookUserInfo withError:error];

    if (!error)
    {
        [self.delegate didReceiveParsedUserData:data];
    }
    else
    {
        [self.delegate failedToReceiveUserData:error];
    }
}

-(void)failedToFetchUserInfo:(NSError *)error
{
    [self.delegate failedToReceiveUserData:error];
}

-(void)receivedFBThumbPaging:(NSDictionary *)facebookThumbPaging
{
    NSError *error = nil;
    NSArray *thumbPages = [FacebookBuilder parseThumbnailPaging:facebookThumbPaging withError:error];

    if (!error)
    {
        [self.delegate didReceiveParsedThumbPaging:thumbPages];
    }
    else
    {
        [self.delegate failedToReceiveParsedThumbPaging:error];
    }
}

-(void)failedToFetchFBThumbPaging:(NSError *)error
{
    [self.delegate failedToReceiveParsedThumbPaging:error];
}

-(void)receivedFBPhotoAlbums:(NSDictionary *)facebookAlbums
{
    NSError *error = nil;
    NSArray *photoAlbums = [FacebookBuilder parsePhotoAlbums:facebookAlbums withError:error];

    if (!error)
    {
        [self.delegate didReceiveParsedAlbumList:photoAlbums];
    }
    else
    {
        [self.delegate failedToReceiveParsedPhotoAlbums:error];
    }
}

-(void)failedToFetchFBPhotoAlbums:(NSError *)error
{
    [self.delegate failedToReceiveParsedPhotoAlbums:error];
}

-(void)receivedFBPhotoAlbum:(NSDictionary *)album
{
    NSError *error = nil;
    NSArray *albumData = [FacebookBuilder parseAlbum:album withError:error];

    if (!error)
    {
        [self.delegate didReceiveParsedAlbum:albumData];
    }
    else
    {
        [self.delegate failedToReceiveParsedAlbum:error];
    }
}

-(void)failedToFetchFBAlbum:(NSError *)error
{
    [self.delegate failedToReceiveParsedAlbum:error];
}

-(void)receivedFBAlbumPaging:(NSDictionary *)albumPaging
{
    NSError *error = nil;
    NSArray *albumPages = [FacebookBuilder parseAlbumPaging:albumPaging withError:error];

    if (!error)
    {
        [self.delegate didReceiveParsedAlbumPaging:albumPages];
    }
    else
    {
        [self.delegate failedToReceiveParsedAlbumPaging:error];
    }
}

-(void)failedToFetchFBAlbumPaging:(NSError *)error
{
    [self.delegate failedToReceiveParsedAlbumPaging:error];
}

-(void)receivedPhotoSource:(NSDictionary *)facebookPhotoSource
{
    [self.delegate didReceiveParsedPhotoSource:facebookPhotoSource[@"source"]];
//    NSURL *url = [NSURL URLWithString:facebookPhotoSource[@"source"]];
  //  [self.delegate didReceiveParsedPhotoSourceData:[NSData dataWithContentsOfURL:url]];
}

-(void)receivedNextPage:(NSArray *)imageArray
{

    [self.delegate didReceiveNextPagePhotos:imageArray];
}

#pragma mark -- HELPERS
-(NSMutableArray *)allUsers
{
    if (!_allUsers)
    {
        _allUsers = [NSMutableArray new];
    }
    return _allUsers;
}

-(NSMutableArray *)pendingMatches
{
    if (!_pendingMatches)
    {
        _pendingMatches = [NSMutableArray new];
    }
    return _pendingMatches;
}

-(NSMutableArray *)matchingUsers
{
    if (!_matchingUsers)
    {
        _matchingUsers = [NSMutableArray new];
    }
    return _matchingUsers;
}
@end
