//
//  SearchViewController.m
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"
#import "FoursquareDataService.h"
#import "UIUtils.h"
#import "CommonUtils.h"

@interface SearchViewController ()

@property(nonatomic,strong) Category *selectedCategory;
@property(nonatomic,readwrite,strong) DataController *dataController;
@property(nonatomic,readwrite,strong) FoursquareDataService *dataService;
@end

@implementation SearchViewController

@synthesize selectedCategory = _selectedCategory;
@synthesize dataController = _dataController;
@synthesize dataService = _dataService;

@synthesize picker = _pickler;
@synthesize categories = _categories;
@synthesize maxResultsField = _maxResultsField;
@synthesize maxDistanceField = _maxDistanceField;
@synthesize allCategoriesSwitch = _allCategoriesSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataController = [DataController instance];
    self.dataService = [FoursquareDataService instance];
    
    // storing categories list and default selection
    self.categories = [self.dataService categories];
    self.selectedCategory = nil;
    if ([self.categories count] > 0) {
        self.selectedCategory = [self.categories objectAtIndex:0];
    }
    
    // setting default values
    self.maxResultsField.text = @"10";
    self.maxDistanceField.text = @"10000";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)searchVenues {
    
    NSLog(@"%s: distance: %@, maxResults: %@, allCategories: %d", __PRETTY_FUNCTION__, self.maxDistanceField.text, self.maxResultsField.text, self.allCategoriesSwitch.on);
    
    NSNumber *distance = [CommonUtils convertToDecimalNumber:self.maxDistanceField.text];
    if (!distance) {
        [UIUtils displayErrorWithMessage: @"Wrong value of field: 'Max. distance'"];
        return;
    }
    
    NSNumber *limit = [CommonUtils convertToDecimalNumber:self.maxResultsField.text];
    if (!limit) {
        [UIUtils displayErrorWithMessage: @"Wrong value of field: 'Max. results'"];
        return;
    }
    
    Category* category = self.allCategoriesSwitch.on ? nil : self.selectedCategory;
    [self.dataController searchVenuesWithLimit:limit radius:distance category:category delegate:self];
}

- (IBAction)allCategoriesSelectionChanged {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    if (self.allCategoriesSwitch.on) {
        self.picker.hidden = TRUE;
    } else {
        self.picker.hidden = false;
    }
}


#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.categories count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return ((Category*)[self.categories objectAtIndex:row]).name;
} 

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"%s: selected row: %d", __PRETTY_FUNCTION__, row);
    self.selectedCategory = [self.categories objectAtIndex:row];
}

#pragma mark -

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark DataControllerDelegate
- (void)venuesFound: (NSArray*)venues; {
    NSLog(@"%s called, venuesSize: %d",__PRETTY_FUNCTION__, [venues count]);
    
    SearchResultsViewController *searchResultsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsViewController"];
    searchResultsViewController.venues = venues;
    
    [[self navigationController] pushViewController:searchResultsViewController animated:YES];
    
}

- (void)operationFailed {
    [UIUtils displayErrorWithMessage: @"Search operation failed"];
}

#pragma mark -


@end
