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

@property (nonatomic) long identity;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *mediaType;
@property (strong, nonatomic) NSString *name;

@end
