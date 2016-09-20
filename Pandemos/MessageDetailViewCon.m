//
//  MessageDetailViewCon.m
//  Pandemos
//
//  Created by Michael Sevy on 1/13/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "MessageDetailViewCon.h"
#import "MessagingList.h"
#import "User.h"
#import "MessageManager.h"
#import "UserManager.h"
#import "MatchView.h"
#import "MessagerProfileInfo.h"
#import "MNCChatMessageCell.h"
#import "AllyAdditions.h"

@interface MessageDetailViewCon ()<UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate,
MatchViewDelegate,
UserManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *textEntryTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToMessaging;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardToUserDetail;

@property BOOL reloading;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) MessageManager *messageManager;

@property (strong, nonatomic) NSString *userImage;
@property (strong, nonatomic) NSString *userGiven;
@property (strong, nonatomic) NSString *user;

@property (strong, nonatomic) NSArray *messages;

@end

@implementation MessageDetailViewCon

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentUser = [User currentUser];
    self.messageManager = [MessageManager new];
    self.messages = [NSArray new];

    self.navigationController.navigationBar.barTintColor = [UIColor yellowGreen];
    self.backToMessaging.image = [UIImage imageWithImage:[UIImage imageNamed:@"Back"] scaledToSize:CGSizeMake(25.0, 25.0)];
    self.backToMessaging.tintColor = [UIColor mikeGray];

    UITapGestureRecognizer *tapTableGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView)];
    [self.tableView addGestureRecognizer:tapTableGR];

    self.textEntryTextField.delegate = self;
    self.textEntryTextField.layer.cornerRadius = 8;
    [self.textEntryTextField setBackgroundColor:[UIColor whiteColor]];
    [self.textEntryTextField.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.textEntryTextField.layer setBorderWidth:1.0];

    [self registerForKeyboardNotifications];

    self.tableView.delegate = self;
   // self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self queryForMessages];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadRecipientUserData];
    self.sendButton.layer.cornerRadius = 8;
    self.sendButton.layer.masksToBounds = YES;
}

- (void)didTapOnTableView
{
    [self.activeTextField resignFirstResponder];
}

#pragma mark -- TEXTFIELD DELEGATES
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    [self scrollTableToBottom];
    NSLog(@"started typing message");
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}

- (IBAction)onSendMessage:(UIButton *)sender
{
    self.sendButton.backgroundColor = [UIColor lightGrayColor];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self sendMessage:sender];
}

-(void)sendMessage:(id)sender
{
    [self.messageManager sendMessage:[User currentUser] toUser:[UserManager sharedSettings].recipient withText:self.activeTextField.text withSuccess:^(BOOL success, NSError *error) {

        if (success)
        {
            self.sendButton.backgroundColor = [UIColor yellowGreen];
            [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            self.activeTextField.text = @"";
            [self scrollTableToBottom];
            [self queryForMessages];
        }
    }];
}
- (void)scrollTableToBottom
{
    int rowNumber = (int)[self.tableView numberOfRowsInSection:0];
    if (rowNumber > 0) [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark -- TABLEVIEW DELEGATES

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNCChatMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"MNCCell" forIndexPath:indexPath];
    messageCell.layer.cornerRadius = 13.75;
    messageCell.layer.masksToBounds = YES;
    [self configureCell:messageCell forIndexPath:indexPath];

    return messageCell;
}

#pragma mark -- HELPERS
-(void)queryForMessages
{
    [self.messageManager queryForFirst50Messages:[UserManager sharedSettings].recipient withBlock:^(NSArray *result, NSError *error) {

        if(result)
        {
            if (result.count < 50)
            {
                self.messages = result;
                NSLog(@"messages: %d", (int)self.messages.count);
            }
            else
            {
                NSLog(@"over 50 messges for pagnation");
            }
        }
        else
        {
            NSLog(@"error: %@", error);
        }

        [self.tableView reloadData];

        [self scrollTableToBottom];
    }];
}

-(void)configureCell:(MNCChatMessageCell *)messageCell forIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *chatMessage = self.messages[indexPath.row];
    User *fromUser = chatMessage[@"fromUser"];
    //User *toUser = chatMessage[@"toUser"];
    NSString *text = chatMessage[@"text"];
    //for footer
    NSDate *time = chatMessage[@"timestamp"];
    NSString *timeFormatted = [NSString timeFromData:time];


    
    if ([fromUser.objectId isEqualToString:[User currentUser].objectId])
    {
        //OUTGOING... hide incoming
        messageCell.chatMessageLabel.text = @"";
        messageCell.incomingTimestampFooter.text = @"";
        messageCell.recipientImage.hidden = YES;

        messageCell.yourImage.hidden = NO;
        messageCell.myMessageLabel.backgroundColor = [UIColor clearColor];
        messageCell.myMessageLabel.text = text;
        messageCell.outgoingTimestampFooter.text = timeFormatted;
        messageCell.myMessageLabel.numberOfLines = 0;
        messageCell.myMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageCell.yourImage.layer.cornerRadius = 15.0;
        messageCell.yourImage.layer.masksToBounds = YES;
        PFFile *pf = [User currentUser].profileImages.firstObject;
        messageCell.yourImage.image = [UIImage imageWithString:pf.url];
        //[messageCell.myMessageLabel sizeToFit];
        //[messageCell.outgoingTimestampFooter sizeToFit];

    }
    else
    {
        //INCOMING... hide outgoing
        messageCell.myMessageLabel.text = @"";
        messageCell.outgoingTimestampFooter.text = @"";
        messageCell.yourImage.hidden = YES;

        messageCell.recipientImage.hidden = NO;
        messageCell.chatMessageLabel.backgroundColor = [UIColor clearColor];
        messageCell.chatMessageLabel.text = text;
        messageCell.incomingTimestampFooter.text = timeFormatted;
        messageCell.chatMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageCell.chatMessageLabel.numberOfLines = 0;
        messageCell.recipientImage.layer.cornerRadius = 15.0;
        messageCell.recipientImage.layer.masksToBounds = YES;
        messageCell.recipientImage.image = [UIImage imageWithString:self.userImage];
    }
}

-(void)loadRecipientUserData
{
    UserManager *userManager = [UserManager new];
    [userManager queryForUserData:[UserManager sharedSettings].recipient.objectId withUser:^(User *users, NSError *error) {

        self.userGiven = users[@"givenName"];
        NSArray<PFFile*> *array = users[@"profileImages"];
        PFFile *image = array.firstObject;
        self.userImage = image.url;

        [self loadMatchView];
    }];
}

-(void)loadMatchView
{
    MatchView *matchView = [[MatchView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.navigationItem.titleView = matchView;
    matchView.delegate = self;
    [matchView setMatchViewWithChatter:self.userGiven];
    [matchView setMatchViewWithChatterDetailImage:self.userImage];
}

#pragma mark -- MATCHVIEW DELEGATE
-(void)didPressMatchView
{
    [self performSegueWithIdentifier:@"toUserInfo" sender:self];
}

#pragma mark - Navigation
- (IBAction)onBackToMessaging:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --KEYBOARD NOTIFS
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"keyboard shown adjustment");

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(kbSize.height, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;




    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin))
    {
        [self.tableView scrollRectToVisible:self.activeTextField.frame animated:NO];

        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height -  self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
@end
