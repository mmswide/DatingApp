//  FacebookAlbumsTableVC.m
//  Pandemos
//
//  Created by Michael Sevy on 1/30/16.
//  Copyright © 2016 Michael Sevy. All rights reserved.
//

#import "FacebookAlbumsTableVC.h"
#import "FacebookTableViewCell.h"
#import "AlbumDetailViewController.h"
#import "Facebook.h"
#import "FacebookManager.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "AllyAdditions.h"

@interface FacebookAlbumsTableVC ()<FacebookManagerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) NSArray *albums;
@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) FacebookManager *manager;
@end

@implementation FacebookAlbumsTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Facebook Albums";
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowGreen];

    UIImage *closeNavBarButton = [UIImage imageWithImage:[UIImage imageNamed:@"Back"] scaledToSize:CGSizeMake(25.0, 25.0)];
    [self.navigationItem.leftBarButtonItem setImage:closeNavBarButton];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor mikeGray];

    self.albums = [NSArray new];
    self.currentUser = [User currentUser];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [SVProgressHUD show];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor spartyGreen]];

    if (self.currentUser)
    {
        self.manager = [FacebookManager new];
        self.manager.facebookNetworker = [FacebookNetwork new];
        self.manager.facebookNetworker.delegate = self.manager;
        self.manager.delegate = self;
        [self.manager loadParsedFBPhotoAlbums];
    }
    else
    {
        NSLog(@"no user for face request");
    }
}

#pragma mark -- TABLEVIEW DELEGATES
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Album:";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

-(FacebookTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FacebookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Facebook *face = [self.albums objectAtIndex:indexPath.row];
    cell.albumTitleLabel.text = face.albumName;
    cell.albumCountLabel.text = face.albumImageCount;
    cell.albumImage.layer.cornerRadius = 7;
    cell.albumImage.image = [UIImage imageWithData:[face stringURLToData:face.albumImageURL]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Facebook *selectedPath = [self.albums objectAtIndex:indexPath.row];
    self.albumId = selectedPath.albumId;
    self.albumName = selectedPath.albumName;

    [self performSegueWithIdentifier:@"AlbumDetail" sender:self];
}

#pragma mark -- NAV
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     if([segue.identifier isEqualToString:@"AlbumDetail"])
    {
        AlbumDetailViewController *advc = segue.destinationViewController;
        advc.albumID = self.albumId;
        advc.albumName = self.albumName;
    }
}

- (IBAction)onBackButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - FACEBOOK MANAGER DELEGATE
-(void)didReceiveParsedAlbumList:(NSArray *)photoAlbums
{
    self.albums = photoAlbums;
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}
@end
