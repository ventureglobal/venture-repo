//
//  MagazineRestService.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/6/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "SessionManager.h"
#import "MagazineResponse.h"

@interface MagazineRestService : SessionManager

- (NSURLSessionDataTask *)getAllMagazines:(void (^)(NSArray<MagazineResponse *> *response))success failure:(void (^)(NSError *error))failure;

@end
