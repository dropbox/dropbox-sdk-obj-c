//
//  AppDelegate.m
//  TestObjectiveDropbox_macOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

static ViewController *viewController = nil;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  switch (appPermission) {
  case FullDropbox:
    [DropboxClientsManager setupWithAppKeyDesktop:@"<FULL_DROPBOX_APP_KEY>"];
    break;
  case TeamMemberFileAccess:
    [DropboxClientsManager setupWithTeamAppKeyDesktop:@"<TEAM_MEMBER_FILE_ACCESS_APP_KEY>"];
    break;
  case TeamMemberManagement:
    [DropboxClientsManager setupWithTeamAppKeyDesktop:@"<TEAM_MEMBER_MANAGEMENT_APP_KEY>"];
    break;
  }
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                     andSelector:@selector(handleAppleEvent:withReplyEvent:)
                                                   forEventClass:kInternetEventClass
                                                      andEventID:kAEGetURL];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
  [NSApp activateIgnoringOtherApps:YES];
  viewController = (ViewController *)[NSApplication sharedApplication].mainWindow.contentViewController;
  [viewController checkButtons];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
  switch (appPermission) {
  case FullDropbox: {
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
  case TeamMemberFileAccess: {
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
  case TeamMemberManagement: {
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
  [viewController checkButtons];
}

@end
