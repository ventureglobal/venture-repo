//
//  SessionManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

- (id)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    if(!self) return nil;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey: @"userToken"];
    if (token != nil) {
        [super.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    return super.requestSerializer;
}

+ (id)sharedInstance {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
