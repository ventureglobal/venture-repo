//
//  PingManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "PingManager.h"
#import "PingRestService.h"

@implementation PingManager

+ (instancetype)sharedInstance {
    static PingManager *pingManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pingManager = [[self alloc] init];
    });
    
    return pingManager;
}

- (void)pingTestSuccess:(void (^)(NSString *response))success
                failure:(void (^)(NSError *error))failure {
    [((PingRestService *)[PingRestService sharedInstance]) pingTestSuccess:^(NSString *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(response);
        });
    } failure:^(NSError *error) {
        NSLog(@"Error while testing ping:%@", [error localizedDescription]);
        NSLog(@"Error domain:%@ code:%ld keys:%@", error.domain, (long)error.code, [error.userInfo allKeys]);
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

@end
