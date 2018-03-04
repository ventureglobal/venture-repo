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

@interface CustomMessageBarViewController ()

@property (strong, nonatomic) UITextView *messageBarTextView;
@property (strong, nonatomic) NSString *messageKey;

@end

@implementation CustomMessageBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        _messageBarTextView.hidden = YES;
    }
    return _messageBarTextView;
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

#pragma mark - <CustomMessageBarDelegate>
- (CGRect)customMessagBarFrame {
    CGPoint position = [self customMessageBarPosition];
    return CGRectMake(position.x, position.y, self.view.frame.size.width, 50);
}

- (CGPoint)customMessageBarPosition {
    return CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
