//
//  Issue.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "IssueResponse.h"

@implementation IssueResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"date":@"date",
             @"imageUrl":@"imageUrl",
             @"thumbnailUrl":@"thumbnailUrl",
             @"issueNumber":@"issueNumber",
             @"price":@"price",
             @"free":@"free",
             @"pageCount":@"pageCount",
             @"issueDescription":@"description",
             @"purchased":@"purchased"
             };
}

#pragma mark - JSON Transformers
+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *milliseconds, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:([milliseconds doubleValue] / 1000.0)];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000.0];
    }];
}

@end
