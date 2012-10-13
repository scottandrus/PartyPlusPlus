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
    if (FBSession.activeSession.isOpen) {
        // If a deep link, go to the seleceted menu
//        if (self.menuLink) {
//            [self goToSelectedMenu];
//        } else {
            [self populateUserDetails];
//        }
    } else {
        [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
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

//- (void)viewDidAppear:(BOOL)animated {
//    
//}

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
    
    self.currentEvent = [[PPPEvent alloc] init];
    
    self.currentEvent.eventName = @"HackNashville";
    self.currentEvent.locationString = @"Emma";
    self.currentEvent.dateString = @"Tonight\n7 PM";
    self.currentEvent.image = [UIImage imageNamed:@"480"];
    [self.currentEventView loadEvent:self.currentEvent];
    
    // Round current event
    [self styleMainEventView:self.currentEventView];
    
    // Add the target to the button
    [self.currentEventView.detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventAllEvents];
    
    // Create a mutable array to mutate events
    NSMutableArray *mutableEvents = [NSMutableArray arrayWithObjects:self.currentEvent, nil];
    
    // Create a main event view pointer
    PPPMainEventView *view;
    PPPEvent *event;
    
    // Create 10 events
    for (size_t i = 1; i < 10; ++i) {
        
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
        
        NSLog(@"%@", view.subviews);
        NSLog(@"%@", view.detailButton);
        
        // Add it to the list of mutable events
        [mutableEvents addObject:event];
    }
    
    // Put it into the events array
    self.events = [mutableEvents copy];
    
    self.mainEventsScrollView.contentSize = CGSizeMake(self.events.count * self.mainEventsScrollView.width, self.mainEventsScrollView.height);
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
    UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
    PPPDetailViewController *dvc = (PPPDetailViewController *)nav.topViewController;
    dvc.event = sender;
    dvc.delegate = self;
}

@end
