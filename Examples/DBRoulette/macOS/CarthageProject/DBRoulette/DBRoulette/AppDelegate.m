//
//  AppDelegate.m
//  DBRoulette
//
//  Created by Stephen Cobbe on 2/27/17.
//  Copyright © 2017 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

static NSTabViewController *tabViewController = nil;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSString *appKey = nil;
  if (!appKey) {
    NSString *message = @"You need to set `appKey` variable in `AppDelegate.m`, as well as add to `Info.plist`, before you can use DBRoulette.";
    NSLog(@"%@", message);
    NSLog(@"Terminating...");
    exit(1);
  }
  [DBClientsManager setupWithAppKeyDesktop:appKey];
}

// generic launch handler
- (void)applicationWillFinishLaunching:(NSNotification *)notification {
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                     andSelector:@selector(handleAppleEvent:withReplyEvent:)
                                                   forEventClass:kInternetEventClass
                                                      andEventID:kAEGetURL];
}

// custom handler
- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
  DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
  if (authResult != nil) {
    if ([authResult isSuccess]) {
      NSLog(@"Success! User is logged into Dropbox.");
    } else if ([authResult isCancel]) {
      NSLog(@"Authorization flow was manually canceled by user!");
    } else if ([authResult isError]) {
      NSLog(@"Error: %@", authResult);
    }
  }
  [tabViewController.childViewControllers[0] checkButtons];
  [tabViewController.childViewControllers[1] checkButtons];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
  [NSApp activateIgnoringOtherApps:YES];
  tabViewController = (NSTabViewController *)[NSApplication sharedApplication].mainWindow.contentViewController;
  [tabViewController.childViewControllers[0] checkButtons];
  [tabViewController.childViewControllers[1] checkButtons];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


@end
