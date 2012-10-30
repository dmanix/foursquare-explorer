//
//  Venue.h
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Category.h"
#import "Location.h"

/**
 * Represents Venue in Foursquare API
 */

@interface Venue : NSObject

@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Location *location;

@end
