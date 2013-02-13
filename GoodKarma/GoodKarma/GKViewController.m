//
//  GKViewController.m
//  GoodKarma
//
//  Created by Will Saults on 2/12/13.
//  Copyright (c) 2013 Fullsail. All rights reserved.
//

#import "GKViewController.h"
#define kGenericTaskRewardKarmaPoints 40

@interface GKViewController () {
    IBOutlet UILabel *karmaScoreLabel;
}

@end

@implementation GKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)completeTask:(id)sender {
    [self increaseKarmaScore];
}

-(void)increaseKarmaScore {
    [karmaScoreLabel setText:[NSString stringWithFormat:@"%d", [[karmaScoreLabel text] integerValue] + kGenericTaskRewardKarmaPoints]];
}

@end
