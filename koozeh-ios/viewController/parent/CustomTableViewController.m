//
//  CustomTableViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/31/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "CustomTableViewController.h"
#import "UIColor+ColorUtil.h"
#import "PingManager.h"
#import "UIFont+FontUtil.h"
#import "MessageUtil.h"

@interface CustomTableViewController ()

@property (strong, nonatomic) NSString *messageKey;
@property (strong, nonatomic) UITextView *messageBarTextView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor navBarBackColor];
    self.navigationController.navigationBar.tintColor = [UIColor navBarTintColor];
    
    UIBarButtonItem *menuBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuIcon"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:[SlideNavigationController sharedInstance]
                                                                      action:@selector(toggleRightMenu)];
    self.navigationItem.rightBarButtonItem=menuBarButtonItem;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.view bringSubviewToFront:self.messageBarTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setDefaultNavigationTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods
- (void)setDefaultNavigationTitle {
    UIImage *logoImage = [UIImage imageNamed:@"navBarLogo"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [logoImageView setImage:logoImage];
    // setContent mode aspect fit
    [logoImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = logoImageView;
}

- (void)setTitleView:(UIView *) titleView {
    self.navigationItem.titleView = titleView;
}

#pragma mark - <SlideNavigationControllerDelegate>
-(BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return YES;
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return NO;
}

#pragma mark - Setters and Getters
- (UITextView *)messageBarTextView {
    if (_messageBarTextView == nil) {
        _messageBarTextView = [[UITextView alloc] initWithFrame:[self customMessagBarFrame]];
        [_messageBarTextView setBackgroundColor:[UIColor messageBarBackColor]];
        [_messageBarTextView setTextColor:[UIColor messageBarTextColor]];
        [_messageBarTextView setFont: [UIFont shabnamWithSize:12]];
        [_messageBarTextView setTextAlignment:NSTextAlignmentRight];
        _messageBarTextView.editable = NO;
        _messageBarTextView.selectable = NO;
        _messageBarTextView.hidden = YES;
    }
    return _messageBarTextView;
}

- (UIView *)overlayView {
    if (_overlayView == nil) {
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        _overlayView.backgroundColor = [UIColor overlayBackgroundColor];
        _overlayView.hidden = YES;
    }
    return _overlayView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        float x = self.view.frame.origin.x + (self.view.frame.size.width / 2) - 25;
        float y = self.view.frame.origin.y + (self.view.frame.size.height / 2) - 25;
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, 50, 50)];
        _activityIndicatorView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _activityIndicatorView;
}

#pragma mark - Public Methods
- (void)checkInternetConnection {
    [[PingManager sharedInstance] pingTestSuccess:^(NSString *response) {
        NSLog(@"pingMessageResponse:%@", response);
        [self hideMessageBarForKey:@"errorNetworkMessage"];
    } failure:^(NSError *error) {
        [self showMessageBarForKey:@"errorNetworkMessage"];
    }];
}

- (void)hideInternetConnectionError {
    [self hideMessageBarForKey:@"errorNetworkMessage"];
}

- (void)showMessageBarForKey:(NSString *)messageKey {
    if (![[self.view subviews] containsObject:self.messageBarTextView]) {
        [self.view addSubview:self.messageBarTextView];
    }
    self.messageBarTextView.text = [MessageUtil messageForKey:messageKey];
    self.messageKey = messageKey;
    self.messageBarTextView.hidden = NO;
}

- (void)hideMessageBarForKey:(NSString *)messageKey {
    if ([self.messageKey isEqualToString:messageKey]) {
        self.messageBarTextView.hidden = YES;
    }
}

- (void)showOverlayActivityIndicator {
    [self.view addSubview:self.overlayView];
    self.overlayView.hidden = NO;
    [self.view addSubview:self.activityIndicatorView];
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideOverlayActivityIndicator {
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
    self.overlayView.hidden = YES;
    [self.activityIndicatorView removeFromSuperview];
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    self.activityIndicatorView = nil;
}

#pragma mark - <CustomMessageBarDelegate>
- (CGRect)customMessagBarFrame {
    CGPoint position = [self customMessageBarPosition];
    return CGRectMake(position.x, position.y , self.view.frame.size.width, 65);
}

- (CGPoint)customMessageBarPosition {
    return CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.height - 65);
}

@end
