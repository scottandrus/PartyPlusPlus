//
//  PhotoDetailViewController.m
//  TopFlickrPlaces
//
//  Created by Scott Andrus on 5/21/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "SVProgressHUD.h"

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PhotoDetailViewController
@synthesize scrollView = _scrollView;
@synthesize image = _image;

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
	// Do any additional setup after loading the view.
    self.scrollView.delegate = self;
    self.splitViewController.delegate = self;
    [self loadImage];
}

- (void)loadImage
{
    self.imageView.image = self.image;
}

- (IBAction)backPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender {
    [self saveImageToSavedPhotosAlbum:self.image];
}

- (void)saveImageToSavedPhotosAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        [SVProgressHUD showErrorWithStatus:@"Error saving photo."];
    }
    else  // No errors
    {
        // Show message image successfully saved
        [SVProgressHUD showSuccessWithStatus:@"Saved to Camera Roll"];
    }
}

//- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
//    return UIInterfaceOrientationIsPortrait(orientation);
//}

//- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem {
//    UIToolbar *toolbar = self.toolbar;
//    NSMutableArray *toolbarItems = [toolbar.items mutableCopy];
//    if (_splitViewBarButtonItem) {
//        [toolbarItems insertObject:barButtonItem atIndex:0];
//        toolbar.items = toolbarItems;
//        _
//    }
//}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [[self.scrollView subviews] objectAtIndex:0];
}

@end
