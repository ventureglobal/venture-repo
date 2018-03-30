//
//  MagazineResponse.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MagazineResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic) long id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *magazineDescription;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *thumbnailUrl;

@end
