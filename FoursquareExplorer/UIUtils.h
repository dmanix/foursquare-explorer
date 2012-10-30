//
//  UIUtils.h
//  FoursquareExplorer
//
//  Created by Lion User on 29/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Class containg helper methods for UI
 */
@interface UIUtils : NSObject

/**
 * Display alert window with given message
 * @param message
 */
+(void) displayErrorWithMessage: (NSString*) message;

@end
