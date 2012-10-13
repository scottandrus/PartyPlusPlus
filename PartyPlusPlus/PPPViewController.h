//
//  PPPViewController.h
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPMainEventView.h"

@interface PPPViewController : UIViewController

@property (strong, nonatomic) IBOutlet PPPMainEventView *currentEvent;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) IBOutlet UIScrollView *mainEventsScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *tertiaryEventsScrollview;

@end
