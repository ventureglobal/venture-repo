//
//  Issue.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"
#import "IssueResponse.h"

@interface Issue : RLMObject

@property long identity;
@property NSDate *date;
@property NSString *imageUrl;
@property NSString *thumbnailUrl;
@property BOOL isOffline;

- (instancetype)initWithDto:(IssueResponse *)response;

@end
