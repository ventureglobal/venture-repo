//
//  UserManager.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomMessageBarViewController.h"

@interface UserManager : NSObject

+ (instancetype)sharedInstance;

- (void)signInWithMobile:(NSString *)mobile
                 success:(void (^)(long deviceId))success
                 failure:(void (^)(NSError *error))failure
      messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

- (void)verifyMobileWithCode:(NSString *)verificationCode
                    deviceId:(long)deviceId
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure
      messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

@end
