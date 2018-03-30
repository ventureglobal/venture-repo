//
//  PageManager.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/5/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Issue.h"
#import "Page.h"
#import "PageRestService.h"
#import "CustomMessageBarViewController.h"

@interface PageManager : NSObject

+ (instancetype)sharedInstance;

- (void)fetchPagesWithIssue:(Issue *)issue
                    success:(void (^)(NSArray<Page *> *))success
                    failure:(void (^)(NSError *))failure
         messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

@end
