//
//  MediaResponse.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface MediaResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic) long id;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *mediaType;
@property (copy, nonatomic) NSString *name;

@end
