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

+ (id)sharedInstance {
    static SessionManager *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}

@end
