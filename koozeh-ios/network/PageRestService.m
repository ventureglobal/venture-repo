//
//  PageRestService.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "PageRestService.h"

static NSString *const kPublicPagesForIssuePath = kContextUrl @"public/pages/";

@implementation PageRestService

+ (id)sharedInstance {
    static PageRestService *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}

- (NSURLSessionDataTask *)getPublicPagesForIssueId:(long)issueId
                                           success:(void (^)(NSArray<PageResponse *> *response))success
                                           failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%ld", kPublicPagesForIssuePath, issueId];
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
                 if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                     [self getPublicPagesForIssueId:issueId success:success failure:failure];
                 } else {
                     failure(error);
                 }
             }];
}
@end
