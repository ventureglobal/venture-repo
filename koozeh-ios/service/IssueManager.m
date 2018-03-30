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

- (void)fetchIssuesWithMagazine:(Magazine *)magazine
                        success:(void (^)(NSArray<Issue *> *issues))success
                        failure:(void (^)(NSError *error))failure
             messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            Magazine *foundMagazine = [[Magazine alloc] initWithValue:[Magazine objectForPrimaryKey:@(magazine.id)]];
            if (foundMagazine != nil) {
                void (^successBlock)(NSArray<Issue *> *);
                void (^failureBlock)(NSError *);
                BOOL replace;
                if (foundMagazine.issues != nil && foundMagazine.issues.count > 0) {
                    replace = NO;
                    successBlock = nil;
                    failureBlock = nil;
                    NSMutableArray<Issue *> *issues = [NSMutableArray array];
                    for (Issue *issue in foundMagazine.issues) {
                        [issues addObject:[[Issue alloc] initWithValue:issue]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [messageBarDalegate checkInternetConnection];
                        success(issues);
                    });
                } else {
                    replace = YES;
                    successBlock = ^(NSArray<Issue *> *issues) {
                        NSMutableArray<Issue *> *result = [NSMutableArray array];
                        for (Issue *issue in issues) {
                            [result addObject:[[Issue alloc] initWithValue:issue]];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [messageBarDalegate hideInternetConnectionError];
                            success(result);
                        });
                    };
                    failureBlock = ^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [messageBarDalegate checkInternetConnection];
                            failure(error);
                        });
                    };
                }
                [self backgroundFetchAndUpdateIssuesForMagazine:foundMagazine
                                                    replace:replace
                                                    success:successBlock
                                                    failure:failureBlock];
            } else {
                NSLog(@"Error while fetching issues for magazine:%@ reaseon:Couldn't find magazine", magazine);
            }
        }
    });
}

#pragma mark - Private Methods
- (void)backgroundFetchAndUpdateIssuesForMagazine:(Magazine *)magazine
                                      replace:(BOOL)replace
                                      success:(void (^)(NSArray<Issue *> *))success
                                      failure:(void (^)(NSError *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[IssueRestService sharedInstance] getPublicIssuesWithMagazine:magazine.id success:^(NSArray<IssueResponse *> *response) {
                NSMutableArray<Issue *> *issues = [NSMutableArray array];
                for (IssueResponse *issueResponse in response) {
                    [issues addObject:[[Issue alloc] initWithDto:issueResponse]];
                }
                if (success != nil) {
                    success(issues);
                }
                if (replace) {
                    [self replaceIssues:issues withMagazine:magazine];
                } else {
                    [self updateIssues:issues withMagazine:magazine];
                }
            } failure:^(NSError *error) {
                NSLog(@"Error while fetching issues:%@", [error localizedDescription]);
                if (failure != nil) {
                    failure(error);
                }
            }];
        }
    });
}

- (void)replaceIssues:(NSArray<Issue *> *)issues withMagazine:(Magazine *)magazine {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            Magazine *foundMagazine = [Magazine objectForPrimaryKey:@(magazine.id)];
            if (foundMagazine != nil) {
                [foundMagazine.issues removeAllObjects];
                [foundMagazine.issues addObjects:issues];
            } else {
                NSLog(@"Error while saving issues for magazine:%@ reaseon:Couldn't find magazine", magazine);
            }
            [realm commitWriteTransaction];
        }
    });
}

- (void)updateIssues:(NSArray<Issue *> *)issues withMagazine:(Magazine *)magazine {
    for (Issue *issue in issues) {
        [self updateIssue:issue withMagazine:magazine];
    }
}

- (void)updateIssue:(Issue *)issue withMagazine:(Magazine *)magazine {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            Issue *foundIssue = [Issue objectForPrimaryKey:@(issue.id)];
            if (foundIssue != nil) {
                foundIssue.date = issue.date;
                foundIssue.imageUrl = issue.imageUrl;
                foundIssue.thumbnailUrl = issue.thumbnailUrl;
                foundIssue.issueNumber = issue.issueNumber;
                foundIssue.price = issue.price;
                foundIssue.free = issue.free;
                foundIssue.pageCount = issue.pageCount;
                foundIssue.issueDescription = issue.issueDescription;
                foundIssue.purchased = issue.purchased;
            } else {
                [magazine.issues addObject:issue];
            }
            [realm commitWriteTransaction];
        }
    });
}

@end
