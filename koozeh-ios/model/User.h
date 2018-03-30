//
//  User.h
//  koozeh-ios
//
//  Created by Samin Safaei on 4/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Realm/Realm.h>
#import "UserResponse.h"

@interface User : RLMObject

@property long id;
@property  NSString *firstName;
@property  NSString *lastName;
@property  NSString *mobile;
@property  NSString *email;
@property  NSNumber<RLMInt> *birthdateJalaliYear;
@property  NSNumber<RLMInt> *birthdateJalaliMonth;
@property  NSNumber<RLMInt> *birthdateJalaliDay;

- (instancetype)initWithDto:(UserResponse *)userResponse;

- (void)updateWith:(User *)user;

- (NSString *)name;

@end
