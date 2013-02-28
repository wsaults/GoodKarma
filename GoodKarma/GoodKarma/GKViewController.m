//
//  GKViewController.m
//  GoodKarma
//
//  Created by Will Saults on 2/12/13.
//  Copyright (c) 2013 Fullsail. All rights reserved.
//

#import "GKViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GKLoginViewController.h"
#import "GKAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define kGenericTaskRewardKarmaPoints 40
#define kSurveyUrl @"https://docs.google.com/forms/d/1nGfP66xIXPUpJfK_ODuNTgBrO1DCbUkfUjHiCdvFwOU/viewform"

@interface GKViewController () {
    IBOutlet UILabel *karmaScoreLabel;
    IBOutlet UITextField *taskTextField;
    
    NSArray *tasks;
    NSMutableArray *taskHistory;
    
    IBOutlet UICollectionView *taskHistoryCollectionView;
    
    GKLoginViewController* loginViewController;
}

@property (nonatomic,strong) IBOutlet FBProfilePictureView *userProfileImage;
@property (nonatomic,strong) IBOutlet UILabel *userNameLabel;

-(IBAction)completeTask:(id)sender;
-(IBAction)skipTask:(id)sender;
-(IBAction)tapActionButton:(id)sender;
-(void)increaseKarmaScore;
-(void)showNextTask;
-(void)setTaskTextFieldWithString:(NSString *)string;

@end

@implementation GKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    taskHistory = [NSMutableArray new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Tasks" ofType:@"plist"];
    tasks = [[NSArray alloc] initWithContentsOfFile:path];
    [self setTaskTextFieldWithString:[tasks objectAtIndex:0]];
    
    [taskHistoryCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:SCSessionStateChangedNotification object:nil];
}

-(void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // If the user is not authenticated with Facebook then display the login view.
    // See if we have a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"FBSessionStateCreatedTokenLoaded");
        [self populateUserDetails];
    } else {
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)completeTask:(id)sender {
    [self increaseKarmaScore];
}

-(IBAction)skipTask:(id)sender {
    [self showNextTask];
}

-(IBAction)tapActionButton:(id)sender {
    NSURL *url = [[NSURL alloc] initWithString:kSurveyUrl];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)increaseKarmaScore {
    [karmaScoreLabel setText:[NSString stringWithFormat:@"%d", [[karmaScoreLabel text] integerValue] + kGenericTaskRewardKarmaPoints]];
    [self showNextTask];
}

-(void)showNextTask {
    [taskHistory addObject:[NSString stringWithFormat:@"%@", taskTextField.text]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [taskHistoryCollectionView insertItemsAtIndexPaths:@[indexPath]];
    [self setTaskTextFieldWithString:[tasks objectAtIndex:arc4random() % [tasks count]]];
}

-(void)setTaskTextFieldWithString:(NSString *)string {
    [taskTextField setText:string];
}

#pragma mark - Collection View methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [taskHistory count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    for (UILabel *label in [cell subviews]) {
        [label removeFromSuperview];
    }
    
    NSArray *reversedArray = [[taskHistory reverseObjectEnumerator] allObjects];
    UILabel *taskText = [[UILabel alloc] initWithFrame:cell.frame];
    [taskText setText:[reversedArray objectAtIndex:indexPath.row]];
    [taskText setFont:[UIFont systemFontOfSize:12]];
    [taskText setTextColor:[UIColor colorWithRed:31.0f/255.0f green:96.0f/255.0f blue:127.0f/255.0f alpha:1]];
    [taskText setTextAlignment:NSTextAlignmentCenter];
    [taskText setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:taskText];
    
    return cell;
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

#pragma mark - FB user info method
- (void)populateUserDetails {
    NSLog(@"populateUserDetails");
    if (FBSession.activeSession.isOpen) {        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
                 [self.userProfileImage.layer setCornerRadius:5.f];
             }
         }];
    }
}

@end
