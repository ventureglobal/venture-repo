//
//  Issue.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "Issue.h"

@implementation Issue

- (instancetype)initWithDto:(IssueResponse *)response {
    self = [super init];
    if (self) {
        self.identity = response.identity;
        self.date = response.date;
        self.imageUrl = response.imageUrl;
        self.thumbnailUrl = response.thumbnailUrl;
        self.isOffline = NO;
    }
    return self;
}

@end
