//
//  LocationController.m
//  FoursquareExplorer
//
//  Created by Lion User on 27/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "LocationController.h"

@interface LocationController ()

/** location Manager instance */
@property (nonatomic, strong) CLLocationManager *locMgr;
/** location updates delegate */
@property (nonatomic, strong) id<LocationControllerDelegate> delegate;

@end

@implementation LocationController

@synthesize locMgr = _locMgr;
@synthesize delegate = _delegate;

- (id)initWithDelegate: (id<LocationControllerDelegate>)delegate {
	self = [super init];
	if (self != nil) {
		self.locMgr = [[CLLocationManager alloc] init]; 
		self.locMgr.delegate = self;
        self.delegate = delegate;
        [self.locMgr startUpdatingLocation];
	}
    
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (oldLocation.coordinate.latitude == newLocation.coordinate.latitude && oldLocation.coordinate.longitude == newLocation.coordinate.longitude) {
        return;
    }
    
    // notifying only when location really changed
    
	if([self.delegate respondsToSelector:@selector(locationUpdate:)]) {
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

	if([self.delegate respondsToSelector:@selector(locationError:)]) { 
		[self.delegate locationError:error];
	}
}

@end
