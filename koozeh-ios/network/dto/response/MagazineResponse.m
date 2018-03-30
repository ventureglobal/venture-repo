//
//  MagazineResponse.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "MagazineResponse.h"
#import <Mantle/Mantle.h>

@implementation MagazineResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"name":@"name",
             @"magazineDescription":@"description",
             @"imageUrl":@"imageUrl",
             @"thumbnailUrl":@"thumbnailUrl"
             };
}

@end
