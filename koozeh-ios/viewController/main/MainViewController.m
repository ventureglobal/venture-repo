//
//  MainViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "MainViewController.h"
#import "IssueManager.h"
#import "Issue.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SessionManager.h"
#import "MainCollectionViewCell.h"
#import "PageSliderViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *latestIssueImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *latestIssueFreeBadgeImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *latestIssueProgressView;
@property (weak, nonatomic) IBOutlet UICollectionView *issuesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *latestIssueVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestIssuePriceLabel;
@property (strong, nonatomic) NSArray<Issue *> *issues;
@property (strong, nonatomic) Issue *selectedIssue;
@property (nonatomic) NSInteger selectedIssueVolume;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    [[IssueManager sharedInstance] fetchPublicDefaultIssues:^(NSArray<Issue *> *issues) {
        self.issues = issues;
        [self.issuesCollectionView setTransform:CGAffineTransformMakeScale(-1, 1)];
        [self.issuesCollectionView reloadData];
        Issue *mainIssue = [issues objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, mainIssue.imageUrl]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [self.latestIssueImageButton setHidden:YES];
        [self.latestIssueFreeBadgeImageView setHighlighted:YES];
        [self.latestIssueProgressView setHidden:NO];
        [self.latestIssueProgressView setProgress:0];
        [manager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                float progress = ((float)receivedSize) / ((float) expectedSize);
                [self.latestIssueProgressView setProgress:progress];
            });
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.latestIssueVolumeLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.issues.count - 1];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.latestIssuePriceLabel.text];
                [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                        value:@1
                                        range:NSMakeRange(0, [attributeString length])];
                [self.latestIssuePriceLabel setAttributedText:attributeString];
                [self.latestIssueImageButton setImage:image forState:UIControlStateNormal];
                
                [self.latestIssueImageButton setHidden:NO];
                [self.latestIssueFreeBadgeImageView setHidden:NO];
                [self.latestIssueProgressView setHidden:YES];
                [self.latestIssueProgressView setProgress:0];
            });
        }];
        for (Issue *issue in issues) {
            NSLog(@"Got issue with id:%ld imageUrl:%@", issue.identity, issue.imageUrl);
        }
    } failure:^(NSError *error) {
        NSLog(@"Error whild using issue manager:%@", [error localizedDescription]);
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([@"showIssueSegue" isEqualToString:segue.identifier]) {
        PageSliderViewController *pageSiderViewController = segue.destinationViewController;
        pageSiderViewController.issue = self.selectedIssue;
        pageSiderViewController.issueVolume = self.selectedIssueVolume;
    }
    // Pass the selected object to the new view controller.
}

#pragma mark - <UICollectionViewDataSource>

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.issue = [self.issues objectAtIndex:indexPath.row + 1];
    cell.issueVolume = self.issues.count - indexPath.row - 2;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.issues != nil && self.issues.count) ? self.issues.count - 1 : 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = (85.0F / 160.0F) * collectionView.frame.size.height;
    return CGSizeMake(width, collectionView.frame.size.height);
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIssueVolume = self.issues.count - indexPath.row - 2;
    self.selectedIssue = [self.issues objectAtIndex:indexPath.row + 1];
//    PageSliderViewController *pageSiderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageSliderViewController"];
//    pageSiderViewController.issue = selectedIssue;
//    pageSiderViewController.issueVolume = self.issues.count - indexPath.row - 1;
//    [self.navigationController pushViewController:pageSiderViewController animated:YES];
    [self performSegueWithIdentifier:@"showIssueSegue" sender:self];
}

#pragma mark - Action Methods

- (IBAction)showLatestIssueActionMethod:(id)sender {
    self.selectedIssueVolume = self.issues.count - 1;
    self.selectedIssue = [self.issues objectAtIndex:0];
    [self performSegueWithIdentifier:@"showIssueSegue" sender:self];
}

@end
