//
//  JSONConverter.h
//  FoursquareExplorer
//
//  Created by Lion User on 26/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoursquareDataService.h"

/**
 * Converts results in JSON object format to logic objects
 */
@interface JSONConverter : NSObject

/**
 * Initializes converter with given FoursquareDataService instance
 */
-(id)initWithDataService:(FoursquareDataService *)dataService;

/**
 * Converts categories from JSON objects to set with Category* objects using given NSManagedObjectContext
 * @remark returned objects are not yet saved in given context!
 *
 * @param jsonCategories categories in JSON object representation
 * @param managedContext
 * @returns set with converted objects
 */
-(NSSet*)convertCategories: (NSArray*) jsonCategories inManagedObjectContext:(NSManagedObjectContext*)managedContext;

/**
 * Converts venues from JSON objects to array with Venue* objects
 * @param jsonVenues venues in JSON object representation
 * @returns converted array of venues
 */
-(NSArray*)convertVenues: (NSArray*) jsonVenues;

@end
