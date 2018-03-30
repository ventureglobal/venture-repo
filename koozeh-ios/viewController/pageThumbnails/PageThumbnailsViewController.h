//
//  PageThumbnailsViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/26/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Page.h"
#import "PageSliderViewController.h"

@interface PageThumbnailsViewController : UICollectionViewController

@property (weak, nonatomic) NSArray<Page *> *pages;
@property (weak, nonatomic) id<PageSliderDelegate> pageSliderDelegate;

@end
