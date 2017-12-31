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
#import "UIColor+ColorUtil.h"
#import "Page.h"
#import "PageContentViewController.h"
#import "UIFont+FontUtil.h"
#import "MediaViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SessionManager.h"

@interface PageSliderViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

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

@end

@implementation PageSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fullLoaded = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.issue != nil && self.issueVolume != 0) {
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

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    }
    return _pageViewController;
}

- (void)setIssue:(Issue *)issue {
    if ((_issue && _issue.identity != issue.identity) || !_issue) {
        self.fullLoaded = NO;
    }
    _issue = issue;
}

#pragma mark - Private Methods

- (void)reloadPages {
    if (!self.fullLoaded) {
        [self.pageViewController.view setHidden:YES];
        [self.loadingActivityIndicator setHidden:NO];
        [self.view bringSubviewToFront:self.loadingActivityIndicator];
        [[IssueManager sharedInstance] fetchPublicPagesForIssue:self.issue success:^(NSArray *pages) {
            self.pages = pages;
            for (Page *page in pages) {
                NSLog(@"GotPagewithId:%ld pageNumber:%ld url:%@", page.identity, page.pageNumber, page.imageUrl);
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
            [self.loadingActivityIndicator setHidden:YES];
            [self.view addSubview:self.pageViewController.view];
            [self.view sendSubviewToBack:self.pageViewController.view];
            [self.pageViewController didMoveToParentViewController:self];
            self.fullLoaded = YES;
        } failure:^(NSError *error) {
            NSLog(@"Error whild using issue manager:%@", [error localizedDescription]);
        }];
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
    return pageContentViewController;
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

#pragma mark - Action Methods

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
