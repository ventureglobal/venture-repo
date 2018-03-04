//
//  PingRestService.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "PingRestService.h"

static NSString *const kPublicPingPath = kContextUrl @"public/ping";

@implementation PingRestService

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    if(!self) return nil;
    
    self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (NSURLSessionDataTask *)pingTestSuccess:(void (^)(NSString *response))success failure:(void (^)(NSError *error))failure {
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return [self GET:kPublicPingPath
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"Ping test response:%@", responseObject);
                 success(responseObject);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 failure(error);
             }];
}

+ (id)sharedInstance {
    static PingRestService *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}

@end
