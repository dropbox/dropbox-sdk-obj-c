//
//  AppDelegate.m
//  TestObjectiveDropbox_macOS
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

static ViewController *viewController = nil;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
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
    [[DBTransportDefaultConfig alloc] initWithAppKey:data.fullDropboxAppKey appSecret:data.fullDropboxAppSecret];
  DBTransportDefaultConfig *transportConfigTeamFileAccess =
    [[DBTransportDefaultConfig alloc] initWithAppKey:data.teamMemberFileAccessAppKey appSecret:data.teamMemberFileAccessAppSecret];
  DBTransportDefaultConfig *transportConfigTeamManagement =
    [[DBTransportDefaultConfig alloc] initWithAppKey:data.teamMemberManagementAppKey appSecret:data.teamMemberManagementAppSecret];
  
  switch (appPermission) {
    case FullDropbox:
      [DBClientsManager setupWithTransportConfigDesktop:transportConfigFullDropbox];
      break;
    case TeamMemberFileAccess:
      [DBClientsManager setupWithTeamTransportConfigDesktop:transportConfigTeamFileAccess];
      break;
    case TeamMemberManagement:
      [DBClientsManager setupWithTeamTransportConfigDesktop:transportConfigTeamManagement];
      break;
  }
  viewController = (ViewController *)[[[NSApplication sharedApplication] windows] objectAtIndex:0].contentViewController;

  [self checkButtons];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                     andSelector:@selector(handleAppleEvent:withReplyEvent:)
                                                   forEventClass:kInternetEventClass
                                                      andEventID:kAEGetURL];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
  DBOAuthCompletion oauthCompletion = ^(DBOAuthResult *authResult) {
    if (authResult != nil) {
      if ([authResult isSuccess]) {
        NSLog(@"\n\nSuccess! User is logged into Dropbox.\n\n");
      } else if ([authResult isCancel]) {
        NSLog(@"\n\nAuthorization flow was manually canceled by user!\n\n");
      } else if ([authResult isError]) {
        NSLog(@"\n\nError: %@\n\n", authResult);
      }
    }
    [self checkButtons];
  };
  switch (appPermission) {
    case FullDropbox: {
      [DBClientsManager handleRedirectURL:url completion:oauthCompletion];
      break;
    }
    case TeamMemberFileAccess:
    case TeamMemberManagement: {
      [DBClientsManager handleRedirectURLTeam:url completion:oauthCompletion];
      break;
    }
  }
  [[NSRunningApplication currentApplication]
      activateWithOptions:(NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps)];
}

- (void)checkButtons {
  if (viewController) {
    [viewController checkButtons];
  }
}

@end
