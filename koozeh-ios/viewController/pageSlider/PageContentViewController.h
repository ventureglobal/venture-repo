//
//  PageContentViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"
#import "Media.h"
#import <LGPlusButton.h>
#import <AVFoundation/AVFoundation.h>

@protocol PageMediaDelegate <NSObject>

- (void)showMedia:(Media *)media forPage:(Page *)page atIndex:(NSUInteger)index;

@end
@interface PageContentViewController : UIViewController <UIScrollViewDelegate, LGPlusButtonsViewDelegate, AVAudioPlayerDelegate>

@property (nonatomic) NSUInteger pageIndex;
@property (weak, nonatomic) Page *page;
@property (weak, nonatomic) id<PageMediaDelegate> pageMediaDelegate;

@end
