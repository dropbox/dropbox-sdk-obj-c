//
//  AppDelegate.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "Dropbox.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    switch (appPermission) {
        case FullDropbox:
            [DropboxClientsManager setupWithAppKey:@"<APP_KEY1>"];
            break;
        case TeamMemberFileAccess:
            [DropboxClientsManager setupWithTeamAppKey:@"<APP_KEY2>"];
            break;
        case TeamMemberManagement:
            [DropboxClientsManager setupWithTeamAppKey:@"<APP_KEY3>"];
            break;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    switch (appPermission) {
        case FullDropbox:
        {
            DBOAuthResult *authResult = [DropboxClientsManager handleRedirectURL:url];
            if (authResult != nil) {
                if ([authResult isSuccess]) {
                    NSLog(@"Success! User is logged into Dropbox.");
                } else if ([authResult isCancel]) {
                    NSLog(@"Authorization flow was manually canceled by user!");
                } else if ([authResult isError]) {
                    NSLog(@"Error: %@", authResult);
                }
            }
            break;
        }
        case TeamMemberFileAccess:
        {
            DBOAuthResult *authResult = [DropboxClientsManager handleRedirectURLTeam:url];
            if (authResult != nil) {
                if ([authResult isSuccess]) {
                    NSLog(@"Success! User is logged into Dropbox.");
                } else if ([authResult isCancel]) {
                    NSLog(@"Authorization flow was manually canceled by user!");
                } else if ([authResult isError]) {
                    NSLog(@"Error: %@", authResult);
                }
            }
            break;
        }
        case TeamMemberManagement:
        {
            DBOAuthResult *authResult = [DropboxClientsManager handleRedirectURLTeam:url];
            if (authResult != nil) {
                if ([authResult isSuccess]) {
                    NSLog(@"Success! User is logged into Dropbox.");
                } else if ([authResult isCancel]) {
                    NSLog(@"Authorization flow was manually canceled by user!");
                } else if ([authResult isError]) {
                    NSLog(@"Error: %@", authResult);
                }
            }
            break;
        }
    }
    
    ViewController *mainController = (ViewController *)self.window.rootViewController;
    [mainController checkButtons];
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
