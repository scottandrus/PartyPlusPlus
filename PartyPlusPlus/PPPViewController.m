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
#import "SVProgressHUD.h"

#define EVENT_PARAMS @"name,picture.type(large),attending,description,location"

@interface PPPViewController ()

@end

@implementation PPPViewController

#pragma mark - Helper methods
/*
 * Configure the logged in versus logged out UX
 */
- (void)sessionStateChanged:(NSNotification*)notification {    
    if (FBSession.activeSession.isOpen) {
//        [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
//        self.userInfoTextView.hidden = NO;
        
        FBRequestConnection *requester = [[FBRequestConnection alloc] init];
        FBRequest *request = [FBRequest requestWithGraphPath:@"me/events" parameters:[NSDictionary dictionaryWithObject:EVENT_PARAMS forKey:@"fields"] HTTPMethod:@"GET"];
        [requester addRequest:request completionHandler:^(FBRequestConnection *connection,
                                                            FBGraphObject *response,
                                                            NSError *error) {
            if (!error) {
                NSArray *eventArrayFromGraphObject = [response objectForKey:@"data"];
                NSMutableArray *tempEventArray = [[NSMutableArray alloc] initWithCapacity:4];
                for (id dict in eventArrayFromGraphObject) {
                    PPPEvent *event = [[PPPEvent alloc] initWithDictionary:dict];
                    [tempEventArray addObject:event];
                }
                self.events = [tempEventArray copy];
                [self setupMainEventsScrollView];
                self.pageLabel.text = [NSString stringWithFormat:@"%d out of %d", 1, self.events.count];
                self.pageLabel.hidden = NO;
                [SVProgressHUD showSuccessWithStatus:@"Done!"];
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
//    [self generateEvents];
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
    
    if (self.pageLabel.hidden) {
        [SVProgressHUD showWithStatus:@"Loading..."];
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
    
    self.pageLabel.hidden = YES;
    
    // Round the navigation bar
    [SAViewManipulator roundNavigationBar:self.navigationController.navigationBar];
}

//- (void)generate

- (void)generateEvents {
    // Create a mutable array to mutate events
    NSMutableArray *mutableEvents = [NSMutableArray array];

    PPPEvent *event;
    
    for (size_t i = 0; i < 10; ++i) {
        event = [[PPPEvent alloc] init];
        // Set the event properties
        // TODO: Change this to dynamic events
        event.eventName = [NSString stringWithFormat:@"HackNashville %zu", i + 1];
        event.locationString = @"7 Lea Ave.";
        event.dateString = @"Tonight\n7 PM";
        event.image = [UIImage imageNamed:@"480"];
        
        // Add it to the list of mutable events
        [mutableEvents addObject:event];
    }
    
    // Put it into the events array
    self.events = [mutableEvents copy];
}

- (void)setupMainEventsScrollView {
    
    // Set the content size first
    self.mainEventsScrollView.contentSize = CGSizeMake(self.events.count * self.mainEventsScrollView.width, self.mainEventsScrollView.height);
    
    // Create a mutable array of event views
    NSMutableArray *mutableEventViews = [NSMutableArray array];
    
    // Create an event view pointer
    PPPMainEventView *view;
    
    // For each event
    for (size_t i = 0; i < self.events.count; ++i) {

        // Allocate and initialize the associated view
        view = [[PPPMainEventView alloc] init];
        [view addSubview:[[[NSBundle mainBundle] loadNibNamed:@"PPPMainEventView" owner:view options:nil] objectAtIndex:0]];
        
        // Grab the one from interface builder
        view.frame = self.currentEventView.frame;
        view.left += self.mainEventsScrollView.width * i;
        
        // Load the corresponding event
        [view loadEvent:[self.events objectAtIndex:i]];

        
        // Add a target to the button
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        [detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        // Add the detail button to the view
        [view addSubview:detailButton];
        detailButton.size = view.size;
        
        // Add it to the scroll view
        [self.mainEventsScrollView addSubview:view];
        
        // Style the event view
        [self styleMainEventView:view];
        
        // Add object to the mutable event views array
        [mutableEventViews addObject:view];
    }
    
    // Copy into the event views property
    self.eventViews = [mutableEventViews copy];
}

- (void)goToDetail:(UIButton *)sender {
    [self performSegueWithIdentifier:@"goToDetail" sender:self.currentEvent];
}

- (void)styleMainEventView:(PPPMainEventView *)mainEventView {
    [SAViewManipulator addBorderToView:mainEventView withWidth:2 color:[UIColor blackColor] andRadius:10];
    mainEventView.clipsToBounds = YES;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.mainEventsScrollView.width;
    int page = floor((self.mainEventsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    self.pageLabel.text = [NSString stringWithFormat:@"%d out of %d", page + 1, self.events.count];
    
    if (page != [self.events indexOfObject:self.currentEvent] && page <= self.events.count && page >= 0) {
        self.currentEvent = [self.events objectAtIndex:page];
    }
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
