//
//  AppDelegate.m
//  DBRoulette
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "AppDelegate.h"
#import "PhotoViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSString *appKey;
  if (!appKey) {
    NSString *message = @"You need to set your app key in `AppDelegate.m` before you can use DBRoulette.";
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"Must set app key"
                                            message:message
                                     preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];

    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:alertController
                                                 animated:NO
                                               completion:^{
                                                 [NSException raise:@"FatalError" format:@"%@", message];
                                               }];
  }
  [DropboxClientsManager setupWithAppKey:appKey];
  return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  DBOAuthResult *authResult = [DropboxClientsManager handleRedirectURL:url];
  if (authResult != nil) {
    if ([authResult isSuccess]) {
      NSLog(@"Success! User is logged into Dropbox.");
      UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
      ViewController *viewController = (ViewController *)navigationController.childViewControllers[0];
      viewController.authSuccessful = YES;
      return YES;
    } else if ([authResult isCancel]) {
      NSLog(@"Authorization flow was manually canceled by user!");
    } else if ([authResult isError]) {
      NSLog(@"Error: %@", authResult);
    }
  }

  return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of
  // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and
  // it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use
  // this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state
  // information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when
  // the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes
  // made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was
  // previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also
  // applicationDidEnterBackground:.
}

@end
