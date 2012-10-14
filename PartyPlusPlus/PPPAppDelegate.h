//
//  PPPAppDelegate.h
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "SAContentViewController.h"
#import "SAMenuViewController.h"

extern NSString *const FBSessionStateChangedNotification;
extern NSString *const FBMenuDataChangedNotification;

typedef void(^UserDataLoadedHandler)(id sender, id<FBGraphUser> user);


@interface PPPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<FBGraphUser> user;
@property (strong, nonatomic) SAContentViewController *contentViewController;
@property (strong, nonatomic) SAMenuViewController *menuViewController;
@property (strong, nonatomic) UINavigationController *contentNavigationController;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;
- (void)requestUserData:(UserDataLoadedHandler)handler;
- (void)showSideMenuWithSender:(SAContentViewController *)sender andNavigationController:(UINavigationController *)navigationController;
- (void)hideSideMenu;

@end
