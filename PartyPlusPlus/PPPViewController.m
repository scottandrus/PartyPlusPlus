//
//  PPPViewController.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPViewController.h"
#import "PPPAppDelegate.h"

@interface PPPViewController ()

@end

@implementation PPPViewController

#pragma mark - Helper methods

/*
 * Configure the logged in versus logged out UX
 */
- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    } else {
        [self performSegueWithIdentifier:@"DisplayLoginViewController" sender:self];
    }
}


- (void)populateUserDetails {
    PPPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate requestUserData:^(id sender, id<FBGraphUser> user) {
        NSLog(@"%@", user.name);
    }];
}
  

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register for notifications on FB session state changes
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController performSegueWithIdentifier:@"DisplayLoginViewController" sender:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCurrentEvent:nil];
    [self setMainEventsScrollView:nil];
    [self setTertiaryEventsScrollview:nil];
    [super viewDidUnload];
}
@end
