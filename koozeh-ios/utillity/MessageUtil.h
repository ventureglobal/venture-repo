//
//  MessageUtil.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/6/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageUtil : NSObject

+ (NSString *)messageForKey:(NSString *) key;
+ (NSArray<NSString *> *)messagesForKey:(NSString *) key;

@end
