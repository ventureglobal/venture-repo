//
//  User.m
//  koozeh-ios
//
//  Created by Samin Safaei on 4/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDto:(UserResponse *)userResponse {
    self = [self initWithValue:
                    @{
                      @"id":@(userResponse.id)
                      }];
    self.firstName = userResponse.firstName;
    self.lastName = userResponse.lastName;
    self.mobile = userResponse.mobile;
    self.email = userResponse.email;
    self.birthdateJalaliYear = userResponse.birthdateJalaliYear;
    self.birthdateJalaliMonth = userResponse.birthdateJalaliMonth;
    self.birthdateJalaliDay = userResponse.birthdateJalaliDay;
    return self;
}

- (void)updateWith:(User *)user {
    self.firstName = user.firstName;
    self.lastName = user.lastName;
    self.mobile = user.mobile;
    self.email = user.email;
    self.birthdateJalaliYear = user.birthdateJalaliYear;
    self.birthdateJalaliMonth = user.birthdateJalaliMonth;
    self.birthdateJalaliDay = user.birthdateJalaliDay;
}

- (NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.firstName , self.lastName];
}

#pragma mark - RLM Configs
+ (NSString *)primaryKey {
    return @"id";
}

+ (NSArray<NSString *> *)indexedProperties {
    return @[@"mobile", @"email"];
}

@end
