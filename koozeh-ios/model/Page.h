//
//  Page.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Media.h"
#import "PageResponse.h"

@interface Page : RLMObject

@property long id;
@property NSInteger pageNumber;
@property NSString *imageUrl;
@property NSString *thumbnailUrl;
@property RLMArray<Media *><Media> *medias;
@property BOOL bookmarked;

- (instancetype)initWithDto:(PageResponse *)response;

@end
RLM_ARRAY_TYPE(Page)
