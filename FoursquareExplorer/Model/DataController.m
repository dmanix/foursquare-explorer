//
//  DataController.m
//  FoursquareExplorer
//
//  Created by Lion User on 26/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "DataController.h"
#import "MainAppDelegate.h"
#import "JSONConverter.h"
#import "FoursquareDataService.h"

@interface DataController ()

@property (nonatomic, strong) FoursquareDataService *dataService;
@property (nonatomic, strong) LocationController *locationController;
@property(nonatomic,strong) NSManagedObjectContext *managedContext;

/** Current location */
@property(nonatomic,assign) CLLocationCoordinate2D location;

@end

/**
 * Helper object containg context of logic operation.
 * Handles result returned by FoursquareClient: parses it and calles delegates
 */
@interface FoursquareOperationContext : NSObject <FoursquareRequestDelegate> 

@property(nonatomic,strong) id<DataControllerDelegate> delegate;
@property (nonatomic,strong) FoursquareDataService *dataService;
@property(nonatomic,strong) JSONConverter *jsonConverter;

-(id)initWithDataService:(FoursquareDataService *)dataService delegate:(id<DataControllerDelegate>)delegate;
@end


@implementation DataController 

// Constants for identifying this application in Foursquare API
static NSString * const ClientID = @"4OTLYW5LSMU4CX3GAHAMM4AXBVKMJ0MZOTDPNKOKH41CGZHE";
static NSString * const CallbackURL = @"fsqexplorer://explorer";

@synthesize foursquareClient = _foursquareClient;

@synthesize location = _location;
@synthesize locationController = _locationController;
@synthesize dataService = _dataService;
@synthesize managedContext = _managedContext;

+(DataController*)instance
{
    static DataController* instance = nil;
    if (!instance)
    {
        instance = [[DataController alloc]init];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {   
        
        // initializing FoursquareClient
        self.foursquareClient = [[FoursquareClient alloc] initWithClientID:ClientID callbackURL:CallbackURL];
        
        // initializing Location controller
        self.locationController = [[LocationController alloc] initWithDelegate: self];
       
        //initializing Data Service
        self.dataService = [FoursquareDataService instance];
        
        // initializing managed context
        self.managedContext = self.dataService.managedObjectContext;
    }
    return self;
}


-(BOOL)loadCategoriesWithDelegate: (id<DataControllerDelegate>)delegate {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    // Firstly checking if categories were already stored in DataService
    if ([self.dataService categoriesStored])
        return FALSE;
    
    // Categories are not loaded yet - doing it now ...
    FoursquareOperationContext *context = [[FoursquareOperationContext alloc]initWithDataService:self.dataService delegate:delegate];
    FoursquareRequest* request = [self.foursquareClient getCategoriesWithDelegate:context];
    [request start];
    
    return TRUE;
}


-(void)searchVenuesWithLimit: (NSNumber*)limit radius:(NSNumber*)radius category:(Category*)category delegate: (id<DataControllerDelegate>)delegate {
    
    NSString *location = [NSString stringWithFormat:@"%f,%f", self.location.latitude, self.location.longitude];
    NSString* categoryId = category ? category.catId : nil;
    
    NSLog(@"%s: Executing Foursquare Search request with params: distance: %@, maxResults: %@, categoryId: %@, location: %@", __PRETTY_FUNCTION__, limit, radius, categoryId, location);
    
    FoursquareOperationContext *context = [[FoursquareOperationContext alloc]initWithDataService:self.dataService delegate:delegate];
    FoursquareRequest* request = [self.foursquareClient searchWithLocation:location limit:limit radius:radius category:categoryId delegate:context];
    [request start];
}


#pragma mark LocationControllerDelegate
- (void)locationUpdate:(CLLocation *)location {
    NSLog(@"%s: changed location: %@", __PRETTY_FUNCTION__, location);
	self.location = location.coordinate;
}

- (void)locationError:(NSError *)error {
	NSLog(@"%s: location error", __PRETTY_FUNCTION__);
}
#pragma mark -

@end



@implementation FoursquareOperationContext

@synthesize delegate = _delegate;
@synthesize dataService = _dataService;
@synthesize jsonConverter = _jsonConverter;


-(id)initWithDataService:(FoursquareDataService *)dataService delegate:(id<DataControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.dataService = dataService;
        self.delegate = delegate;
        
        // initializing JSON converter
        self.jsonConverter = [[JSONConverter alloc]initWithDataService:dataService];
    }
    return self;
};

#pragma mark FoursquareRequestDelegate

- (void)categoriesReturned: (NSArray*)jsonCategories {
    NSLog(@"%s: called",__PRETTY_FUNCTION__);
    
    // parsing response
    NSSet* categories = [self.jsonConverter convertCategories:jsonCategories inManagedObjectContext:self.dataService.managedObjectContext];
    [self.dataService save];
    
    if (!categories) {
        [self operationFailed];
        return;
    }
    
    // calling delegate
    if ([self.delegate respondsToSelector:@selector(categoriesLoaded:)]) {
        [self.delegate categoriesLoaded:categories];
    }
}

- (void)venuesReturned: (NSArray*)jsonVenues; {
    NSLog(@"%s called, venuesSize: %d",__PRETTY_FUNCTION__, [jsonVenues count]);
    
    // parsing response
    NSArray* venues = [self.jsonConverter convertVenues:jsonVenues];
    
    if (!venues) {
        [self operationFailed];
        return;
    }
    
    // calling delegate
    if ([self.delegate respondsToSelector:@selector(venuesFound:)]) {
        [self.delegate venuesFound:venues];
    }
}

- (void)operationFailed {
    NSLog(@"%s called", __PRETTY_FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(operationFailed)]) {
        [self.delegate operationFailed];
    }
}
#pragma mark -

@end



