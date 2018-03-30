//
//  UserResponse.m
//  koozeh-ios
//
//  Created by Samin Safaei on 4/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "UserResponse.h"

@implementation UserResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"firstName":@"firstName",
             @"lastName":@"lastName",
             @"mobile":@"mobile",
             @"email":@"email",
             @"birthdateJalaliYear":@"birthdateJalaliYear",
             @"birthdateJalaliMonth":@"birthdateJalaliMonth",
             @"birthdateJalaliDay":@"birthdateJalaliDay"
             };
}

@end
