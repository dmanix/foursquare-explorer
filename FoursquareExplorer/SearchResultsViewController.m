//
//  SearchResultsViewController.m
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "Venue.h"
#import "VenueDetailViewController.h"

@interface SearchResultsViewController ()


@end

@implementation SearchResultsViewController

@synthesize venues = _venues;
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s: called, venuesSize: %u", __PRETTY_FUNCTION__, [self.venues count]);
    return [self.venues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"VenueCell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = ((Venue*)[self.venues objectAtIndex:indexPath.row]).name;
    return cell;
}

/** Moves to controller managing display of venue details */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    if ([segue.identifier isEqualToString:@"showVenueDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%s: selected_row: %u", __PRETTY_FUNCTION__, indexPath.row);
        VenueDetailViewController *destViewController = segue.destinationViewController;
        destViewController.venue = [self.venues objectAtIndex:indexPath.row];
    }
    
}
@end
