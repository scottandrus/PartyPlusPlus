//
//  PPPViewController.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPViewController.h"
#import "UIView+Frame.h"

@interface PPPViewController ()

@end

@implementation PPPViewController

#pragma mark - View Controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupMainEventsScrollView];
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

#pragma mark - Utility methods

- (void)setupMainEventsScrollView {
    
    NSMutableArray *mutableEvents = [NSMutableArray arrayWithObjects:self.currentEvent, nil];
    
    // Create a main event view pointer
    PPPMainEventView *view;
    
    // Create 10 events
    for (size_t i = 1; i < 10; ++i) {
        
        // Allocate and initialize the event
        view = [[PPPMainEventView alloc] init];
        
        // Grab the one from interface builder
        view.origin = self.currentEvent.origin;
        view.left += self.mainEventsScrollView.width * i;
        
        // Set the labels
        view.eventNameLabel.text = [NSString stringWithFormat:@"Event %zu", i + 1];
        view.placeTimeLabel.text = @"Next Week";
        
        // Add it to the subview
        [self.mainEventsScrollView addSubview:view];
        [mutableEvents addObject:view];
    }
    
    // Put it into the events array
    self.events = [mutableEvents copy];
    
    self.currentEvent.eventNameLabel.text = @"HackNashville";
    self.currentEvent.placeTimeLabel.text = @"Tonight";
    
    self.mainEventsScrollView.contentSize = CGSizeMake(self.events.count * self.mainEventsScrollView.width, self.mainEventsScrollView.height);
}

@end
