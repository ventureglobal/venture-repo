//
//  PageResponse.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MediaResponse.h"

@interface PageResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic) long id;
@property (nonatomic) NSInteger pageNumber;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *thumbnailUrl;
@property (copy, nonatomic) NSArray<MediaResponse *> *medias;
@property (nonatomic) BOOL bookmarked;

@end
