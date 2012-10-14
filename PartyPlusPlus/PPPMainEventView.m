//
//  PPPMainEventView.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/12/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPMainEventView.h"
#import "SAViewManipulator.h"
#import "UIView+Frame.h"

@implementation PPPMainEventView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//        
//    }
//    return self;
//}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
    }
    return self;
}

- (void)loadEvent:(PPPEvent *)event {
    self.event = event;
    
    self.eventNameLabel.text = self.event.eventName;
    self.placeLabel.text = self.event.locationString;
    self.dateLabel.text = self.event.dateString;
    self.imageView.image = self.event.image;
}


- (void)setupAttendingScrollView {
    
    // Round current event
    //    [self styleMainEventView:self.currentEvent];
    
    // Create a mutable array to mutate events
    NSMutableArray *mutableThumbnails = [NSMutableArray arrayWithObjects:self.thumbnailImageView, nil];
    
    // Create a main event view pointer
    UIImageView *view;
    
    // Create 10 events
    for (size_t i = 1; i < 10; ++i) {
        
        // Allocate and initialize the event
        view = [[UIImageView alloc] initWithFrame:self.imageView.frame];
        
        view.left -= (self.thumbnailImageView.width + 5) * i;
        
        // Set the labels
        view.image = [UIImage imageNamed:@"Thumbnail.png"];
        
        // Add it to the subview
        [self.thumbnailScrollView addSubview:view];
        
        
        [mutableThumbnails addObject:view];
        
        //        [self styleMainEventView:view];
    }
    
    // Put it into the events array
    self.attendingThumbnails = [mutableThumbnails copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
*/

@end
