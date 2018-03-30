//
//  MagazineRestService.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/6/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "MagazineRestService.h"

static NSString *const kPublicMagazinesPath = kContextUrl @"public/magazines";

@implementation MagazineRestService

+ (id)sharedInstance {
    static MagazineRestService *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}

- (NSURLSessionDataTask *)getAllMagazines:(void (^)(NSArray<MagazineResponse *> *response))success failure:(void (^)(NSError *error))failure {
    return [self GET:kPublicMagazinesPath
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSArray *responseArray = (NSArray *)responseObject;
                 NSError *error;
                 NSArray<MagazineResponse *> *list = [MTLJSONAdapter modelsOfClass:MagazineResponse.class fromJSONArray:responseArray error:&error];
                 if (error == nil) {
                     success(list);
                 } else {
                     NSLog(@"Error while converting JSON:%@", [error localizedDescription]);
                     failure(error);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                     [self getAllMagazines:success failure:failure];
                 } else {
                     failure(error);
                 }
             }];
}

@end
