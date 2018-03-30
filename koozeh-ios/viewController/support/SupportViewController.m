//
//  SupportViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 4/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "SupportViewController.h"
#import "SessionManager.h"

@interface SupportViewController ()

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)openTelegramAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTelegramUrl]];
}
- (IBAction)openEmailAction:(id)sender {
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString:kEmailUrl]];
}
- (IBAction)openPhoneAction:(id)sender {
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString:kPhoneUrl]];
}

@end
