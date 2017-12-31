//
//  AboutViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/20/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.aboutTextView setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:[self.aboutTextView textRangeFromPosition:[self.aboutTextView beginningOfDocument] toPosition:[self.aboutTextView endOfDocument]]];
    self.aboutTextView.textAlignment = NSTextAlignmentJustified;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    sender.contentOffset = CGPointMake(0.f, sender.contentOffset.y);
}

@end
