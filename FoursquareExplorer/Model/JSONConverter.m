//
//  JSONConverter.m
//  FoursquareExplorer
//
//  Created by Lion User on 26/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "JSONConverter.h"
#import "FoursquareDataService.h"
#import "Category.h"
#import "Venue.h"

@interface JSONConverter ()
@property (nonatomic,strong) FoursquareDataService *dataService;
@end

@implementation JSONConverter

@synthesize dataService = _dataService;

-(id)initWithDataService:(FoursquareDataService *)dataService {
    self = [super init];
    if (self) {
        self.dataService = dataService;
    }
    return self;
};


-(NSSet*)convertCategories: (NSArray*) jsonCategories inManagedObjectContext:(NSManagedObjectContext*)managedContext
{
    //NSLog(@"%s: JSON CATEGORIES: %@", __PRETTY_FUNCTION__, jsonCategories);
    return [self convertCategories:jsonCategories parent:nil inManagedObjectContext:managedContext];
}

-(NSSet*)convertCategories: (NSArray*) jsonCategories parent: (Category*) parent inManagedObjectContext:(NSManagedObjectContext*)managedContext
{
    NSMutableSet* categories = [[NSMutableSet alloc]init];
    for (NSDictionary *jsonCategory in jsonCategories) {
        NSManagedObject *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" 
                                                                    inManagedObjectContext:managedContext];
        [newCategory setValue:[jsonCategory objectForKey:@"id"] forKey:@"catId"];
        [newCategory setValue:[jsonCategory objectForKey:@"name"] forKey:@"name"];
        [newCategory setValue:[jsonCategory objectForKey:@"pluralName"] forKey:@"pluralName"];
        [newCategory setValue:[jsonCategory objectForKey:@"shortName"] forKey:@"shortName"];
        if (parent != nil) {
            [newCategory setValue:parent forKey:@"parentCategory"];
        }
        
        NSArray* childJsonCategories = [jsonCategory objectForKey:@"categories"];
        NSSet* childCategories = [self convertCategories: childJsonCategories parent: (Category*)newCategory inManagedObjectContext:managedContext];
        [newCategory setValue:childCategories forKey:@"childCategories"];
        
        [categories addObject:(Category*)newCategory];
    }
    return categories;
}

-(NSArray*)convertVenues: (NSArray*) jsonVenues {
    //NSLog(@"%s: started, size %d", __PRETTY_FUNCTION__, [jsonVenues count]);
    
    NSMutableArray* venues = [[NSMutableArray alloc]init];
    for (NSDictionary *jsonVenue in jsonVenues) {
        Venue* newVenue = [[Venue alloc]init];
        newVenue.venueId = [jsonVenue objectForKey:@"id"];
        newVenue.name = [jsonVenue objectForKey:@"name"];
        newVenue.category = [self convertCategoriesReference: [jsonVenue objectForKey:@"categories"]];
        newVenue.location = [self convertLocation: [jsonVenue objectForKey:@"location"]];
   
        [venues addObject:newVenue];
    }
    
    return venues;
}

-(Location*)convertLocation: (NSDictionary*) jsonLocation {
    
    Location* newLocation = [[Location alloc]init];
    newLocation.address = [jsonLocation objectForKey:@"address"];
    newLocation.latitude = [jsonLocation objectForKey:@"lat"];
    newLocation.longitude = [jsonLocation objectForKey:@"lng"];
    newLocation.distance = [jsonLocation objectForKey:@"distance"];
    newLocation.postalCode = [jsonLocation objectForKey:@"postalCode"];
    newLocation.city = [jsonLocation objectForKey:@"city"];    
    newLocation.state = [jsonLocation objectForKey:@"state"];
    newLocation.country = [jsonLocation objectForKey:@"country"];  
    
    return newLocation;
}

/**
 * Helper function for converting category reference. If categoryID != nil is found, corresponding object from Data service is returned
 * @param jsonCategories JSON object with categories references array (always contaims at most one category)
 * @returns found referenced Category object, or nil when reference was nil or category wasn't found in Data Service
 */
-(Category*)convertCategoriesReference: (NSArray*) jsonCategories {
    
    if ([jsonCategories count] == 0)
        return nil;
    
    NSDictionary* jsonCategory = [jsonCategories objectAtIndex: 0];
    NSString *categoryId = [jsonCategory objectForKey:@"id"];
    
    Category *category = [self.dataService categoryWithId:categoryId];
    
    //NSLog(@"%s: found category = %@", __PRETTY_FUNCTION__, category);

    return category;
}

@end
