//
//  MainViewController.m
//  FoursquareExplorer
//
//  Created by Lion User on 21/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "MainViewController.h"
#import "UserSessionViewController.h"
#import "UIUtils.h"

@interface MainViewController ()

@property(nonatomic,readwrite,strong) FoursquareClient *foursquareClient;
@property(nonatomic,readwrite,strong) FoursquareDataService *dataService;
@property(strong, readwrite,nonatomic) NSString *theNewUserName;
@end

@implementation MainViewController

@synthesize foursquareClient = _foursquareClient;
@synthesize dataService = _dataService;
@synthesize tableView = _tableView;
@synthesize theNewUserField = _theNewUserField;
@synthesize theNewUserName = _theNewUserName;
@synthesize users = _users;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.foursquareClient = [DataController instance].foursquareClient;
    
    self.dataService = [FoursquareDataService instance];
    
    // storing list of existing authorized users
    self.users = [self.dataService users];

}

- (void)viewWillAppear:(BOOL)animated {
    //reloading users
    self.users = [self.dataService users]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)addUser {
    NSLog(@"%s: starting", __PRETTY_FUNCTION__);
    
    self.theNewUserName = self.theNewUserField.text;
    if ([self.theNewUserName length] == 0) {
        [UIUtils displayErrorWithMessage: @"User name cannot be empty!"];
        return;
    }
    
    [self.foursquareClient authorizeWithDelegate:self];
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s: called, usersSize: %u", __PRETTY_FUNCTION__, [self.users count]);
    return [self.users count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"UserCell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = ((User*)[self.users objectAtIndex:indexPath.row]).name;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    if ([segue.identifier isEqualToString:@"logInExistingUser"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%s: selected_row: %u", __PRETTY_FUNCTION__, indexPath.row);
        User* selectedUser = [self.users objectAtIndex:indexPath.row];

        // moving to controller managing authorized user
        [self.foursquareClient useAccessToken:selectedUser.accessToken];
        UserSessionViewController *destViewController = segue.destinationViewController;
        
        destViewController.user = selectedUser;
        
        // deselecting row - we don't want it to be marked
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

#pragma mark FoursquareAuthorizationDelegate

- (void)foursquareDidAuthorize:(FoursquareClient *)foursquareClient {
    
    NSLog(@"%s: authorization successfull, assigned accessToken = %@, for user = %@", __PRETTY_FUNCTION__, foursquareClient.accessToken, self.theNewUserName);
    
    User* user = [self.dataService addUserWithName: self.theNewUserName accessToken: foursquareClient.accessToken];
    

    // updating table view with new user
    self.users = [self.dataService users];
    [self.tableView reloadData];
    self.theNewUserField.text = @"";
    self.theNewUserName = @"";
    
    // moving to controller managing authorized user
    UserSessionViewController *userSessionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSessionViewController"];
    userSessionViewController.user = user;
    
    [[self navigationController] pushViewController:userSessionViewController animated:YES];
    
}

- (void)foursquareDidNotAuthorize:(FoursquareClient *)foursquareClient error:(NSDictionary *)errorInfo {
    NSLog(@"%s: authorization failed, error: %@", __PRETTY_FUNCTION__, errorInfo);
    [UIUtils displayErrorWithMessage: @"Authorization failed"];
}

#pragma mark -

@end
