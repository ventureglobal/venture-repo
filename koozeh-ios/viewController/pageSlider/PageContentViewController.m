//
//  PageContentViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "PageContentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SessionManager.h"
#import "LGPlusButtonsView.h"
#import "UIColor+ColorUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "UIFont+FontUtil.h"

@interface PageContentViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *pageImageScrollView;
@property (weak, nonatomic) IBOutlet UIProgressView *pageImageProgressView;
@property (weak, nonatomic) IBOutlet UILabel *pageImageProgressLabel;
@property (strong, nonatomic) LGPlusButtonsView *mediaOptionsButtonView;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageImageScrollView.minimumZoomScale=1;
    self.pageImageScrollView.maximumZoomScale=6.0;
    self.pageImageScrollView.contentSize=CGSizeMake(15027, 2048);
    self.pageImageScrollView.delegate=self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.page) {
        [self reloadPageImage];
        [self reloadPageMediaOptions];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

#pragma mark - Private Methods
- (void)reloadPageImage {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, self.page.imageUrl]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = ((float)receivedSize) / ((float) expectedSize);
            [self.pageImageProgressView setProgress:progress];
            [self.pageImageProgressView setHidden:NO];
            [self.pageImageProgressLabel setHidden:NO];
            self.pageImageProgressLabel.text = [NSString stringWithFormat:@"%ld%@", (long)(progress * 100), @"%"];
        });
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageImageProgressView setHidden:YES];
            [self.pageImageProgressLabel setHidden:YES];
            [self.pageImageView setImage:image];
        });
    }];
}

- (void)reloadPageMediaOptions {
    if (self.page.medias.count) {
        self.mediaOptionsButtonView =
        [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:(self.page.medias.count + 1)
                                      firstButtonIsPlusButton:YES
                                                showAfterInit:YES
                                                     delegate:self];
        
        [self.mediaOptionsButtonView setAppearingAnimationType:LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical];
        self.mediaOptionsButtonView.coverColor = [UIColor colorWithWhite:1.f alpha:0.7];
        self.mediaOptionsButtonView.position = LGPlusButtonsViewPositionBottomRight;
        self.mediaOptionsButtonView.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
        
        NSMutableArray *descriptions = [NSMutableArray arrayWithObject:@""];
        NSMutableArray *titles = [NSMutableArray arrayWithObject:@""];
        NSMutableArray *iconImages = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"fabIcon"]];
        NSMutableArray *colors = [NSMutableArray arrayWithObject:[UIColor mediaOptionButonColor]];
        for (int i = 1; i <= self.page.medias.count ; i++) {
            Media *media = [self.page.medias objectAtIndex:(i - 1)];
            [titles addObject:@""];
            [descriptions addObject:media.name];
            if ([@"AUDIO" isEqualToString:media.mediaType]) {
                [iconImages addObject:[UIImage imageNamed:@"iconSound"]];
                [colors addObject:[UIColor mediaSoundButtonColor]];
            } else if ([@"VIDEO" isEqualToString:media.mediaType]) {
                [iconImages addObject:[UIImage imageNamed:@"iconVideo"]];
                [colors addObject:[UIColor mediaVideoButtonColor]];
            }else if ([@"IMAGE" isEqualToString:media.mediaType]) {
                [iconImages addObject:[UIImage imageNamed:@"iconImage"]];
                [colors addObject:[UIColor mediaImageButtonColor]];
            }
            [self.mediaOptionsButtonView setButtonAtIndex:i offset:CGPointMake(-6.f, 0.f)
                                      forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
        }
        
        [self.mediaOptionsButtonView setAppearingAnimationType:LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical];
        [self.mediaOptionsButtonView setButtonsAdjustsImageWhenHighlighted:NO];

        [self.mediaOptionsButtonView setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [self.mediaOptionsButtonView setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [self.mediaOptionsButtonView setButtonsTitleFont:[UIFont mainBoldFontWithSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
        [self.mediaOptionsButtonView setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
        [self.mediaOptionsButtonView setButtonsLayerShadowOpacity:0.5];
        [self.mediaOptionsButtonView setButtonsLayerShadowRadius:3.f];
        [self.mediaOptionsButtonView setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
        
        [self.mediaOptionsButtonView setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
        [self.mediaOptionsButtonView setButtonAtIndex:0 layerCornerRadius:56.f/2.f
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
        [self.mediaOptionsButtonView setButtonAtIndex:0 titleFont:[UIFont mainBoldFontWithSize:40.f]
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
        [self.mediaOptionsButtonView setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
        
        
        [self.mediaOptionsButtonView setButtonsTitles:titles forState:UIControlStateNormal];
        [self.mediaOptionsButtonView setDescriptionsTexts:descriptions];
        [self.mediaOptionsButtonView setButtonsBackgroundColors:colors forState:UIControlStateNormal];
        [self.mediaOptionsButtonView setButtonsImages:iconImages
                                        forState:UIControlStateNormal
                                  forOrientation:LGPlusButtonsViewOrientationAll];
        
        [self.mediaOptionsButtonView setDescriptionsBackgroundColor:[UIColor whiteColor]];
        [self.mediaOptionsButtonView setDescriptionsTextColor:[UIColor blackColor]];
        [self.mediaOptionsButtonView setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
        [self.mediaOptionsButtonView setDescriptionsLayerShadowOpacity:0.25];
        [self.mediaOptionsButtonView setDescriptionsLayerShadowRadius:1.f];
        [self.mediaOptionsButtonView setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
        [self.mediaOptionsButtonView setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
        [self.mediaOptionsButtonView setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
        
//        for (NSUInteger i=1; i<=self.media; i++)
//            [mediaOptionsButtonView setButtonAtIndex:i offset:CGPointMake(-6.f, 0.f)
//                                      forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.mediaOptionsButtonView setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
            [self.mediaOptionsButtonView setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
        }
        
//        [self.navigationController.view addSubview:_plusButtonsViewMain];
        [self.view addSubview:self.mediaOptionsButtonView];
    }
}

#pragma mark - <LGPlusButtonsViewDelegate>

- (void)plusButtonsView:(LGPlusButtonsView *)plusButtonsView buttonPressedWithTitle:(NSString *)title description:(NSString *)description index:(NSUInteger)index {
    NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
    if (index > 0) {
        [self.mediaOptionsButtonView hideButtonsAnimated:YES completionHandler:^{
//            Media *selectedMedia = [self.page.medias objectAtIndex:index - 1];
//            if ([@"AUDIO" isEqualToString:selectedMedia.mediaType]) {
//                [self reloadAudioPlayerForMedia:selectedMedia];
//            } else {
                [self.pageMediaDelegate showMedia:[self.page.medias objectAtIndex:index - 1] forPage:self.page atIndex:self.pageIndex];
//            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.pageImageView;
}

@end
