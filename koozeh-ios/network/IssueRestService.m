//
//  IssueRestService.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "IssueRestService.h"

static NSString *const kPublicDefaultIssuesPath = kContextUrl @"public/issues/default";
static NSString *const kPublicPagesForIssuePath = kContextUrl @"public/pages/";

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
                 failure(error);
             }];
}

- (NSURLSessionDataTask *)getPublicPagesForIssue:(Issue *)issue success:(void (^)(NSArray<PageResponse *> *response))success failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%ld", kPublicPagesForIssuePath, issue.identity];
    return [self GET:url
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSArray *responseArray = (NSArray *)responseObject;
                 NSError *error;
                 NSArray<PageResponse *> *list = [MTLJSONAdapter modelsOfClass:PageResponse.class fromJSONArray:responseArray error:&error];
                 if (error == nil) {
                     success(list);
                 } else {
                     NSLog(@"Error while converting JSON:%@", [error localizedDescription]);
                     failure(error);
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error);
             }];
}

@end
