//
//  SessionManager.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
//#define kContextUrl @"koozeh-replicate-2/"
//#define kContextUrl @"koozeh-test/"
#define kContextUrl @"koozeh/"

//static NSString *const kBaseURL = @"http://212.32.237.113:8080";
//static NSString *const kBaseStorageURL = @"http://212.32.237.113/";
static NSString *const kBaseURL = @"http://localhost:9090";
static NSString *const kBaseStorageURL = @"http://localhost:9090/";

@interface SessionManager : AFHTTPSessionManager

+ (id)sharedInstance;

@end
