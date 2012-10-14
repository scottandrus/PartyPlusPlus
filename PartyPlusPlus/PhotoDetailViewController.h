//
//  PhotoDetailViewController.h
//  TopFlickrPlaces
//
//  Created by Scott Andrus on 5/21/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)loadImage;

@end
