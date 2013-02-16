//
//  GKLoginViewController.m
//  GoodKarma
//
//  Created by Will Saults on 2/16/13.
//  Copyright (c) 2013 Fullsail. All rights reserved.
//

#import "GKLoginViewController.h"

#import "GKAppDelegate.h"

@implementation GKLoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender {
    NSLog(@"login!");
    
    GKAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSessionWithAllowLoginUI:YES];
}

@end
