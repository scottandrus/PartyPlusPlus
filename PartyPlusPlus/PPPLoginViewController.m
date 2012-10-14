//
//  PPPLoginViewController.m
//  PartyPlusPlus
//
//  Created by Graham Gaylor on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPLoginViewController.h"
#import "PPPAppDelegate.h"
#import "SVProgressHUD.h"
#import "UIView+Frame.h"
#import "SAViewManipulator.h"

@interface PPPLoginViewController ()

@end

@implementation PPPLoginViewController

#pragma mark - Helper methods
/*
 * Configure the logged in versus logged out UX
 */
- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        // If the session is open, cache friend data
        FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
        [cacheDescriptor prefetchAndCacheForSession:FBSession.activeSession];
        
        // Go to the menu page by dismissing the modal view controller
        // instead of using segues.
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Register for notifications on FB session state changes
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    [self customizeUI];
}


- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)customizeUI {
    // Set a gradient on the background
    [SAViewManipulator setGradientBackgroundImageForView:self.view withTopColor:[UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1] /*#1c1c1c*/ andBottomColor:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1] /*#474747*/];
    
    [SAViewManipulator setGradientBackgroundImageForView:self.loginButton withTopColor:[UIColor colorWithRed:0.11 green:0.188 blue:0.427 alpha:1] /*#1c306d*/ andBottomColor:[UIColor colorWithRed:0.231 green:0.349 blue:0.592 alpha:1] /*#3b5997*/];
    [SAViewManipulator addBorderToView:self.loginButton withWidth:.5 color:[UIColor blackColor] andRadius:10];
    self.loginButton.clipsToBounds = YES;
    
//    UIImageView *fbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb64"]];
//    [self.loginButton addSubview:fbIcon];
//    fbIcon.frame = CGRectMake(8, self.loginButton.height / 2, 80, 80);
//    fbIcon.centerY = self.loginButton.centerY;
    
    // Round the navigation bar
//    [SAViewManipulator roundNavigationBar:self.navigationController.navigationBar];
    
    // Round the view
    [SAViewManipulator addBorderToView:self.view withWidth:.5 color:[UIColor blackColor] andRadius:10];
    
    self.view.clipsToBounds = YES;
}

#pragma mark - Action methods

- (IBAction)loginButtonClicked:(id)sender {
    PPPAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
}

@end
