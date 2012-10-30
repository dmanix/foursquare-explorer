//
//  FoursquareClient.h
//  FoursquareExplorer
//
//  Created by Lion User on 23/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoursquareRequest.h"

@protocol FoursquareAuthorizationDelegate;

/**
 * Foursquare API client
 * To use it, one must have valid access token to Foursquare API. It can be specified in two ways:
 *  - calling authorizate method on FoursquareAPI which after successfull authorization returns a valid access token in response
 *  - setting directly valid access token (which was obtained previously)
 */
@interface FoursquareClient : NSObject {

}

/** access token used by FoursquareClient. nil when client is not authorized yet! */
@property(nonatomic,strong,readonly) NSString *accessToken;

/**
 * FoursquareClient initialization
 *
 * @param clientID ID of this application registered in Foursquare
 * @param callbackURL callbackURL to called after registration (it should have custom URL scheme type defined in project properties
 */
- (id)initWithClientID:(NSString *)clientID callbackURL:(NSString *)callbackURL;

/**
 * Starts to authorize in FoursquareAPI
 *
 * @param delegate delegate called when authorization process (sucessfull or unsuccessfull is finished)
 */
- (BOOL)authorizeWithDelegate:(id<FoursquareAuthorizationDelegate>)delegate;

/**
 * Manually specifies accessToken that should be used during using FoursquareAPI
 *
 * @param accessToken access token to be used (it must have been previously retrieved from Foursquare API in authorization process
 */
- (void)useAccessToken:(NSString*) accessToken;

/**
 * Invalidates current accessToken.
 */
- (void)invalidateSession;

/**
 * Callback after authorize in Forusquare process
 *
 * @param url url to handle
 * @returns if opening the url was successfully handled
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 * Searches venues with given parameters.
 *
 * @param location requested GPS location
 * @param limit maximum number of returned rows
 * @param radius maximum radius (in metres) within which venus can be returned
 * @param categoryId id of category, only venues from this category will be returned (when equals nil, all categories can be returned)
 * @param delegate delegate for handling request results
 * @returns Foursquare request instance if scheduling request succeded, otherwise nil
 */
- (FoursquareRequest *)searchWithLocation:(NSString*)location limit:(NSNumber*)limit radius:(NSNumber*)radius category:(NSString*)categoryId delegate:(id<FoursquareRequestDelegate>)delegate;

/**
 * Retrieves list of all categories defined in FoursquareAPI
 * 
 * @param delegate for handling request results
 * @returns Foursquare request instance if scheduling request succeded, otherwise nil
 */
- (FoursquareRequest *)getCategoriesWithDelegate:(id<FoursquareRequestDelegate>)delegate;

@end


/**
 * Delegate prividing information about authorization process results
 */
@protocol FoursquareAuthorizationDelegate <NSObject>
@optional

/**
 * Called authorization finished successfully
 * @param foursquareClient client instance
 */
- (void)foursquareDidAuthorize:(FoursquareClient *)foursquareClient;

/**
 * Called when authorization process failed
 * @param foursquareClient client instance
 * @param errorInfo error information
 */
- (void)foursquareDidNotAuthorize:(FoursquareClient *)foursquareClient error:(NSDictionary *)errorInfo;
@end





