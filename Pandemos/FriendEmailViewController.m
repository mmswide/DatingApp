//
//  FriendEmailViewController.m
//  Pandemos
//
//  Created by Michael Sevy on 1/21/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "FriendEmailViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "AllyAdditions.h"

@interface FriendEmailViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSString *emailAddress;

@end

@implementation FriendEmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    self.navigationItem.title = @"Your Ally";
    self.navigationItem.titleView.tintColor = [UIColor mikeGray];
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowGreen];

    self.emailTextField.delegate = self;
    self.emailTextField.placeholder = @"email address";

    self.continueButton.enabled = NO;
    self.continueButton.backgroundColor = [UIColor colorWithHexValue:@"EFEFF4"];
    self.continueButton.layer.cornerRadius = 20;

    UIImage *closeNavBarButton = [UIImage imageWithImage:[UIImage imageNamed:@"Back"] scaledToSize:CGSizeMake(25.0, 25.0)];
    [self.navigationItem.leftBarButtonItem setImage:closeNavBarButton];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor mikeGray];


    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange:(UITextField *)emailAddress
{
    if (emailAddress.text.length > 0)
    {

        if (emailAddress.text.length > 7 && [emailAddress.text containsString:@"@"])
        {
            [self continueButtonEnabled:YES];
            self.emailAddress = emailAddress.text;
        }
    }
}

- (IBAction)onContinueButton:(UIButton *)sender
{
    [self saveConfidantEmailToParse];
}

-(void)saveConfidantEmailToParse
{
    NSRange whiteSpaceRange = [self.emailAddress rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];

    if (whiteSpaceRange.location != NSNotFound)
    {
        [self addInvalidEmailAlert];
    }
    else
    {
        [self.currentUser setObject:self.emailTextField.text forKey:@"confidantEmail"];
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

            if (!error)
            {
                NSLog(@"saved: %@ %s", self.emailTextField.text, succeeded ? "true" : "false");
                [self performSegueWithIdentifier:@"ConfidantToHome" sender:self];
            }
            else
            {
                [self addParseErrorAlert];
                NSLog(@"error: %@", error);
            }
        }];
    }
}

-(void)addInvalidEmailAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ooops!"
                                                                   message:@"Make sure you enter a valid email address"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [self dismissViewControllerAnimated:alert completion:^{

                                                       }];
                                                   }];

    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addParseErrorAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ooops!"
                                                                   message:@"There was a problem saving your confidant email"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Try Again"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [self dismissViewControllerAnimated:alert completion:^{

                                                       }];
                                                   }];

    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)continueButtonEnabled:(BOOL)enabled
{
    if (enabled)
    {
        self.continueButton.enabled = YES;
        self.continueButton.backgroundColor = [UIColor colorWithHexValue:@"2ecc71"];
    }
    else
    {
        self.continueButton.enabled = NO;
        self.continueButton.backgroundColor = [UIColor colorWithHexValue:@"EFEFF4"];
    }
}
@end
