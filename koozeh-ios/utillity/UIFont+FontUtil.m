//
//  UIFont+FontUtil.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "UIFont+FontUtil.h"

@implementation UIFont (FontUtil)

+ (instancetype)mainRegularFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Samim" size:size];
}

+ (instancetype)mainBoldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Samim-Bold" size:size];
}

+ (instancetype)iranianSansBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Samim" size:size];
}

+ (instancetype)shabnamWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Samim-Bold" size:size];
}

+ (CGSize)labelSizeForString:(NSString *)text font:(UIFont *)font {
    return [text boundingRectWithSize:CGSizeMake(100, 40)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: font}
                              context:nil].size;
}

@end
