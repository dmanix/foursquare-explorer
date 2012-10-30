//
//  Category.h
//  FoursquareExplorer
//
//  Created by Lion User on 28/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * catId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pluralName;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSSet *childCategories;
@property (nonatomic, retain) Category *parentCategory;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addChildCategoriesObject:(Category *)value;
- (void)removeChildCategoriesObject:(Category *)value;
- (void)addChildCategories:(NSSet *)values;
- (void)removeChildCategories:(NSSet *)values;

@end
