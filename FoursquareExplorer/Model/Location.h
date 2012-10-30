//
//  Location.h
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents Location of Venue from Foursquare API
 */
@interface Location : NSObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * state;

@end
