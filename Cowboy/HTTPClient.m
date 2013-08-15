//
//  HTTPClient.m
//  Cowboy
//
//  Created by Andrew Katz on 8/15/13.
//  Copyright (c) 2013 Outright. All rights reserved.
//

#import "HTTPClient.h"
#import "AFNetworking/AFJSONRequestOperation.h"
#import "AFNetworking/AFNetworkActivityIndicatorManager.h"

@implementation HTTPClient

#pragma mark - Methods

- (void)setUsername:(NSString *)username andPassword:(NSString *)password
{
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithUsername:username password:password];
}

#pragma mark - Initialization

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(!self)
        return nil;
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return self;
}

#pragma mark - Singleton Methods

+ (HTTPClient *)sharedClient
{
    static dispatch_once_t pred;
    static HTTPClient *_sharedManager = nil;
    
    dispatch_once(&pred, ^{ _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://secure.outright.com"]]; }); // You should probably make this a constant somewhere
    return _sharedManager;
}

@end