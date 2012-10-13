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
    self.mainEventsScrollView.contentSize = CGSizeMake(self.events.count * self.mainEventsScrollView.width, self.mainEventsScrollView.height);
}

@end
