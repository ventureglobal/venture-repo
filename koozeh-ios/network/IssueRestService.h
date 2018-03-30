//
//  IssueRestService.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"
#import "IssueResponse.h"
#import "PageResponse.h"
#import "Issue.h"

@interface IssueRestService : SessionManager

- (NSURLSessionDataTask *)getPublicDefaultIssues:(void (^)(NSArray<IssueResponse *> *response))success failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getPublicIssuesWithMagazine:(long)magazineId success:(void (^)(NSArray<IssueResponse *> *response))success failure:(void (^)(NSError *error))failure;

@end
