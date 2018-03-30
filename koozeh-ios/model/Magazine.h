//
//  Magazine.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Realm/Realm.h>
#import "Issue.h"
#import "MagazineResponse.h"

@interface Magazine : RLMObject

@property long id;
@property NSString *name;
@property NSString *magazineDescription;
@property NSString *imageUrl;
@property NSString *thumbnailUrl;
@property RLMArray<Issue *><Issue> *issues;

- (instancetype)initWithDto:(MagazineResponse *)magazineResponse;

@end
