//
//  PageThumbnailCell.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/27/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "PageThumbnailCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SessionManager.h"

@interface PageThumbnailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mediaIconImageView;

@end
@implementation PageThumbnailCell

#pragma mark - Setters and Getters
- (void)setPage:(Page *)page {
    _page = page;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, page.thumbnailUrl]];
    self.pageImageView.image = [UIImage imageNamed:@"placeHolder"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageImageView setImage:image];
        });
    }];

    self.pageNumberLabel.text = [NSString stringWithFormat:@"%ld", page.pageNumber];
    
    if (page.medias != nil && page.medias.count != 0) {
        self.mediaIconImageView.hidden = NO;
    } else {
        self.mediaIconImageView.hidden = YES;
    }
}

@end
