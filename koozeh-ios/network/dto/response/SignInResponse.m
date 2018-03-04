//
//  SignInResponse.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "SignInResponse.h"

@implementation SignInResponse

#pragma mark - Mantle JSONKeyPathsByPropertyKey
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"deviceIdentity" : @"deviceId"
             };
}

@end
