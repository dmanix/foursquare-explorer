//
//  FoursquareDataService.h
//  FoursquareExplorer
//
//  Created by Lion User on 28/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Category.h"
#import "User.h"

/**
 * Data logic managing authorized users and categories
 */
@interface FoursquareDataService : NSObject 

/** Returns singleton instance of DataController */
+(FoursquareDataService*)instance;

/** ManagedObjectContext instance used by Data Service */
@property(nonatomic,readonly,strong) NSManagedObjectContext *managedObjectContext;

/**
 * Returns Category with given id
 * @param categoryId requested ID of category
 * @returns found Category (nil if not found)
 */
-(Category*)categoryWithId: (NSString*)categoryId;

/**
 * Returns array of all stored categories
 */
-(NSArray*)categories;

/**
 * Adds user with given name and Foursquare access token
 * @param name
 * @param accessToken
 * @returns created User object
 */
-(User*)addUserWithName: (NSString*)name accessToken: (NSString*)accessToken;

/**
 * Returns array of all stored users
 */
-(NSArray*)users;

/**
 * Checks if any categories are already stored
 */
-(BOOL)categoriesStored;

/**
 * Saves state of ManagedObjectContext 
 */
-(void)save;

@end
