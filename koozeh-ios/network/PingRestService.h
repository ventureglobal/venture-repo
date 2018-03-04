//
//  PingRestService.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionManager.h"

@interface PingRestService : SessionManager

- (NSURLSessionDataTask *)pingTestSuccess:(void (^)(NSString *response))success failure:(void (^)(NSError *error))failure;

@end
