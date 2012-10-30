//
//  CommonUtils.m
//  FoursquareExplorer
//
//  Created by Lion User on 29/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(NSNumber*) convertToDecimalNumber: (NSString*)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:value];
    return number;
}

+(NSArray*) escapeParameters:(NSDictionary*)parameters {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in parameters) {
        NSString *value = [parameters objectForKey:key];
        if (![value isKindOfClass:[NSString class]]) {
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [value description];
            } else {
                continue;
            }
        }
        CFStringRef escapedValue = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)value, NULL, CFSTR("%:/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
        NSMutableString *pair = [key mutableCopy];
        [pair appendString:@"="];
        [pair appendString:(__bridge NSString *)escapedValue];
        [pairs addObject:pair];
        CFRelease(escapedValue);
    }
    
    return pairs;
}

+(NSURL*) createURLWithUri:(NSString*)uri parameters:(NSArray*)parameters {
    NSMutableString *URLString = [uri mutableCopy];
    [URLString appendString:@"?"];
    [URLString appendString:[parameters componentsJoinedByString:@"&"]];
    NSURL *URL = [NSURL URLWithString:URLString];
    return URL;
}

+(NSDictionary*) parseParametersFromURL:(NSURL*)url {
    NSString *fragment = [url fragment];
    NSArray *pairs = [fragment componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *key = [kv objectAtIndex:0];
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [parameters setObject:val forKey:key];
    }
    return parameters;
}

@end
