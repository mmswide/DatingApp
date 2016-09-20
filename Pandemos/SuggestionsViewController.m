//
//  SuggestionsViewController.m
//  Pandemos
//
//  Created by Michael Sevy on 1/28/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "SuggestionsViewController.h"
#import "User.h"
#import "InitialWalkThroughViewController.h"
#import <Parse/PFUser.h>
#import "UIColor+Pandemos.h"

@interface SuggestionsViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *unwindButton;


@property (strong, nonatomic) NSArray *suggestedPhrases;
@property (strong, nonatomic) PFUser *currentUser;

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];

    self.navigationItem.title = @"Suggestions";
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowGreen];

    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelection = YES;

    self.suggestedPhrases = [NSArray new];
    NSLog(@"gender: %@", self.userGender);

    self.segmentedControl.selectedSegmentIndex = 1;

    NSArray *segmentedArray = [self.segmentedControl subviews];
    [[segmentedArray objectAtIndex:0] setTintColor:[UIColor uclaBlue]];
    [[segmentedArray objectAtIndex:1] setTintColor:[UIColor blackColor]];
    [[segmentedArray objectAtIndex:2] setTintColor:[UIColor rubyRed]];
}

- (IBAction)onSegmentedTapped:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex ==0)
    {
        if ([self.userGender isEqualToString:@"male"])
        {
            self.suggestedPhrases = [NSArray arrayWithObjects:@"hey girl, what up", @"girl you so fine", nil];
            [self.tableView reloadData];
        }
        else
        {
            self.suggestedPhrases = [NSArray arrayWithObjects:@"oh hey there", @"looking for a fun time...", nil];
            [self.tableView reloadData];
        }
    }
    else if(sender.selectedSegmentIndex == 1)
    {
        if ([self.userGender isEqualToString:@"male"])
        {
            self.suggestedPhrases = [NSArray arrayWithObjects:@"Only serious Girls apply!", @"I'm looking for something serious", nil];
            [self.tableView reloadData];
        }
        else
        {
            self.suggestedPhrases = [NSArray arrayWithObjects:@"Looking for relationships only!!", @"Swipe right if you're not serious this will be a long lined one", nil];
            [self.tableView reloadData];
        }
    }
    else
    {
        if ([self.userGender isEqualToString:@"male"])
        {
            self.suggestedPhrases = [NSArray arrayWithObjects:@"Hi, I new to town and looking for friends", @"What's a boy to do around here?", nil];
            [self.tableView reloadData];
        }
        else
        {
            self.suggestedPhrases = [NSArray arrayWithObjects:@"Just trying this app out and want to meet new people", @"new to town and looking to mingle" @"Hi I'm only interested in friendshiip", nil];
            [self.tableView reloadData];
        }
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.suggestedPhrases.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SugCell"];
    UIFont *myFont = [UIFont fontWithName: @"HELVETICA NEUE" size: 12.0];
    cell.textLabel.font = myFont;
    cell.textLabel.text = [self.suggestedPhrases objectAtIndex:indexPath.row];

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedcell = [tableView cellForRowAtIndexPath:indexPath];
    selectedcell.accessoryView.hidden = NO;
    selectedcell.accessoryType = UITableViewCellAccessoryCheckmark;

    NSLog(@"selected items: %@", selectedcell.textLabel.text);

    [self.currentUser setObject:selectedcell.textLabel.text forKey:@"aboutMe"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (error)
        {
            NSLog(@"error: %@", error);
        } else
        {
            NSLog(@"saved: %s", succeeded ? "true" : "false");
        }
    }];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryView.hidden = NO;
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    //Parse save
    [self.currentUser setObject:@"" forKey:@"aboutMe"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
    {
        if (error)
        {
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"saved: %s", succeeded ? "true" : "false");
        }
    }];
}

- (IBAction)onUnwindSegue:(UIButton *)sender
{
    [self changeButtonState:self.unwindButton];
    //goes back one in the navigator, same as using the back button(but different feel for the user)
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- HELPERS
-(void)changeButtonState:(UIButton *)button
{
    [button setHighlighted:YES];
    button.backgroundColor = [UIColor blackColor];
    button.titleLabel.textColor = [UIColor whiteColor];

}

-(void)changeOtherButton:(UIButton *)button
{
    [button setHighlighted:NO];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.textColor = [UIColor blackColor];
}
@end