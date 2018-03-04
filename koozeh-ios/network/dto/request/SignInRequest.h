//
//  SignInRequest.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/4/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface SignInRequest : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *deviceInfo;

@end
