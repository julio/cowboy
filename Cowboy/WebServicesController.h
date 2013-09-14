//
//  WebServicesController.h
//  Cowboy
//
//  Created by Andrew Katz on 8/15/13.
//  Copyright (c) 2013 Outright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServicesController : NSObject

+ (WebServicesController *)sharedController;

- (void)getImporterProgressWithBlock:(void (^)(NSDictionary *))completeBlock;

@end
