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

@interface PPPViewController ()

@end

@implementation PPPViewController

#pragma mark - View Controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self customizeUI];
    [self setupMainEventsScrollView];
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d out of %d", 1, self.events.count];

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
    
    // Round current event
    [self styleMainEventView:self.currentEvent];
    
    [self.currentEvent.detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventAllEvents];
    
    // Create a mutable array to mutate events
    NSMutableArray *mutableEvents = [NSMutableArray arrayWithObjects:self.currentEvent, nil];
    
    // Create a main event view pointer
    PPPMainEventView *view;
    
    // Create 10 events
    for (size_t i = 1; i < 10; ++i) {
        
        // Allocate and initialize the event
        view = [[PPPMainEventView alloc] init];
        
        // Set the labels
        view.eventNameLabel.text = [NSString stringWithFormat:@"Event %zu", i + 1];
        view.placeLabel.text = @"Vanderbilt";
        
        [view.detailButton addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventAllEvents];
        
        // Add it to the subview
        [self.mainEventsScrollView addSubview:view];
        
        // Grab the one from interface builder
        view.origin = self.currentEvent.origin;
        view.left += self.mainEventsScrollView.width * i;
        
        // Add it to the list of mutable events
        [mutableEvents addObject:view];
    }
    
    // Put it into the events array
    self.events = [mutableEvents copy];
    
    self.currentEvent.eventNameLabel.text = @"HackNashville";
    self.currentEvent.placeLabel.text = @"Emma";
    
    self.mainEventsScrollView.contentSize = CGSizeMake(self.events.count * self.mainEventsScrollView.width, self.mainEventsScrollView.height);
}

- (void)goToDetail:(PPPMainEventView *)detail {
    [self performSegueWithIdentifier:@"goToDetail" sender:nil];
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
    dvc.delegate = self;
}

@end
