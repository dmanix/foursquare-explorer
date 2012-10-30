//
//  FoursquareClient.m
//  FoursquareExplorer
//
//  Created by Lion User on 23/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "FoursquareClient.h"
#import "CommonUtils.h"

@interface FoursquareClient ()

@property(nonatomic,strong,readwrite) NSString *clientID;
@property(nonatomic,strong,readwrite) NSString *callbackURL;
@property(nonatomic,strong,readwrite) id<FoursquareAuthorizationDelegate> authorizationDelegate;
@property(nonatomic,strong,readwrite) NSString *accessToken;

@end

@implementation FoursquareClient

// Foursquare Authorization URL
static NSString * const AuthorizeBaseURL = @"https://foursquare.com/oauth2/authorize";

// Foursquare API version used
static NSString * const FoursquareApiVersion = @"20121027";

@synthesize clientID = _clientID;
@synthesize callbackURL = _callbackURL;
@synthesize authorizationDelegate = _authorizationDelegate;
@synthesize accessToken = _accessToken;

- (id)initWithClientID:(NSString *)clientID callbackURL:(NSString *)callbackURL {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    
    NSParameterAssert(clientID != nil && callbackURL != nil);
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.callbackURL = callbackURL;
    }
    return self;
}


- (BOOL)authorizeWithDelegate:(id<FoursquareAuthorizationDelegate>)delegate {
    
    self.authorizationDelegate = delegate;
    [self invalidateSession];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.clientID, @"client_id", @"token", @"response_type", self.callbackURL, @"redirect_uri", nil];
    
    NSArray *escapedParameters = [CommonUtils escapeParameters:parameters];
    NSURL *URL = [CommonUtils createURLWithUri:AuthorizeBaseURL parameters:escapedParameters];
     
    NSLog(@"%s: authorization url: \"%@\"", __PRETTY_FUNCTION__, URL);
    
    BOOL result = [[UIApplication sharedApplication] openURL:URL];
    if (!result) {
        NSLog(@"*** %s: cannot open url \"%@\"", __PRETTY_FUNCTION__, URL);
    }
    return result;    
}


- (BOOL)handleOpenURL:(NSURL *)url {
    if (![[url absoluteString] hasPrefix:self.callbackURL]) {
        NSLog(@"%s: unsupported url \"%@\", expected \"%@\" ", __PRETTY_FUNCTION__, url, self.callbackURL);
        return NO;
    }
    
    NSLog(@"%s: Handling url \"%@\" ", __PRETTY_FUNCTION__, url);
    
    NSDictionary *parameters = [CommonUtils parseParametersFromURL:url];

    self.accessToken = [parameters objectForKey:@"access_token"];
    NSLog(@"%s: assigned accessToken: \"%@\" ", __PRETTY_FUNCTION__, self.accessToken);
    
    if (self.accessToken) {
        if ([self.authorizationDelegate respondsToSelector:@selector(foursquareDidAuthorize:)]) {
            [self.authorizationDelegate foursquareDidAuthorize:self];
        }
    } else {
        if ([self.authorizationDelegate respondsToSelector:@selector(foursquareDidNotAuthorize:error:)]) {
            [self.authorizationDelegate foursquareDidNotAuthorize:self error:parameters];
        }
    }    
    
    return YES;
}

- (void)invalidateSession {
    NSLog(@"%s: token = %@ invalidated", __PRETTY_FUNCTION__,self.accessToken);
    self.accessToken = nil;
}

- (BOOL)isSessionValid {
    return (self.accessToken != nil);
}

- (void)useAccessToken:(NSString*) accessToken {
    NSLog(@"%s: use token = %@ as access credential", __PRETTY_FUNCTION__, accessToken);
    self.accessToken = accessToken;
}


- (FoursquareRequest *)searchWithLocation:(NSString*)location limit: (NSNumber*)limit radius:(NSNumber*)radius category:(NSString*)categoryId delegate:(id<FoursquareRequestDelegate>)delegate {
    
    NSMutableDictionary *parameters = [self createDictWithCommonParameters];
    if (!parameters)
        return nil;
    
    // adding requester parameters
    [self addParameterToDictionary:parameters value:location key:@"ll"];
    [self addParameterToDictionary:parameters value:limit key:@"limit"];
    [self addParameterToDictionary:parameters value:radius key:@"radius"];
    [self addParameterToDictionary:parameters value:categoryId key:@"categoryId"];
    
    return [self createFoursquareRequestWithParameters:parameters delegate:delegate resource:FoursquareRequestSearch];
}

- (FoursquareRequest *)getCategoriesWithDelegate:(id<FoursquareRequestDelegate>)delegate {
    
    NSMutableDictionary *parameters = [self createDictWithCommonParameters];
    if (!parameters)
        return nil;
    
    return [self createFoursquareRequestWithParameters:parameters delegate:delegate resource:FoursquareRequestGetCategories];
}

#pragma mark local helper functions

-(void)addParameterToDictionary:(NSMutableDictionary*)dictionary value:(id)value key: (NSString*)key {
    if (value) {
        [dictionary setValue: value forKey:key];
    }
}

-(NSMutableDictionary *)createDictWithCommonParameters {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    // checking access_token validity
    if (![self isSessionValid]) {
        NSLog(@"%s: request not sent - invalid access token",__PRETTY_FUNCTION__);
        return nil;
    }
    
    // adding access token
    [self addParameterToDictionary:parameters value:self.accessToken key:@"oauth_token"];
    
    // adding used Foursquare API version 
    [self addParameterToDictionary:parameters value:FoursquareApiVersion key:@"v"];
    
    return parameters;
}


- (FoursquareRequest *)createFoursquareRequestWithParameters:parameters delegate:delegate resource:(FoursquareRequestType)resourceType {
    FoursquareRequest *request = [[FoursquareRequest alloc] initWithParameters:parameters delegate:delegate resource:resourceType];
    BOOL succeeded = [request start];
    if (!succeeded) {
        NSLog(@"%s: starting request failed",__PRETTY_FUNCTION__);
        return nil;
    }
    return request;
}

#pragma mark -

@end
