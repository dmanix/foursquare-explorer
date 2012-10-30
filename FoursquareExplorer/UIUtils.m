//
//  UIUtils.m
//  FoursquareExplorer
//
//  Created by Lion User on 29/10/2012.
//  Copyright (c) 2012 Damian Manski. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils


+(void)displayErrorWithMessage: (NSString*) message {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Ok" 
                                          otherButtonTitles: nil];
    [alert show];
}

@end
