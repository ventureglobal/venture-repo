//
//  MagazineManager.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/6/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "MagazineManager.h"
#import "MagazineRestService.h"

@implementation MagazineManager

+ (instancetype)sharedInstance {
    static MagazineManager *magazineManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        magazineManager = [[self alloc] init];
    });
    
    return magazineManager;
}

- (void)fetchPublicMagazines:(void (^)(NSArray<Magazine *> *magazines))success
                     failure:(void (^)(NSError *error))failure
          messageBarDelegate:(id<CustomMessageBarDelegate>) messageBarDalegate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            RLMResults *results = [Magazine allObjects];
            void (^successBlock)(NSArray<Magazine *> *);
            void (^failureBlock)(NSError *);
            if (results.count > 0) {
                successBlock = nil;
                failureBlock = nil;
                NSMutableArray<Magazine *> *magazines = [NSMutableArray array];
                for (Magazine *magazine in results) {
                    [magazines addObject:[[Magazine alloc] initWithValue:magazine]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [messageBarDalegate checkInternetConnection];
                    success(magazines);
                });
            } else {
                successBlock = ^(NSArray<Magazine *> *magazines) {
                    NSMutableArray<Magazine *> *magazinesResult = [NSMutableArray array];
                    for (Magazine *magazine in magazines) {
                        [magazinesResult addObject:[[Magazine alloc] initWithValue:magazine]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [messageBarDalegate hideInternetConnectionError];
                        success(magazinesResult);
                    });
                };
                failureBlock = ^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [messageBarDalegate checkInternetConnection];
                        failure(error);
                    });
                };
            }
            [self backgroundFetchAndUpdateMagazines:successBlock
                                            failure:failureBlock];
        }
    });
}

#pragma mark - Private Methods
- (void)backgroundFetchAndUpdateMagazines:(void (^)(NSArray<Magazine *> *magazines))success
                                  failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[MagazineRestService sharedInstance] getAllMagazines:^(NSArray<MagazineResponse *> *response) {
                NSMutableArray<Magazine *> *magazines = [NSMutableArray array];
                for (MagazineResponse *magazineResponse in response) {
                    [magazines addObject:[[Magazine alloc] initWithDto:magazineResponse]];
                }
                if (success != nil) {
                    success(magazines);
                }
                [self saveMagazines:magazines];
            } failure:^(NSError *error) {
                NSLog(@"Error while fetching magazines:%@", [error localizedDescription]);
                if ([AFURLResponseSerializationErrorDomain isEqual:error.domain]) {
                    NSLog(@"ErrorResponse:%@", [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseErrorKey]);
                    NSLog(@"ErrorData:%@", [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey]);
                }
                if (failure != nil) {
                    failure(error);
                }
            }];
        }
    });
}

- (void)saveMagazine:(Magazine *)magazine {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Magazine *foundMagazine = [Magazine objectForPrimaryKey:@(magazine.id)];
    if (foundMagazine != nil) {
        foundMagazine.name = magazine.name;
        foundMagazine.magazineDescription = magazine.magazineDescription;
        foundMagazine.imageUrl = magazine.imageUrl;
        foundMagazine.thumbnailUrl = magazine.thumbnailUrl;
    } else {
        [realm addObject:magazine];
    }
    [realm commitWriteTransaction];
}

- (void)saveMagazines:(NSArray<Magazine *> *)magazines {
    for (Magazine *magazine in magazines) {
        [self saveMagazine:magazine];
    }
}

@end
