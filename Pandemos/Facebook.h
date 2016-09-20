//
//  FacebookData.h
//  Pandemos
//
//  Created by Michael Sevy on 2/18/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Facebook : NSObject
//Ind. FB Categories
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *timezone;
@property (strong, nonatomic) NSString *givenName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *identification;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *work;
@property (strong, nonatomic) NSString *school;



@property (strong, nonatomic) NSArray *likes;


//image properties-- THUMBS
@property (strong, nonatomic) NSString *thumbURL;
@property (strong, nonatomic) NSString *thumbPhotoID;
@property (strong, nonatomic) NSString *thumbTimeUpdated;
//ALBUMS
@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) NSString *albumImageCount;
@property (strong, nonatomic) NSString *albumImageURL;
@property (strong, nonatomic) NSData *albumImageData;
@property (strong, nonatomic) NSString *albumtimestamp;
@property (strong, nonatomic) NSString *albumImageID;
//PAGINATION
@property (strong, nonatomic) NSString *nextPage;
@property (strong, nonatomic) NSString *previousPage;
@property (strong, nonatomic) NSString *photoCount;

-(NSData *)stringURLToData:(NSString *)urlString;
-(NSString *)ageFromBirthday:(NSString *)birthday;
@end
