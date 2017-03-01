//
//  AppDelegate.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "AppDelegate.h"
#import "TestAppType.h"
#import "TestData.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  TestData *data = [TestData new];

  if ([data.fullDropboxAppSecret containsString:@"<"] ||
      [data.teamMemberFileAccessAppKey containsString:@"<"] ||
      [data.teamMemberManagementAppKey containsString:@"<"]) {
    NSLog(@"\n\n\nMust set test data (in TestData.h) before launching app.\n\n\nTerminating.....\n\n");
    exit(0);
  }

  NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
  NSString *migrationOccuredLookupKey = [NSString stringWithFormat: @"KeychainV1TokenMigration-%@", data.fullDropboxAppKey];
  [Defaults setObject:@"YES" forKey:migrationOccuredLookupKey];
  [DBClientsManager checkAndPerformV1TokenMigration:^(BOOL shouldRetry, BOOL invalidAppKeyOrSecret, NSArray<NSArray<NSString *> *> *unsuccessfullyMigratedTokenData) {
    NSLog(@"Migration completed.");
    NSLog(shouldRetry ? @"ShouldRetry: Yes" : @"ShouldRetry: No");
    NSLog(invalidAppKeyOrSecret ? @"InvalidAppKeyOrSecret: Yes" : @"InvalidAppKeyOrSecret: No");
  } queue:nil appKey:data.fullDropboxAppKey appSecret:data.fullDropboxAppSecret];

  DBTransportDefaultConfig *transportConfigFullDropbox =
    [[DBTransportDefaultConfig alloc] initWithAppKey:data.fullDropboxAppKey
                                           appSecret:data.fullDropboxAppSecret
                                           userAgent:nil
                                       delegateQueue:nil
                              forceForegroundSession:YES];
  DBTransportDefaultConfig *transportConfigTeamFileAccess =
    [[DBTransportDefaultConfig alloc] initWithAppKey:data.teamMemberFileAccessAppKey appSecret:data.teamMemberFileAccessAppSecret];
  DBTransportDefaultConfig *transportConfigTeamManagement =
    [[DBTransportDefaultConfig alloc] initWithAppKey:data.teamMemberManagementAppKey appSecret:data.teamMemberManagementAppSecret];

  switch (appPermission) {
  case FullDropbox:
      [DBClientsManager setupWithTransportConfig:transportConfigFullDropbox];
      break;
  case TeamMemberFileAccess:
      [DBClientsManager setupWithTeamTransportConfig:transportConfigTeamFileAccess];
      break;
  case TeamMemberManagement:
      [DBClientsManager setupWithTeamTransportConfig:transportConfigTeamManagement];
      break;
  }
  return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

  switch (appPermission) {
  case FullDropbox: {
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
    if (authResult != nil) {
      if ([authResult isSuccess]) {
        NSLog(@"\n\nSuccess! User is logged into Dropbox.\n\n");
      } else if ([authResult isCancel]) {
        NSLog(@"\n\nAuthorization flow was manually canceled by user!\n\n");
      } else if ([authResult isError]) {
        NSLog(@"\n\nError: %@\n\n", authResult);
      }
    }
    break;
  }
  case TeamMemberFileAccess: {
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURLTeam:url];
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
  case TeamMemberManagement: {
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURLTeam:url];
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

  if ([[url absoluteString] containsString:@"openWith"]) {
    NSLog(@"Successfully retrieved openWith url");

    NSMutableDictionary *urlData = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:@"&"] ?: @[];

    for (NSString *pair in pairs) {
      NSArray *kv = [pair componentsSeparatedByString:@"="];
      NSString *unEscapedValue = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      [urlData setObject:unEscapedValue forKey:[kv objectAtIndex:0]];
    }

    DBOpenWithInfo *openWithInfo = [[DBOpenWithInfo alloc] initWithUserId:urlData[@"uid"]
                                                                      rev:urlData[@"rev"]
                                                                     path:urlData[@"path"]
                                                             modifiedTime:urlData[@"modifiedTime"]
                                                                 readOnly:[urlData[@"readOnly"] boolValue]
                                                                     verb:urlData[@"verb"]
                                                                sessionId:urlData[@"sessionId"]
                                                                   fileId:nil
                                                                 fileData:nil
                                                                sourceApp:urlData[@"sourceApp"]];
    [mainController setOpenWithInfoNSURL:openWithInfo];
  }
  [mainController checkButtons];

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
