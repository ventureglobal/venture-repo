//
//  CustomMessageBarViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomMessageBarDelegate <NSObject>

@optional
- (CGRect)customMessagBarFrame;
- (CGPoint)customMessageBarPosition;
- (void)checkInternetConnection;
- (void)hideInternetConnectionError;
- (void)showMessageBarForKey:(NSString *)messageKey;
- (void)hideMessageBarForKey:(NSString *)messageKey;

@end
@interface CustomMessageBarViewController : UIViewController <CustomMessageBarDelegate>

- (void)checkInternetConnection;
- (void)hideInternetConnectionError;
- (void)showMessageBarForKey:(NSString *)messageKey;
- (void)hideMessageBarForKey:(NSString *)messageKey;

- (void)showOverlayActivityIndicator;
- (void)hideOverlayActivityIndicator;
- (void)restrictRotation:(BOOL)restriction;

@end
