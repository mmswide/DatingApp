//
//  FacebookNetwork.m
//  Pandemos
//
//  Created by Michael Sevy on 3/22/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "FacebookNetwork.h"
#import "User.h"
#import <FBSDKGraphRequestConnection.h>
#import <FBSDKGraphRequest.h>
#import <AFNetworking.h>
#import "Facebook.h"

@implementation FacebookNetwork

-(void)loadFacebookThumbnails:(resultBlockWithSuccess)results
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me/photos" parameters:@{@"fields":@"picture, updated_time, id, album"} HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            results(YES, nil);
            [self.delegate receivedFBThumbnail:result];
            [self.delegate receivedFBThumbPaging:result];
        }
        else
        {
            results(NO, nil);
            [self.delegate failedToFetchFBThumbs:error];
            [self.delegate failedToFetchFBThumbPaging:error];
        }
    }];
}

-(void)loadFacebookUserData:(resultBlockWithSuccess)results
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"id, about, birthday, gender, bio, education, first_name, last_name, hometown, work"} HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

        User *user = [User currentUser];
        if (!error)
        {
            results(YES, nil);
            [self.delegate receivedFBUserInfo:result andUser:user];
        }
        else
        {
            results(NO, nil);
            [self.delegate failedToFetchUserInfo:error];
        }
    }];
}

-(void)loadFacebookPhotoAlbums:(resultBlockWithSuccess)results
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me/albums" parameters:@{@"fields": @"picture, count, updated_time, name"} HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

        if (!error)
        {
            results(YES, nil);
            [self.delegate receivedFBPhotoAlbums:result];
        }

        else
        {
            results(NO, nil);
            [self.delegate failedToFetchFBPhotoAlbums:error];
        }
    }];
}

-(void)loadFacebookPhotoAlbum:(NSString *)albumID withSuccess:(resultBlockWithSuccess)results
{
    NSString *albumIdPath = [NSString stringWithFormat:@"/%@/photos", albumID];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:albumIdPath parameters:@{@"fields": @"source, updated_time"} HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

        if (!error)
        {
            results(YES, nil);
            [self.delegate receivedFBPhotoAlbum:result];
            [self.delegate receivedFBAlbumPaging:result];
        }
        else
        {
            results(NO, nil);
            [self.delegate failedToFetchFBAlbum:error];
            [self.delegate failedToFetchFBAlbum:error];
        }
    }];
}

-(void)loadFacebookSourcePhoto:(NSString *)photoId withSuccess:(resultBlockWithSuccess)results
{
    NSString *photoIdStr = [NSString stringWithFormat:@"/%@", photoId];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:photoIdStr parameters:@{@"fields": @"source, updated_time"} HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

        if (!error)
        {
            results(YES, nil);
            [self.delegate receivedPhotoSource:result];
        }
        else
        {
            results(NO, nil);
            [self.delegate failedToFetchFBAlbum:error];
        }
    }];
}

-(void)loadNextPrevPage:(NSString *)pageURLString
{
    NSURL *URL = [NSURL URLWithString:pageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *dTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, NSData *data , NSError * _Nullable error) {

        if (!response)
        {
            NSLog(@"error: %@", error);
            //[self.delegate failedToFetchPagnation:error];
        }
        else
        {
            [self parsePageData:data];
        }
    }];

    [dTask resume];
}
#pragma mark -- PRIVATE METHODS
-(void)parsePageData:(NSData*)data
{
    NSError *error = nil;
    NSDictionary *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *dataFromJSON = objects[@"data"];

    NSMutableArray *newArray = [NSMutableArray new];

    for (NSDictionary *sourceURL in dataFromJSON)
    {
        Facebook *face = [Facebook new];
        face.albumImageURL = sourceURL[@"source"];
        NSURL *url = [NSURL URLWithString:sourceURL[@"source"]];
        face.albumImageData = [NSData dataWithContentsOfURL:url];
        face.albumImageID = sourceURL[@"id"];
        face.nextPage = objects[@"next"];
        face.previousPage = objects[@"previous"];

        [newArray addObject:face];
    }

    [self.delegate receivedNextPage:newArray];

}

@end
