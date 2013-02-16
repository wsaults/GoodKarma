//
//  GKAppDelegate.h
//  GoodKarma
//
//  Created by Will Saults on 2/12/13.
//  Copyright (c) 2013 Fullsail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const SCSessionStateChangedNotification;

//extern NSString *const SCSessionStateChangedNotification;

@interface GKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code;


@end
