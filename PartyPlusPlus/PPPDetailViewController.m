//
//  PPPDetailViewController.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/13/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPDetailViewController.h"
#import "SAViewManipulator.h"
#import "UIView+Frame.h"

@interface PPPDetailViewController ()

@end

@implementation PPPDetailViewController
@synthesize attendingScrollView;
@synthesize attendingThumbnails;
@synthesize feedScrollView;
@synthesize wallPhotoImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAttendingScrollView];
    [self setupFeedScrollView];
    // Round the navigation bar
    [SAViewManipulator roundNavigationBar:self.navigationController.navigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ScrollView Methods
- (void)setupAttendingScrollView {
    
    // Create a main event view pointer
    UIImageView *view;
    
    self.attendingScrollView.contentSize = CGSizeMake(self.thumbnailImageView.width * 10, self.thumbnailImageView.height);

    
    // Create 10 events
    for (size_t i = 0; i < 9; ++i) {
        
        // Allocate and initialize the event
        view = [[UIImageView alloc] initWithFrame:self.thumbnailImageView.frame];
        
        view.left = (self.thumbnailImageView.width + 5) * i;
        
        // Set the labels
        view.image = [UIImage imageNamed:@"Thumbnail.png"];
        
        // Add it to the subview
        [self.attendingScrollView addSubview:view];
        
    }
    
}

#pragma mark - ScrollView Methods
- (void)setupFeedScrollView {
    
    // Create a main event view pointer
    UIImageView *view;
    
    self.feedScrollView.contentSize = CGSizeMake(self.wallPhotoImageView.width, self.thumbnailImageView.height * 10);
    
    
    // Create 10 events
    for (size_t i = 0; i < 9; ++i) {
        
        // Allocate and initialize the event
        view = [[UIImageView alloc] initWithFrame:self.wallPhotoImageView.frame];
        
        view.top = (self.wallPhotoImageView.height + 10) * i;
        
        // Set the labels
        view.image = [UIImage imageNamed:@"Thumbnail.png"];
        
        // Add it to the subview
        [self.feedScrollView addSubview:view];
        
    }
    
}

#pragma mark - IBActions

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setAttendingScrollView:nil];
    [self setThumbnailImageView:nil];
    [self setFeedScrollView:nil];
    [self setWallPhotoImageView:nil];
    [super viewDidUnload];
}
@end
