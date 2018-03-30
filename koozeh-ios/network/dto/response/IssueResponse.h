//
//  Issue.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IssueResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic) long id;
@property (copy, nonatomic) NSDate *date;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy,nonatomic) NSString *thumbnailUrl;
@property (nonatomic) int issueNumber;
@property (nonatomic) long price;
@property (nonatomic) BOOL free;
@property (nonatomic) int pageCount;
@property (copy,nonatomic) NSString *issueDescription;
@property (nonatomic) BOOL purchased;


@end
