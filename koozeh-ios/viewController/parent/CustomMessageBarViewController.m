//
//  CustomMessageBarViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "CustomMessageBarViewController.h"
#import "PingManager.h"
#import "MessageUtil.h"
#import "UIColor+ColorUtil.h"
#import "UIFont+FontUtil.h"
#import "AppDelegate.h"

@interface CustomMessageBarViewController ()

@property (strong, nonatomic) NSString *messageKey;
@property (strong, nonatomic) UITextView *messageBarTextView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;


@end

@implementation CustomMessageBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:self.messageBarTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self restrictRotation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)restrictRotation:(BOOL)restriction {
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

@end
