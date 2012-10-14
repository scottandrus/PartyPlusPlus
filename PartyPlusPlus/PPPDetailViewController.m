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

#define WALL_PHOTO_PARAMS @"source"
#define ATTENDING_PARAMS @"picture"

@interface PPPDetailViewController ()

@end

@implementation PPPDetailViewController
@synthesize wallPhotoURLs;
@synthesize attendingScrollView;
@synthesize attendingFriendsUrls;
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
    [self didPullEventPhotoURLsWithCallBack:^{
        [self setupFeedScrollView];
    }];
    [self didPullAttendingPhotoURLsWithCallBack:^{
        [self setupAttendingScrollView];
    }];

    
    [self customizeUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility methods 

- (void)customizeUI {
    [SAViewManipulator setGradientBackgroundImageForView:self.view withTopColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1] andBottomColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1]];
    
    [SAViewManipulator setGradientBackgroundImageForView:self.attendingScrollViewBackgroundView withTopColor:[UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1] /*#1c1c1c*/ andBottomColor:[UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1] /*#474747*/];
    [SAViewManipulator setGradientBackgroundImageForView:self.feedScrollViewBackgroundView withTopColor:[UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1] /*#1c1c1c*/ andBottomColor:[UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1] /*#474747*/];
    
    [SAViewManipulator setGradientBackgroundImageForView:self.friendsHeaderView withTopColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1] andBottomColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1]];
    [SAViewManipulator addBorderToView:self.friendsHeaderView withWidth:.5 color:[UIColor blackColor] andRadius:1];
    
    [SAViewManipulator setGradientBackgroundImageForView:self.photoStreamHeaderView withTopColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1] andBottomColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1]];
    [SAViewManipulator addBorderToView:self.photoStreamHeaderView withWidth:.5 color:[UIColor blackColor] andRadius:1];
    
//    [SAViewManipulator setGradientBackgroundImageForView:self.feedScrollView withTopColor:[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1] andBottomColor:[UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1]];
    
    // Round the navigation bar
    [SAViewManipulator roundNavigationBar:self.navigationController.navigationBar];
}

#pragma mark - ScrollView Methods
- (void)setupAttendingScrollView {
    
    // Create a main event view pointer
    UIImageView *view;
    
    self.attendingScrollView.contentSize = CGSizeMake((self.thumbnailImageView.width + 5) * self.attendingFriendsUrls.count, self.thumbnailImageView.height);

    
    // Create 10 events
    for (size_t i = 0; i < self.attendingFriendsUrls.count; ++i) {
        
        // Allocate and initialize the event
        view = [[UIImageView alloc] initWithFrame:self.thumbnailImageView.frame];
        
        view.left = (self.thumbnailImageView.width + 5) * i;
        
        // Set the labels
        [self downloadPhoto:[self.attendingFriendsUrls objectAtIndex:i] forImageView:view];
        
        // Add it to the subview
        [self.attendingScrollView addSubview:view];
        
    }
    
}

#pragma mark - ScrollView Methods
- (void)setupFeedScrollView {
    
    // Create a main event view pointer
    UIImageView *view;
    
    self.feedScrollView.contentSize = CGSizeMake((self.wallPhotoImageView.width + 10) * self.wallPhotoURLs.count, self.wallPhotoImageView.height);
    
    
    // Create 10 events
    for (size_t i = 0; i < self.wallPhotoURLs.count; ++i) {
        
        // Allocate and initialize the event
        view = [[UIImageView alloc] initWithFrame:self.wallPhotoImageView.frame];
        
        view.left = (self.wallPhotoImageView.width + 10) * i;
        
        // Set the labels
//        view.image = [UIImage imageNamed:@"Thumbnail.png"];
        [self downloadPhoto:[self.wallPhotoURLs objectAtIndex:i] forImageView:view];
        
        // Add it to the subview
        [self.feedScrollView addSubview:view];
        
    }
    
}

#pragma mark - Facebook API Calls
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
                [loading stopAnimating];
                [loading removeFromSuperview];
            });
        });
        dispatch_release(downloadQueue);
    }
}


- (void)didPullEventPhotoURLsWithCallBack:(void (^)(void))callback; {
    
    FBRequestConnection *requester = [[FBRequestConnection alloc] init];
    NSString *graphPath = [NSString stringWithFormat:@"/%@/photos", self.event.eventId];
    FBRequest *request = [FBRequest requestWithGraphPath:graphPath parameters:[NSDictionary dictionaryWithObject:WALL_PHOTO_PARAMS forKey:@"fields"] HTTPMethod:@"GET"];
    [requester addRequest:request completionHandler:^(FBRequestConnection *connection,
                                                      FBGraphObject *response,
                                                      NSError *error) {
        if (!error) {
            
            // Ok, so grab an event array
            NSArray *eventArrayFromGraphObject = [response objectForKey:@"data"];
            
            // temp event array to hold
            NSMutableArray *tempPhotoArray = [NSMutableArray array];
            for (id dict in eventArrayFromGraphObject) {
                NSString *photoURL = [dict objectForKey:@"source"];
                [tempPhotoArray addObject:photoURL];
            }
            
            // Create an immutable copy for the property
            self.wallPhotoURLs = [tempPhotoArray copy];
            callback();
            
//            // Ok, events are loaded, set up the Main Events scroll view
//            [self setupMainEventsScrollView];
//            
//            // Grab the current page and number of pages while we're here
//            self.pageControl.currentPage = 0;
//            self.pageControl.numberOfPages = self.events.count;
//            
//            // Show that page control
//            self.pageControl.hidden = NO;
//            
//            // Dismiss our SVProgressHUD
//            [SVProgressHUD showSuccessWithStatus:@"Done!"];
        }
        
    }];
    
    [requester start];

}

- (void)didPullAttendingPhotoURLsWithCallBack:(void (^)(void))callback; {
    
    FBRequestConnection *requester = [[FBRequestConnection alloc] init];
    NSString *graphPath = [NSString stringWithFormat:@"/%@/attending", self.event.eventId];
    FBRequest *request = [FBRequest requestWithGraphPath:graphPath parameters:[NSDictionary dictionaryWithObject:ATTENDING_PARAMS forKey:@"fields"] HTTPMethod:@"GET"];
    [requester addRequest:request completionHandler:^(FBRequestConnection *connection,
                                                      FBGraphObject *response,
                                                      NSError *error) {
        if (!error) {
            
            // Ok, so grab an event array
            NSArray *eventArrayFromGraphObject = [response objectForKey:@"data"];
            
            // temp event array to hold
            NSMutableArray *tempPhotoArray = [NSMutableArray array];
            for (id dict in eventArrayFromGraphObject) {
                NSString *photoURL = [[[dict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                [tempPhotoArray addObject:photoURL];
            }
            
            // Create an immutable copy for the property
            self.attendingFriendsUrls = [tempPhotoArray copy];
            callback();
            
            //            // Ok, events are loaded, set up the Main Events scroll view
            //            [self setupMainEventsScrollView];
            //
            //            // Grab the current page and number of pages while we're here
            //            self.pageControl.currentPage = 0;
            //            self.pageControl.numberOfPages = self.events.count;
            //
            //            // Show that page control
            //            self.pageControl.hidden = NO;
            //
            //            // Dismiss our SVProgressHUD
            //            [SVProgressHUD showSuccessWithStatus:@"Done!"];
        }
        
    }];
    
    [requester start];
    
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
    [self setFriendsHeaderView:nil];
    [self setPhotoStreamHeaderView:nil];
    [self setAttendingScrollViewBackgroundView:nil];
    [self setFeedScrollViewBackgroundView:nil];
    [super viewDidUnload];
}
@end
