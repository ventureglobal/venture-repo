//
//  UserProfileViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 4/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIColor+ColorUtil.h"
#import "UserManager.h"
#import "User.h"
#import "LoginViewController.h"
#import "UIViewUtil.h"
#import "MessageUtil.h"
#import "EditUserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray<NSString *> *persianMonth;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.editButton.layer.borderWidth = 2.0;
    self.editButton.layer.borderColor = [UIColor profileTitntColor].CGColor;
    self.editButton.layer.cornerRadius = 8;
    
    self.persianMonth = [MessageUtil messagesForKey:@"persianMonth"];
    
    self.mobileLabel.text = [MessageUtil messageForKey:@"mobilePlaceHolderMessage"];
    self.nameLabel.text = [MessageUtil messageForKey:@"namePlaceHolderMessage"];
    self.dateLabel.text = [MessageUtil messageForKey:@"birthDatePlaceHolderMessage"];
    self.emailLabel.text = [MessageUtil messageForKey:@"emailPlaceHolderMessage"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showOverlayActivityIndicator];
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"userToken"] == nil) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[LoginViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    } else {
        [[UserManager sharedInstance] getUser:^(User *user) {
            [self hideOverlayActivityIndicator];
            self.user = user;
        } failure:^(NSError *error) {
            [self hideOverlayActivityIndicator];
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
        } messageBarDelegate:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters and Setters
- (void)setUser:(User *)user {
    _user = user;
    if (user.mobile != nil) {
        self.mobileLabel.text = user.mobile;
    } else {
        self.mobileLabel.text = [MessageUtil messageForKey:@"mobilePlaceHolderMessage"];
    }
    if (user.firstName != nil && user.lastName != nil) {
        self.nameLabel.text = user.name;
    } else {
        self.nameLabel.text = [MessageUtil messageForKey:@"namePlaceHolderMessage"];
    }
    if (user.birthdateJalaliDay != 0 && user.birthdateJalaliYear != 0 && user.birthdateJalaliMonth != 0) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ %@", user.birthdateJalaliYear, self.persianMonth[[user.birthdateJalaliMonth integerValue] - 1], user.birthdateJalaliDay];
    } else {
        self.dateLabel.text = [MessageUtil messageForKey:@"birthDatePlaceHolderMessage"];
    }
    if (user.email != nil && user.email.length) {
        self.emailLabel.text = user.email;
    } else {
        self.emailLabel.text = [MessageUtil messageForKey:@"emailPlaceHolderMessage"];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"showEditUserProfile" isEqualToString:segue.identifier]) {
        EditUserProfileViewController *viewController = segue.destinationViewController;
        viewController.user = self.user;
    }
}

#pragma mark - Action Methods
- (IBAction)editAction:(id)sender {
    
}

@end
