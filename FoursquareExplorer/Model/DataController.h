//
//  DataController.h
//  FoursquareExplorer
//
//  Created by Lion User on 26/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Category.h"
#import "User.h"
#import "FoursquareClient.h"
#import "LocationController.h"

@protocol DataControllerDelegate;

/**
 * Main logic controller, giving access to logic operation on Foursquare API
 */
@interface DataController : NSObject <LocationControllerDelegate> {
}

/** FoursquareClient instance */
@property(nonatomic,strong) FoursquareClient *foursquareClient;

/** Returns singleton instance of DataController */
+(DataController*)instance;

/**
 * Loads all categories from Foursquare into local cache (FoursquareDataService)
 * @remark when categories are already loaded into FoursquareDataService, another request is not sent to FoursquareAPI
 *
 * @param delegate delegate for notifying when loading categories is done
 * @returns if request was sent to FoursquareAPI
 */
-(BOOL)loadCategoriesWithDelegate: (id<DataControllerDelegate>)delegate;

/**
 * Searches the closest venues to our current GPS location, according to search parameters.
 *
 * @param limit maximum number of returned rows
 * @param radius maximum radius (in metres) within which venus can be returned
 * @param categoryId id of category, only venues from this category will be returned (when equals nil, all categories can be returned)
 * @param delegate delegate for handling operation results
 */
-(void)searchVenuesWithLimit: (NSNumber*)limit radius: (NSNumber*)radius category:(Category*)category delegate:(id<DataControllerDelegate>)delegate;


@end

/**
 * Delagate notifying about logic operation finishing
 */
@protocol DataControllerDelegate <NSObject>
@optional
/**
 * Called when categories were loaded successfull
 */
-(void)categoriesLoaded: (NSSet*) categories;

/**
 * Called when search operation finished successfully
 */
-(void)venuesFound: (NSArray*)venues;

/**
 * Called when logic operation failed
 */
-(void)operationFailed; 

@end


