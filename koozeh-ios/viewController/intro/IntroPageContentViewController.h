//
//  IntroPageContentViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/6/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IntroPageContentProtocol

-(void)pageChangedToIndex:(NSUInteger)currentPageIndex;

@end
@interface IntroPageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *imageFile;
@property id<IntroPageContentProtocol> pageInteractionController;

@end
