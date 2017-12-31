//
//  RightMenuViewCell.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "RightMenuViewCell.h"

@interface RightMenuViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *menuIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *MenuIconTitleLabel;

@end
@implementation RightMenuViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenuIconTitle:(NSString *)menuIconTitle {
    _menuIconTitle = menuIconTitle;
    self.MenuIconTitleLabel.text = _menuIconTitle;
}

- (void)setMenuIconImage:(NSString *)menuIconImage {
    _menuIconImage = menuIconImage;
    self.menuIconImageView.image = [UIImage imageNamed:_menuIconImage];
}

@end
