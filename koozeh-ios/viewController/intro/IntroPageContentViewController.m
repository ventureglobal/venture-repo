//
//  IntroPageContentViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/6/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "IntroPageContentViewController.h"

@interface IntroPageContentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation IntroPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Showing intro image:%@", self.imageFile);
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pageInteractionController pageChangedToIndex:self.pageIndex];
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

@end
