//
//  Bookmark.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Realm/Realm.h>
#import "BookmarkResponse.h"
#import "Page.h"
#import "Issue.h"
#import "Magazine.h"

@interface Bookmark : RLMObject

@property long id;
@property Magazine *magazine;
@property Issue *issue;
@property Page *page;

- (instancetype)initWithDto:(BookmarkResponse *)bookmarkResponse;

@end
