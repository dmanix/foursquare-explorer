//
//  UserSessionViewController.h
//  FoursquareExplorer
//
//  Created by Lion User on 28/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "User.h"

@interface UserSessionViewController : UIViewController {
    
}

@property(nonatomic,readonly,strong) DataController *dataController;

@property (nonatomic,strong) IBOutlet UILabel *userNameLabel;

/** authorized user */
@property(nonatomic,readwrite,strong) User *user;
/** invalidates current user's session*/
- (IBAction)logout;

@end
