//
//  InitialWalkThroughViewController.m
//  Pandemos
//
//  Created by Michael Sevy on 12/20/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import "InitialWalkThroughViewController.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SuggestionsViewController.h"
#import "Facebook.h"
#import "FacebookManager.h"
#import "FacebookNetwork.h"
#import "User.h"
#import "UserManager.h"
#import "SelectedImageViewController.h"
#import "SVProgressHUD.h"
#import "AllyAdditions.h"

@interface InitialWalkThroughViewController ()<
CLLocationManagerDelegate,
UITextViewDelegate,
UIScrollViewDelegate,
FacebookManagerDelegate,
UserManagerDelegate,
UIImagePickerControllerDelegate>
{
    UIImagePickerController *ipc;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textViewAboutMe;
@property (weak, nonatomic) IBOutlet UISlider *minAgeSlider;
@property (weak, nonatomic) IBOutlet UISlider *maxAgeSlider;
@property (weak, nonatomic) IBOutlet UISlider *milesSlider;
@property (weak, nonatomic) IBOutlet UILabel *minAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationlabel;
@property (weak, nonatomic) IBOutlet UILabel *milesAwayLabel;

@property (weak, nonatomic) IBOutlet UIButton *facebookAlbumBUtton;
@property (weak, nonatomic) IBOutlet UIButton *mensInterestButton;
@property (weak, nonatomic) IBOutlet UIButton *womensInterestButton;
@property (weak, nonatomic) IBOutlet UIButton *bothSexesButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotifications;
@property (weak, nonatomic) IBOutlet UIButton *imagesFromPhoneButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) FacebookManager *manager;
@property (strong, nonatomic) UserManager *userManager;

@property (strong, nonatomic) PFGeoPoint *pfGeoCoded;
@property (strong, nonatomic) NSString *userGender;
@property (strong, nonatomic) NSString *cameraImage;
@property (strong, nonatomic) NSData *dataImage;
@end

@implementation InitialWalkThroughViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [User currentUser];

    if (self.currentUser)
    {
        [self setupManagersForInitalWalkViewController];

        self.navigationController.navigationItem.title = @"Ally";
        self.navigationController.navigationBar.backgroundColor = [UIColor yellowGreen];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.scrollView.delegate = self;
        self.textViewAboutMe.delegate = self;

        [self setupLocation];
        [self setupButtons];

        [self defaultAgeSliderSet];
        [self defaultMilesAwaySliderSet];
        [self defaultPublicProfileSet];
    }
    else
    {
        NSLog(@"no user for face request");
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];

    [UIButton setUpLargeButton:self.continueButton];
    [UIButton setUpLargeButton:self.imagesFromPhoneButton];
    [UIButton setUpLargeButton:self.facebookAlbumBUtton];

    [SVProgressHUD dismiss];

    NSString *aboutMeDescription = [self.currentUser objectForKey:@"aboutMe"];
    if (aboutMeDescription)
    {
        self.textViewAboutMe.text = aboutMeDescription;
    }
    else
    {
        self.textViewAboutMe.text = @"Enter a little about yourself";
    }

    if ([UserManager sharedSettings].dataImage)
    {
        [self performSegueWithIdentifier:@"ChooseImage" sender:self];
    }
}

#pragma mark -- CLLOCATION
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //current location
    CLLocation *currentLocation = [locations firstObject];
    //NSLog(@"array of cuurent locations: %@", locations);
    double latitude = self.locationManager.location.coordinate.latitude;
    double longitude = self.locationManager.location.coordinate.longitude;

    [self.locationManager stopUpdatingLocation];

    NSString *latitudeStr = [NSString stringWithFormat:@"%f", latitude];
    NSString *longStr = [NSString stringWithFormat:@"%f", longitude];

    //save location in latitude and longitude
    [self.currentUser setObject:latitudeStr forKey:@"latitude"];
    [self.currentUser setObject:longStr forKey:@"longitude"];
    [self.currentUser saveInBackground];

    //get city and location from a CLPlacemark object
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *city = placemark.locality;
            NSDictionary *stateDict = placemark.addressDictionary;
            NSString *state = stateDict[@"State"];
            self.locationlabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
        }
    }];
}

#pragma mark -- TEXTVIEW DELEGATE
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -- NAV
- (IBAction)onFacebookAlbumsTapped:(UIButton *)sender
{
    [UIButton changeButtonStateForSingleButton:self.facebookAlbumBUtton];
    [self performSegueWithIdentifier:@"FacebookAlbums" sender:self];
}

-(IBAction)onContinueTapped:(UIButton *)sender
{
    [UIButton changeButtonStateForSingleButton:self.continueButton];

    if ([self.userGender isEqualToString:@"male"])
    {
        [self performSegueWithIdentifier:@"Matches" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ConfidantEmail" sender:self];
    }
}

#pragma mark -- IMAGE FROM PHONE
- (IBAction)onImagesFromPhone:(UIButton *)sender
{
    [UIButton changeButtonStateForSingleButton:self.imagesFromPhoneButton];

    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = (id)self;

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   {
                                       ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
                                       [self presentViewController:ipc animated:YES completion:nil];
                                   }];

    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        [self presentViewController:ipc animated:YES completion:nil];
                                    }];

    UIAlertAction *savedPhotosAction = [UIAlertAction actionWithTitle:@"Saved" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                        {
                                            ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                            [self presentViewController:ipc animated:YES completion:nil];
                                        }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

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

#pragma mark -- SEGUE
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"ChooseImage"])
//    {
//
//        //SelectedImageViewController *sivc = [(UINavigationController*)segue.destinationViewController topViewController];
//        //sivc.profileImageAsData = self.dataImage;
//    }
//}


#pragma mark -- AGE SLIDERS
- (IBAction)minSliderChange:(UISlider *)sender
{
    NSString *minAgeStr = [NSString stringWithFormat:@"%.f", self.minAgeSlider.value];
    NSString *minAge = [NSString stringWithFormat:@"Minimum Age: %@", minAgeStr];
    self.minAgeLabel.text = minAge;
    [self.currentUser setObject:minAgeStr forKey:@"minAge"];
    [self.currentUser saveInBackground];
}

- (IBAction)maxSliderChange:(UISlider *)sender
{
    NSString *maxAgeStr = [NSString stringWithFormat:@"%.f", self.maxAgeSlider.value];
    NSString *maxAge = [NSString stringWithFormat:@"Maximum Age: %@", maxAgeStr];
    self.maxAgeLabel.text = maxAge;

    [self.currentUser setObject:maxAgeStr forKey:@"maxAge"];
    [self.currentUser saveInBackground];
}

#pragma mark -- DISTANCE AWAY
- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSString *milesAwayStr = [NSString stringWithFormat:@"%.f", self.milesSlider.value];
    NSString *milesAway = [NSString stringWithFormat:@"Show results within %@ miles of here", milesAwayStr];
    self.milesAwayLabel.text = milesAway;

    [self.currentUser setObject:milesAwayStr forKey:@"milesAway"];
    [self.currentUser saveInBackground];
}

#pragma mark -- SEX PREFERENCE
- (IBAction)menInterestButton:(UIButton *)sender
{
    [UIButton changeButtonState:self.mensInterestButton];
    [UIButton changeOtherButton:self.womensInterestButton];
    [UIButton changeOtherButton:self.bothSexesButton];

    [self.currentUser setObject:@"male" forKey:@"sexPref"];
    [self.currentUser saveInBackground];
}
//W
- (IBAction)womenInterestButton:(UIButton *)sender
{
    [UIButton changeButtonState:self.womensInterestButton];
    [UIButton changeOtherButton:self.mensInterestButton];
    [UIButton changeOtherButton:self.bothSexesButton];

    [self.currentUser setObject:@"female" forKey:@"sexPref"];
    [self.currentUser saveInBackground];
}
//Both
- (IBAction)bothSexesInterestButton:(UIButton *)sender
{
    [UIButton changeButtonState:self.bothSexesButton];
    [UIButton changeOtherButton:self.womensInterestButton];
    [UIButton changeOtherButton:self.mensInterestButton];

    [self.currentUser setObject:@"male female" forKey:@"sexPref"];
    [self.currentUser saveInBackground];
}

#pragma mark -- PUSH NOTIFICATIONS
- (IBAction)pushNotificationsOnOff:(UISwitch *)sender
{
    if ([sender isOn])
    {
        NSLog(@"push notifs are on");
    }
    else
    {
        NSLog(@"push notifs are off");
    }
}

#pragma mark -- FACEBOOK MANAGER DELEGATE
-(void)didReceiveParsedUserData:(NSArray *)data
{
    [self saveToParse:data];
}

-(void)saveToParse:(NSArray*)facebookUserDataArray
{
    Facebook *face = [facebookUserDataArray firstObject];

    if (face.identification)
    {
        [self.currentUser setObject:face.identification forKey:@"faceID"];
    }
    if (face.givenName)
    {
        [self.currentUser setObject:face.givenName forKey:@"givenName"];
    }
    if (face.lastName)
    {
        [self.currentUser setObject:face.lastName forKey:@"lastName"];
    }
    if (face.birthday)
    {
        [self.currentUser setObject:face.birthday forKey:@"birthday"];

        [self.currentUser setObject:[face ageFromBirthday:face.birthday] forKey:@"userAge"];
    }
    if (face.gender)
    {
        [self.currentUser setObject:face.gender forKey:@"gender"];
        self.userGender = face.gender;
        [self sexPreferenceButton];
    }
    if (face.location)
    {
        [self.currentUser setObject:face.location forKey:@"facebookLocation"];
    }
    if (face.work)
    {
        [self.currentUser setObject:face.work forKey:@"work"];
    }
    if (face.school)
    {
        [self.currentUser setObject:face.school forKey:@"lastSchool"];
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

        NSLog(@"saved facebook user data to parse: %d", succeeded ? true : false);
    }];
}


-(void)failedToReceiveUserData:(NSError *)error
{
    NSLog(@"failed to get parsed Data %@", error);
}

#pragma mark - USERMANAGER DELEGATE
-(void)didReceiveUserData:(NSArray *)data
{
    NSDictionary *userData = [data firstObject];

    self.userGender = userData[@"gender"];

    [self sexPreferenceButton];
}

-(void)failedToFetchUserData:(NSError *)error
{
    NSLog(@"failed to fetch Data: %@", error);
}

-(void)didReceiveProfileImageData:(NSData *)data
{
    NSLog(@"stop here");
}

#pragma mark -- HELPERS
-(void)setupButtons
{
    [UIButton setUpLargeButton:self.mensInterestButton];
    [UIButton setUpLargeButton:self.womensInterestButton];
    [UIButton setUpLargeButton:self.bothSexesButton];


    [UITextView setup:self.textViewAboutMe];
}

-(void)setupLocation
{
     self.locationManager = [CLLocationManager new];
     self.locationManager.delegate = self;
     [self.locationManager requestWhenInUseAuthorization];
     [self.locationManager startUpdatingLocation];
     self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
     double latitude = self.locationManager.location.coordinate.latitude;
     double longitude = self.locationManager.location.coordinate.longitude;

     //save lat and long in a PFGeoCode Object and save to User in Parse
     self.pfGeoCoded = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
     [self.currentUser setObject:self.pfGeoCoded forKey:@"GeoCode"];
     //NSLog(@"saved PFGeoCode: %@", self.pfGeoCoded);
}

-(void)sexPreferenceButton
{
    if ([self.userGender isEqualToString:@"male"])
    {
        self.womensInterestButton.backgroundColor = [UIColor blackColor];
        [self.currentUser setObject:@"female" forKey:@"sexPref"];
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"saved as prefer women: %d", succeeded ? true : false);
        }];
    }
    else if ([self.userGender isEqualToString:@"female"])
    {
        self.mensInterestButton.backgroundColor = [UIColor blackColor];
        [self.currentUser setObject:@"male" forKey:@"sexPref"];
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"saved as prefer men: %d", succeeded ? true : false);
        }];
    }
    else
    {
        NSLog(@"no data for sex pref");
    }
}

-(void)defaultAgeSliderSet
{
    //MIN
    NSString *minAgeFloat = [NSString stringWithFormat:@"Minimum Age: %.f", self.minAgeSlider.value];
    self.minAgeLabel.text = minAgeFloat;
    NSString *minAge = [NSString stringWithFormat:@"%.f", self.minAgeSlider.value];
    //Max
    NSString *maxAgeFloat = [NSString stringWithFormat:@"Maximum Age: %.f", self.maxAgeSlider.value];
    self.maxAgeLabel.text = maxAgeFloat;
    NSString *maxAge = [NSString stringWithFormat:@"%.f", self.maxAgeSlider.value];

    [self.currentUser setObject:minAge forKey:@"minAge"];
    [self.currentUser setObject:maxAge forKey:@"maxAge"];

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saved min/max age preference: mid: %@ & max: %@ %d", minAge, maxAge, succeeded ? true : false);
    }];
}

-(void)defaultMilesAwaySliderSet
{
    NSString *milesAwayFloat = [NSString stringWithFormat:@"%.f", self.milesSlider.value];
    NSLog(@"miles away: %@", milesAwayFloat);
    NSString *milesAway = [NSString stringWithFormat:@"Show results within %@ miles of here", milesAwayFloat];
    self.milesAwayLabel.text = milesAway;
    [self.currentUser setObject:milesAwayFloat forKey:@"milesAway"];

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saved min/max age preference: milesAway: %@, %d", milesAway, succeeded ? true : false);
    }];
}

-(void)defaultPublicProfileSet
{
    [self.currentUser setObject:@"public" forKey:@"publicProfile"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saved min/max age preference: milesAway: %d", succeeded ? true : false);
    }];
}

-(void)setupManagersForInitalWalkViewController
{
    self.manager = [FacebookManager new];
    self.manager.facebookNetworker = [FacebookNetwork new];
    self.manager.facebookNetworker.delegate = self.manager;
    self.userManager = [UserManager new];
    self.userManager.delegate = self;
    self.manager.delegate = self;

    [self.manager loadParsedUserData];
    [self.userManager loadUserData:self.currentUser];
}
@end

