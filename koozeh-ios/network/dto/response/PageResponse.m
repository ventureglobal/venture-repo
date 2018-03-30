//
//  PageResponse.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "PageResponse.h"
#import "MediaResponse.h"

@implementation PageResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"pageNumber":@"pageNumber",
             @"imageUrl":@"imageUrl",
             @"thumbnailUrl":@"thumbnailUrl",
             @"medias":@"medias",
             @"bookmarked":@"bookmarked"
             };
}

#pragma mark - JSON Transformers
+ (NSValueTransformer *)mediasJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *mediaJsonArray, BOOL *success, NSError *__autoreleasing *error) {
        NSError *convertError;
        NSArray<MediaResponse *> *list = [MTLJSONAdapter modelsOfClass:MediaResponse.class fromJSONArray:mediaJsonArray error:&convertError];
        if (convertError == nil) {
            return list;
        } else {
            NSLog(@"Error while converting JSON:%@", [convertError localizedDescription]);
            *error = convertError;
            return nil;
        }
    }];
}

@end
