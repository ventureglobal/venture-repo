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

@property (nonatomic) long identity;
@property (nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *thumbnailUrl;
@property (strong, nonatomic) NSArray<MediaResponse *> *medias;

@end
