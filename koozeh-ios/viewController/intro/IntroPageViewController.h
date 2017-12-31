//
//  IntroPageViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/7/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroPageContentViewController.h"
#import "RootViewController.h"

@interface IntroPageViewController : UIViewController <UIPageViewControllerDataSource, IntroPageContentProtocol>

@property (weak, nonatomic) RootViewController *rootViewController;
@property (weak, nonatomic) UIPageViewController *pageViewController;

@end
