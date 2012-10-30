//
//  CommonUtils.h
//  FoursquareExplorer
//
//  Created by Lion User on 29/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Class containing helper methods/utilities
 */
@interface CommonUtils : NSObject

/**
 * Converts string to decimal number.
 *
 * @param value string to converts
 * @returns parsed number if converting succeeded, otherwise nil
 */
+(NSNumber*) convertToDecimalNumber:(NSString*)value;

/**
 * Escapes given parameters dictionary
 * @param parameters parameters to escape
 * @returns array with escaped parameters
 */
+(NSArray*) escapeParameters:(NSDictionary*)parameters;

/**
 * Creates NSURL object from givem uri and parameters
 * @param uri
 * @param parameters
 * @returns NSURL object if parameters were correct, otherwise nil
 */
+(NSURL*) createURLWithUri:(NSString*)uri parameters:(NSArray*)parameters;

/**
 * Parses given url and retrieves parameters from it.
 * @param url url to parse
 * @returns dictionary with parsed parameters
 */
+(NSDictionary*) parseParametersFromURL:(NSURL*)url;

@end
