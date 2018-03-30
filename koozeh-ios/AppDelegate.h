//
//  AppDelegate.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/6/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SlideNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property () BOOL restrictRotation;

//@property (readonly, strong) NSPersistentContainer *persistentContainer;

//- (void)saveContext;

//@TODO use these methods instead of Parent View Controller
- (void)showMessageBarForKey:(NSString *)messageKey;
- (void)hideMessageBarForKey:(NSString *)messageKey;

@end

