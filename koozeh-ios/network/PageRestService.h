//
//  PageRestService.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "SessionManager.h"
#import "PageResponse.h"
#import "Issue.h"

@interface PageRestService : SessionManager

- (NSURLSessionDataTask *)getPublicPagesForIssueId:(long)issueId
                                           success:(void (^)(NSArray<PageResponse *> *response))success
                                           failure:(void (^)(NSError *error))failure;

@end
