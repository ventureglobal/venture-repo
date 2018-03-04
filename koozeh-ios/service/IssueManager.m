//
//  IssueManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "IssueManager.h"
#import "Issue.h"
#import "Page.h"
#import "IssueRestService.h"
#import "IssueResponse.h"
#import "PageResponse.h"
#import <Realm/Realm.h>

@implementation IssueManager

+ (instancetype)sharedInstance {
    static IssueManager *issueManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        issueManager = [[self alloc] init];
    });
    
    return issueManager;
}

- (void)fetchPublicDefaultIssues:(void (^)(NSArray<Issue *> *))success
                         failure:(void (^)(NSError *))failure
              messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    [[IssueRestService sharedInstance] getPublicDefaultIssues:^(NSArray<IssueResponse *> *response) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray<Issue *> *issues = [NSMutableArray array];
            for (IssueResponse *issueResponse in response) {
                [issues addObject:[[Issue alloc] initWithDto:issueResponse]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [messageBarDalegate hideInternetConnectionError];
                success(issues);
            });
        });
    } failure:^(NSError *error) {
        NSLog(@"Error while fetching issues:%@", [error localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [messageBarDalegate checkInternetConnection];
            failure(error);
        });
    }];
}

- (void)fetchPublicPagesForIssue:(Issue *)issue
                         success:(void (^)(NSArray<Page *> *))success
                         failure:(void (^)(NSError *))failure
              messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    [[IssueRestService sharedInstance]
     getPublicPagesForIssue:issue
     success:^(NSArray<PageResponse *> *response) {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             NSMutableArray<Page *> *pages = [NSMutableArray array];
             for (PageResponse *pageResponse in response) {
                 [pages addObject:[[Page alloc] initWithDto:pageResponse]];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [messageBarDalegate hideInternetConnectionError];
                 success(pages);
             });
         });
     } failure:^(NSError *error) {
         NSLog(@"Error while fetching issues:%@", [error localizedDescription]);
         dispatch_async(dispatch_get_main_queue(), ^{
             [messageBarDalegate checkInternetConnection];
             failure(error);
         });
     }];
}

@end
