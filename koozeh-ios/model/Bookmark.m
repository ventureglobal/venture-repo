//
//  Bookmark.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

- (instancetype)initWithDto:(BookmarkResponse *)bookmarkResponse {
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithDictionary:
                                   @{@"id":@(bookmarkResponse.id)}];
    if (bookmarkResponse.page != nil) {
        [values setObject:[[Page alloc] initWithDto:bookmarkResponse.page] forKey:@"page"];
    }
    if (bookmarkResponse.issue != nil) {
        [values setObject:[[Issue alloc] initWithDto:bookmarkResponse.issue] forKey:@"issue"];
    }
    if (bookmarkResponse.magazine != nil) {
        [values setObject:[[Magazine alloc] initWithDto:bookmarkResponse.magazine] forKey:@"magazine"];
    }
    return [self initWithValue:values];
}

- (instancetype)initWithValue:(id)value {
    if ([value isKindOfClass:Bookmark.class]) {
        NSMutableDictionary *values = [NSMutableDictionary dictionaryWithDictionary:
                                       @{@"id":@(((Bookmark *)value).id)}];
        if (((Bookmark *)value).page != nil) {
            [values setObject:[[Page alloc] initWithValue:((Bookmark *)value).page] forKey:@"page"];
        }
        if (((Bookmark *)value).issue != nil) {
            [values setObject:[[Issue alloc] initWithValue:((Bookmark *)value).issue] forKey:@"issue"];
        }
        if (((Bookmark *)value).magazine != nil) {
            [values setObject:[[Magazine alloc] initWithValue:((Bookmark *)value).magazine] forKey:@"magazine"];
        }
        return [super initWithValue:values];
    } else {
        return [super initWithValue:value];
    }
}

#pragma mark - Realm Config
+ (NSString *)primaryKey {
    return @"id";
}

@end
