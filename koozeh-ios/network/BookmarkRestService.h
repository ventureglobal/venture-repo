//
//  BookmarkRestService.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "SessionManager.h"
#import "BookmarkResponse.h"

@interface BookmarkRestService : SessionManager

- (NSURLSessionDataTask *)bookmarkPageWithId:(long)pageId
                                     success:(void (^)(BookmarkResponse *response))success
                                     failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)removeBookmarkWithPageId:(long)pageId
                                              success:(void (^)(void))success
                                              failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getAllBookmarks:(void (^)(NSArray<BookmarkResponse *> *))success
                                  failure:(void (^)(NSError *error))failure;

@end
