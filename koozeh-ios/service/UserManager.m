//
//  UserManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "UserManager.h"
#import "UserRestService.h"
#import "SystemUtil.h"
#import "SignInResponse.h"

@implementation UserManager

+ (instancetype)sharedInstance {
    static UserManager *userManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[self alloc] init];
    });
    
    return userManager;
}

- (void)signInWithMobile:(NSString *)mobile
                 success:(void (^)(long deviceId))success
                 failure:(void (^)(NSError *error))failure
      messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    [[UserRestService sharedInstance] signInWithMobile:mobile
                                            deviceInfo:[SystemUtil getDeviceName]
                                               success:^(SignInResponse *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [messageBarDalegate hideInternetConnectionError];
            success(response.deviceIdentity);
        });
    } failure:^(NSError *error) {
        NSLog(@"Error while signing in:%@", [error localizedDescription]);
        NSLog(@"Error domain:%@ code:%ld keys:%@", error.domain, (long)error.code, [error.userInfo allKeys]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [messageBarDalegate checkInternetConnection];
            failure(error);
        });
    }];
}

- (void)verifyMobileWithCode:(NSString *)verificationCode
                    deviceId:(long)deviceId
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure
          messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    [(UserRestService *)[UserRestService sharedInstance]
     verifyMobileWithCode:verificationCode
     deviceId:deviceId
     success:^(VerifyDeviceResponse *response) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [messageBarDalegate hideInternetConnectionError];
             if (response != nil && response.token != nil) {
                 [[NSUserDefaults standardUserDefaults] setObject:response.token forKey:@"userToken"];
                 success();
             } else {
                 failure([NSError errorWithDomain:@"ir.bina.koozeh-ios" code:-1 userInfo:@{@"errorKey":@"WrongVerificationCode"}]);
             }
         });
     } failure:^(NSError *error) {
         NSLog(@"Error while using verifying mobile:%@", [error localizedDescription]);
         NSLog(@"Error domain:%@ errorCode:%ld", error.domain, error.code);
         dispatch_async(dispatch_get_main_queue(), ^{
             [messageBarDalegate checkInternetConnection];
             failure([NSError errorWithDomain:@"ir.bina.koozeh-ios" code:-1 userInfo:@{@"errorKey":@"WrongVerificationCode"}]);
         });
     }];
}

@end
