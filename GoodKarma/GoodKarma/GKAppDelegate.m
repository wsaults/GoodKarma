//
//  GKAppDelegate.m
//  GoodKarma
//
//  Created by Will Saults on 2/12/13.
//  Copyright (c) 2013 Fullsail. All rights reserved.
//

#import "GKAppDelegate.h"
#import "GKViewController.h"
#import "GKLoginViewController.h"

@interface GKAppDelegate ()

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) GKLoginViewController *mainViewController;
@property (strong, nonatomic) GKLoginViewController* loginViewController;
@property (strong, nonatomic) UIViewController *topViewController;

- (void)showLoginView;

@end


@implementation GKAppDelegate

NSString *const SCSessionStateChangedNotification = @"com.facebook.GoodKarma:SCSessionStateChangedNotification";

@synthesize mainViewController = _mainViewController;
@synthesize navController = _navController;
@synthesize loginViewController = _loginViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBProfilePictureView class];
    
    self.mainViewController = [[GKLoginViewController alloc] initWithNibName:@"GKLoginViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    
    [self.window makeKeyAndVisible];
    
    if (![self openSessionWithAllowLoginUI:NO]) {
        [self showLoginView];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

- (void)createAndPresentLoginView {
    if (self.loginViewController == nil) {
        self.loginViewController = [[GKLoginViewController alloc] initWithNibName:@"GKLoginViewController" bundle:nil];
        [_loginViewController.view setTag:1];
        [self.window addSubview:_loginViewController.view];
        
//        _topViewController = [self.navController topViewController];
//        [_topViewController presentViewController:self.loginViewController animated:NO completion:^{}];
    }
}

- (void)showLoginView {
    if (self.loginViewController == nil) {
        [self createAndPresentLoginView];
    } else {
//        [self.loginViewController loginFailed];
    }
}

#pragma mark - FB session handling
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    NSLog(@"state changed: state %d", state);
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"dismiss view controller");
            for (UIView *view in self.window.subviews) {
                if ([view isKindOfClass:[UIView class]] && view.tag == 1) {
                    [view removeFromSuperview];
                }
            }
            [_topViewController dismissViewControllerAnimated:YES completion:^{}];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %@", [GKAppDelegate FBErrorCodeDescription:error.code]]
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSLog(@"open session");
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"return from session");
    return [FBSession.activeSession handleOpenURL:url];
}

+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
    switch(code){
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
        case FBErrorNativeDialog:{
            return @"FBErrorNativeDialog";
        }
        default:
            return @"[Unknown]";
    }
}

@end
