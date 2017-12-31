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

+ (UIColor *)menuIconColor {
    return [UIColor colorWithRed:132.0/255.0 green:132.0/255.0 blue:132.0/255.0 alpha:1.0];
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

@end
