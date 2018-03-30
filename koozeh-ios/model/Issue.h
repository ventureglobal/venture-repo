//
//  Issue.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "IssueResponse.h"
#import "Page.h"

@interface Issue : RLMObject

@property long id;
@property NSDate *date;
@property NSString *imageUrl;
@property NSString *thumbnailUrl;
@property RLMArray<Page *><Page> *pages;
@property int issueNumber;
@property long price;
@property BOOL free;
@property int pageCount;
@property NSString *issueDescription;
@property BOOL purchased;

- (instancetype)initWithDto:(IssueResponse *)response;

@end
RLM_ARRAY_TYPE(Issue)
