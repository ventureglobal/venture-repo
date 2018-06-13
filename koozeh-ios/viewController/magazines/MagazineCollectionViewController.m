//
//  MagazineCollectionViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/7/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "MagazineCollectionViewController.h"
#import "MagazineCollectionViewCell.h"
#import "MagazineManager.h"
#import "Magazine.h"
#import "UIViewUtil.h"
#import "IssuesViewController.h"
#import "UIColor+ColorUtil.h"

@interface MagazineCollectionViewController ()

@property (strong, nonatomic) NSArray<Magazine *> *magazines;
@property (strong, nonatomic) Magazine *selectedMagazine;

@end

@implementation MagazineCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    self.navigationItem.hidesBackButton = YES;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.view bringSubviewToFront:self.collectionView];
    
    // Do any additional setup after loading the view.
    [super viewDidLoad];
//    [self.view bringSubviewToFront:self.messageBarTextView];
//    [self showMessageBarForKey:@"errorNetworkMessage"];
    [self.collectionView setTransform:CGAffineTransformMakeScale(-1, 1)];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.collectionView registerClass:MagazineCollectionViewCell.class forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor counterColor];
    [self reloadMagazines];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)reloadMagazines {
    [self showOverlayActivityIndicator];
    self.selectedMagazine = nil;
    [[MagazineManager sharedInstance] fetchPublicMagazines:^(NSArray<Magazine *> *magazines) {
        self.magazines = magazines;
        [self.collectionView reloadData];
        [self hideOverlayActivityIndicator];
    } failure:^(NSError *error) {
        [UIViewUtil showUIAlertError:error fromController:self];
        [self hideOverlayActivityIndicator];
    } messageBarDelegate:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.magazines.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MagazineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.magazine = self.magazines[indexPath.row];
    [cell.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2.0;
    float cellHeight = ((409.0 / 305.0) * (cellWidth - 20)) + 40;
    CGSize size = CGSizeMake(cellWidth, cellHeight);
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedMagazine = [self.magazines objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showIssuesSegue" sender:nil];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"showIssuesSegue"]) {
         IssuesViewController *destination = segue.destinationViewController;
         destination.magazine = self.selectedMagazine;
     }
 }

@end
