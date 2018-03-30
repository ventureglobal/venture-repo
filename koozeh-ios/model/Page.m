//
//  Page.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "Page.h"
#import "MediaResponse.h"

@implementation Page

- (instancetype)initWithDto:(PageResponse *)response {
    self = [self initWithValue:
            @{
              @"id":@(response.id),
              @"pageNumber":@(response.pageNumber),
              @"imageUrl":response.imageUrl,
              @"thumbnailUrl":response.thumbnailUrl,
              @"bookmarked":@(response.bookmarked)
              }];
    if (self) {
        for (MediaResponse *mediaResponse in response.medias) {
            if (mediaResponse.id != 0) {
                [self.medias addObject:[[Media alloc] initWithDto:mediaResponse]];
            }
        }
    }
    return self;
}

#pragma mark - RLM Configs
+ (NSString *)primaryKey {
    return @"id";
}

+ (NSArray<NSString *> *)indexedProperties {
    return @[@"pageNumber"];
}

@end
