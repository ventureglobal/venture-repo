//
//  IssueRestService.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "IssueRestService.h"

static NSString *const kPublicDefaultIssuesPath = kContextUrl @"public/issues/default";
static NSString *const kPublicIssuesPath = kContextUrl @"public/issues/";

@implementation IssueRestService

- (NSURLSessionDataTask *)getPublicDefaultIssues:(void (^)(NSArray<IssueResponse *> *response))success failure:(void (^)(NSError *error))failure {
    return [self GET:kPublicDefaultIssuesPath
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSArray *responseArray = (NSArray *)responseObject;
                 NSError *error;
                 NSArray<IssueResponse *> *list = [MTLJSONAdapter modelsOfClass:IssueResponse.class fromJSONArray:responseArray error:&error];
                 if (error == nil) {
                     success(list);
                 } else {
                     NSLog(@"Error while converting JSON:%@", [error localizedDescription]);
                     failure(error);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                     [self getPublicDefaultIssues:success failure:failure];
                 } else {
                     failure(error);
                 }
             }];
}

- (NSURLSessionDataTask *)getPublicIssuesWithMagazine:(long)magazineId success:(void (^)(NSArray<IssueResponse *> *response))success failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%ld", kPublicIssuesPath, magazineId];
    return [self GET:url
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSArray *responseArray = (NSArray *)responseObject;
                 NSError *error;
                 NSArray<IssueResponse *> *list = [MTLJSONAdapter modelsOfClass:IssueResponse.class fromJSONArray:responseArray error:&error];
                 if (error == nil) {
                     success(list);
                 } else {
                     NSLog(@"Error while converting JSON:%@", [error localizedDescription]);
                     failure(error);
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                     [self getPublicIssuesWithMagazine:magazineId success:success failure:failure];
                 } else {
                     failure(error);
                 }
             }];
}

+ (id)sharedInstance {
    static IssueRestService *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}

@end
