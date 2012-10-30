//
//  FoursquareRequest.h
//  FoursquareExplorer
//
//  Created by Lion User on 24/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FoursquareRequestDelegate;

/** Foursquare request context */
@interface FoursquareRequest : NSObject <NSURLConnectionDelegate>

/**
 * Possible types of Foursquare API resources
 */
typedef enum FoursquareRequestType {
    FoursquareRequestSearch = 0,
    FoursquareRequestGetCategories = 1
} FoursquareRequestType;

/**
 * request initilization 
 * @param parameters parameters to be sent
 * @param delegate
 * @param resource type of resource to be accessed
 */
- (id)initWithParameters:(NSDictionary *)parameters delegate:(id<FoursquareRequestDelegate>)delegate resource:(FoursquareRequestType)resourceType;

/**
 * Starts executing request
 * @returns if requesting scheduling finished successfully
 */
- (BOOL)start;

@end

/**
 * Delagate notifying about Foursquare request finishing
 */
@protocol FoursquareRequestDelegate <NSObject>
@optional

/**
 * Called when request for categories resource was finished successfully
 */
- (void)categoriesReturned: (NSArray*) jsonCategories;

/**
 * Called when request for search resource was finished successfully
 */
- (void)venuesReturned: (NSArray*)jsonVenues;

/**
 * Called when request failed
 */
- (void)operationFailed;

@end


