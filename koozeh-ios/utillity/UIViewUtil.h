//
//  UIViewUtil.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewUtil : NSObject

+ (void)addDoneButton:(UITextField *)textField target:(id)target action:(SEL)doneAction;

+ (void)showUIAlertError:(NSError *)error fromController:(UIViewController *)viewController;

@end
