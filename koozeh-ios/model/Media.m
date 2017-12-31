//
//  Media.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "Media.h"

@implementation Media

- (instancetype)initWithDto:(MediaResponse *)response {
    self = [super init];
    if (self) {
        self.identity = response.identity;
        self.url = response.url;
        self.mediaType = response.mediaType;
        self.name = response.name;
    }
    return self;
}

@end
