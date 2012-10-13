//
//  PPPViewController.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

// Frameworks
#import <QuartzCore/QuartzCore.h>

// Class files
#import "PPPViewController.h"
#import "UIView+Frame.h"
#import "SAViewManipulator.h"
#import "PPPDetailViewController.h"
#import "PPPAppDelegate.h"

@interface PPPViewController ()

@end

@implementation PPPViewController

#pragma mark - Helper methods
/*
 * Configure the logged in versus logged out UX
 */
- (void)sessionStateChanged:(NSNotification*)notification {
//    if (FBSession.activeSession.isOpen) {
//        [self populateUserDetails];
//        FBSession *session = notification.object;
//        NSLog(@"%@", session);
//        FBRequest *request = [[FBRequest alloc] initWithSession:[FBSession activeSession] restMethod:@"GET" parameters:[NSDictionary dictionary] HTTPMethod:@"GET"];
//        [delegate facebook];
//    } else {
//        [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
//    }
    
    if (FBSession.activeSession.isOpen) {
//        [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
//        self.userInfoTextView.hidden = NO;
        
        FBRequestConnection *requester = [[FBRequestConnection alloc] init];
        [requester addRequest:[FBRequest requestForGraphPath:@"me/events"] completionHandler:^(FBRequestConnection *connection,
                                                            NSArray *response,
                                                            NSError *error) {
            if (!error) {
                NSLog(@"%@", response);
                for (id dict in response) {
                    PPPEvent *event = [[PPPEvent alloc] init];
                    [dict objectForKey:@"id"];
                    [dict objectForKey:@"name"];
                    [dict objectForKey:@"start_time"];
                    [dict objectForKey:@"end_time"];
                    [dict objectForKey:@"rsvp_status"];
                }
            }
            
        }];
        
        [requester start];
    }
    

        
}

- (void)populateUserDetails {
    PPPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate requestUserData:^(id sender, id<FBGraphUser> user) {
//        self.userNameLabel.text = user.name;
//        self.userProfilePictureView.profileID = [user objectForKey:@"id"];
        NSLog(@"%@", user.name);
    }];
}

#pragma mark - View Controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Register for notifications on FB session state changes
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    [self customizeUI];
    [self setupMainEventsScrollView];
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d out of %d", 1, self.events.count];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        // If the user's session is active, personalize, but
        // only if this is not deep linking into the order view.
        [self populateUserDetails];
    } else if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Check the session for a cached token to show the proper authenticated
        // UI. However, since this is not user intitiated, do not show the login UX.
        PPPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Present login modal if necessary after the view has been
    // displayed, not in viewWillAppear: so as to allow display
    // stack to "unwind"
    if (FBSession.activeSession.isOpen) {
//        [self goToSelectedMenu];
    } else if (FBSession.activeSession.isOpen ||
               FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded ||
               FBSession.activeSession.state == FBSessionStateCreatedOpening) {
    } else {
        [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCurrentEventView:nil];
    [self setMainEventsScrollView:nil];
    [self setTertiaryEventsScrollview:nil];
    [self setBackgroundView:nil];
    [self setPageLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Utility methods

- (void)customizeUI {
    [SAViewManipulator setGradientBackgroundImageForView:self.backgroundView withTopColor:[UIColor colorWithRed:0.875 green:0.875 blue:0.875 alpha:1] /*#dfdfdf*/ andBottomColor:[UIColor colorWithRed:0.549 green:0.549 blue:0.549 alpha:1] /*#8c8c8c*/];
    
    // Set a gradient on the navigation bar
//    [SAViewManipulator setGradientBackgroundImageForView:self.navigationController.navigationBar withTopColor:[UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1] /*#f7f7f7*/ andBottomColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1] /*#e8e8e8*/];
    
    // Round the navigation bar
    [SAViewManipulator roundNavigationBar:self.navigationController.navigationBar];
}

- (void)setupMainEventsScrollView {
    
    // Set up current event view
    [self setupCurrentEventView];
    
    // Round current event
//    [self styleMainEventView:self.currentEventView];
    
    // Add the target to the button
    [self.currentEventView.detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventAllEvents];
    
    // Create a mutable array to mutate events
    NSMutableArray *mutableEvents = [NSMutableArray arrayWithObjects:self.currentEvent, nil];
    
    // Create a main event view pointer
    PPPMainEventView *view;
    PPPEvent *event;
    
    // Create 10 events
    for (size_t i = 0; i < 10; ++i) {
        
        // Allocate and initialize the event
        view = [[PPPMainEventView alloc] init];
        event = [[PPPEvent alloc] init];
        
        // Set the labels
        event.eventName = [NSString stringWithFormat:@"Event %zu", i + 1];
        event.locationString = @"Vanderbilt";
        event.dateString = @"Next Week\n7 PM";
        event.image = [UIImage imageNamed:@"480"];
        
        [view loadEvent:event];
        
        // Add it to the subview
        [self.mainEventsScrollView addSubview:view];
        
        // Add a target to the button
        [view.detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventAllEvents];
        
        // Grab the one from interface builder
        view.origin = self.currentEventView.origin;
        view.left += self.mainEventsScrollView.width * i;
        
        // Style the event view
        [self styleMainEventView:view];
        
        // Add it to the list of mutable events
        [mutableEvents addObject:event];
    }
    
    // Put it into the events array
    self.events = [mutableEvents copy];
    
    self.mainEventsScrollView.contentSize = CGSizeMake(self.events.count * self.mainEventsScrollView.width, self.mainEventsScrollView.height);
}

- (void)setupCurrentEventView {
//    self.currentEvent = [[PPPEvent alloc] init];
//    self.currentEvent.eventName = @"HackNashville";
//    self.currentEvent.locationString = @"Emma";
//    self.currentEvent.dateString = @"Tonight\n7 PM";
//    self.currentEvent.image = [UIImage imageNamed:@"480"];
//    [self.currentEventView loadEvent:self.currentEvent];
    
    
}

- (void)goToDetail:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToDetail" sender:self.currentEvent];
}

- (void)styleMainEventView:(PPPMainEventView *)mainEventView {
    mainEventView.clipsToBounds = YES;
    [SAViewManipulator addBorderToView:mainEventView withWidth:2 color:[UIColor blackColor] andRadius:10];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.mainEventsScrollView.width;
    int page = floor((self.mainEventsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageLabel.text = [NSString stringWithFormat:@"%d out of %d", page + 1, self.events.count];
}


#pragma mark - Storyboard methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        PPPDetailViewController *dvc = (PPPDetailViewController *)nav.topViewController;
        dvc.event = sender;
        dvc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"segueToLogin"]) {
        
    }
}

@end
