//
//  CustomNavigationBarViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/14/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "CustomNavigationBarViewController.h"
#import "SlideNavigationController.h"
#import "UIColor+ColorUtil.h"

@interface CustomNavigationBarViewController ()

@property (weak, nonatomic) UIView *messageBar;

@end

@implementation CustomNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor navBarBackColor];
    self.navigationController.navigationBar.tintColor = [UIColor navBarTintColor];
    
    UIBarButtonItem *menuBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuIcon"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:[SlideNavigationController sharedInstance]
                                                         action:@selector(toggleRightMenu)];
    self.navigationItem.rightBarButtonItem=menuBarButtonItem;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <SlideNavigationControllerDelegate>
-(BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return YES;
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return NO;
}

#pragma mark - <CustomMessageBarDelegate>
- (CGPoint)customMessageBarPosition {
    return CGPointMake(0, 60);
}

@end
