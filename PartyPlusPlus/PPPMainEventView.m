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
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

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
    if ([self.event.locationString isKindOfClass:[NSNull class]]) {
         self.placeLabel.text =  @"";
    } else {
        self.placeLabel.text = self.event.locationString;
    }
   
    self.dateLabel.text = self.event.dateString;
    self.timeLabel.text = self.event.timeString;
    
    self.imageView.left = CGRectGetMidX(self.bounds) - CGRectGetMidX(self.imageView.bounds);
    self.imageView.top = CGRectGetMidY(self.bounds) - CGRectGetMidY(self.imageView.bounds);
    
    self.eventNameLabel.size = [self.eventNameLabel.text sizeWithFont:self.eventNameLabel.font constrainedToSize:CGSizeMake(self.topOverlayView.width - 15, self.eventNameLabel.height)];
    self.placeLabel.size = [self.placeLabel.text sizeWithFont:self.placeLabel.font constrainedToSize:CGSizeMake(self.topOverlayView.width - 15, self.placeLabel.height)];
    self.dateLabel.size = [self.dateLabel.text sizeWithFont:self.dateLabel.font constrainedToSize:CGSizeMake(self.dateLabel.width, self.dateLabel.height)];
    self.timeLabel.size = [self.timeLabel.text sizeWithFont:self.timeLabel.font constrainedToSize:CGSizeMake(self.timeLabel.width, self.timeLabel.height)];

    
    // Width calculations based on Interface Builder dimensions
    self.topOverlayView.width = MAX(self.eventNameLabel.width, self.placeLabel.width) + 15;
    self.topOverlayView.layer.cornerRadius = 10;
    self.bottomOverlayView.width = MAX(self.dateLabel.width, self.timeLabel.width) + 15;
    self.bottomOverlayView.layer.cornerRadius = 10;
    
    if (!self.eventNameLabel.text && !self.placeLabel.text) {
        self.topOverlayView.hidden = YES;
    } else self.topOverlayView.hidden = NO;
    
    if (!self.dateLabel.text && !self.timeLabel.text) {
        self.bottomOverlayView.hidden = YES;
    } else self.bottomOverlayView.hidden = NO;
    
    self.imageView.image = self.event.image;
    [self downloadPhoto:event.imageURL];
}

- (void)downloadPhoto:(NSString *)urlStr {
    if (!self.event.image) {
        // Download photo
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading startAnimating];
        [self addSubview:loading];
        loading.center = self.center;
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            // TODO: Add a different image for each location
            NSData *imgUrl;
            if (!urlStr) {
                imgUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://placekitten.com/g/480/480"]];
            } else {
                imgUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView setImage:[UIImage imageWithData:imgUrl]];
                [loading stopAnimating];
                [loading removeFromSuperview];
            });
        });
        dispatch_release(downloadQueue);
    }
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
