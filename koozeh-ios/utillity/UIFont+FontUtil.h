//
//  UIFont+FontUtil.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (FontUtil)

+ (instancetype)mainRegularFontWithSize:(CGFloat)size;
+ (instancetype)mainBoldFontWithSize:(CGFloat)size;
+ (instancetype)iranianSansBoldWithSize:(CGFloat)size;
+ (instancetype)shabnamWithSize:(CGFloat)size;
+ (CGSize)labelSizeForString:(NSString *)text font:(UIFont *)font;

@end
