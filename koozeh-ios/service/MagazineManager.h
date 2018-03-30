//
//  MagazineManager.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/6/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Magazine.h"
#import "CustomMessageBarViewController.h"

@interface MagazineManager : NSObject

+ (instancetype)sharedInstance;

- (void)fetchPublicMagazines:(void (^)(NSArray<Magazine *> *magazines))success
                     failure:(void (^)(NSError *error))failure
          messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

@end
