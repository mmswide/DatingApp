//
//  UserNetwork.h
//  Pandemos
//
//  Created by Michael Sevy on 4/6/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MatchRequest.h"

@class User;
@class PFQuery;
@class PFUser;

@protocol UserManagerDelegate <NSObject>

@required

@optional
-(void)didCreateUser:(PFUser*)user withError:(NSError*)error;
-(void)didReceiveUserData:(NSArray*)data;
-(void)failedToFetchUserData:(NSError*)error;
-(void)didReceiveUserImages:(NSArray*)images;
-(void)failedToFetchImages:(NSError*)error;
-(void)didReceivePotentialMatchData:(NSArray*)data;
-(void)failedToFetchPotentialMatchData:(NSError *)error;
-(void)didReceivePotentialMatchImages:(NSArray *)images;
-(void)failedToFetchPotentialMatchImages:(NSError*)error;
//match Requests
-(void)didLoadAlreadySeen:(NSArray<User*>*)users;
-(void)didCreateMatchRequest:(MatchRequest*)matchRequest;
-(void)failedToCreateMatchRequest:(NSError*)error;
-(void)didUpdateMatchRequest:(User *)user;
-(void)failedToUpdateMatchRequest:(NSError*)error;
-(void)didCreateDenyMatchRequest:(MatchRequest*)matchRequest;
-(void)failedToCreateDenyMatchRequest:(NSError*)error;
-(void)didComeFromMessaging:(BOOL)fromMessaging withUser:(User*)user;
-(void)didFetchUserObjectForFinalMatch:(User*)user;
-(void)didReturnImageDataCount:(NSDictionary*)userDict;
@end

@interface UserManager : NSObject

typedef void (^resultBlockWithMatchRequest)(MatchRequest *matchRequest, NSError *error);
typedef void (^resultBlockWithArray)(NSArray *users, NSError *error);
typedef void (^resultBlockWithUserData)(NSDictionary *userDict, NSError *error);
typedef void (^resultBlockWithUserConfidant)(NSString *confidant, NSError *error);
typedef void (^resultBlockWithUser)(User *user, NSError *error);
typedef void (^resultBlockWithMatchedUser)(NSArray<User*> *matchedUser, NSError *error);

@property(nonatomic, strong)NSMutableArray<User*> *allUsers;
@property(nonatomic, strong)NSArray<User*> *allMatchedUsers;
@property(nonatomic, strong)NSArray<User*> *alreadySeenUsers;
@property(nonatomic, strong)User *recipient;
@property(nonatomic, strong)NSData *dataImage;
@property(nonatomic, strong)NSString *urlImage;

@property (weak, nonatomic) id<UserManagerDelegate>delegate;

+(UserManager*)sharedSettings;

-(void)signUp:(PFUser*)user;
-(void)loadUserData:(User *)user;
-(void)loadUserImages:(User *)user;
-(void)loadUsersUnseenPotentialMatches:(NSString *)sexPref
                                minAge:(NSString *)min
                                maxAge:(NSString *)max;
-(void)createMatchRequest:(User*)user
               withStatus:(NSString*)status
           withCompletion:(resultBlockWithMatchRequest)result;
-(void)updateMatchRequestWithRetrivalUserObject:(MatchRequest*)matchRequest
             withResponse:(NSString*)response
              withSuccess:(resultBlockWithUserData)result;
-(void)loadAlreadySeenMatches;
-(void)fromMessaging:(User*)user;
-(void)queryForUserData:(NSString *)objectId
               withUser:(resultBlockWithUser)user;
-(void)queryForUsersConfidant:(resultBlockWithUserConfidant)confidant;
-(void)createMatchRequestWithStringId:(NSString*)strId
                           withStatus:(NSString*)status
                       withCompletion:(resultBlockWithMatchRequest)result;
-(void)secureMatchWithPFCloudFunction:(User*)recipientUser;
-(void)changePFRelationToDeniedWithPFCloudFunction:(User*)recipientUser;
-(void)queryForImageCount:(NSString *)objectId;
-(void)queryForRelationshipMatch:(User*)matchedUser withBlock:(resultBlockWithMatchedUser)match;
-(void)addPFRelationWithPFCloudFunction:(User*)recipientUser
                        andMatchRequest:(MatchRequest*)match;


-(void)sendEmailWithPFCloudFunction:(NSString*)confidantEmail withRelation:(PFRelation*)rela andMatchedUser:(User*)user;
@end





