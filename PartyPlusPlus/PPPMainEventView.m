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
    
    CGFloat oldHeight = self.eventNameLabel.height;
    self.eventNameLabel.size = [self.eventNameLabel.text sizeWithFont:self.eventNameLabel.font constrainedToSize:CGSizeMake(self.topOverlayView.width - 15, self.eventNameLabel.height * 3)];
    CGFloat heightChange = self.eventNameLabel.height - oldHeight;
    
    self.placeLabel.top += heightChange;
    
    self.placeLabel.size = [self.placeLabel.text sizeWithFont:self.placeLabel.font constrainedToSize:CGSizeMake(self.topOverlayView.width - 15, self.placeLabel.height)];
    self.dateLabel.size = [self.dateLabel.text sizeWithFont:self.dateLabel.font constrainedToSize:CGSizeMake(self.dateLabel.width, self.dateLabel.height)];
    self.timeLabel.size = [self.timeLabel.text sizeWithFont:self.timeLabel.font constrainedToSize:CGSizeMake(self.timeLabel.width, self.timeLabel.height)];

    
    // Width calculations based on Interface Builder dimensions
    self.topOverlayView.width = MAX(self.eventNameLabel.width, self.placeLabel.width) + 15;
    self.topOverlayView.height = self.eventNameLabel.height + self.placeLabel.height + 4;
    self.topOverlayView.layer.cornerRadius = 10;
    self.bottomOverlayView.width = MAX(self.dateLabel.width, self.timeLabel.width) + 15;
    self.bottomOverlayView.layer.cornerRadius = 10;
    
    if (!self.eventNameLabel.text && !self.placeLabel.text) {
        self.topOverlayView.hidden = YES;
    } else self.topOverlayView.hidden = NO;
    
    if (!self.dateLabel.text && !self.timeLabel.text) {
        self.bottomOverlayView.hidden = YES;
    } else self.bottomOverlayView.hidden = NO;
    
    if (self.event.image.size.width >= self.size.width || self.event.image.size.height >= self.size.height) {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    
    self.imageView.image = self.event.image;
    [self downloadPhoto:event.imageURL];
}

- (void)showThumbnails {
    [self setupAttendingScrollView];
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
                UIImage *image = [UIImage imageWithData:imgUrl];
                if (image.size.width >= self.size.width || image.size.height >= self.size.height) {
                    self.imageView.contentMode = UIViewContentModeCenter;
                }
                [self.imageView setImage:[UIImage imageWithData:imgUrl]];
                [loading stopAnimating];
                [loading removeFromSuperview];
            });
        });
        dispatch_release(downloadQueue);
    }
}

- (void)downloadPhoto:(NSString *)urlStr forImageView:(UIImageView*)imageView {
    if (!self.event.image) {
        // Download photo
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading startAnimating];
        //        [self addSubview:loading];
        //        loading.center = self.center;
        
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
                [imageView setImage:[UIImage imageWithData:imgUrl]];
                imageView.hidden = NO;
                [loading stopAnimating];
                [loading removeFromSuperview];
            });
        });
        dispatch_release(downloadQueue);
    }
}


- (void)setupAttendingScrollView {
    
    // Create a main event view pointer
    UIImageView *view;
    
    self.thumbnailScrollView.contentSize = CGSizeMake((self.thumbnailImageView.width + 5) * self.attendingThumbnails.count - 5, self.thumbnailImageView.height);
    
    
    // Create events
    for (size_t i = 0; i < self.attendingThumbnails.count; ++i) {
        
        // Allocate and initialize the event
        view = [[UIImageView alloc] initWithFrame:self.thumbnailImageView.frame];
        
        view.left += -1 * (self.thumbnailImageView.width + 5) * i;
        
//        NSLog(@"%@", [self.attendingThumbnails objectAtIndex:i]);
        
        // Set the labels
        [self downloadPhoto:[self.attendingThumbnails objectAtIndex:i] forImageView:view];
        
        [SAViewManipulator addBorderToView:view withWidth:1.5 color:[UIColor whiteColor] andRadius:22];
        view.clipsToBounds = YES;
        //        [SAViewManipulator addShadowToView:view withOpacity:.8 radius:3 andOffset:CGSizeMake(1, 1)];
        
        // Add it to the subview
        [self.thumbnailScrollView addSubview:view];
//        [self addSubview:view];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
*/

@end
