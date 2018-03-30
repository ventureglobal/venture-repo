//
//  IssueViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/27/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "IssueViewController.h"
#import "PageSliderViewController.h"
#import "SessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageUtil.h"
#import "UIColor+ColorUtil.h"
#import "PageManager.h"
#import "UIViewUtil.h"
#import "Page.h"
#import "UIFont+FontUtil.h"
#import <MaterialShowcase/MaterialShowcase-Swift.h>

@interface IssueViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *issueImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadBarButtonItem;
@property (strong, nonatomic) MaterialShowcase *showcase;
@property BOOL fullyLoaded;

@end

@implementation IssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(issueSelectedAction:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
    self.issueImageView.userInteractionEnabled = YES;
    [self.issueImageView addGestureRecognizer:tapRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL issueShowcaseViewed = [userDefaults boolForKey:@"issueShowcaseViewed"];
    if (!issueShowcaseViewed) {
        MaterialShowcase *showcase = [UIViewUtil showcaseWithTitle:[MessageUtil messageForKey:@"issueShowcaseDownloadTitle"]
                          withMessage:[MessageUtil messageForKey:@"issueShowcaseDownloadMessage"]
                    withBarButtonItem:self.downloadBarButtonItem];
    [showcase showWithAnimated:YES completion:nil];
        [userDefaults setBool:YES forKey:@"issueShowcaseViewed"];
        [userDefaults synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.issueImageView.image = [UIImage imageNamed:@"placeHolder"];
    [self reloadIssue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"fa_IR"];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"MMMM yy"];
    NSString *titleString = [NSString stringWithFormat:[MessageUtil messageForKey:@"issueTitleFormatMessage"]
                             , self.issue.issueNumber
                             , [dateFormatter stringFromDate:self.issue.date]];
    UIFont *font = [UIFont mainBoldFontWithSize:16];
    CGSize labelSize = [UIFont labelSizeForString:titleString font:font];
    UILabel *issueVolumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelSize.height, labelSize.width)];
    issueVolumeLabel.text = titleString;
    issueVolumeLabel.font = font;
    issueVolumeLabel.numberOfLines = 1;
    issueVolumeLabel.textColor = [UIColor navBarTintColor];
    issueVolumeLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleView:issueVolumeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters and Setters
- (MaterialShowcase *)showcase {
    if (!_showcase) {
        _showcase = [[MaterialShowcase alloc] init];
    }
    return _showcase;
}

#pragma mark - Private Methods
- (void)reloadIssue {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, _issue.imageUrl]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.issueImageView setImage:image];
        });
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"showPagesSegue" isEqualToString:segue.identifier]) {
        PageSliderViewController *pageSliderViewController = segue.destinationViewController;
        pageSliderViewController.magazine = self.magazine;
        pageSliderViewController.issue = self.issue;
        pageSliderViewController.magazineName = self.magazine.name;
        pageSliderViewController.issueVolume = self.issue.issueNumber;
    }
}

#pragma mark - Action Methods

- (IBAction)downloadAction:(id)sender {
    NSString *message = [NSString stringWithFormat:@"%@ 0%%", [MessageUtil messageForKey:@"downloadProgressMessage"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[MessageUtil messageForKey:@"downloadProgressTitle"] message:message preferredStyle:UIAlertControllerStyleAlert];
    CGRect progressFrame = CGRectMake(10.0, 72.0, 250.0, 8.0);
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:progressFrame];
    progressView.tintColor = [UIColor progressViewColor];
    
    [alertController.view addSubview:progressView];
    progressView.progress = 0.0;
    __block BOOL canceled = NO;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[MessageUtil messageForKey:@"cancelActionTitle"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:^{
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager cancelAll];
            canceled = YES;
        }];
    }];
    UIAlertAction *runInBackgroundAction = [UIAlertAction actionWithTitle:[MessageUtil messageForKey:@"runInBackgroundActionTitle"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:runInBackgroundAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        [[PageManager sharedInstance] fetchPagesWithIssue:self.issue success:^(NSArray<Page *> *pages) {
            CGFloat pageProgress = 1.0/[[NSNumber numberWithUnsignedInteger:(pages.count * 2)] floatValue];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            __block NSInteger remainingPages = pages.count * 2;
            for (Page *page in pages) {
                if (canceled) {
                    [manager cancelAll];
                    break;
                }
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, page.imageUrl]];
                [manager loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (image != nil && error == nil) {
                        if (cacheType == SDImageCacheTypeNone) {
                            [self hideInternetConnectionError];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            remainingPages --;
                            [self setIssueDownloadProgress:progressView pageProgress:pageProgress alert:alertController remaining:remainingPages];
                        });
                    } else if (error != nil) {
                        [self checkInternetConnection];
                    }
                }];
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, page.thumbnailUrl]];
                [manager loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (image != nil && error == nil) {
                        if (cacheType == SDImageCacheTypeNone) {
                            [self hideInternetConnectionError];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            remainingPages--;
                            [self setIssueDownloadProgress:progressView pageProgress:pageProgress alert:alertController remaining:remainingPages];
                        });
                    } else if (error != nil) {
                        [self checkInternetConnection];
                    }
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"Error whild using page manager:%@", [error localizedDescription]);
            [alertController dismissViewControllerAnimated:YES completion:^{
                [UIViewUtil showUIAlertError:error fromController:self];
            }];
        } messageBarDelegate:self];
    }];
}

- (void)setIssueDownloadProgress:(UIProgressView *)progressView pageProgress:(CGFloat)pageProgress alert:(UIAlertController *)alertController remaining:(NSInteger)remainingPages {
    CGFloat progress = progressView.progress + pageProgress;
    NSInteger progressPercentage = [[NSNumber numberWithFloat:progress * 100] integerValue];
    if (remainingPages == 0) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [progressView setProgress:progress animated:YES];
        alertController.message = [NSString stringWithFormat:@"%@ %ld%%", [MessageUtil messageForKey:@"downloadProgressMessage"], progressPercentage];
    }
}

- (void)issueSelectedAction:(id)sender {
    [self performSegueWithIdentifier:@"showPagesSegue" sender:sender];
}
@end
