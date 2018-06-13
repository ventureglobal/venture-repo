//
//  UIColor+ColorUtil.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/14/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "UIColor+ColorUtil.h"

@implementation UIColor (ColorUtil)

+ (UIColor *)navBarTintColor {
    return [UIColor colorWithRed:228.0/255.0 green:199.0/255.0 blue:45.0/255.0 alpha:1.0];
}

+ (UIColor *)navBarBackColor {
    return [UIColor colorWithRed:35.0/255.0 green:95.0/255.0 blue:131.0/255.0 alpha:1.0];
}

+ (UIColor *)navBarItemActiveColor {
    return [UIColor colorWithRed:24.0/255.0 green:131.0/255.0 blue:231.0/255.0 alpha:1.0];
}

+ (UIColor *)navBarItemDefaultColor {
    return [UIColor whiteColor];
}

+ (UIColor *)messageBarTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)messageBarBackColor {
    return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
}

+ (UIColor *)generalLogoColor {
    return [UIColor colorWithRed:228.0/255.0 green:199.0/255.0 blue:45.0/255.0 alpha:1.0];
}

+ (UIColor *)generalLogoDarkColor {
    return [UIColor colorWithRed:198.0/255.0 green:169.0/255.0 blue:15.0/255.0 alpha:1.0];
}

+ (UIColor *)menuIconColor {
    return [UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0];
}

+ (UIColor *)overlayBackgroundColor {
    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
}

+ (UIColor *)mediaOptionButonColor {
    return [UIColor purpleColor];
}

+ (UIColor *)mediaSoundButtonColor {
    return [UIColor colorWithRed:229.0/255.0 green:118.0/255.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)mediaVideoButtonColor {
    return [UIColor colorWithRed:1.0/255.0 green:103.0/255.0 blue:247.0/255.0 alpha:1.0];
}

+ (UIColor *)mediaImageButtonColor{
    return [UIColor colorWithRed:28.0/255.0 green:170.0/255.0 blue:122.0/255.0 alpha:1.0];
}

+ (UIColor *)thumbnailBacgroundColor {
    return [UIColor colorWithWhite:1.0 alpha:0.6];
}

+ (UIColor *)progressViewColor {
    return [UIColor colorWithRed:0 green:150.0/255.0 blue:255.0/255.0 alpha:1.0];
}
+ (UIColor *)profileTitntColor {
    return [UIColor colorWithRed:75.0/255.0 green:127.0/255.0 blue:156.0/255.0 alpha:1.0];
}

+ (UIColor *)cancelColor {
    return [UIColor colorWithRed:255.0/255.0 green:126.0/255.0 blue:121.0/255.0 alpha:1.0];
}

+ (UIColor *)showcaseBackgroundColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
}
+ (UIColor *)showcaseTitleColor {
    return [self generalLogoColor];
}
+ (UIColor *)showcaseMessageColor {
    return [self whiteColor];
}

+ (UIColor *)counterColor {
    return [UIColor colorWithRed:188.0/255.0 green:200.0/255.0 blue:201.0/255.0 alpha:1.0];
}

@end
