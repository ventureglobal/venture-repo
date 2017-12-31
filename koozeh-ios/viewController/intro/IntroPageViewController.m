//
//  IntroPageViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/7/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "IntroPageViewController.h"
#import "IntroPageContentViewController.h"
#import "MessageUtil.h"
#import "RootViewController.h"

@interface IntroPageViewController ()

@property (strong, nonatomic) NSArray<NSString *> *introImages;
@property (weak, nonatomic) IBOutlet UIPageControl *introPageControl;
@property (weak, nonatomic) IBOutlet UIButton *startAppButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;

@end

@implementation IntroPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.introImages = [MessageUtil messagesForKey:@"introImageFiles"];
    [self.introPageControl setNumberOfPages:[self.introImages count]];
    //        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
    self.pageViewController.dataSource = self;
    
    IntroPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view sendSubviewToBack:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"IntroSegueIdentifier" isEqualToString:segue.identifier]) {
        UIPageViewController *pageViewController = segue.destinationViewController;
        pageViewController.dataSource = self;
    }
}

#pragma mark - <UIPageViewControllerDataSource>
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((IntroPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((IntroPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.introImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.introImages.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - <IntroPageContentProtocol>
- (void)pageChangedToIndex:(NSUInteger)currentPageIndex {
    [self.introPageControl setCurrentPage:currentPageIndex];
    if (currentPageIndex == self.introImages.count - 1) {
        [self.startAppButton setHidden:YES];
        [self.nextPageButton setTitle:[MessageUtil messageForKey:@"startApp"] forState:UIControlStateNormal];
    } else {
        [self.startAppButton setHidden:NO];
        [self.nextPageButton setTitle:[MessageUtil messageForKey:@"next"] forState:UIControlStateNormal];
    }
}

#pragma mark - Private methods
- (IntroPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.introImages count] == 0) || (index >= [self.introImages count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    IntroPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageContentViewController"];
    pageContentViewController.imageFile = [self.introImages objectAtIndex:index];
    pageContentViewController.pageIndex = index;
    pageContentViewController.pageInteractionController = self;
    return pageContentViewController;
}

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    NSUInteger pageIndex = ((IntroPageContentViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).pageIndex;
    if (direction == UIPageViewControllerNavigationDirectionForward){
        pageIndex++;
    }else {
        pageIndex--;
    }
    IntroPageContentViewController *viewController = [self  viewControllerAtIndex:pageIndex];
    if (viewController == nil) {
        return;
    }
    [self.pageViewController setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
}

#pragma mark - Action Methods
- (IBAction)nextPageActionMethod:(id)sender {
    NSUInteger pageIndex = ((IntroPageContentViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).pageIndex;
    if (pageIndex == self.introImages.count - 1) {
        [self.startAppButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [self changePage:UIPageViewControllerNavigationDirectionForward];
    }
}

- (IBAction)startAppActionMethod:(id)sender {
    RootViewController *rootViewController = nil;
    for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
        if ([[self.navigationController.viewControllers objectAtIndex:i] isKindOfClass:[RootViewController class]]) {
            rootViewController = [self.navigationController.viewControllers objectAtIndex:i];
            break;
        }
    }
    if (rootViewController != nil) {
        [self.navigationController popToViewController:rootViewController animated:YES];
    } else {
        NSLog(@"RootViewController not found! Trying to instanciate new one!!!");
        rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
        [self.navigationController popToViewController:rootViewController animated:YES];
    }
}

@end
