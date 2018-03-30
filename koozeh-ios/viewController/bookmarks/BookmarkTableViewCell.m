//
//  BookmarkTableViewCell.m
//  koozeh-ios
//
//  Created by Samin Safaei on 4/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "BookmarkTableViewCell.h"
#import "BookmarkCollectionViewCell.h"
#import "SessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageUtil.h"

@interface BookmarkTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *issueImageView;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *bookmarkCollectionView;

@end
@implementation BookmarkTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGFloat width = self.contentView.frame.size.width / 4;
        CGFloat height = (409.0 / 305.0) * width;
        self.issueImageView.frame = CGRectMake(self.issueImageView.frame.origin.x, self.issueImageView.frame.origin.y, width, height);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <Getters and Setters>
- (void)setBookmarks:(NSMutableArray<Bookmark *> *)bookmarks {
    _bookmarks = bookmarks;
    [self.bookmarkCollectionView setTransform:CGAffineTransformMakeScale(-1, 1)];
    [self.bookmarkCollectionView reloadData];
}

- (void)setIssue:(Issue *)issue {
    _issue = issue;
    self.issueImageView.image = [UIImage imageNamed:@"placeHolder"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"fa_IR"];
    [dateFormatter setLocalizedDateFormatFromTemplate:@"MMMM yy"];
    self.issueLabel.text = [NSString stringWithFormat:[MessageUtil messageForKey:@"issueTitleFormatMessage"], issue.issueNumber, [dateFormatter stringFromDate:issue.date]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, issue.thumbnailUrl]];
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.issueImageView setImage:image];
        });
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookmarks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (BookmarkCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookmarkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell
    cell.bookmark = self.bookmarks[indexPath.item];
    [cell.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat width = self.contentView.frame.size.width / 4;
    CGFloat height = collectionView.frame.size.height;
    return CGSizeMake(width + 10, height);
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.bookmarkDelegate didSelectBookmark:self.bookmarks[indexPath.item]];
}

@end
