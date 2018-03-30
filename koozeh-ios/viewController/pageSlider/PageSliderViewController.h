//
//  PageSliderViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/14/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBarViewController.h"
#import "Magazine.h"
#import "Issue.h"
#import "PageContentViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MaterialShowcase/MaterialShowcase-Swift.h>

@protocol PageSliderDelegate

- (void)goToPageWithNumber:(NSInteger)pageNumber;

@end

@interface PageSliderViewController : CustomNavigationBarViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageMediaDelegate, AVAudioPlayerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, PageSliderDelegate, MaterialShowcaseDelegate>

@property (weak, nonatomic) Magazine *magazine;
@property (strong, nonatomic) Issue *issue;
@property NSInteger issueVolume;
@property NSString *magazineName;
@property (weak, nonatomic)Page *pageToShow;
@property (weak, nonatomic) UIPageViewController *pageViewController;

@end
