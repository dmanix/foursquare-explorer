//
//  UserSessionViewController.m
//  FoursquareExplorer
//
//  Created by Lion User on 28/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "UserSessionViewController.h"
#import "MainViewController.h"

@interface UserSessionViewController ()

@property(nonatomic,readwrite,strong) DataController *dataController;

@end

@implementation UserSessionViewController

@synthesize dataController = _dataController;

@synthesize user = _user;
@synthesize userNameLabel = _userNameLabel;

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton=TRUE;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.user != nil) {
        self.userNameLabel.text = self.user.name;
    }
    
    self.dataController = [DataController instance];
    
    [self.dataController loadCategoriesWithDelegate:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logout {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);

    [self.dataController.foursquareClient invalidateSession];

    // moving to MainViewController
    [[self navigationController] popToRootViewControllerAnimated:YES];
    	
}

@end
