//
//  SAContentViewController.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/14/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "SAContentViewController.h"
#import "PPPAppDelegate.h"

@interface SAContentViewController ()

@end

@implementation SAContentViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slideMenuButtonTouched {
    PPPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
   [appDelegate showSideMenuWithSender:self andNavigationController:self.navigationController];
}

@end
