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

@property (strong, nonatomic) NSArray *attendingThumbnails;
@property (strong, nonatomic) IBOutlet UIScrollView *attendingScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (strong, nonatomic) IBOutlet UIScrollView *feedScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *wallPhotoImageView;

@end
