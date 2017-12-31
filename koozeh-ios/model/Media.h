//
//  Media.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Realm/Realm.h>
#import "MediaResponse.h"

@interface Media : RLMObject

@property long identity;
@property NSString *url;
@property NSString *mediaType;
@property NSString *name;

- (instancetype)initWithDto:(MediaResponse *)response;

@end
