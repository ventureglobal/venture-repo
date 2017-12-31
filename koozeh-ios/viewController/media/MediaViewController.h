//
//  MediaViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/19/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Media.h"
#import "CustomNavigationBarViewController.h"

@interface MediaViewController : CustomNavigationBarViewController

@property (weak, nonatomic) Media *media;

@end
