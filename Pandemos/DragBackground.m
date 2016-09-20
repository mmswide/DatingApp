

#import "DragBackground.h"
#import "AppConstants.h"
#import "UIImage+Additions.h"

#import "SVProgressHUD.h"
#import "AcceptedMatchView.h"

@implementation DragBackground{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)

    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
static float CARD_HEIGHT;
static float CARD_WIDTH;

@synthesize allCards;//%%% all the cards
@synthesize profileImages;
@synthesize alreadyMatched;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [super layoutSubviews];

        [SVProgressHUD show];

        if (IS_IPHONE4)
        {
            CARD_WIDTH = 320 - 20;
            CARD_HEIGHT = 480 - 50;
        }
        else if (IS_IPHONE5)
        {
            CARD_WIDTH = 320 - 20;
            CARD_HEIGHT = 568 - 55;
        }
        else if (IS_IPHONE6)
        {
            CARD_WIDTH = 375 - 30;
            CARD_HEIGHT = 667 - 70;
        }
        else if (IS_IPHONE6PLUS)
        {
            CARD_WIDTH = 414 - 40;
            CARD_HEIGHT = 736 - 80;
        }

        self.userManager = [UserManager new];
        self.userManager.delegate = self;
        //load user data for search preferences
        [self.userManager loadUserData:[User currentUser]];
        
        //load user objects
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
    }

    return self;
}

//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DragView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    self.dragView = [[DragView alloc]initWithFrame:CGRectMake(15, 50, CARD_WIDTH, CARD_HEIGHT)];
                    //self.dragView.information.text = [exampleCardLabels objectAtIndex:index]; //%%% placeholder for card-specific information
    self.dragView.delegate = self;

    [self loadProfileImagesAtIndex:index];

    return self.dragView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([self.potentialMatchData count] > 0)
    {
        NSInteger numLoadedCardsCap =(([self.potentialMatchData count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[self.potentialMatchData count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen

        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[self.potentialMatchData count]; i++)
        {
            DragView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];

            NSLog(@"user matched count: %d", i);
            if (i<numLoadedCardsCap)
            {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++)
        {
            if (i > 0)
            {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            }
            else
            {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}

-(void)loadProfileImagesAtIndex:(NSInteger)i
{
    User *userDict = [self.potentialMatchData objectAtIndex:i];
    //changed to current user objectAtIndex

    //self.dragView = [[DragView alloc]initWithFrame:self.view.frame];
    
    NSString *nameAndAge = [NSString stringWithFormat:@"%@, %@", userDict[@"givenName"], [userDict[@"birthday"] ageFromBirthday:userDict[@"birthday"]]];
    self.dragView.nameLabel.text = nameAndAge;
    self.dragView.schoolLabel.text = userDict[@"lastSchool"];

    profileImages = userDict[@"profileImages"];

    NSLog(@"%d images for user: %@",(int)profileImages.count, nameAndAge);

    if (profileImages.count == 1)
    {
        [self loadOneImage];
    }
    else if (profileImages.count == 2)
    {
        [self loadTwoImages];
    }
    else if (profileImages.count == 3)
    {
        [self loadThreeImages];
    }
    else if (profileImages.count == 4)
    {
        [self loadFourImages];
    }
    else if (profileImages.count == 5)
    {
        [self loadFiveImages];
    }
    else if (profileImages.count == 6)
    {
        [self loadSixImages];
    }
}

//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    User *matchedObject = [self.potentialMatchData objectAtIndex:self.userCount];
    [self setNoStatusForMatchRequestObject:matchedObject];
    self.userCount++;

    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"

    if (cardsLoadedIndex < [allCards count])
    { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    else
    {
        NSLog(@"reached the end of your matches, insert a view");
    }
}

-(void)cardSwipedRight:(UIView *)card
{
    self.currentMatch = [self.potentialMatchData objectAtIndex:self.userCount];

    //check if a girl has already ok'd a boy, here they can speak now
    [self.userManager queryForRelationshipMatch:self.currentMatch withBlock:^(NSArray<User *> *matchedUser, NSError *error) {

        //compare curent match with all mathces to check for an already existing PFRelationship
        if (matchedUser)
        {
            for (User *matched in matchedUser)
            {

                if ([matched.objectId isEqualToString:self.currentMatch.objectId])
                {
                    //[self snapAcceptedMatchViewToStartNewConvo];
                    NSLog(@"boom we've got a match, send to messager");
                }
                else
                {
                    NSLog(@"no previous matches");
                    //[self setYesStatusForMatchRequestObject:self.currentMatch];
                }
            }
        }
        else
        {

            [self setYesStatusForMatchRequestObject:self.currentMatch];

            //not a previous match, so start the match process
        }
    }];


    //set match
    [self setYesStatusForMatchRequestObject:self.currentMatch];
    NSLog(@"matched: %@ & %@", _currentMatch.givenName, [User currentUser].givenName);


    //*** this is the magic that did it!!!
    self.userCount++;

    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"

    if (cardsLoadedIndex < [allCards count])
    { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    else
    {
        NSLog(@"reached the end of your matches, insert view");
    }

}

-(void)cardSwipedUp:(UIView *)card
{
    //call up action for new image
    NSLog(@"card swiped up");
}

-(void)cardSwipedDown:(UIView *)card
{
    NSLog(@"card swiped down");
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DragView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DragView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

#pragma mark -- HELPERS
-(void)snapAcceptedMatchViewToStartNewConvo
{
    self.alpha = .7;
    self.backgroundColor = [UIColor blackColor];

    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];

    AcceptedMatchView *matchView = [[AcceptedMatchView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    [self addSubview:matchView];

    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:matchView snapToPoint:CGPointMake(100, 300)];
    snapBehaviour.damping = 0.65f;
    [animator addBehavior:snapBehaviour];


}

#pragma mark - USER MANAGER DELEGATES
//Step 2
-(void)didReceiveUserData:(NSArray *)data
{
    NSDictionary *userData = [data firstObject];
    self.sexPref = userData[@"sexPref"];
    self.milesAway = userData[@"milesAway"];
    self.minAge = userData[@"minAge"];
    self.maxAge = userData[@"maxAge"];
    self.gender = userData[@"gender"];

    //this method take user preferences and returns allMatchedUsers
    [self.userManager loadUsersUnseenPotentialMatches:self.sexPref minAge:self.minAge maxAge:self.maxAge];
}

-(void)failedToFetchUserData:(NSError *)error
{
    NSLog(@"failed to fetch Data: %@", error);
}
//Step 3
-(void)didReceivePotentialMatchData:(NSArray *)data
{
    [self.userManager loadAlreadySeenMatches];//returns to the didLoadAlreadySeen
}
//Step 4
-(void)didLoadAlreadySeen:(NSArray<User *> *)users
{
    //NSLog(@"already seen users: %@", users);
    //loop through all matched users and compare to all current matches
    NSMutableArray *intersectionArray = [NSMutableArray arrayWithArray:self.userManager.allMatchedUsers];

    for (User *allMatches in self.userManager.allMatchedUsers)
    {
        NSLog(@"match: %@", allMatches.givenName);

        for (NSDictionary *matchRequest in users)//self.userManager.alreadySeenUser
        {
            User *fromUser = matchRequest[@"fromUser"];
            User *toUser = matchRequest[@"toUser"];

            if ([allMatches.objectId isEqualToString:fromUser.objectId] || [allMatches.objectId isEqualToString:toUser.objectId])
            {
                NSLog(@"filtered matches to remove: %@", allMatches.givenName);
                [intersectionArray removeObject:allMatches];
            }
        }
    }

    if (intersectionArray.count > 0)
    {
        self.potentialMatchData = intersectionArray;

        [self loadCards];
    }
    else
    {
        NSLog(@"no cards left");
    }
}

-(void)failedToFetchPotentialMatchData:(NSError *)error
{
    NSLog(@"NO POTENTIAL MATCHES FOR USER TO SEE: %@", error);
}



#pragma mark -- Swipe YES OR NO HELPERS
-(void)setYesStatusForMatchRequestObject:(User*)potentialMatch
{
    if ([self.gender isEqualToString:@"male"])
    {
        [self matchStatus:@"boyYes" potentialMatch:potentialMatch];
    }
    else if ([self.gender isEqualToString:@"female"])
    {
        [self matchStatus:@"girlYes" potentialMatch:potentialMatch];
    }
    else
    {
        NSLog(@"neither boy nor girl???");
    }
}

-(void)setNoStatusForMatchRequestObject:(User*)deniedMatch
{
    [self matchStatus:@"denied" potentialMatch:deniedMatch];
}

-(void)matchStatus:(NSString*)status potentialMatch:(User*)potMatch
{
//    [self.userManager createMatchRequestWithStringId:potMatch.objectId withStatus:status withCompletion:^(MatchRequest *matchRequest, NSError *error) {
//    }];
    [self.userManager createMatchRequest:potMatch withStatus:status withCompletion:^(MatchRequest *matchRequest, NSError *error) {
        if (matchRequest)
        {
            NSLog(@"match object: %@", matchRequest);
        }
    }];

}

-(void)didCreateMatchRequest:(MatchRequest *)matchRequest
{
    NSLog(@"match Request class successfully created: %@", matchRequest);

    //    NSDictionary *matchDict = matchRequest;
    NSString *status = matchRequest[@"status"];

    if ([status isEqualToString:@"denied"])
    {
        NSLog(@"no match it dies here, buried as a match request");
    }
    else if([status isEqualToString:@"boyYes"])
    {
        //        //************for TESTING***************
        [self.userManager addPFRelationWithPFCloudFunction:self.currentMatch andMatchRequest:matchRequest];
    }
    else if([status isEqualToString:@"girlYes"])
    {
        //        //************for TESTING***************
        [self.userManager addPFRelationWithPFCloudFunction:self.currentMatch andMatchRequest:matchRequest];
        /////////SEND EMAIL FOR APPROVAL/////////CLOUD CODE//////
        //send email through mail chimp + then figure out how to handle setitng up the PFRelation "match"

        //           [self.userManager updateMatchRequestWithRetrivalUserObject:matchRequest withResponse:@"lastStep" withSuccess:^(NSDictionary *userDict, NSError *error) {
        //
        //                if (!error)
        //                {
        //                    NSLog(@"update worked added PFRelation");
        //                    //calls didFetchUserObjectForFinalMatch
        //                }
        //            }];
        //    }
    }
}

#pragma mark -- USER IMAGES
-(void)loadOneImage
{
    self.dragView.imageScroll.contentSize = CGSizeMake(self.dragView.frame.size.width, self.dragView.frame.size.height * 1);

    PFFile *i0 = [profileImages objectAtIndex:0];
    self.dragView.profileImageView.image = [UIImage imageWithString:i0.url];

    [self.dragView.v2 removeFromSuperview];
    [self.dragView.v3 removeFromSuperview];
    [self.dragView.v4 removeFromSuperview];
    [self.dragView.v5 removeFromSuperview];
    [self.dragView.v6 removeFromSuperview];
    [SVProgressHUD dismiss];
}

-(void)loadTwoImages
{
    self.dragView.imageScroll.contentSize = CGSizeMake(self.dragView.frame.size.width, self.dragView.frame.size.height * 2);

    PFFile *i0 = [profileImages objectAtIndex:0];
    PFFile *i1 = [profileImages objectAtIndex:1];
    self.dragView.profileImageView.image = [UIImage imageWithString:i0.url];
    self.dragView.profileImageView2.image = [UIImage imageWithString:i1.url];

    [self.dragView.v3 removeFromSuperview];
    [self.dragView.v4 removeFromSuperview];
    [self.dragView.v5 removeFromSuperview];
    [self.dragView.v6 removeFromSuperview];
    [SVProgressHUD dismiss];
}

-(void)loadThreeImages
{
    self.dragView.imageScroll.contentSize = CGSizeMake(self.dragView.frame.size.width, self.dragView.frame.size.height * 3);

    PFFile *i0 = [profileImages objectAtIndex:0];
    PFFile *i1 = [profileImages objectAtIndex:1];
    PFFile *i2 = [profileImages objectAtIndex:2];
    self.dragView.profileImageView.image = [UIImage imageWithString:i0.url];
    self.dragView.profileImageView2.image = [UIImage imageWithString:i1.url];
    self.dragView.profileImageView3.image = [UIImage imageWithString:i2.url];

    [self.dragView.v4 removeFromSuperview];
    [self.dragView.v5 removeFromSuperview];
    [self.dragView.v6 removeFromSuperview];
    [SVProgressHUD dismiss];
}

-(void)loadFourImages
{
    self.dragView.imageScroll.contentSize = CGSizeMake(self.dragView.frame.size.width, self.dragView.frame.size.height * 4);

    PFFile *i0 = [profileImages objectAtIndex:0];
    PFFile *i1 = [profileImages objectAtIndex:1];
    PFFile *i2 = [profileImages objectAtIndex:2];
    PFFile *i3 = [profileImages objectAtIndex:3];
    self.dragView.profileImageView.image = [UIImage imageWithString:i0.url];
    self.dragView.profileImageView2.image = [UIImage imageWithString:i1.url];
    self.dragView.profileImageView3.image = [UIImage imageWithString:i2.url];
    self.dragView.profileImageView4.image = [UIImage imageWithString:i3.url];

    [self.dragView.v5 removeFromSuperview];
    [self.dragView.v6 removeFromSuperview];
    [SVProgressHUD dismiss];
}

-(void)loadFiveImages
{
    self.dragView.imageScroll.contentSize = CGSizeMake(self.dragView.frame.size.width, self.dragView.frame.size.height * 5);

    PFFile *i0 = [profileImages objectAtIndex:0];
    PFFile *i1 = [profileImages objectAtIndex:1];
    PFFile *i2 = [profileImages objectAtIndex:2];
    PFFile *i3 = [profileImages objectAtIndex:3];
    PFFile *i4 = [profileImages objectAtIndex:4];
    self.dragView.profileImageView.image = [UIImage imageWithString:i0.url];
    self.dragView.profileImageView2.image = [UIImage imageWithString:i1.url];
    self.dragView.profileImageView3.image = [UIImage imageWithString:i2.url];
    self.dragView.profileImageView4.image = [UIImage imageWithString:i3.url];
    self.dragView.profileImageView5.image = [UIImage imageWithString:i4.url];

    [self.dragView.v6 removeFromSuperview];
    [SVProgressHUD dismiss];
}

-(void)loadSixImages
{
    self.dragView.imageScroll.contentSize = CGSizeMake(self.dragView.frame.size.width, self.dragView.frame.size.height * 6);

    PFFile *i0 = [profileImages objectAtIndex:0];
    PFFile *i1 = [profileImages objectAtIndex:1];
    PFFile *i2 = [profileImages objectAtIndex:2];
    PFFile *i3 = [profileImages objectAtIndex:3];
    PFFile *i4 = [profileImages objectAtIndex:4];
    PFFile *i5 = [profileImages objectAtIndex:5];
    self.dragView.profileImageView.image = [UIImage imageWithString:i0.url];
    self.dragView.profileImageView2.image = [UIImage imageWithString:i1.url];
    self.dragView.profileImageView3.image = [UIImage imageWithString:i2.url];
    self.dragView.profileImageView4.image = [UIImage imageWithString:i3.url];
    self.dragView.profileImageView5.image = [UIImage imageWithString:i4.url];
    self.dragView.profileImageView6.image = [UIImage imageWithString:i5.url];
    [SVProgressHUD dismiss];
}
@end
