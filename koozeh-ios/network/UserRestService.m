//
//  UserRestService.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "UserRestService.h"
#import "UserResponse.h"

static NSString *const kPublicSignInPath = kContextUrl @"public/signIn";
static NSString *const kPublicVerifyMobilePath = kContextUrl @"public/verifyDevice";
static NSString *const kGetPostUserPath = kContextUrl @"user/";

@implementation UserRestService

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    if(!self) return nil;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    return self;
}

- (NSURLSessionDataTask *)signInWithMobile:(NSString *)mobile deviceInfo:(NSString *)deviceInfo success:(void (^)(SignInResponse *response))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:deviceInfo forKey:@"deviceInfo"];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded"
                  forHTTPHeaderField:@"Content-Type"];
    return [self POST:kPublicSignInPath
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSError *error;
                  SignInResponse *signInResponse = [MTLJSONAdapter modelOfClass:SignInResponse.class
                                                             fromJSONDictionary:responseObject
                                                                          error:&error];
                  success(signInResponse);
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                      [self signInWithMobile:mobile deviceInfo:deviceInfo success:success failure:failure];
                  } else {
                      failure(error);
                  }
              }];
}

- (NSURLSessionDataTask *)verifyMobileWithCode:(NSString *)verificationCode
                                      deviceId:(long)deviceId
                                       success:(void (^)(VerifyDeviceResponse *response))success
                                       failure:(void (^)(NSError *error))failure {
    NSError *error;
    NSString *jsonString = [NSString stringWithFormat:@"{\"deviceId\":\"%ld\", \"verificationCode\":\"%@\"}", deviceId, verificationCode];
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8"
                  forHTTPHeaderField:@"Content-Type"];
    return [self POST:kPublicVerifyMobilePath
           parameters:json
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSError *error;
                  VerifyDeviceResponse *verifyDeviceResponse = [MTLJSONAdapter modelOfClass:VerifyDeviceResponse.class
                                                             fromJSONDictionary:responseObject
                                                                          error:&error];
                  if (error != nil) {
                      failure(error);
                  } else {
                      success(verifyDeviceResponse);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                      [self verifyMobileWithCode:verificationCode deviceId:deviceId success:success failure:failure];
                  } else {
                      failure(error);
                  }
              }];
}

- (NSURLSessionDataTask *)getUser:(void (^)(UserResponse *))success
                          failure:(void (^)(NSError *))failure {
    return [self GET:kGetPostUserPath
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSError *error;
                 UserResponse *userResponse = [MTLJSONAdapter modelOfClass:UserResponse.class fromJSONDictionary:responseObject error:&error];
                 if (error == nil) {
                     success(userResponse);
                 } else {
                     NSLog(@"Error while converting JSON:%@", [error localizedDescription]);
                     failure(error);
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                     failure([NSError errorWithDomain:@"ir.bina.koozeh-ios"
                                                 code:401
                                             userInfo:@{@"errorKey":@"Unauthorize"}]);
                 } else {
                     failure(error);
                 }
             }];
}

- (NSURLSessionDataTask *)updateUserFirstName:(NSString *)firstName
                                     lastName:(NSString *)lastName
                                        email:(NSString *)email
                          birthdateJalaliYear:(NSNumber *)birthdateJalaliYear
                         birthdateJalaliMonth:(NSNumber *)birthdateJalaliMonth
                           birthdateJalaliDay:(NSNumber *)birthdateJalaliDay
                                      success:(void (^)(UserResponse *response))success
                                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:firstName forKey:@"firstName"];
    [parameters setObject:lastName forKey:@"lastName"];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:birthdateJalaliYear forKey:@"birthdateJalaliYear"];
    [parameters setObject:birthdateJalaliMonth forKey:@"birthdateJalaliMonth"];
    [parameters setObject:birthdateJalaliDay forKey:@"birthdateJalaliDay"];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8;"
                  forHTTPHeaderField:@"Content-Type"];
    return [self POST:kGetPostUserPath
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSError *error;
                  UserResponse *userResponse = [MTLJSONAdapter modelOfClass:UserResponse.class fromJSONDictionary:responseObject error:&error];
                  if (error == nil) {
                      success(userResponse);
                  } else {
                      NSLog(@"Error while converting JSON:%@", [error localizedDescription]);
                      failure(error);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                      failure([NSError errorWithDomain:@"ir.bina.koozeh-ios"
                                                  code:401
                                              userInfo:@{@"errorKey":@"Unauthorize"}]);
                  } else {
                      failure(error);
                  }
              }];
}

+ (id)sharedInstance {
    static UserRestService *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}

@end
