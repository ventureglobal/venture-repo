//
//  CustomNavigationBarViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/14/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface CustomNavigationBarViewController : UIViewController <SlideNavigationControllerDelegate>

- (void)setDefaultNavigationTitle;

- (void)setTitleView:(UIView *) titleView;

@end
