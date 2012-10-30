//
//  FoursquareDataService.m
//  FoursquareExplorer
//
//  Created by Lion User on 28/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "FoursquareDataService.h"

@interface FoursquareDataService ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation FoursquareDataService

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(FoursquareDataService*)instance
{
    static FoursquareDataService* instance = nil;
    if (!instance)
    {
        instance = [[FoursquareDataService alloc]init];
    }
    return instance;
}

-(Category*)categoryWithId: (NSString*)categoryId
{
    //NSLog(@"%s: called with id = %@", __PRETTY_FUNCTION__, categoryId);
    
    if (categoryId == nil)
        return nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];   
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Category"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(catId == %@)", categoryId];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([results count] == 0) 
        return nil;
    
    return [results objectAtIndex:0];
}

-(NSArray*)categories
{
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Category"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%s: error: %@", __PRETTY_FUNCTION__, error);
    return results;
}

-(User*)addUserWithName: (NSString*)name accessToken: (NSString*)accessToken {
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" 
                                                          inManagedObjectContext:self.managedObjectContext];
    [user setValue:name forKey:@"name"];
    [user setValue:accessToken forKey:@"accessToken"];
    
    [self save];
    return (User*)user;
}

-(NSArray*)users
{
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%s: error: %@", __PRETTY_FUNCTION__, error);
    return results;
}

-(BOOL)categoriesStored
{
    NSLog(@"%s: called", __PRETTY_FUNCTION__);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Category"
                                                         inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entityDescription];	
    NSError *error;
    
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (count == NSNotFound) {
        NSLog(@"%s: operation failed with error: %@", __PRETTY_FUNCTION__, error);
        return FALSE;
    }
    if (count > 0) {
        NSLog(@"%s: categories are already loaded from Foursquare Service, count = %i, error %@", __PRETTY_FUNCTION__, count, error);
        return TRUE;
    }
    
    return FALSE;
}

-(void)save
{
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"%s: error occurred: %@:",__PRETTY_FUNCTION__, error);
    }
}


#pragma mark Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
    
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel == nil) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (
        _persistentStoreCoordinator == nil) {
        NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *storeUrl = [NSURL fileURLWithPath: [documentsDirectory stringByAppendingPathComponent: @"foursquare.sqlite"]];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSError *error = nil;
        if (![
              _persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
        {
            NSLog(@"Error occured error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}


@end
