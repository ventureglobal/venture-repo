//
//  PageSliderViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/14/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "PageSliderViewController.h"
#import "MessageUtil.h"
#import "IssueManager.h"
#import "PageManager.h"
#import "UIColor+ColorUtil.h"
#import "Page.h"
#import "PageContentViewController.h"
#import "UIFont+FontUtil.h"
#import "MediaViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SessionManager.h"
#import "UIViewUtil.h"
#import "LoginViewController.h"
#import "BookmarkManager.h"
#import "PageThumbnailsViewController.h"
#import <MaterialShowcase/MaterialShowcase-Swift.h>

@interface PageSliderViewController ()

@property (weak, nonatomic) IBOutlet UIView *audioPlayerContainerView;
@property (weak, nonatomic) IBOutlet UISlider *audioPlayerSeeker;
@property (weak, nonatomic) IBOutlet UIButton *playActionButton;
@property (strong, nonatomic) AVAudioPlayer *avAudioPlayer;
@property (strong, nonatomic) NSTimer *seekerTimer;

@property (strong, nonatomic) NSArray *pages;
@property (weak, nonatomic) Page *selectedMediaPage;
@property (nonatomic) NSUInteger selectedMediaPageIndex;
@property (nonatomic) Media *selectedMedia;
@property (nonatomic) BOOL fullLoaded;
@property (strong, nonatomic) UIBarButtonItem *bookmarkButtonItem;
@property (strong, nonatomic) UIBarButtonItem *thumbnailButtonItem;
@property (nonatomic, assign) BOOL isPresenting;

@property (strong, nonatomic) UIView *pageSliderShowcaseView;

@end

@implementation PageSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fullLoaded = NO;
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.thumbnailButtonItem.tintColor = [UIColor navBarItemDefaultColor];
    self.bookmarkButtonItem.tintColor = [UIColor navBarItemDefaultColor];
    self.navigationItem.leftBarButtonItems = @[self.thumbnailButtonItem, self.bookmarkButtonItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL pageSliderGeneralShowcaseViewed = [userDefaults boolForKey:@"pageSliderGeneralShowcaseViewed"];
    if (!pageSliderGeneralShowcaseViewed) {
    [UIView transitionWithView:self.navigationController.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                    animations:^ { [self.navigationController.view addSubview:self.pageSliderShowcaseView]; }
                    completion:nil];
    
        [userDefaults setBool:YES forKey:@"pageSliderGeneralShowcaseViewed"];
        [userDefaults synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.issue != nil && self.issueVolume >= 0) {
        NSString *titleString;
        if (self.magazineName) {
            titleString = [NSString stringWithFormat:@"%@ - %@ %lu"
                           , self.magazineName
                           , [MessageUtil messageForKey:@"volume"]
                           , self.issueVolume];
        } else {
            titleString = [NSString stringWithFormat:@"%@ - %@ %lu"
                           , [MessageUtil messageForKey:@"defaultMagazineName"]
                           , [MessageUtil messageForKey:@"volume"]
                           , self.issueVolume];
        }
        UIFont *font = [UIFont mainBoldFontWithSize:16];
        CGSize labelSize = [UIFont labelSizeForString:titleString font:font];
        UILabel *issueVolumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelSize.height, labelSize.width)];
        issueVolumeLabel.text = titleString;
        issueVolumeLabel.font = font;
        issueVolumeLabel.numberOfLines = 1;
        issueVolumeLabel.textColor = [UIColor navBarTintColor];
        issueVolumeLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleView:issueVolumeLabel];
        [self reloadPages];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.seekerTimer invalidate];
    [self.avAudioPlayer pause];
    [self.playActionButton setImage:[UIImage imageNamed:@"pausePlayer"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setters

- (UIView *)pageSliderShowcaseView {
    if (!_pageSliderShowcaseView) {
        _pageSliderShowcaseView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        _pageSliderShowcaseView.backgroundColor = [UIColor showcaseBackgroundColor];
        UIImage *pagingImage = [UIImage imageNamed:@"pagingHorizontal"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 70.0) / 2.0, (self.view.frame.size.height / 2.0) - 190.0, 70.0, 70.0)];
        [imageView setImage:pagingImage];
        [_pageSliderShowcaseView addSubview:imageView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height / 2.0) - 90, self.view.frame.size.width, 30.0)];
        titleLabel.text = [MessageUtil messageForKey:@"pageSliderShowcaseSlideTitle"];
        titleLabel.textColor = [UIColor showcaseTitleColor];
        titleLabel.font = [UIFont shabnamWithSize:18.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_pageSliderShowcaseView addSubview:titleLabel];
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, (self.view.frame.size.height - 120.0) / 2.0, self.view.frame.size.width - 100.0, 120.0)];
        messageLabel.text = [MessageUtil messageForKey:@"pageSliderShowcaseSlideMessage"];
        messageLabel.textColor = [UIColor showcaseMessageColor];
        messageLabel.numberOfLines = 4;
        messageLabel.font = [UIFont shabnamWithSize:16.0];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [_pageSliderShowcaseView addSubview:messageLabel];
        [_pageSliderShowcaseView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePageSliderShowcaseView)];
        [_pageSliderShowcaseView addGestureRecognizer:tapGestureRecognizer];
    }
    return _pageSliderShowcaseView;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    }
    return _pageViewController;
}

- (void)setIssue:(Issue *)issue {
    if ((_issue && _issue.id != issue.id) || !_issue) {
        self.fullLoaded = NO;
    }
    _issue = issue;
}

- (UIBarButtonItem *)bookmarkButtonItem {
    if (!_bookmarkButtonItem) {
        _bookmarkButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmarkIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmarkCurrentPageActionMethod)];
        self.bookmarkButtonItem.tintColor = [UIColor navBarItemDefaultColor];
    }
    return _bookmarkButtonItem;
}

- (UIBarButtonItem *)thumbnailButtonItem {
    if (!_thumbnailButtonItem) {
        _thumbnailButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumbnailIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showThumbnails)];
    }
    return _thumbnailButtonItem;
}

#pragma mark - Private Methods

- (void)removePageSliderShowcaseView {
    [self.pageSliderShowcaseView removeFromSuperview];
    self.pageSliderShowcaseView = nil;
    [self showShowcaseWithTitle:[MessageUtil messageForKey:@"pageSliderShowcaseBookmarkTitle"] withMessage:[MessageUtil messageForKey:@"pageSliderShowcaseBookmarkMessage"] withBarButtonItem:self.bookmarkButtonItem];
}

- (void)showShowcaseWithTitle:(NSString *)title
                  withMessage:(NSString *)message
            withBarButtonItem:(UIBarButtonItem *)barButtonItem {
    MaterialShowcase *showcase = [UIViewUtil showcaseWithTitle:title
                                                   withMessage:message
                                             withBarButtonItem:barButtonItem];
    showcase.delegate = self;
    [showcase showWithAnimated:YES completion:nil];
}

- (void)reloadPages {
    if (!self.fullLoaded) {
        [self.pageViewController.view setHidden:YES];
        [self showOverlayActivityIndicator];
        [[PageManager sharedInstance]
         fetchPagesWithIssue:self.issue
         success:^(NSArray<Page*> *pages) {
             self.pages = pages;
             for (Page *page in pages) {
                 NSLog(@"GotPagewithId:%ld pageNumber:%ld url:%@", page.id, page.pageNumber, page.imageUrl);
             }
             self.pageViewController.delegate = self;
             self.pageViewController.dataSource = self;
             PageContentViewController *pageContentViewController = [self viewControllerAtIndex:0];
             
             NSArray *viewControllers = @[pageContentViewController];
             [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
             
             // Change the size of page view controller
             self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
             
             [self addChildViewController:self.pageViewController];
             [self.pageViewController.view setHidden:NO];
             [self hideOverlayActivityIndicator];
             [self.view addSubview:self.pageViewController.view];
             [self.view sendSubviewToBack:self.pageViewController.view];
             [self.pageViewController didMoveToParentViewController:self];
             [self setBookmarkForPage:self.pages[0]];
             self.fullLoaded = YES;
             if (self.pageToShow != nil) {
                 [self goToPageWithNumber:self.pageToShow.pageNumber - 1];
                 self.pageToShow = nil;
             }
        } failure:^(NSError *error) {
            NSLog(@"Error whild using issue manager:%@", [error localizedDescription]);
            [UIViewUtil showUIAlertError:error fromController:self];
        } messageBarDelegate:self];
    }
}

- (void)reloadAudioPlayerForMedia:(Media *)selectedMedia {
    
    NSString* resourcePath = [NSString stringWithFormat:@"%@%@", kBaseStorageURL, selectedMedia.url]; //your url
    NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:resourcePath]];
    NSError *error;
    
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
    [self.avAudioPlayer setDelegate:self];
    self.avAudioPlayer.numberOfLoops = 0;
    self.avAudioPlayer.volume = 1.0f;
    [self.avAudioPlayer prepareToPlay];
    self.audioPlayerSeeker.maximumValue = self.avAudioPlayer.duration;
    // Set the valueChanged target
    [self.audioPlayerSeeker addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Set a timer which keep getting the current music time and update the UISlider in 1 sec interval
    self.seekerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSeeker) userInfo:nil repeats:YES];
    
    
    if (self.avAudioPlayer == nil)
        NSLog(@"%@", [error description]);
    else
        [self.avAudioPlayer play];
    
    [self.audioPlayerContainerView setHidden:NO];
    [self.view bringSubviewToFront:self.audioPlayerContainerView];
}

- (void)updateSeeker {
    self.audioPlayerSeeker.value = self.avAudioPlayer.currentTime;
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pages count] == 0) || (index >= [self.pages count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.page = [self.pages objectAtIndex:index];
    pageContentViewController.pageIndex = index;
    pageContentViewController.pageMediaDelegate = self;
    pageContentViewController.messageBarDelegate = self;
    return pageContentViewController;
}

- (void)setBookmarkForPage:(Page *)page {
    if (page.bookmarked) {
        [self.bookmarkButtonItem setImage:[UIImage imageNamed:@"bookmarkIconFill"]];
        self.bookmarkButtonItem.tintColor = [UIColor navBarItemActiveColor];
    } else {
        [self.bookmarkButtonItem setImage:[UIImage imageNamed:@"bookmarkIcon"]];
        self.bookmarkButtonItem.tintColor = [UIColor navBarItemDefaultColor];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"showMedia" isEqualToString:segue.identifier]) {
        MediaViewController *mediaViewController = segue.destinationViewController;
        mediaViewController.media = self.selectedMedia;
    }
}

#pragma mark - <MaterialShowcaseDelegate>
- (void)showCaseDidDismissWithShowcase:(MaterialShowcase *)showcase {
    if ([[MessageUtil messageForKey:@"pageSliderShowcaseBookmarkTitle"] isEqualToString:showcase.primaryText]) {
        [self showShowcaseWithTitle:[MessageUtil messageForKey:@"pageSliderShowcaseThumbnailTitle"] withMessage:[MessageUtil messageForKey:@"pageSliderShowcaseThumbnailMessage"] withBarButtonItem:self.thumbnailButtonItem];
    }
}

#pragma mark - <UIPageViewControllerDataSource>
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark - <UIPageViewControllerDelegate>
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];

        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    PageContentViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = currentViewController.pageIndex;
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
    } else {
        UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];

    return UIPageViewControllerSpineLocationMin;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    PageContentViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    [self setBookmarkForPage:currentViewController.page];
}

#pragma mark - <UIViewControllerTransitionDelegate>
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    //I will fix it later.
    //    AnimatedTransitioning *controller = [[AnimatedTransitioning alloc]init];
    //    controller.isPresenting = NO;
    //    return controller;
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *inView = [transitionContext containerView];
    
    PageThumbnailsViewController *toVC = (PageThumbnailsViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PageSliderViewController *fromVC = (PageSliderViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [inView addSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [toVC.view setFrame:CGRectMake(0, screenRect.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}


#pragma mark - PageMediaDelegate
- (void) showMedia:(Media *)media forPage:(Page *)page atIndex:(NSUInteger)index {
    self.selectedMedia = media;
    self.selectedMediaPage = page;
    self.selectedMediaPageIndex = index;
    if ([@"VIDEO" isEqualToString:media.mediaType] || [@"Image" isEqualToString:media.mediaType]) {
        [self performSegueWithIdentifier:@"showMedia" sender:self];
    } else if ([@"AUDIO" isEqualToString:media.mediaType]) {
        [self reloadAudioPlayerForMedia:media];
    }
}

#pragma mark - <AVAudioPlayerDelegate>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self.seekerTimer invalidate];
        [self.audioPlayerContainerView setHidden:YES];
    }
}

#pragma mark - <PageSliderDelegate>
- (void)goToPageWithNumber:(NSInteger)pageNumber {
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    if (self.pageViewController.viewControllers != nil && self.pageViewController.viewControllers.count) {
        PageContentViewController *currentViewController = self.pageViewController.viewControllers[0];
        if (currentViewController.pageIndex > pageNumber) {
            direction = UIPageViewControllerNavigationDirectionForward;
        } else {
            direction = UIPageViewControllerNavigationDirectionReverse;
        }
    }
    PageContentViewController *viewControllerToShow = [self viewControllerAtIndex:pageNumber];
    NSArray<UIViewController *> *viewControllers = @[viewControllerToShow];
    [self.pageViewController setViewControllers:viewControllers direction:direction animated:YES completion:nil];
    [self setBookmarkForPage:viewControllerToShow.page];
}

#pragma mark - Action Methods

- (void)showThumbnails {
    PageThumbnailsViewController *thumbnails = [self.storyboard instantiateViewControllerWithIdentifier:@"PageThumbnailsViewController"];
    thumbnails.pages = self.pages;
    thumbnails.modalPresentationStyle = UIModalPresentationCustom;
    thumbnails.transitioningDelegate = self;
    thumbnails.pageSliderDelegate = self;
    [self presentViewController:thumbnails animated:NO completion:nil];
}

- (void)bookmarkCurrentPageActionMethod {
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"userToken"] == nil) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[LoginViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    } else {
        PageContentViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        if (currentViewController.page.bookmarked) {
            [[BookmarkManager sharedInstance] removeBookmarkWithPageId:currentViewController.page.id
                                                               issueId:self.issue.id
                                                            magazineId:self.magazine.id
                                                               success:^{
                                                                   ((Page *)self.pages[currentViewController.pageIndex]).bookmarked = NO;
                                                                   currentViewController.page.bookmarked = NO;
                                                                   [self setBookmarkForPage:currentViewController.page];
                                                               }
                                                               failure:^(NSError *error) {
                                                                   if (error.userInfo != nil && [@"Unauthorize" isEqualToString:error.userInfo[@"errorKey"]]) {
                                                                       [UIViewUtil showUIAlertError:error
                                                                                     fromController:self
                                                                                               onOk:^{
                                                                                                   for (UIViewController *viewController in self.navigationController.viewControllers) {
                                                                                                       if ([viewController isKindOfClass:[LoginViewController class]]) {
                                                                                                           [self.navigationController popToViewController:viewController animated:YES];
                                                                                                           return;
                                                                                                       }
                                                                                                   }
                                                                                               } onCancel:^{
                                                                                                   //Do nothing
                                                                                               }];
                                                                   }
                                                               }
                                                    messageBarDelegate:self];
        } else {
            [[BookmarkManager sharedInstance] bookmarkPageWithId:currentViewController.page.id
                                                         issueId:self.issue.id
                                                      magazineId:self.magazine.id
                                                         success:^{
                                                             ((Page *)self.pages[currentViewController.pageIndex]).bookmarked = YES;
                                                             currentViewController.page.bookmarked = YES;
                                                             [self setBookmarkForPage:currentViewController.page];
                                                         }
                                                         failure:^(NSError *error) {
                                                             if (error.userInfo != nil && [@"Unauthorize" isEqualToString:error.userInfo[@"errorKey"]]) {
                                                                 [UIViewUtil showUIAlertError:error
                                                                               fromController:self
                                                                                         onOk:^{
                                                                                             for (UIViewController *viewController in self.navigationController.viewControllers) {
                                                                                                 if ([viewController isKindOfClass:[LoginViewController class]]) {
                                                                                                     [self.navigationController popToViewController:viewController animated:YES];
                                                                                                     return;
                                                                                                 }
                                                                                             }
                                                                                             [self performSegueWithIdentifier:@"showLogin" sender:nil];
                                                                                         } onCancel:^{
                                                                                             //Do nothing
                                                                                         }];
                                                             }
                                                         }
                                              messageBarDelegate:self];
        }
    }
}

- (IBAction)playActionMethod:(id)sender {
    if (self.avAudioPlayer) {
        if ([self.avAudioPlayer isPlaying]) {
            [self.seekerTimer invalidate];
            UIImage *pauseButtonImage = [UIImage imageNamed:@"play"];
            [self.playActionButton setImage:pauseButtonImage forState:UIControlStateNormal];
            [self.avAudioPlayer pause];
        } else {
            self.seekerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSeeker) userInfo:nil repeats:YES];
            UIImage *playButtonImage = [UIImage imageNamed:@"pausePlayer"];
            [self.playActionButton setImage:playButtonImage forState:UIControlStateNormal];
            [self.avAudioPlayer play];
        }
    }
}

- (IBAction)closePlayerActionMethod:(id)sender {
    [self.audioPlayerContainerView setHidden:YES];
    [self.avAudioPlayer stop];
    [self.seekerTimer invalidate];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    // Fast skip the music when user scroll the UISlider
    [self.avAudioPlayer stop];
    [self.avAudioPlayer setCurrentTime:self.audioPlayerSeeker.value];
    [self.avAudioPlayer prepareToPlay];
    [self.avAudioPlayer play];
}

@end
