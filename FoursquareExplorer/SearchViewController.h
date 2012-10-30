//
//  SearchViewController.h
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoursquareClient.h"
#import "DataController.h"

@interface SearchViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, DataControllerDelegate> {
}

// GUI components
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UITextField *maxResultsField;
@property (strong, nonatomic) IBOutlet UITextField *maxDistanceField;
@property (strong, nonatomic) IBOutlet UISwitch *allCategoriesSwitch;

/** Array of all available categories */
@property (strong, nonatomic) NSArray *categories;

/** Validates parameters and starts search parameters */
- (IBAction)searchVenues;
/** Handles of switch (searching in all categories) value changed */
- (IBAction)allCategoriesSelectionChanged;
/** Ensures that keyboard is hidden when entering value into text field is done */
-(IBAction)textFieldReturn:(id)sender;

@end
