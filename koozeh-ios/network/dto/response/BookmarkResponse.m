//
//  BookmarkResponse.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "BookmarkResponse.h"
#import "MagazineResponse.h"
#import "IssueResponse.h"
#import "PageResponse.h"

@implementation BookmarkResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"magazine":@"magazine",
             @"issue":@"issue",
             @"page":@"page"
             };
}

#pragma mark - JSON Transformers
+ (NSValueTransformer *)magazineJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:MagazineResponse.class];
}
+ (NSValueTransformer *)issueJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:IssueResponse.class];
}
+ (NSValueTransformer *)pageSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:PageResponse.class];
}

@end
