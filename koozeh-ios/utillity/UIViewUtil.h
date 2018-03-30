//
//  UIViewUtil.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MaterialShowcase/MaterialShowcase-Swift.h>

@interface UIViewUtil : NSObject

+ (void)addDoneButton:(UITextField *)textField target:(id)target action:(SEL)doneAction;

+ (void)showUIAlertError:(NSError *)error fromController:(UIViewController *)viewController;
+ (void)showUIAlertError:(NSError *)error fromController:(UIViewController *)viewController onClose:(void (^)(void))onClose ;
+ (void)showUIAlertError:(NSError *)error fromController:(UIViewController *)viewController onOk:(void (^)(void))onOk onCancel:(void (^)(void))onCancel;
+ (void)showUIAlertError:(NSError *)error fromController:(UIViewController *)viewController includeNetworkErrors:(BOOL)includeNetworkErrors onClose:(void (^)(void))onClose ;

+ (MaterialShowcase *)showcaseWithTitle:(NSString *)title
                            withMessage:(NSString *)message
                      withBarButtonItem:(UIBarButtonItem *)barButtonItem;

@end
