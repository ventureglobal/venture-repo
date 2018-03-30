//
//  UserResponse.h
//  koozeh-ios
//
//  Created by Samin Safaei on 4/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface UserResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic) long id;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSNumber *birthdateJalaliYear;
@property (copy, nonatomic) NSNumber *birthdateJalaliMonth;
@property (copy, nonatomic) NSNumber *birthdateJalaliDay;

@end
