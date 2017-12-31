//
//  PageSliderViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/14/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBarViewController.h"
#import "Issue.h"
#import "PageContentViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PageSliderViewController : CustomNavigationBarViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageMediaDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) Issue *issue;
@property NSInteger issueVolume;
@property NSString *magazineName;
@property (weak, nonatomic) UIPageViewController *pageViewController;

@end
