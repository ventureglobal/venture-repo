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
            success(response.deviceId);
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

- (void)getUser:(void (^)(User *))success
        failure:(void (^)(NSError *))failure
messageBarDelegate:(id<CustomMessageBarDelegate>)messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMResults *foundUsers = [User allObjects];
            void (^successBlock)(User *);
            void (^failureBlock)(NSError *);
            if (foundUsers != nil && foundUsers.count == 1) {
                failureBlock = nil;
                successBlock = nil;
                User *detachedUser = [[User alloc] initWithValue:[foundUsers objectAtIndex:0]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [messageBarDalegate checkInternetConnection];
                    success(detachedUser);
                });
            } else {
                successBlock = ^(User *user) {
                    User *detachedUser = [[User alloc] initWithValue:user];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [messageBarDalegate hideInternetConnectionError];
                        success(detachedUser);
                    });
                };
                failureBlock = ^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [messageBarDalegate checkInternetConnection];
                        failure(error);
                    });
                };
            }
            [self backgroundFetchAndUpdateUser:successBlock
                                            failure:failureBlock];
        }
    });
}

- (void)updateUser:(User *)user
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure
messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[UserRestService sharedInstance]
             updateUserFirstName:user.firstName
             lastName:user.lastName
             email:user.email
             birthdateJalaliYear:user.birthdateJalaliYear
             birthdateJalaliMonth:user.birthdateJalaliMonth
             birthdateJalaliDay:user.birthdateJalaliDay
             success:^(UserResponse *userResponse) {
                 User *result = [[User alloc] initWithDto:userResponse];
                 if (success != nil) {
                     success(result);
                 }
                 [self backgroundUpdateUser:result];
             } failure:^(NSError *error) {
                 failure(error);
             }];
        }
    });
}

#pragma mark - Private Methods
- (void)backgroundFetchAndUpdateUser:(void (^)(User *))success
                             failure:(void (^)(NSError *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[UserRestService sharedInstance]
             getUser:^(UserResponse *userResponse) {
                 User *result = [[User alloc] initWithDto:userResponse];
                 if (success != nil) {
                     success(result);
                 }
                 [self backgroundUpdateUser:result];
             } failure:^(NSError *error) {
                 failure(error);
             }];
        }
    });
}

- (void)backgroundUpdateUser:(User *)user {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            RLMResults *allUsers = [User allObjects];
            if (allUsers != nil && allUsers.count == 1) {
                User *foundUser = allUsers[0];
                [realm beginWriteTransaction];
                [foundUser updateWith:user];
                [realm commitWriteTransaction];
            } else {
                [realm beginWriteTransaction];
                if (allUsers.count) {
                    [realm deleteObjects:allUsers];
                }
                [realm commitWriteTransaction];
                [realm beginWriteTransaction];
                [realm addObject:user];
                [realm commitWriteTransaction];
            }
        }
    });
}

@end
