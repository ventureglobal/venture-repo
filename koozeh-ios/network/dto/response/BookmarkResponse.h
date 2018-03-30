//
//  BookmarkResponse.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MagazineResponse.h"
#import "IssueResponse.h"
#import "PageResponse.h"

@interface BookmarkResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic) long id;
@property (copy, nonatomic) MagazineResponse *magazine;
@property (copy, nonatomic) IssueResponse *issue;
@property (copy, nonatomic) PageResponse *page;

@end
