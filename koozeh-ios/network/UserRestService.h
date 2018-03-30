//
//  UserRestService.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"
#import "SignInResponse.h"
#import "VerifyDeviceResponse.h"
#import "UserResponse.h"

@interface UserRestService : SessionManager

- (NSURLSessionDataTask *)signInWithMobile:(NSString *)mobile
                                deviceInfo:(NSString *)deviceInfo
                                   success:(void (^)(SignInResponse *response))success
                                   failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)verifyMobileWithCode:(NSString *)verificationCode
                                      deviceId:(long)deviceId
                                       success:(void (^)(VerifyDeviceResponse *response))success
                                       failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)getUser:(void (^)(UserResponse *response))success
                          failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)updateUserFirstName:(NSString *)firstName
                                     lastName:(NSString *)lastName
                                        email:(NSString *)email
                          birthdateJalaliYear:(NSNumber *)birthdateJalaliYear
                         birthdateJalaliMonth:(NSNumber *)birthdateJalaliMonth
                           birthdateJalaliDay:(NSNumber *)birthdateJalaliDay
                                      success:(void (^)(UserResponse *response))success
                          failure:(void (^)(NSError *error))failure;

@end
