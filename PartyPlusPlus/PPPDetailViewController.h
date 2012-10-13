//
//  PPPDetailViewController.h
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/13/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPViewController.h"

@interface PPPDetailViewController : UIViewController

@property (strong, nonatomic) PPPEvent *event;

@property (strong, nonatomic) PPPViewController *delegate;

@end
