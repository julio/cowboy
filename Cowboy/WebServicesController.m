//
//  WebServicesController.m
//  Cowboy
//
//  Created by Andrew Katz on 8/15/13.
//  Copyright (c) 2013 Outright. All rights reserved.
//

#import "WebServicesController.h"
#import "SBJson.h"
#import "AFJSONRequestOperation.h"

@implementation WebServicesController

+ (WebServicesController *)sharedController
{
    static WebServicesController *sharedController = nil;
    @synchronized (self)
    {
        if (sharedController == nil)
        {
            sharedController = [[[self class] alloc] init];
        }
    }
    return sharedController;
}

- (BOOL)requestWithURL:(NSString *)urlString params:(NSDictionary *)params completionBlock:(void (^)(NSDictionary *))completeBlock
{
    NSString *credentialsFilePath = [[NSBundle mainBundle] pathForResource:@"Credentials" ofType:@"plist"];
    NSDictionary *credentialsDict = [NSDictionary  dictionaryWithContentsOfFile:credentialsFilePath];
    NSString *username = [credentialsDict valueForKey:@"admin_username"];
    NSLog(@"Username: %@", username);
    NSString *password = [[credentialsDict valueForKey:@"admin_password"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *fullUrl = [NSString stringWithFormat:@"http://%@:%@@secure.outright.com/%@", username, password, urlString];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"App.net Global Stream: %@", JSON);
        completeBlock(JSON);
    } failure:nil];
    [operation start];
    return false;
}


- (void)getImporterProgressWithBlock:(void (^)(NSDictionary *))completeBlock
{
    [self requestWithURL:@"admin/importer_progress?format=json" params:nil completionBlock:completeBlock];
}

@end