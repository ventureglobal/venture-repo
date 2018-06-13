//
//  MagazineCollectionViewCell.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/7/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "MagazineCollectionViewCell.h"
#import "SessionManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import "UIFont+FontUtil.h"
#import "UIColor+ColorUtil.h"

@interface MagazineCollectionViewCell ()

@property (strong, nonatomic) UIImageView *magazineImageView;
@property (strong, nonatomic) UILabel *magazineNameLabel;

@end
@implementation MagazineCollectionViewCell

#pragma mark - Getters and Setters
- (void)setMagazine:(Magazine *)magazine {
    _magazine = magazine;
    self.magazineNameLabel.text = magazine.magazineDescription;
    [self reloadMagazineImage];
}

- (UIImageView *)magazineImageView {
    if (_magazineImageView == nil) {
        CGRect frame = CGRectMake(self.contentView.frame.origin.x + 10, self.contentView.frame.origin.y + 10, self.contentView.frame.size.width - 10, self.contentView.frame.size.height - 45);
        _magazineImageView = [[UIImageView alloc] initWithFrame:frame];
        _magazineImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_magazineImageView];
    }
    return _magazineImageView;
}

- (UILabel *)magazineNameLabel {
    if (_magazineNameLabel == nil) {
        float x = self.contentView.frame.origin.x;
        float y = self.contentView.frame.origin.y + self.contentView.frame.size.height - 35;
        CGRect frame = CGRectMake(x, y, self.contentView.frame.size.width, 35);
        _magazineNameLabel = [[UILabel alloc] initWithFrame:frame];
        _magazineNameLabel.font = [UIFont mainRegularFontWithSize:18.0];
        _magazineNameLabel.textAlignment = NSTextAlignmentCenter;
        _magazineNameLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_magazineNameLabel];
    }
    return _magazineNameLabel;
}

#pragma mark - Private Methods
- (void)reloadMagazineImage {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, self.magazine.thumbnailUrl]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.magazineImageView setImage:image];
//            CGRect imageFrame = AVMakeRectWithAspectRatioInsideRect(image.size, self.magazineImageView.frame);
//            [self.magazineImageView setFrame:imageFrame];
        });
    }];
}

@end
