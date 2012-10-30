//
//  VenueDetailViewController.h
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface VenueDetailViewController : UITableViewController 

/** Displayed venue */
@property (nonatomic, strong) Venue *venue;

@end
