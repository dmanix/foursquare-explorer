//
//  FoursquareRequest.m
//  FoursquareExplorer
//
//  Created by Lion User on 24/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "FoursquareRequest.h"
#import "CommonUtils.h"

@interface FoursquareRequest ()

// request properties:
@property(nonatomic,strong) NSString *path;
@property(nonatomic,strong) NSString *HTTPMethod;
@property(nonatomic,strong) NSDictionary *parameters;
@property(nonatomic,strong) id<FoursquareRequestDelegate> delegate;

/** Connection to Foursquare API service */
@property(nonatomic,strong) NSURLConnection *connection;
/** Response data receiving from Foursquare service */
@property(nonatomic,strong) NSMutableData *responseData;
/** Foursquare resource requsting in this request */
@property(nonatomic,assign) FoursquareRequestType requestType;


@end

@implementation FoursquareRequest

static NSString * const HttpMethodGET =  @"GET";

// Base Foursquare API url
static NSString * const FoursquareApiBaseURL =  @"https://api.foursquare.com/v2";

// Resource in Foursquare API
static NSString * const FoursquareResourceSearch =  @"venues/search";
static NSString * const FoursquareResourceCategories =  @"venues/categories";

static const NSTimeInterval TiomeoutInterval =  180.0;

@synthesize path = _path;
@synthesize HTTPMethod = _HTTPMethod;
@synthesize parameters = _parameters;
@synthesize delegate = _delegate;
@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize requestType = _requestType;


- (id)initWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters type: (FoursquareRequestType)requestType delegate:(id<FoursquareRequestDelegate>)delegate {
    self = [super init];
    if (self) {
        self.path = path;
        self.HTTPMethod = HTTPMethod ?: HttpMethodGET;
        self.parameters = parameters;
        self.requestType = requestType;
        self.delegate = delegate;
        
        NSLog(@"%s: parameters: %@", __PRETTY_FUNCTION__, parameters);
    }
    return self;
}


- (id)initWithParameters:(NSDictionary *)parameters delegate:(id<FoursquareRequestDelegate>)delegate resource:(FoursquareRequestType)resourceType {
    
    NSString *path;
    switch (resourceType) {
        case FoursquareRequestSearch:
            path = FoursquareResourceSearch;
            break;
        case FoursquareRequestGetCategories:
            path = FoursquareResourceCategories;
            break;
        default:
            path = @"";
    }
    return [self initWithPath:path HTTPMethod:HttpMethodGET parameters:parameters type:resourceType delegate:delegate];
}

- (BOOL)start {
    [self cancel];
    
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    
    NSURLRequest *request;
    if ([self.HTTPMethod isEqualToString:@"GET"]) {
        request = [self requestForGETMethod];
    } 
    else {
        NSAssert2(NO, @"*** %s: HTTP %@ method not supported", __PRETTY_FUNCTION__, self.HTTPMethod);
        request = nil;
        return FALSE;
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!self.connection) {
        NSLog(@"*** %s: connection is nil", __PRETTY_FUNCTION__);
        return FALSE;
    }
    return TRUE;
}

/** 
 * Cleans request data: connection and response
 */
- (void)cancel {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
        self.responseData = nil;
    }
}


- (NSURLRequest *)requestForGETMethod {
    
    NSArray *escapedParameters = [CommonUtils escapeParameters:self.parameters];

    NSString *uri = [FoursquareApiBaseURL stringByAppendingPathComponent:self.path];
    NSURL *URL = [CommonUtils createURLWithUri:uri parameters:escapedParameters];
    if (!URL) 
        return nil;
    
    NSLog(@"%s: sending request with url: %@", __PRETTY_FUNCTION__, URL);
    
    return [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TiomeoutInterval];
}


#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    [self.responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *response;
    NSError *error = nil;
    response = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if (!response) {
        NSLog(@"%s: Missing parsed response", __PRETTY_FUNCTION__);
        [self requestFailedWithError: error];
        return;
    }
    
    switch (self.requestType) {
        case FoursquareRequestGetCategories: {
            [self handleGetCategoriesReponse:response];            
            break;
        }
        case FoursquareRequestSearch: {
            [self handleSearchReponse:response];
            break;
        }
    }

}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self requestFailedWithError: error];
}

#pragma mark -

#pragma mark helper functions for handling response

/** Handles response of GetCategories request */
- (void)handleGetCategoriesReponse:(NSDictionary *)response {
    //NSLog(@"%s: response: %@", __PRETTY_FUNCTION__, response);
    
    NSDictionary* jsonCategoriesDict = [response objectForKey:@"response"];
    NSArray* jsonCategories = [jsonCategoriesDict objectForKey:@"categories"];
    
    if (!jsonCategories) {
        [self requestFailedWithError: nil];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(categoriesReturned:)]) {
        [self.delegate categoriesReturned:jsonCategories];
    } 
}

/** Handles response of Search request */
- (void)handleSearchReponse:(NSDictionary *)response {
    //NSLog(@"%s: Search result: %@", __PRETTY_FUNCTION__, response);
    
    NSDictionary* jsonVenuesDict = [response objectForKey:@"response"];
    NSArray* jsonVenues = [jsonVenuesDict objectForKey:@"venues"];
    
    if (!jsonVenues) {
        [self requestFailedWithError: nil];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(venuesReturned:)]) {
        [self.delegate venuesReturned:jsonVenues];
    } 
}

/** helper function for reporting error */
- (void) requestFailedWithError: (NSError *)error {
    NSLog(@"%s: called, error: %@", __PRETTY_FUNCTION__, error);
    if ([self.delegate respondsToSelector:@selector(operationFailed)]) {
        [self.delegate operationFailed];
    }
    [self cancel];
}


@end
