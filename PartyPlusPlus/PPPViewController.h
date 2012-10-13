//
//  PPPViewController.h
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPMainEventView.h"

@interface PPPViewController : UIViewController <UIScrollViewDelegate>

// Non-IB
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) PPPEvent *currentEvent;

// IBOutlets
@property (strong, nonatomic) IBOutlet PPPMainEventView *currentEventView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainEventsScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *tertiaryEventsScrollview;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;

@end
