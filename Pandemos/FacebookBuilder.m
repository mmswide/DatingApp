//
//  FacebookBuilder.m
//  Pandemos
//
//  Created by Michael Sevy on 3/22/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "FacebookBuilder.h"
#import "Facebook.h"
#import "User.h"
#import "Parse/Parse.h"

@implementation FacebookBuilder

+(NSArray *)parseThumbnailData:(NSDictionary *)results withError:(NSError *)error
{
    NSError *localError = nil;

    if (localError != nil)
    {
        error = localError;
        return nil;
    }
    NSMutableArray *parsedData = [NSMutableArray new];
    NSArray *dataArray = results[@"data"];

    if (dataArray)
    {
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:dataArray];
        NSArray *uniqueArray = [orderedSet array];

        for (NSDictionary *dict in uniqueArray)
        {
            Facebook *face = [Facebook new];
            face.thumbPhotoID = dict[@"id"];
            face.thumbURL = dict[@"picture"];
            face.thumbTimeUpdated = dict[@"updated_time"];

            [parsedData addObject:face];
        }
    }

    return parsedData;
}

+(NSArray *)parseUserData:(NSDictionary *)results withError:(NSError *)error
{
    NSError *localError = nil;

    if (localError != nil)
    {
        error = localError;
    }

    NSDictionary *userDict = results;
    NSMutableArray *facebookItems = [NSMutableArray new];

    if (userDict)
    {
        NSString *faceID = userDict[@"id"];
        NSString *name = userDict[@"first_name"];
        //print out 
        NSString *lastName = userDict[@"last_name"];
        NSString *gender = userDict[@"gender"];
        NSString *birthday = userDict[@"birthday"];
        NSString *location = userDict[@"hometown"][@"name"];
        //work
        NSArray *workArray = userDict[@"work"];
        NSDictionary *employerDict = [workArray lastObject];
        NSString *placeOfWork = employerDict[@"employer"][@"name"];
        //education
        NSArray *educationArray = userDict[@"education"];
        NSDictionary *schoolDict = [educationArray lastObject];
        NSString *lastSchool = schoolDict[@"school"][@"name"];
        //likes
        NSDictionary *likeDict = userDict[@"likes"];

        if (likeDict)
        {
            Facebook *face = [Facebook new];
            NSArray *likes = likeDict[@"data"];
            face.likes = likes;

        }
            Facebook *face = [Facebook new];

            face.givenName = name;
            face.lastName = lastName;
            face.identification = faceID;
            face.work = placeOfWork;
            face.school = lastSchool;
            face.gender = gender;
            face.birthday = birthday;
            face.location = location;

            [facebookItems addObject:face];
        }

    return facebookItems;
}




+(NSArray *)parseThumbnailPaging:(NSDictionary *)results withError:(NSError *)error
{
    NSError *localError = nil;

    if (localError != nil)
    {
        error = localError;
        return nil;
    }
    NSMutableArray *parsedPaging = [NSMutableArray new];
    NSDictionary *paging = results[@"paging"];

    //NSLog(@"pagings: %@", paging);

    if (paging)
    {
        Facebook *face = [Facebook new];

        if (paging[@"next"])
        {
            NSString *next = paging[@"next"];
            face.nextPage = next;
        }
        if (paging[@"previous"])
        {
            NSString *previous = paging[@"previous"];
            face.previousPage = previous;
        }

        [parsedPaging addObject:face];

    }
    return parsedPaging;
}

+(NSArray *)parsePhotoAlbums:(NSDictionary *)results withError:(NSError *)error
{
    NSError *localError = nil;

    if (localError != nil)
    {
        error = localError;
        return nil;
    }
    NSMutableArray *parsedData = [NSMutableArray new];
    NSArray *data = results[@"data"];

    if (data)
    {

        for (NSDictionary *imageData in data)
        {
            Facebook *face = [Facebook new];

            face.albumId = imageData[@"id"];
            NSNumber *nSCount = imageData[@"count"];
            face.albumImageCount = [NSString stringWithFormat:@"%@", nSCount];
            face.albumName = imageData[@"name"];
            NSDictionary *picture = imageData[@"picture"];
            NSDictionary *data = picture[@"data"];
            face.albumImageURL = data[@"url"];
            NSURL *url = [NSURL URLWithString:data[@"url"]];
            face.albumImageData = [NSData dataWithContentsOfURL:url];

            [parsedData addObject:face];
        }
    }

    return parsedData;
}

+(NSArray *)parseAlbum:(NSDictionary *)results withError:(NSError *)error
{
    NSError *localError = nil;

    if (localError != nil)
    {
        error = localError;
        return nil;
    }
    NSMutableArray *parsedData = [NSMutableArray new];
    NSArray *data = results[@"data"];

    if (data)
    {
        for (NSDictionary *dict in data)
        {
            Facebook *face = [Facebook new];
            face.albumImageURL = dict[@"source"];
            NSURL *url = [NSURL URLWithString:dict[@"source"]];
            face.albumImageData = [NSData dataWithContentsOfURL:url];
            face.albumtimestamp = dict[@"updated_time"];
            face.albumImageID = dict[@"id"];

            [parsedData addObject:face];
        }
    }
    
    return parsedData;
}

+(NSArray *)parseAlbumPaging:(NSDictionary *)results withError:(NSError *)error
{
    NSError *localError = nil;
    
    if (localError != nil)
    {
        error = localError;
        return nil;
    }
    NSMutableArray *parsedPagingData = [NSMutableArray new];
    NSDictionary *paging = results[@"paging"];
    
    if (paging)
    {
        Facebook *face = [Facebook new];
        NSString *next = paging[@"next"];
        NSString *prev = paging[@"previous"];

        if (next)
        {
            face.nextPage = next;
        }
        
        if (prev)
        {
            face.previousPage = prev;
        }

        [parsedPagingData addObject:face];
    }
    
    return parsedPagingData;
}

@end