//
//  SAMenuViewController.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "SAMenuViewController.h"
#import "PPPAppDelegate.h"
#import "PPPViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface SAMenuViewController ()

@end

@implementation SAMenuViewController

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
    
    // create a UITapGestureRecognizer to detect when the screenshot recieves a single tap
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapScreenShot:)];
    [self.screenShotImageView addGestureRecognizer:self.tapGesture];
    
    // create a UIPanGestureRecognizer to detect when the screenshot is touched and dragged
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMoveAround:)];
    [self.panGesture setMaximumNumberOfTouches:2];
    [self.panGesture setDelegate:self];
    [self.screenShotImageView addGestureRecognizer:self.panGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // remove the gesture recognizers
    [self.screenShotImageView removeGestureRecognizer:self.tapGesture];
    [self.screenShotImageView removeGestureRecognizer:self.panGesture];
}

- (void)singleTapScreenShot:(UITapGestureRecognizer *)gestureRecognizer
{
    // on a single tap of the screenshot, assume the user is done viewing the menu
    // and call the slideThenHide function
    [self slideThenHide];
}

/* The following is from http://blog.shoguniphicus.com/2011/06/15/working-with-uigesturerecognizers-uipangesturerecognizer-uipinchgesturerecognizer/ */
-(void)panGestureMoveAround:(UIPanGestureRecognizer *)gesture;
{
    UIView *piece = [gesture view];
    [self adjustAnchorPointForGestureRecognizer:gesture];
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:[piece superview]];
        
        // I edited this line so that the image view cannont move vertically
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y)];
        [gesture setTranslation:CGPointZero inView:[piece superview]];
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded)
        [self slideThenHide];
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // when the menu view appears, it will create the illusion that the other view has slide to the side
    // what its actually doing is sliding the screenShotImage passed in off to the side
    // to start this, we always want the image to be the entire screen, so set it there
    [self.screenShotImageView setImage:self.screenShotImage];
    [self.screenShotImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    // now we'll animate it across to the right over 0.2 seconds with an Ease In and Out curve
    // this uses blocks to do the animation. Inside the block the frame of the UIImageView has its
    // x value changed to where it will end up with the animation is complete.
    // this animation doesn't require any action when completed so the block is left empty
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.screenShotImageView setFrame:CGRectMake(240, 0, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished){}];
}

- (IBAction)showViewController {
    // this sets the currentViewController on the app_delegate to the expanding view controller
    // then slides the screenshot back over
//    PPPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate setContentViewController:appDelegate.contentViewController];
    [self slideThenHide];
}

- (void)slideThenHide {
    // this animates the screenshot back to the left before telling the app delegate to swap out the MenuViewController
    // it tells the app delegate using the completion block of the animation
    PPPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.screenShotImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished){
        [appDelegate hideSideMenu];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
