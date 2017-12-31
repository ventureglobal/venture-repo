//
//  MessageUtil.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/6/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "MessageUtil.h"

@interface MessageUtil ()

@property (strong, nonatomic) NSDictionary *mainDictionary;

@end
@implementation MessageUtil

-(instancetype)init {
    self = [super init];
    if (self) {
        self.mainDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Messages" ofType:@"plist"]];
    }
    return self;
}

+ (MessageUtil *)sharedInstance
{
    static MessageUtil *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[MessageUtil alloc] init];
    });
    
    return sharedInstance;
}

+ (NSString *)messageForKey:(NSString *) key {
    return [[MessageUtil sharedInstance].mainDictionary objectForKey:key];
}

+ (NSArray<NSString *> *)messagesForKey:(NSString *) key {
    return [[MessageUtil sharedInstance].mainDictionary objectForKey:key];
}

@end
