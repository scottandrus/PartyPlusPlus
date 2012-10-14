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
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action methods

- (IBAction)loginButtonClicked:(id)sender {
    PPPAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (IBAction)bypassPressed {
//    [self performSegueWithIdentifier:@"loggedIn" sender:self];
}



@end
