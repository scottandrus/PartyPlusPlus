//
//  PPPTertiaryEventView.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/13/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPTertiaryEventView.h"
#import "UIView+Frame.h"

@implementation PPPTertiaryEventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
//        [self style];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
//        [self style];
    }
    return self;
}

- (void)loadEvent:(PPPEvent *)event {
    self.event = event;
    
    self.label.text = self.event.eventName;
    
    self.imageView.left = CGRectGetMidX(self.bounds) - CGRectGetMidX(self.imageView.bounds);
    self.imageView.top = CGRectGetMidY(self.bounds) - CGRectGetMidY(self.imageView.bounds);
    
    self.imageView.image = self.event.image;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
