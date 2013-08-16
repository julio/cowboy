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
    NSString *fullUrl = [NSString stringWithFormat:@"http://andrew.katz%%40outrightcom:1234@secure.outright.com/%@", urlString];
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
    } failure:nil];
    [operation start];
    
    
//    MKNetworkOperation *op = [self operationWithPath:url params:params httpMethod:@"GET" ssl:YES];
//    [op setUsername:@"andrew.katz@outright.com" password:@"1234" basicAuth:YES];
//    
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
//     {
//         NSLog(@"Request response: %@", [completedOperation responseString]);
//         NSDictionary *response = @{@"response": [completedOperation responseJSON]};
//         completeBlock(response);
//     }
//                errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
//     {
//         NSLog(@"Error");
//     }];
//    
//    [self enqueueOperation:op];
//    
//    return op;
    return false;
}

- (void)getImporterProgressWithBlock:(void (^)(NSDictionary *))completeBlock
{
    [self requestWithURL:@"importer_progress?format=json" params:nil completionBlock:completeBlock];
}

- (void)getImporterErrorsWithBlock:(void (^)(NSDictionary *))completeBlock
{
    [self requestWithURL:@"company_importer_errors?format=json" params:nil completionBlock:completeBlock];
}

@end