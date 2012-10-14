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
#import "PPPPost.h"

#define WALL_PHOTO_PARAMS @"source"
#define ATTENDING_PARAMS @"picture"

@interface PPPDetailViewController ()

@end

@implementation PPPDetailViewController
@synthesize posts;
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
    
    self.attendingScrollView.contentSize = CGSizeMake(self.thumbnailImageView.width * self.attendingFriendsUrls.count, self.thumbnailImageView.height);

    
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
    
    self.feedScrollView.contentSize = CGSizeMake(self.wallPhotoImageView.width, self.wallPhotoImageView.height * self.posts.count);
    
    
    // Create 10 events
    for (size_t i = 0; i < self.posts.count; ++i) {
        
        // Allocate and initialize the event
        view = [[UIImageView alloc] initWithFrame:self.wallPhotoImageView.frame];
        
        view.top = (self.wallPhotoImageView.height + 10) * i;
        
        // Set the labels
//        view.image = [UIImage imageNamed:@"Thumbnail.png"];
        PPPPost *post = [self.posts objectAtIndex:i];
        [self downloadPhoto:post.imageURL forImageView:view];
        
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

- (void)didPullFeedWithCallBack:(void (^)(void))callback; {
    
    FBRequestConnection *requester = [[FBRequestConnection alloc] init];
    NSString *graphPath = [NSString stringWithFormat:@"/%@/feed", self.event.eventId];
    FBRequest *request = [FBRequest requestWithGraphPath:graphPath parameters:nil HTTPMethod:@"GET"];
    [requester addRequest:request completionHandler:^(FBRequestConnection *connection,
                                                      FBGraphObject *response,
                                                      NSError *error) {
        if (!error) {
            
            // Ok, so grab an event array
            NSArray *eventArrayFromGraphObject = [response objectForKey:@"data"];
            
            // temp event array to hold
            NSMutableArray *tempPostArray = [NSMutableArray array];
            for (id dict in eventArrayFromGraphObject) {
//                NSString *photoURL = [dict objectForKey:@"source"];
//                NSString *dateString = [dict objectForKey:@"created_time"];
//                PPPPost *post = [[PPPPost alloc] initWithImageUrl:photoURL andDateString:dateString];
//                [tempPostArray addObject:post];
            }
            
            // Create an immutable copy for the property
            self.posts = [tempPostArray copy];
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
            NSMutableArray *tempPostArray = [NSMutableArray array];
            for (id dict in eventArrayFromGraphObject) {
                NSString *photoURL = [dict objectForKey:@"source"];
                NSString *dateString = [dict objectForKey:@"created_time"];
                PPPPost *post = [[PPPPost alloc] initWithImageUrl:photoURL andDateString:dateString];
                [tempPostArray addObject:post];
            }
            
            // Create an immutable copy for the property
            self.posts = [tempPostArray copy];
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
    [self setFeedScrollView:nil];
    [self setPosts:nil];
    [super viewDidUnload];
}
@end
