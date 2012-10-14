//
//  PPPTertiaryEventView.h
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/13/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPPEvent.h"

@interface PPPTertiaryEventView : UIView

@property (strong, nonatomic) PPPEvent *event;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (void)loadEvent:(PPPEvent *)event;

@end
