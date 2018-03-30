//
//  BookmarkManager.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bookmark.h"
#import "CustomMessageBarViewController.h"

@interface BookmarkManager : NSObject

+ (instancetype)sharedInstance;

- (void)bookmarkPageWithId:(long)pageId
                   issueId:(long)issueId
                magazineId:(long)magazineId
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *))failure
        messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

- (void)removeBookmarkWithPageId:(long)pageId
                         issueId:(long)issueId
                      magazineId:(long)magazineId
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *))failure
              messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

- (void)getAllBookmarks:(void (^)(NSArray<Bookmark *> *))success
                failure:(void (^)(NSError *))failure
     messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

@end
