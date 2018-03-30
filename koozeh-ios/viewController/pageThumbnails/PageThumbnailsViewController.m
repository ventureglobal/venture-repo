//
//  PageThumbnailsViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/26/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "PageThumbnailsViewController.h"
#import "UIColor+ColorUtil.h"
#import "PageThumbnailCell.h"

@interface PageThumbnailsViewController ()

@end

@implementation PageThumbnailsViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.view.backgroundColor = [UIColor thumbnailBacgroundColor];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setTransform:CGAffineTransformMakeScale(-1, 1)];
    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 20, 35, 35)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 20, 50, 50)];
    [button addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [button setImage:[UIImage imageNamed:@"iconClose"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"iconClose"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters and Setters
- (void)setPages:(NSArray<Page *> *)pages {
    _pages = pages;
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PageThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.page = self.pages[indexPath.row];
    [cell setTransform:CGAffineTransformMakeScale(-1, 1)];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width / 2.0;
    CGFloat height = ((409.0 / 305.0) * width) + 35.0;
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.pageSliderDelegate goToPageWithNumber:indexPath.row];
    }];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - Action Methods
- (void)closeButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
