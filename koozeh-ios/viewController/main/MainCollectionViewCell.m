//
//  MainCollectionViewCell.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SessionManager.h"

@interface MainCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *issueVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation MainCollectionViewCell

- (void)setIssue:(Issue *)issue {
    _issue = issue;
    [self.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    [self reloadIssue];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@1
                            range:NSMakeRange(0, [attributeString length])];
    [self.priceLabel setAttributedText:attributeString];
}

- (void)setIssueVolume:(NSInteger)issueVolume {
    _issueVolume = issueVolume;
    self.issueVolumeLabel.text = [NSString stringWithFormat:@"%ld", issueVolume];
}

- (void)reloadIssue {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, self.issue.thumbnailUrl]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView.layer setBorderColor: [[UIColor colorWithRed:237.0/255.0 green:74.0/255.0 blue:37.0/255.0 alpha:1.0] CGColor]];
            [self.imageView.layer setBorderWidth: 2.0];
            [self.imageView setImage:image];
        });
    }];
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source {
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *tempImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempImg;
}

@end
