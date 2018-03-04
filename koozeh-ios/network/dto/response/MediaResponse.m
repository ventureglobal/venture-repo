//
//  MediaResponse.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "MediaResponse.h"

@implementation MediaResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identity":@"id",
             @"url":@"url",
             @"mediaType":@"mediaType",
             @"name":@"name"
             };
}

@end
