//
//  Magazine.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "Magazine.h"

@implementation Magazine

- (instancetype)initWithDto:(MagazineResponse *)magazineResponse {
    return [self initWithValue:
  @{
    @"id":@(magazineResponse.id),
    @"name":magazineResponse.name,
    @"magazineDescription":magazineResponse.magazineDescription,
    @"imageUrl":magazineResponse.imageUrl,
    @"thumbnailUrl":magazineResponse.thumbnailUrl,
    @"issues":@[]
    }];
}

#pragma mark - Realm Config
+ (NSString *)primaryKey {
    return @"id";
}

+ (NSArray<NSString *> *)indexedProperties {
    return @[@"name"];
}

@end
