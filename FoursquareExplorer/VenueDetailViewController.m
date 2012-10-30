//
//  VenueDetailViewController.m
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VenueDetailViewController.h"

@interface VenueDetailViewController ()

@end

// IDs for table sections
enum {
    TableSectionVenueDetails = 0,
    TableSectionLocationDetails,
};

// IDs for detail venue cells
enum {
    VenueDetailName = 0,
    VenueDetailCategory,
};
// IDs for detail location cells
enum {
    LocationDetailAddress = 0,
    LocationDetailGpsLocation,
    LocationDetailDistance,
    LocationDetailPostalCode,
    LocationDetailCity,
    LocationDetailState,
    LocationDetailCountry
};

@implementation VenueDetailViewController

@synthesize venue = _venue;

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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // DO nothing
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellName;
    NSString *cellValue;
    
    switch (indexPath.section) {
        case TableSectionVenueDetails:
        {
            switch (indexPath.row) {
                case VenueDetailName:
                    cellName = @"Name";
                    cellValue = self.venue.name;
                    break;    
                case VenueDetailCategory:
                    cellName = @"Category";
                    cellValue = self.venue.category.name;
                    break;       
            }
            break;
        }
        case TableSectionLocationDetails:
        {
            Location *location = self.venue.location;
            switch (indexPath.row) {
                case LocationDetailAddress:
                    cellName = @"Address";
                    cellValue = location.address;
                    break;
                case LocationDetailGpsLocation:
                    cellName = @"Gps Location";
                    cellValue = [NSString stringWithFormat:@"%0.5f,%0.5f", [location.latitude floatValue], [location.longitude floatValue]];
                    break;
                case LocationDetailDistance:
                    cellName = @"Distance";
                    cellValue = [NSString stringWithFormat:@"%i metres", [location.distance intValue]];
                    break;
                case LocationDetailPostalCode:
                    cellName = @"Postal code";
                    cellValue = location.postalCode;
                    break;
                case LocationDetailCity:
                    cellName = @"City";
                    cellValue = location.city;
                    break;
                case LocationDetailState:
                    cellName = @"State";
                    cellValue = location.state;
                    break;
                case LocationDetailCountry:
                    cellName = @"Country";
                    cellValue = location.country;
                    break;
            }
            
        }
    }
    
    cell.textLabel.text = cellName;
    cell.detailTextLabel.text = cellValue;
}


@end
