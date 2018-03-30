//
//  PageManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "PageManager.h"
#import <Realm/Realm.h>
#import "IssueManager.h"

@implementation PageManager

+ (instancetype)sharedInstance {
    static PageManager *pageManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pageManager = [[self alloc] init];
    });
    
    return pageManager;
}

- (void)fetchPagesWithIssue:(Issue *)issue
                    success:(void (^)(NSArray<Page *> *))success
                    failure:(void (^)(NSError *))failure
         messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            Issue *foundIssue = [[Issue alloc] initWithValue:[Issue objectForPrimaryKey:@(issue.id)]];
            void (^successBlock)(NSArray<Page *> *);
            void (^failureBlock)(NSError *);
            BOOL replace;
            if (foundIssue != nil) {
                if (foundIssue.pages.count != 0) {
                    replace = NO;
                    failureBlock = nil;
                    successBlock = nil;
                    NSMutableArray<Page *> *pages = [NSMutableArray array];
                    for (Page *page in foundIssue.pages) {
                        Page *detachedPage = [[Page alloc] initWithValue:page];
                        [detachedPage.medias removeAllObjects];
                        for (Media *media in page.medias) {
                            [detachedPage.medias addObject:[[Media alloc] initWithValue:media]];
                        }
                        [pages addObject:detachedPage];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [messageBarDalegate checkInternetConnection];
                        success(pages);
                    });
                } else {
                    replace = YES;
                    successBlock = ^(NSArray<Page *> *pages) {
                        NSMutableArray<Page *> *result = [NSMutableArray array];
                        for (Page *page in pages) {
                            Page *detachedPage = [[Page alloc] initWithValue:page];
                            [detachedPage.medias removeAllObjects];
                            for (Media *media in page.medias) {
                                [detachedPage.medias addObject:[[Media alloc] initWithValue:media]];
                            }
                            [result addObject:detachedPage];
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
                [self backgroundFetchAndUpdatePagesForIssue:foundIssue
                                                    replace:replace
                                                    success:successBlock
                                                    failure:failureBlock];
            } else {
                NSLog(@"Error while fetching pages for issue:%@ reason:%@", (foundIssue != nil? issue:@"[nil]"), @"Could not find issue");
            }
        }
    });
}

#pragma mark - Private Methods
- (void)backgroundFetchAndUpdatePagesForIssue:(Issue *)issue
                                      replace:(BOOL)replace
                                      success:(void (^)(NSArray<Page *> *))success
                                      failure:(void (^)(NSError *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[PageRestService sharedInstance]
             getPublicPagesForIssueId:issue.id
             success:^(NSArray<PageResponse *> *response) {
                 NSMutableArray<Page *> *pages = [NSMutableArray array];
                 for (PageResponse *pageResponse in response) {
                     [pages addObject:[[Page alloc] initWithDto:pageResponse]];
                 }
                 if (replace) {
                     [self replacePages:pages withIssue:issue];
                 } else {
                     [self updatePages:pages withIssue:issue];
                 }
                 if (success != nil) {
                     success(pages);
                 }
             } failure:^(NSError *error) {
                 NSLog(@"Error while fetching pages:%@", [error localizedDescription]);
                 if (failure != nil) {
                     failure(error);
                 }
             }];
        }
    });
}

- (void)replacePages:(NSArray<Page *> *)pages withIssue:(Issue *)issue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            Issue *foundIssue = [Issue objectForPrimaryKey:@(issue.id)];
            if (foundIssue != nil) {
                [foundIssue.pages removeAllObjects];
                [foundIssue.pages addObjects:pages];
            } else {
                NSLog(@"Error while saving pages for issue:%@ reason:%@", (foundIssue != nil? foundIssue:@"[nil]"), @"Could not find issue");
            }
            [realm commitWriteTransaction];
        }
    });
}

- (void)updatePage:(Page *)page withIssue:(Issue *)issue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            Page *foundPage = [Page objectForPrimaryKey:@(page.id)];
            if (foundPage != nil) {
                foundPage.pageNumber = page.pageNumber;
                foundPage.imageUrl = page.imageUrl;
                foundPage.thumbnailUrl = page.thumbnailUrl;
                foundPage.bookmarked = page.bookmarked;
                if (page.medias.count) {
                    [foundPage.medias removeAllObjects];
                    for (Media *media in page.medias) {
                        Media *foundMedia = [Media objectForPrimaryKey:@(media.id)];
                        if (foundMedia != nil) {
                            [foundPage.medias addObject:foundMedia];
                        } else {
                            [foundPage.medias addObject:[[Media alloc] initWithValue:media]];
                        }
                    }
                }
            } else {
                Issue *foundIssue = [Issue objectForPrimaryKey:@(issue.id)];
                [foundIssue.pages addObject:page];
            }
            [realm commitWriteTransaction];
        }
    });
}

- (void)updatePages:(NSArray<Page *> *)pages withIssue:(Issue *)issue {
    for (Page *page in pages) {
        [self updatePage:page withIssue:issue];
    }
}

@end
