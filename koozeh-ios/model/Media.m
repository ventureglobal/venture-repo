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
    return [self initWithValue:
            @{
              @"id":@(response.id),
              @"url":response.url,
              @"mediaType":response.mediaType,
              @"name":response.name
              }];
}

#pragma mark - RLM Configs
+ (NSString *)primaryKey {
    return @"id";
}

@end
