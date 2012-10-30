//
//  LocationController.h
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * Delegate for notifying about location changes
 */
@protocol LocationControllerDelegate <NSObject>
@optional
/**
 * Informs about location changes. 
 * @remark It is called only when latitue or longitude are changed.
 *
 * @param location current location
 */
- (void)locationUpdate:(CLLocation *)location;

/**
 * Informs about any errors
 * @param error
 */
- (void)locationError:(NSError *)error;
@end

@interface LocationController : NSObject <CLLocationManagerDelegate>

/**
 * Initializes controller with given delegate and starts updating locations
 */
- (id)initWithDelegate: (id<LocationControllerDelegate>)delegate;

@end
