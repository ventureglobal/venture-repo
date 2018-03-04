//
//  SignInRequest.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/4/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "SignInRequest.h"

@implementation SignInRequest

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mobile" : @"mobile",
             @"deviceInfo" : @"deviceInfo"
             };
}

@end
