//
//  MainViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBarViewController.h"
#import "Magazine.h"

@interface IssuesViewController : CustomNavigationBarViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) Magazine *magazine;

@end
