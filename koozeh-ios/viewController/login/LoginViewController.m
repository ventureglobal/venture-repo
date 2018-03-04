//
//  LoginViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 2/28/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+ColorUtil.h"
#import "UserManager.h"
#import "MessageUtil.h"
#import "UIViewUtil.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *inputTextFieldLable;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *mainActionButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryActionButton;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *secondaryButtonOverlayView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *secondaryButtonActivityIndicator;
@property (nonatomic) BOOL isLoginState;
@property (nonatomic) long deviceId;
@property (strong, nonatomic) NSString *mobile;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainActionButton.layer.borderWidth = 2.0;
    self.mainActionButton.layer.borderColor = [UIColor generalLogoDarkColor].CGColor;
    self.mainActionButton.layer.cornerRadius = 8;
   
    self.secondaryActionButton.layer.borderWidth = 2.0;
    self.secondaryActionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.secondaryActionButton.layer.cornerRadius = 8;
    
    [UIViewUtil addDoneButton:self.inputTextField target:self action:@selector(keyboardDoneAction)];
    
    self.isLoginState = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - Private Methods
- (void)initializeSignInViews {
    self.inputTextFieldLable.text = [MessageUtil messageForKey:@"signInLabelString"];
    self.inputTextField.placeholder = [MessageUtil messageForKey:@"signInTextFieldPlaceHolder"];
    [self.mainActionButton setTitle:[MessageUtil messageForKey:@"signInMainActionString"] forState:UIControlStateNormal];
    [self.secondaryActionButton setTitle:[MessageUtil messageForKey:@"signInSecondaryActionString"] forState:UIControlStateNormal];
    self.isLoginState = YES;
}

- (void)initializeVerifyMobileViews {
    self.inputTextFieldLable.text = [MessageUtil messageForKey:@"verifyMobileLabelString"];
    self.inputTextField.placeholder = [MessageUtil messageForKey:@"verifyMobileTextFieldPlaceHolder"];
    self.inputTextField.text = nil;
    [self.mainActionButton setTitle:[MessageUtil messageForKey:@"verifyMobileMainActionString"] forState:UIControlStateNormal];
    [self.secondaryActionButton setTitle:[MessageUtil messageForKey:@"verifyMobileSecondaryActionString"] forState:UIControlStateNormal];
    self.isLoginState = NO;
}

- (void)mainActionMethod {
    self.overlayView.hidden = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    if (self.isLoginState) {
        self.mobile = self.inputTextField.text;
        [[UserManager sharedInstance] signInWithMobile:self.inputTextField.text success:^(long deviceId) {
            self.deviceId = deviceId;
            NSLog(@"Got deviceId:%ld", deviceId);
            self.overlayView.hidden = YES;
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
            [self initializeVerifyMobileViews];
            [self disableRetry];
        } failure:^(NSError *error) {
            NSLog(@"Error whild using user manager:%@", [error localizedDescription]);
            self.overlayView.hidden = YES;
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
            [UIViewUtil showUIAlertError:error fromController:self];
        } messageBarDelegate:self];
    } else {
        [[UserManager sharedInstance]
         verifyMobileWithCode:self.inputTextField.text
         deviceId:self.deviceId
         success:^{
             [self performSegueWithIdentifier:@"showMainViewSegue" sender:nil];
             self.overlayView.hidden = YES;
             self.activityIndicatorView.hidden = YES;
             [self.activityIndicatorView stopAnimating];
         } failure:^(NSError *error) {
             [self initializeVerifyMobileViews];
             [UIViewUtil showUIAlertError:error fromController:self];
             self.overlayView.hidden = YES;
             self.activityIndicatorView.hidden = YES;
             [self.activityIndicatorView stopAnimating];
         } messageBarDelegate:self];
    }
}

- (void)disableRetry {
    self.secondaryActionButton.enabled = NO;
    self.secondaryButtonOverlayView.hidden = NO;
    [self.secondaryButtonActivityIndicator startAnimating];
    self.secondaryButtonActivityIndicator.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:self
                                   selector:@selector(enableRetry)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)enableRetry {
    self.secondaryButtonActivityIndicator.hidden = YES;
    self.secondaryButtonOverlayView.hidden = YES;
    self.secondaryActionButton.enabled = YES;
    [self.secondaryButtonActivityIndicator stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action Methods
- (IBAction)mainButtonActionMethod:(id)sender {
    [self mainActionMethod];
}

- (IBAction)secondaryButtonActionMethod:(id)sender {
    if (self.isLoginState) {
        [self performSegueWithIdentifier:@"showMainViewSegue" sender:nil];
    } else {
        self.overlayView.hidden = NO;
        [self.activityIndicatorView startAnimating];
        self.activityIndicatorView.hidden = NO;
        [self disableRetry];
        [[UserManager sharedInstance] signInWithMobile:self.mobile success:^(long deviceId) {
            self.deviceId = deviceId;
            NSLog(@"Got deviceId:%ld", deviceId);
            self.overlayView.hidden = YES;
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
        } failure:^(NSError *error) {
            NSLog(@"Error whild using user manager:%@", [error localizedDescription]);
            self.overlayView.hidden = YES;
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
            [UIViewUtil showUIAlertError:error fromController:self];
        } messageBarDelegate:self];
    }
}

-(void)keyboardDoneAction {
    NSLog(@"Done button clicked");
    [self.inputTextField endEditing:YES];
    [self mainActionMethod];
}

@end
