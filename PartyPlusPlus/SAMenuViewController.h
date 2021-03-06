//
//  SAMenuViewController.h
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMenuViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *screenShotImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImage *screenShotImage;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userProfilePictureView;


@end
