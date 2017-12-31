//
//  APIManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "APIManager.h"
#import "Mantle.h"

static NSString *const kPublicDefaultIssuesPath = @"/public/issues/default";

@implementation APIManager

- (NSURLSessionDataTask *)getPublicDefaultIssues:(void (^)(IssueListResponse *response))success
                                              failure:(void (^)(NSError *error))failure{
    return [self GET:kPublicDefaultIssuesPath
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 
                 NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                 
                 NSError *error;
                 IssueListResponse *list = [MTLJSONAdapter modelOfClass:IssueListResponse.class
                                                            fromJSONDictionary:responseDictionary error:&error];
                 success(list);
                 
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
                 failure(error);
                 
             }];
}

@end
