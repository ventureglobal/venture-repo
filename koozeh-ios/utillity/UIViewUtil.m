//
//  UIViewUtil.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "UIViewUtil.h"
#import "MessageUtil.h"
#import "UIColor+ColorUtil.h"
#import "UIFont+FontUtil.h"
#import <AFNetworking/AFNetworking.h>
#import <MaterialShowcase/MaterialShowcase-Swift.h>

@implementation UIViewUtil

+ (void)addDoneButton:(UITextField *)textField target:(id)target action:(SEL)doneAction {
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:target action:doneAction];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    textField.inputAccessoryView = keyboardToolbar;
}

+ (void)showUIAlertError:(NSError *)error
          fromController:(UIViewController *)viewController {
    [self showUIAlertError:error fromController:viewController includeNetworkErrors:YES onClose:^{
        exit(0);
    }];
}

+ (void)showUIAlertError:(NSError *)error
          fromController:(UIViewController *)viewController
                 onClose:(void (^)(void))onClose {
    [self showUIAlertError:error fromController:viewController includeNetworkErrors:YES onClose:onClose];
}

+ (void)showUIAlertError:(NSError *)error
          fromController:(UIViewController *)viewController
    includeNetworkErrors:(BOOL)includeNetworkErrors
                 onClose:(void (^)(void))onClose {
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:[MessageUtil messageForKey:@"errorOkString"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Error Cancel action");
                                       if (onClose != nil) {
                                           onClose();
                                       }
                                   }];
    NSString *alertTitle = [MessageUtil messageForKey:@"errorGeneralTitle"];
    NSString *alertMessage = [MessageUtil messageForKey:@"errorGeneralMessage"];
    if ([@"ir.bina.koozeh-ios" isEqualToString:error.domain]
        && error.userInfo != nil
        && [error.userInfo objectForKey:@"errorKey"] != nil) {
        alertTitle = [MessageUtil messageForKey:[NSString stringWithFormat:@"error%@Title", [error.userInfo objectForKey:@"errorKey"]]];
        alertMessage = [MessageUtil messageForKey:[NSString stringWithFormat:@"error%@Message", [error.userInfo objectForKey:@"errorKey"]]];
    } else if (includeNetworkErrors &&
               [NSURLErrorDomain isEqualToString:error.domain] && error.code == -1004) {
        alertTitle = [MessageUtil messageForKey:[NSString stringWithFormat:@"errorNetworkTitle"]];
        alertMessage = [MessageUtil messageForKey:[NSString stringWithFormat:@"errorNetworkMessage"]];
    }
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


+ (void)showUIAlertError:(NSError *)error
          fromController:(UIViewController *)viewController
                    onOk:(void (^)(void))onOk
                onCancel:(void (^)(void))onCancel {
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:[MessageUtil messageForKey:@"errorCancelString"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Error Cancel action");
                                       if (onCancel != nil) {
                                           onCancel();
                                       }
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:[MessageUtil messageForKey:@"errorOkString"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Error Cancel action");
                                       if (onOk != nil) {
                                           onOk();
                                       }
                                   }];
    NSString *alertTitle = [MessageUtil messageForKey:@"errorGeneralTitle"];
    NSString *alertMessage = [MessageUtil messageForKey:@"errorGeneralMessage"];
    if ([@"ir.bina.koozeh-ios" isEqualToString:error.domain]
        && error.userInfo != nil
        && [error.userInfo objectForKey:@"errorKey"] != nil) {
        alertTitle = [MessageUtil messageForKey:[NSString stringWithFormat:@"error%@Title", [error.userInfo objectForKey:@"errorKey"]]];
        alertMessage = [MessageUtil messageForKey:[NSString stringWithFormat:@"error%@Message", [error.userInfo objectForKey:@"errorKey"]]];
    }
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (MaterialShowcase *)showcaseWithTitle:(NSString *)title
              withMessage:(NSString *)message
        withBarButtonItem:(UIBarButtonItem *)barButtonItem {
    MaterialShowcase *showcase = [[MaterialShowcase alloc] init];
    [showcase setTargetViewWithBarButtonItem:barButtonItem];
    showcase.primaryText = title;
    showcase.primaryTextAlignment = NSTextAlignmentCenter;
    showcase.primaryTextColor = [UIColor generalLogoColor];
    showcase.primaryTextFont = [UIFont shabnamWithSize:18];
    showcase.primaryTextSize = 18;
    showcase.secondaryText = message;
    showcase.secondaryTextAlignment = NSTextAlignmentJustified;
    showcase.secondaryTextColor = [UIColor whiteColor];
    showcase.secondaryTextFont = [UIFont shabnamWithSize:16];
    showcase.secondaryTextSize = 16;
    showcase.backgroundPromptColor = [UIColor blackColor];
    showcase.backgroundPromptColorAlpha = 0.7;
    showcase.targetHolderColor = [UIColor clearColor];
    return showcase;
}

@end
