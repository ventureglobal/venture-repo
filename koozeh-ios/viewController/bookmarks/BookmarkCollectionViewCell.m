//
//  BookmarkCollectionViewCell.m
//  koozeh-ios
//
//  Created by Samin Safaei on 4/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "BookmarkCollectionViewCell.h"
#import "MessageUtil.h"
#import "SessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BookmarkCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;

@end
@implementation BookmarkCollectionViewCell

#pragma mark - <Getters and Setters>
- (void)setBookmark:(Bookmark *)bookmark {
    _bookmark = bookmark;
    self.pageNumberLabel.text = [NSString stringWithFormat:[MessageUtil messageForKey:@"pageIndexFormatMessage"], bookmark.page.pageNumber];
    self.pageImageView.image = [UIImage imageNamed:@"placeHolder"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, bookmark.page.thumbnailUrl]];
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        self.pageImageView.image = image;
    }];
}

@end
