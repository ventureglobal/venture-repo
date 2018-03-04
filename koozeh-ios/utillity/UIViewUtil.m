//
//  UIViewUtil.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "UIViewUtil.h"
#import "MessageUtil.h"
#import <AFNetworking.h>

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

+ (void)showUIAlertError:(NSError *)error fromController:(UIViewController *)viewController {
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:[MessageUtil messageForKey:@"errorOkString"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Error Cancel action");
                                   }];
    NSString *alertTitle = [MessageUtil messageForKey:@"errorGeneralTitle"];
    NSString *alertMessage = [MessageUtil messageForKey:@"errorGeneralMessage"];
    if ([@"ir.bina.koozeh-ios" isEqualToString:error.domain]
        && error.userInfo != nil
        && [error.userInfo objectForKey:@"errorKey"] != nil) {
        alertTitle = [MessageUtil messageForKey:[NSString stringWithFormat:@"error%@Title", [error.userInfo objectForKey:@"errorKey"]]];
        alertMessage = [MessageUtil messageForKey:[NSString stringWithFormat:@"error%@Message", [error.userInfo objectForKey:@"errorKey"]]];
    } else if ([NSURLErrorDomain isEqualToString:error.domain] && error.code == -1004) {
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

@end
