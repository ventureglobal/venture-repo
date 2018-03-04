//
//  VerifyDeviceResponse.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface VerifyDeviceResponse : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *token;

@end
