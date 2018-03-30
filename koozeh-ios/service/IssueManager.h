//
//  IssueManager.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Issue.h"
#import "Page.h"
#import "CustomMessageBarViewController.h"
#import "Magazine.h"

@interface IssueManager : NSObject

+ (instancetype)sharedInstance;

- (void)fetchPublicDefaultIssues:(void (^)(NSArray<Issue *> *issues))success
                         failure:(void (^)(NSError *error))failure
              messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

- (void)fetchIssuesWithMagazine:(Magazine *)magazine
                        success:(void (^)(NSArray<Issue *> *issues))success
                        failure:(void (^)(NSError *error))failure
             messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate;

@end
