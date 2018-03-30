//
//  BookmarkManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "BookmarkManager.h"
#import "BookmarkRestService.h"
#import "BookmarkResponse.h"
#import <Realm/Realm.h>
#import "Magazine.h"
#import "Issue.h"
#import "Page.h"

@implementation BookmarkManager

+ (instancetype)sharedInstance {
    static BookmarkManager *bookmarkManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bookmarkManager = [[self alloc] init];
    });
    
    return bookmarkManager;
}

- (void)bookmarkPageWithId:(long)pageId
                   issueId:(long)issueId
                magazineId:(long)magazineId
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *))failure
        messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[BookmarkRestService sharedInstance]
             bookmarkPageWithId:pageId
             success:^(BookmarkResponse *response) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [messageBarDalegate hideInternetConnectionError];
                     success();
                 });
                 RLMRealm *realm = [RLMRealm defaultRealm];
                 [realm beginWriteTransaction];
                 Page *page = [Page objectForPrimaryKey:@(pageId)];
                 Issue *issue = [Issue objectForPrimaryKey:@(issueId)];
                 Magazine *magazine = [Magazine objectForPrimaryKey:@(magazineId)];
                 page.bookmarked = YES;
                 Bookmark *bookmark = [[Bookmark alloc] initWithDto:response];
                 bookmark.page = page;
                 bookmark.issue = issue;
                 bookmark.magazine = magazine;
                 [realm addObject:bookmark];
                 [realm commitWriteTransaction];
             }
             failure:^(NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (![@"ir.bina.koozeh-ios" isEqualToString:error.domain]) {
                         [messageBarDalegate checkInternetConnection];
                     }
                     failure(error);
                 });
             }];
        }
    });
}

- (void)removeLocalBookmarkWithPageId:(long)pageId
                              issueId:(long)issueId
                           magazineId:(long)magazineId {
    
}

- (void)removeBookmarkWithPageId:(long)pageId
                         issueId:(long)issueId
                      magazineId:(long)magazineId
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *))failure
                  messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[BookmarkRestService sharedInstance]
             removeBookmarkWithPageId:pageId success:^{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [messageBarDalegate hideInternetConnectionError];
                     success();
                 });
                 RLMRealm *realm = [RLMRealm defaultRealm];
                 [realm beginWriteTransaction];
                 NSPredicate *pred = [NSPredicate predicateWithFormat:@"page.id = %@ AND issue.id = %@ AND magazine.id = %@",
                                      @(pageId), @(issueId), @(magazineId)];
                 RLMResults<Bookmark *> *bookmarkResult = [Bookmark objectsWithPredicate:pred];
                 [realm deleteObjects:bookmarkResult];
                 Page *page = [Page objectForPrimaryKey:@(pageId)];
                 page.bookmarked = NO;
                 [realm commitWriteTransaction];
             } failure:^(NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (![@"ir.bina.koozeh-ios" isEqualToString:error.domain]) {
                         [messageBarDalegate checkInternetConnection];
                     }
                     failure(error);
                 });
             }];
        }
    });
}

- (void)getAllBookmarks:(void (^)(NSArray<Bookmark *> *))success
                failure:(void (^)(NSError *))failure
     messageBarDelegate:(id<CustomMessageBarDelegate>)messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMResults *foundBookmarks = [Bookmark allObjects];
            void (^successBlock)(NSArray<Bookmark *> *);
            void (^failureBlock)(NSError *);
            if (foundBookmarks != nil && foundBookmarks.count > 0) {
                failureBlock = nil;
                successBlock = nil;
                NSMutableArray<Bookmark *> *bookmarks = [NSMutableArray array];
                for (Bookmark *bookmark in foundBookmarks) {
                    Bookmark *detachedBookmark = [[Bookmark alloc] initWithValue:bookmark];
                    [bookmarks addObject:detachedBookmark];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [messageBarDalegate checkInternetConnection];
                    success(bookmarks);
                });
            } else {
                successBlock = ^(NSArray<Bookmark *> *bookmarks) {
                    NSMutableArray<Bookmark *> *result = [NSMutableArray array];
                    for (Bookmark *bookmark in bookmarks) {
                        Bookmark *detachedBookmark = [[Bookmark alloc] initWithValue:bookmark];
                        [result addObject:detachedBookmark];
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
            [self backgroundFetchAndUpdateBookmarks:successBlock
                                            failure:failureBlock];
        }
    });
}

#pragma mark - Private Methods
- (void)backgroundFetchAndUpdateBookmarks:(void (^)(NSArray<Bookmark *> *))success
                                  failure:(void (^)(NSError *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[BookmarkRestService sharedInstance]
             getAllBookmarks:^(NSArray<BookmarkResponse *> *bookmarkResponses) {
                 NSMutableArray<Bookmark *> *result = [NSMutableArray arrayWithCapacity:bookmarkResponses.count];
                 for (BookmarkResponse *bookmarkResponse in bookmarkResponses) {
                     Bookmark *bookmark = [[Bookmark alloc] initWithDto:bookmarkResponse];
                     [result addObject:bookmark];
                 }
                 if (success != nil) {
                     success(result);
                 }
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     @autoreleasepool {
                         RLMRealm *realm = [RLMRealm defaultRealm];
                         [realm beginWriteTransaction];
                         RLMResults *allBookmarks = [Bookmark allObjects];
                         for (Bookmark *dbBookmark in allBookmarks) {
                             dbBookmark.page.bookmarked = NO;
                         }
                         [realm deleteObjects:allBookmarks];
                         for (BookmarkResponse *bookmarkResponse in bookmarkResponses) {
                             Bookmark *dbBookmark = [[Bookmark alloc] initWithDto:bookmarkResponse];
                             Page *page = [Page objectForPrimaryKey:@(bookmarkResponse.page.id)];
                             page.bookmarked = YES;
                             dbBookmark.page = page;
                             dbBookmark.issue = [Issue objectForPrimaryKey:@(bookmarkResponse.issue.id)];
                             dbBookmark.magazine = [Magazine objectForPrimaryKey:@(bookmarkResponse.magazine.id)];
                             
                         }
                         [realm commitWriteTransaction];
                     }
                 });
             } failure:^(NSError *error) {
                 failure(error);
             }];
        }
    });
}

@end
