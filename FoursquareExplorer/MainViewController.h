//
//  MainViewController.h
//  FoursquareExplorer
//
//  Created by Lion User on 21/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoursquareClient.h"
#import "DataController.h"
#import "FoursquareDataService.h"

/**
 * Starting view controller of application. Managas view used for authorizing user.
 */
@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,FoursquareAuthorizationDelegate> {
    
}

/** array of all users */
@property(strong, nonatomic) NSArray *users;

// GUI components
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property(strong, nonatomic) IBOutlet UITextField *theNewUserField;

@property(strong, readonly,nonatomic) NSString *theNewUserName;

/** Validate parameter and starts authorizing new user*/
- (IBAction)addUser;
/** Ensures that keyboard is hidden when entering value into text field is done */
- (IBAction)textFieldReturn:(id)sender;

@end
