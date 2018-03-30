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
    return [self initWithValue:
  @{
    @"id":@(response.id),
    @"date":response.date,
    @"imageUrl":response.imageUrl,
    @"thumbnailUrl":response.thumbnailUrl,
    @"pages":@[],
    @"issueNumber":@(response.issueNumber),
    @"price":@(response.price),
    @"free":@(response.free),
    @"pageCount":@(response.pageCount),
    @"issueDescription":response.issueDescription,
    @"purchased":@(response.purchased)
    }];
}

#pragma mark - RLM Configs
+ (NSString *)primaryKey {
    return @"id";
}

+ (NSArray<NSString *> *)indexedProperties {
    return @[@"issueNumber"];
}

@end
