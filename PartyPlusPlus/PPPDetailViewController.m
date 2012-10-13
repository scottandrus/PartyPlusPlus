//
//  PPPDetailViewController.m
//  PartyPlusPlus
//
//  Created by Scott Andrus on 10/13/12.
//  Copyright (c) 2012 Tapatory. All rights reserved.
//

#import "PPPDetailViewController.h"

@interface PPPDetailViewController ()

@end

@implementation PPPDetailViewController

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

#pragma mark IBActions

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    [self.delegate dismissViewControllerAnimated:YES completion:nil];
}

@end
