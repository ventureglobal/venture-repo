//
//  SignInResponse.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface SignInResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic) long deviceId;

@end
