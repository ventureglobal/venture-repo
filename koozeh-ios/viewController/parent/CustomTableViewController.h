//
//  CustomTableViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/31/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "CustomMessageBarViewController.h"

@interface CustomTableViewController : UITableViewController <SlideNavigationControllerDelegate, CustomMessageBarDelegate>

@end
