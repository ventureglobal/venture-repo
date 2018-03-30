//
//  EditUserProfileViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 4/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CustomNavigationBarViewController.h"

@interface EditUserProfileViewController : CustomNavigationBarViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) User *user;

@end
