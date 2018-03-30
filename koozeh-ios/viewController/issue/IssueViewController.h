//
//  IssueViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/27/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Magazine.h"
#import "Issue.h"
#import "CustomNavigationBarViewController.h"

@interface IssueViewController : CustomNavigationBarViewController

@property (weak, nonatomic) Magazine *magazine;
@property (weak, nonatomic) Issue *issue;

@end
