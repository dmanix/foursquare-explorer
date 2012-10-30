//
//  SearchResultsViewController.h
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

/** Array with found venues */
@property (strong, readwrite, nonatomic) NSArray *venues;

@end
