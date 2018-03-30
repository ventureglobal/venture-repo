//
//  BookmarkRestService.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/17/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "BookmarkRestService.h"

static NSString *const kBookmarkPath = kContextUrl @"bookmark/add";
static NSString *const kBookmarkRemovePath = kContextUrl @"bookmark/remove";
static NSString *const kBookmarkGetAllPath = kContextUrl @"bookmark/getAll";

@implementation BookmarkRestService

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    if(!self) return nil;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    return self;
}

+ (id)sharedInstance {
    static BookmarkRestService *_sessionManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[self alloc] init];
    });
    
    return _sessionManager;
}

- (NSURLSessionDataTask *)bookmarkPageWithId:(long)pageId
                                     success:(void (^)(BookmarkResponse *response))success
                                     failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(pageId) forKey:@"pageId"];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8"
                  forHTTPHeaderField:@"Content-Type"];
    return [self POST:kBookmarkPath
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSError *error;
                  BookmarkResponse *bookmarkResponse = [MTLJSONAdapter modelOfClass:BookmarkResponse.class
                                                                         fromJSONDictionary:responseObject
                                                                                      error:&error];
                  if (error != nil) {
                      failure(error);
                  } else {
                      success(bookmarkResponse);
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                      failure([NSError errorWithDomain:@"ir.bina.koozeh-ios"
                                                  code:401
                                              userInfo:@{@"errorKey":@"Unauthorize"}]);
                  } else {
                      failure(error);
                  }
              }];
}

- (NSURLSessionDataTask *)removeBookmarkWithPageId:(long)pageId
                                           success:(void (^)(void))success
                                           failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@(pageId) forKey:@"pageId"];
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8"
                  forHTTPHeaderField:@"Content-Type"];
    return [self POST:kBookmarkRemovePath
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  success();
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                      failure([NSError errorWithDomain:@"ir.bina.koozeh-ios"
                                                  code:401
                                              userInfo:@{@"errorKey":@"Unauthorize"}]);
                  } else {
                      failure(error);
                  }
              }];
}

- (NSURLSessionDataTask *)getAllBookmarks:(void (^)(NSArray<BookmarkResponse *> *))success
                                  failure:(void (^)(NSError *))failure {
    return [self GET:kBookmarkGetAllPath
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSArray *responseArray = (NSArray *)responseObject;
                 NSError *error;
                 NSArray<BookmarkResponse *> *list = [MTLJSONAdapter modelsOfClass:BookmarkResponse.class fromJSONArray:responseArray error:&error];
                 if (error == nil) {
                     success(list);
                 } else {
                     NSLog(@"Error while converting JSON:%@", [error localizedDescription]);
                     failure(error);
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if ([task.response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)task.response).statusCode == 401) {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                     failure([NSError errorWithDomain:@"ir.bina.koozeh-ios"
                                                 code:401
                                             userInfo:@{@"errorKey":@"Unauthorize"}]);
                 } else {
                     failure(error);
                 }
             }];
}

@end
