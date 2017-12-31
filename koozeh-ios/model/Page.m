//
//  Page.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "Page.h"

@implementation Page

- (instancetype)initWithDto:(PageResponse *)response {
    self = [super init];
    if (self) {
        self.identity = response.identity;
        self.pageNumber = response.pageNumber;
        self.imageUrl = response.imageUrl;
        self.thumbnailUrl = response.thumbnailUrl;
        self.medias = [NSMutableArray array];
        for (MediaResponse *mediaResponse in response.medias) {
            [self.medias addObject:[[Media alloc] initWithDto:mediaResponse]];
        }
    }
    return self;
}

@end
