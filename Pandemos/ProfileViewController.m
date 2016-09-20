//
//  ProfileViewController.m
//  Pandemos
//
//  Created by Michael Sevy on 12/19/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import "ProfileViewController.h"
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "CVSettingCell.h"
#import <LXReorderableCollectionViewFlowLayout.h>
#import "User.h"
#import "FacebookManager.h"
#import "UserManager.h"
#import "SelectedImageViewController.h"
#import "HeaderForProfileVC.h"
#import "SVProgressHUD.h"
#import "AllyAdditions.h"

#import <Bolts/BFTask.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4.h>
#import <Parse/PFConstants.h>
#import "PFFacebookUtils.h"

static NSString * const k_cell_id = @"SettingCell";

@interface ProfileViewController ()
<MFMailComposeViewControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UITextViewDelegate,
UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout,
LXReorderableCollectionViewDelegateFlowLayout,
LXReorderableCollectionViewDataSource,
UIPopoverPresentationControllerDelegate,
UserManagerDelegate>
{
    UIImagePickerController *ipc;
}


//View Properties
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewInsideScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextView *textViewAboutMe;
@property (weak, nonatomic) IBOutlet UILabel *addOrSwapLabel;

@property (weak, nonatomic) IBOutlet UILabel *minimumAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesAwayLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;

@property (weak, nonatomic) IBOutlet UIButton *SwapAddPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *interestedSexLabel;
@property (weak, nonatomic) IBOutlet UIButton *menButton;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;
@property (weak, nonatomic) IBOutlet UIButton *bothButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookAlbumsButton;

@property (weak, nonatomic) IBOutlet UISwitch *publicProfileSwitch;
@property (weak, nonatomic) IBOutlet UISlider *milesSlider;
@property (weak, nonatomic) IBOutlet UISlider *minimumAgeSlider;
@property (weak, nonatomic) IBOutlet UISlider *maximumAgeSlider;
//strong global properties
@property (strong, nonatomic) NSString *aboutMe;
@property (strong, nonatomic) NSString *sexPref;
@property (strong, nonatomic) NSString *minAge;
@property (strong, nonatomic) NSString *maxAge;
@property (strong, nonatomic) NSString *miles;
@property (strong, nonatomic) NSString *publicProfile;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSMutableArray *profileImages;
@property (strong, nonatomic) FacebookManager *manager;
@property (strong, nonatomic) UserManager *userManager;

@property (strong, nonatomic) NSString *iPhoneImageString;
@property (strong, nonatomic) NSString *selectedImage;
@property (strong, nonatomic) NSData *selectedData;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [User currentUser];





    if (self.currentUser)
    {
        [self loadNavigationBarItems];
        
        self.locationLabel.text = self.cityAndState;
        //placeholder
        //self.locationLabel.text = @"Location";

        self.profileImages = [NSMutableArray new];
        self.textViewAboutMe.delegate = self;

        [UICollectionView setupBorder:self.collectionView];
        self.collectionView.delegate = self;
        [self setFlowLayout];

        [self setupButtonsAndTextView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    //the only way scrolling works is if contentsize is set here between the viewinside and the scrollview alloc/init, when this is moved contentSize says 950, but it wont scroll
    [SVProgressHUD show];

    self.viewInsideScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 950)];
    //self.viewInsideScrollView.userInteractionEnabled = YES;

    self.scrollView.contentSize = CGSizeMake(375,950);

    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 667)];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;

    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.exclusiveTouch = YES;
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.delaysContentTouches = NO;


    //self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = YES;
    //self.scrollView.clipsToBounds = YES;

    [self.scrollView addSubview:self.viewInsideScrollView];


    NSLog(@"scrollView: %f, viewinside scrollView: %f & content size: %f", self.scrollView.frame.size.height, self.viewInsideScrollView.frame.size.height, self.scrollView.contentSize.height);

    [self setupManagersProfileVC];

    [UIButton setUpLargeButton:self.SwapAddPhotoButton];
    [UIButton setUpLargeButton:self.facebookAlbumsButton];
    [self.facebookAlbumsButton setEnabled:YES];
    [self.SwapAddPhotoButton setEnabled:YES];

    //on reload scroll to top
    [self.milesSlider setUserInteractionEnabled:YES];
    [self.minimumAgeSlider setUserInteractionEnabled:YES];
    [self.maximumAgeSlider setUserInteractionEnabled:YES];

    if ([UserManager sharedSettings].dataImage)
    {
        [self performSegueWithIdentifier:@"Selected" sender:self];
    }
    else if([UserManager sharedSettings].urlImage)
    {
        [self performSegueWithIdentifier:@"Selected" sender:self];
    }
    // add buttons
//    [self addViewObjects];
    //add constraints for view objects
  //   [self addLabelConstraints];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"begun dragging");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark -- TEXTVIEW DELEGATE
-(void)textViewDidChange:(UITextView *)textView
{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [textView.text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;

    if (textView.text.length > 280)
    {
        if (location != NSNotFound)
        {
            [textView resignFirstResponder];
            NSLog(@"editing: %@", textView.text);
        }
    }
    else if (location != NSNotFound)
    {
        [textView resignFirstResponder];

        NSLog(@"text from shouldChangeInRange: %@", textView.text);

        NSString *aboutMeDescr = textView.text;
        NSLog(@"save textView: %@", aboutMeDescr);

        [self.currentUser setObject:aboutMeDescr forKey:@"aboutMe"];

        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

            if (error)
            {
                NSLog(@"cannot save: %@", error.description);
            }
            else
            {
                NSLog(@"saved successful: %s", succeeded ? "true" : "false");
            }
        }];
    }
}

#pragma mark -- COLLECTIONVIEW DELEGATE
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(300, 20);
}

-(HeaderForProfileVC *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderForProfileVC *header = nil;
    static NSString *imagesDesc = @"*Hold and drag photos to change their order";
    static NSString *identifier = @"ImageDescription";

    if (kind == UICollectionElementKindSectionHeader)
    {
        HeaderForProfileVC *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
        headerView.headerTitle.text = imagesDesc;
        headerView.backgroundColor = [UIColor lightGrayColor];
        header = headerView;
    }

    return header;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.profileImages.count;
}

-(CVSettingCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CVSettingCell *cell = (CVSettingCell *)[collectionView dequeueReusableCellWithReuseIdentifier:k_cell_id forIndexPath:indexPath];
    PFFile *pfFile = [self.profileImages objectAtIndex:indexPath.item];
    cell.userImage.image = [UIImage imageWithString:pfFile.url];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *photoString = [self.profileImages objectAtIndex:fromIndexPath.item];
    [self.profileImages removeObjectAtIndex:fromIndexPath.item];
    [self.profileImages insertObject:photoString atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dragging cell begun");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dragging has stopped");
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFFile *pfFile = [self.profileImages objectAtIndex:indexPath.item];
    [UserManager sharedSettings].urlImage = pfFile.url;
    [self performSegueWithIdentifier:@"Selected" sender:self];
}

#pragma mark -- BUTTONS/SLIDERS
//3) Min/Max Ages
- (IBAction)onMinAgeSliderChange:(UISlider *)sender
{
    NSLog(@"slider sender: %.0f", truncf(sender.value));
    NSString *minAgeStr = [NSString stringWithFormat:@"%.0f", truncf(self.minimumAgeSlider.value)];
    NSString *minAge = [NSString stringWithFormat:@"Minimum Age: %@", minAgeStr];
    self.minimumAgeLabel.text = minAge;

    [self.minimumAgeSlider setThumbImage:[self.minimumAgeSlider thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    float minValue = 18.0f;

    if ([(UISlider*)sender value] < minValue)
    {
        [(UISlider*)sender setValue:minValue];
    }
    self.minimumAgeSlider.minimumTrackTintColor = [UIColor yellowGreen];
    self.minimumAgeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    self.minimumAgeSlider.thumbTintColor = [UIColor lightGrayColor];

    [self.currentUser setObject:minAgeStr forKey:@"minAge"];

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"error in saving min Age: %@", error);
        }
    }];
}

- (IBAction)onMaxAgeSliderChange:(UISlider *)sender
{
    NSLog(@"slider sender: %.0f", truncf(sender.value));
    NSString *maxAgeStr = [NSString stringWithFormat:@"%.0f", truncf(self.maximumAgeSlider.value)];
    NSString *maxAge = [NSString stringWithFormat:@"Maximum Age: %@", maxAgeStr];
    self.maximumAgeLabel.text = maxAge;

    [self.maximumAgeSlider setThumbImage:[self.maximumAgeSlider thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.maximumAgeSlider.minimumTrackTintColor = [UIColor yellowGreen];
    self.maximumAgeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    self.maximumAgeSlider.thumbTintColor = [UIColor lightGrayColor];

    [self.currentUser setObject:maxAgeStr forKey:@"maxAge"];

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"error in saving Max Age: %@", error);
        }
    }];
}

// 4) Sex Preference
- (IBAction)onMensButton:(UIButton *)sender
{
    NSLog(@"mens tapped");
    [self changeButtonState:self.menButton sexString:@"male" otherButton1:self.womenButton otherButton2:self.bothButton];
}

- (IBAction)onWomensButton:(UIButton *)sender
{
    NSLog(@"womens tapped");

    [self changeButtonState:self.womenButton sexString:@"female" otherButton1:self.menButton otherButton2:self.bothButton];
}

- (IBAction)onBothButton:(UIButton *)sender
{
    NSLog(@"both tapped");
    [self changeButtonState:self.bothButton sexString:@"male female" otherButton1:self.menButton otherButton2:self.womenButton];
}

- (IBAction)onMilesSliderChanged:(UISlider *)sender
{
    NSLog(@"miles value: %d", (int)sender);
    NSString *milesAwayStr = [NSString stringWithFormat:@"%.f", self.milesSlider.value];
    NSString *milesAway = [NSString stringWithFormat:@"Show results within %@ miles of here", milesAwayStr];
    self.milesAwayLabel.text = milesAway;
    [self.currentUser setObject:milesAwayStr forKey:@"milesAway"];

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"error in saving miles away: %@", error);
        }
        else
        {
            //NSLog(@"SAVED:%@ %s", milesAwayStr, succeeded ? "true" : "false");
        }
    }];
}

//6)Puublic Profile
- (IBAction)publicProfileSwitch:(UISwitch *)sender
{
    if ([sender isOn])
    {
        [self.currentUser setObject:@"public" forKey:@"publicProfile"];
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"error in saving public profile: %@", error);
            }
            else
            {
                NSLog(@"saved: %s", succeeded ? "true" : "false");
            }
        }];
    }
    else
    {
        [self.currentUser setObject:@"private" forKey:@"publicProfile"];
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error in saving pub profile: %@", error);
            } else{
                NSLog(@"saved: %s", succeeded ? "true" : "false");
            }
        }];
    }
}

- (IBAction)feedback:(UIButton *)sender
{
    NSLog(@"feedback tapped");

    //subject line and body of email to send
    NSString *emailTitle = @"Feedback";
    NSString *messageBody = @"message body";
    NSArray *reciepents = [NSArray arrayWithObject:@"michealsevy@gmail.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:reciepents];

    [self presentViewController:mc animated:YES completion:nil];
}

#pragma mark - USER MANAGER DELEGATE
-(void)didReceiveUserData:(NSArray *)data
{
    NSDictionary *userData = [data firstObject];
    self.sexPref = userData[@"sexPref"];
    [self sexPreferenceButton];

    self.aboutMe = userData[@"aboutMe"];
    if (self.aboutMe)
    {
        self.textViewAboutMe.text = self.aboutMe;
    }
    else
    {
        self.textViewAboutMe.text = @"Tell us about you, 280 characters max";
    }

    NSString *miles = userData[@"milesAway"];
    [self setMilesAway:miles];
    [self.milesSlider setThumbImage:[self.minimumAgeSlider thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.milesSlider.minimumTrackTintColor = [UIColor yellowGreen];
    self.milesSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    self.milesSlider.thumbTintColor = [UIColor lightGrayColor];

    NSString *min = userData[@"minAge"];
    NSString *max = userData[@"maxAge"];
    [self setMinAndMaxAgeSliders:min andMax:max];
    [self.minimumAgeSlider setThumbImage:[self.minimumAgeSlider thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.minimumAgeSlider.minimumTrackTintColor = [UIColor yellowGreen];
    self.minimumAgeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    self.minimumAgeSlider.thumbTintColor = [UIColor lightGrayColor];

    [self.maximumAgeSlider setThumbImage:[self.maximumAgeSlider thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.maximumAgeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    self.maximumAgeSlider.minimumTrackTintColor = [UIColor yellowGreen];
    self.maximumAgeSlider.thumbTintColor = [UIColor lightGrayColor];

    self.jobLabel.text = userData[@"work"];
    self.educationLabel.text = userData[@"lastSchool"];
    [self setPublicProfile:userData[@"publicProfile"]];
}

-(void)failedToFetchUserData:(NSError *)error
{
    NSLog(@"failed to fetch Data: %@", error);
}

-(void)didReceiveUserImages:(NSArray *)images
{
    self.profileImages = [NSMutableArray arrayWithArray:images];
    
    [self.collectionView reloadData];
    self.scrollView.contentSize = CGSizeMake(375, 900);
    self.scrollView.userInteractionEnabled = YES;
    [SVProgressHUD dismiss];

//    self.scrollView.contentSize = CGSizeMake(375,900);
//    NSLog(@"scroll view: %0.f", self.scrollView.contentSize.height);
}

-(void)failedToFetchImages:(NSError *)error
{
    NSLog(@"failed to fetch profile images: %@", error);
}

#pragma mark -- SEGUE
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Selected"])
    {
//        UINavigationController *navController = [segue destinationViewController];
//        SelectedImageViewController *sivc = (SelectedImageViewController*)([navController viewControllers][0]);
        [SVProgressHUD dismiss];


    }
}

#pragma mark -- NAV
- (IBAction)onFacebookAlbums:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"Swap" sender:self];
    [UIButton changeButtonStateForSingleButton:self.facebookAlbumsButton];
}

- (IBAction)onPreviewTapped:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"Preview" sender:self];
}

- (IBAction)logoutTest:(UIButton *)sender
{
    NSLog(@"button tapped");

//    if (sender.isSelected)
//    {
//        self.logoutButton.backgroundColor = [UIColor blackColor];


        //[PFUser logOut];



        //[PFFacebookUtils unlinkUserInBackground:self.currentUser];

        [PFFacebookUtils unlinkUserInBackground:[User currentUser] block:^(BOOL succeeded, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"error unlinking: %@", error);
            }
            else
            {
                NSLog(@"logged out?: %@", self.currentUser.givenName);
                [self performSegueWithIdentifier:@"BackToMain" sender:self];
            }
        }];
        
//    }
}

- (IBAction)logOutButton:(UIButton *)sender
{

    if (sender.isSelected)
    {
        self.logoutButton.backgroundColor = [UIColor blackColor];

        [PFFacebookUtils unlinkUserInBackground:[User currentUser] block:^(BOOL succeeded, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"error unlinking: %@", error);
            }
            else
            {
                NSLog(@"logged out, no user: %@", self.currentUser);
                [self performSegueWithIdentifier:@"LoggedOut" sender:self];
            }
        }];
    }
}

- (IBAction)onBackButton:(id)sender
{
    [self performSegueWithIdentifier:@"BackToMain" sender:self];
}

#pragma mark -- Retrive or Take Image from Phone
- (IBAction)onSwapTapped:(UIButton *)sender
{
    [UIButton changeButtonStateForSingleButton:self.SwapAddPhotoButton];
    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = (id)self;

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                       ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                                       [self presentViewController:ipc animated:YES completion:nil];
                                   }];

    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)  {
                                        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        [self presentViewController:ipc animated:YES completion:nil];
                                    }];

    UIAlertAction *savedPhotosAction = [UIAlertAction actionWithTitle:@"Saved" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                            ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                            [self presentViewController:ipc animated:YES completion:nil];
                                        }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        [alertController dismissViewControllerAnimated:YES completion:^{
            [UIButton setUpLargeButton:self.SwapAddPhotoButton];

        }];
    }];

    [alertController addAction:cameraAction];
    [alertController addAction:libraryAction];
    [alertController addAction:savedPhotosAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *orginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *scaledImage = [UIImage imageWithImage:orginalImage scaledToScale:2.0];

    if (scaledImage)
    {
        NSData *dataImage = [[NSData alloc] init];
        dataImage = UIImagePNGRepresentation(scaledImage);
        [UserManager sharedSettings].dataImage = dataImage;
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- HELPERS
-(void)setupManagersProfileVC
{
    self.userManager = [UserManager new];
    self.userManager.delegate = self;

    [self.userManager loadUserData:self.currentUser];
    [self.userManager loadUserImages:self.currentUser];
}

-(void)loadNavigationBarItems
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor mikeGray],
                                 NSFontAttributeName :[UIFont fontWithName:@"GeezaPro" size:20.0]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.title = @"Settings";
    self.navigationController.navigationBar.barTintColor = [UIColor yellowGreen];

    UIImage *backToMatches = [UIImage imageWithImage:[UIImage imageNamed:@"Back"] scaledToSize:CGSizeMake(30.0, 30.0)];
    [self.navigationItem.leftBarButtonItem setImage:backToMatches];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor mikeGray];

    NSDictionary *attributesForRight = @{NSForegroundColorAttributeName:[UIColor mikeGray],
                                         NSFontAttributeName :[UIFont fontWithName:@"GeezaPro" size:18.0]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attributesForRight forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.title = @"Preview";
}

-(void)setupButtonsAndTextView
{
    [UIButton setUpLargeButton:self.menButton];
    [UIButton setUpLargeButton:self.womenButton];
    [UIButton setUpLargeButton:self.bothButton];
    [UIButton setUpLargeButton:self.logoutButton];
    [UIButton setUpLargeButton:self.deleteButton];
    [UIButton setUpLargeButton:self.shareButton];
    [UIButton setUpLargeButton:self.feedbackButton];

    self.textViewAboutMe.layer.cornerRadius = 10;
    [self.textViewAboutMe.layer setBorderWidth:1.0];
    [self.textViewAboutMe.layer setBorderColor:[UIColor grayColor].CGColor];
}

-(void)setFlowLayout
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 2;
    layout.headerReferenceSize = CGSizeMake(300, 20);

    LXReorderableCollectionViewFlowLayout *flowlayouts = [LXReorderableCollectionViewFlowLayout new];
    [flowlayouts setItemSize:CGSizeMake(100, 100)];
    [flowlayouts setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayouts.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowlayouts.headerReferenceSize = CGSizeMake(300, 20);
    flowlayouts.footerReferenceSize = CGSizeZero;

    [self.collectionView setCollectionViewLayout:flowlayouts];
    self.collectionView.contentInset = UIEdgeInsetsZero;
}

-(void)setPublicProfile:(NSString *)publicProfile
{
    if ([publicProfile containsString:@"public"])
    {
        [self.publicProfileSwitch setOn:YES animated:YES];
    }
    else
    {
        [self.publicProfileSwitch setOn:NO animated:YES];
    }
}

-(void)setMilesAway:(NSString *)milesAway
{
    CGFloat away = (CGFloat)[milesAway floatValue];
    self.milesSlider.value = away;
    NSString *milesAwayStr = [NSString stringWithFormat:@"Within: %.f miles of you", away];
    self.milesAwayLabel.text = milesAwayStr;
}

-(void)setMinAndMaxAgeSliders:(NSString *)min andMax:(NSString *)max
{
    CGFloat minAge = (CGFloat)[min floatValue];
    self.minimumAgeSlider.value = minAge;
    NSString *minAgeStr = [NSString stringWithFormat:@"Minimum Age: %.f", minAge];
    self.minimumAgeLabel.text = minAgeStr;

    CGFloat maxAge = (CGFloat)[max floatValue];
    self.maximumAgeSlider.value = maxAge;
    NSString *maxAgeStr = [NSString stringWithFormat:@"Minimum Age: %.f", maxAge];
    self.maximumAgeLabel.text = maxAgeStr;
}

-(void)sexPreferenceButton
{
    if ([self.sexPref isEqualToString:@"female"])
    {
        self.womenButton.backgroundColor = [UIColor blackColor];
    }

    else if ([self.sexPref isEqualToString:@"male"])
    {
        self.menButton.backgroundColor = [UIColor blackColor];
    }
    else if ([self.sexPref isEqualToString:@"male female"])
    {
        self.bothButton.backgroundColor = [UIColor blackColor];
    }
    else
    {
        NSLog(@"sex Pref data not working");
    }
}

-(void)changeButtonState:(UIButton *)button sexString:(NSString *)sex otherButton1:(UIButton *)b1 otherButton2:(UIButton *)b2
{
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.currentUser setObject:sex forKey:@"sexPref"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saved for %@, %d", sex, succeeded ? true : false);
    }];

    if ([button isSelected])
    {
        [button setSelected:NO];
        button.backgroundColor = [UIColor blackColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    else
    {
        //change other two buttons
        [button setSelected:YES];
        [b1 setSelected:NO];
        [b2 setSelected:NO];
        [b1 setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        [b2 setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        b1.backgroundColor = [UIColor whiteColor];
        b2.backgroundColor = [UIColor whiteColor];
    }
}

-(void)addLabelConstraints
{
    NSDictionary *imageDict = @{@"collection" : self.collectionView, @"addOr" : self.addOrSwapLabel, @"faceButton" : self.facebookAlbumsButton, @"swapOr" : self.SwapAddPhotoButton, @"textView" : self.textViewAboutMe, @"minAge" : self.minimumAgeLabel, @"minSlider" : self.minimumAgeSlider, @"maxAge" : self.maximumAgeLabel, @"maxSlider" : self.maximumAgeSlider, @"interest": self.interestedSexLabel, @"men" : self.menButton, @"women" : self.womenButton, @"both" : self.bothButton, @"location" : self.locationLabel, @"milesAway" : self.milesAwayLabel, @"milesSlider" : self.milesSlider, @"job" : self.jobLabel, @"education" : self.educationLabel, @"feedback" : self.feedbackButton, @"share" : self.shareButton, @"logout" : self.logoutButton, @"delete" : self.deleteButton};

    NSArray *yPosition = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[collection]-[addOr]-[faceButton]-[textView]-[minAge]-[minSlider]-[maxAge]-[maxSlider]-[interest]-[men]-[location]-[milesAway]-[milesSlider]-[job]-[education]-[feedback]-40-[logout]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *xCollectionView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[collection]-20-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:imageDict];

    NSArray *xAddOr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[addOr]-50-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:imageDict];

    NSArray *xFace = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[faceButton]-20-[swapOr]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:imageDict];

    NSArray *xTextView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[textView]-20-|"
                                                             options:0
                                                             metrics:nil
                                                               views:imageDict];

    NSArray *xMinAge = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[minAge]-|"
                                                             options:0
                                                             metrics:nil
                                                               views:imageDict];

    NSArray *xMinSlider = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[minSlider]-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:imageDict];

    NSArray *xMaxAge = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[maxAge]-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:imageDict];

    NSArray *xMaxSlider = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[maxSlider]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:imageDict];

    NSArray *xInterest = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[interest]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:imageDict];

    NSArray *xPosForSexButtons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[men]-20-[women]-20-[both]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:imageDict];

    NSArray *xLocationLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[location]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:imageDict];

    NSArray *xMilesAway = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[milesAway]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:imageDict];

    NSArray *xMilesSlider = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[milesSlider]-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:imageDict];

    NSArray *xJobLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[job]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:imageDict];


    NSArray *xEducation = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[education]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:imageDict];

    NSArray *xPosForFeedback = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[feedback]-50-[share]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:imageDict];

    NSArray *xPosForLogout = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[logout]-50-[delete]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:imageDict];

    [self.viewInsideScrollView addConstraints:yPosition];
    [self.viewInsideScrollView addConstraints:xCollectionView];
    [self.viewInsideScrollView addConstraints:xAddOr];
    [self.viewInsideScrollView addConstraints:xFace];
    [self.viewInsideScrollView addConstraints:xTextView];
    [self.viewInsideScrollView addConstraints:xMinAge];
    [self.viewInsideScrollView addConstraints:xMinSlider];
    [self.viewInsideScrollView addConstraints:xMaxAge];
    [self.viewInsideScrollView addConstraints:xMaxSlider];
    [self.viewInsideScrollView addConstraints:xInterest];
    [self.viewInsideScrollView addConstraints:xPosForSexButtons];
    [self.viewInsideScrollView addConstraints:xLocationLabel];
    [self.viewInsideScrollView addConstraints:xMilesAway];
    [self.viewInsideScrollView addConstraints:xMilesSlider];
    [self.viewInsideScrollView addConstraints:xJobLabel];
    [self.viewInsideScrollView addConstraints:xEducation];
    [self.viewInsideScrollView addConstraints:xPosForFeedback];
    [self.viewInsideScrollView addConstraints:xPosForLogout];


}

-(void)addViewObjects
{
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.collectionView];

    self.addOrSwapLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.addOrSwapLabel];

    self.facebookAlbumsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.facebookAlbumsButton];
    self.SwapAddPhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.SwapAddPhotoButton];

    self.textViewAboutMe.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.textViewAboutMe];

    self.minimumAgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.minimumAgeLabel];
    self.minimumAgeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.minimumAgeSlider];

    self.maximumAgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.maximumAgeLabel];
    self.maximumAgeSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.maximumAgeSlider];

    self.interestedSexLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.interestedSexLabel];
    self.menButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.menButton];
    self.womenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.womenButton];
    self.bothButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.bothButton];

    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.locationLabel];
    self.milesAwayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.milesAwayLabel];
    self.milesSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.milesSlider];

    self.jobLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.jobLabel];
    self.educationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.educationLabel];

    self.feedbackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.feedbackButton];
    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.shareButton];
    self.logoutButton.translatesAutoresizingMaskIntoConstraints  = NO;
    [self.viewInsideScrollView addSubview:self.logoutButton];
    self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewInsideScrollView addSubview:self.deleteButton];
}
@end