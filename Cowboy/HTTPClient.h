//
//  HTTPClient.h
//  Cowboy
//
//  Created by Andrew Katz on 8/15/13.
//  Copyright (c) 2013 Outright. All rights reserved.
//

#import "AFNetworking/AFHTTPClient.h"

@interface HTTPClient : AFHTTPClient

- (void)setUsername:(NSString *)username andPassword:(NSString *)password;

+ (HTTPClient *)sharedClient;

@end