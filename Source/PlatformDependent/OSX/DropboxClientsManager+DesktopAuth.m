///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBOAuth.h"
#import "DBOAuthDesktop.h"
#import "DBTransportClient.h"
#import "DropboxClientsManager.h"
#import <AppKit/AppKit.h>

@interface DropboxClientsManager ()

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey
     sharedOAuthManager:(DBOAuthManager * _Nonnull)sharedOAuthManager
        transportClient:(DBTransportClient * _Nullable)transportClient;

+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey
         sharedOAuthManager:(DBOAuthManager * _Nonnull)sharedOAuthManager
            transportClient:(DBTransportClient * _Nullable)transportClient;

@end

@implementation DropboxClientsManager (DesktopAuth)

+ (void)authorizeFromControllerDesktop:(NSWorkspace *)sharedApplication
                            controller:(NSViewController *)controller
                               openURL:(void (^_Nonnull)(NSURL *))openURL
                           browserAuth:(BOOL)browserAuth {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
  NSAssert([DropboxClientsManager authorizedClient] == nil && [DropboxClientsManager authorizedTeamClient] == nil,
           @"A Dropbox client is already authorized");
  DBDesktopSharedApplication *sharedDesktopApplication =
      [[DBDesktopSharedApplication alloc] init:sharedApplication controller:controller openURL:openURL];
  [[DBOAuthManager sharedOAuthManager] authorizeFromSharedApplication:sharedDesktopApplication browserAuth:browserAuth];
}

+ (void)setupWithAppKeyDesktop:(NSString *)appKey {
  [DropboxClientsManager setupWithAppKey:appKey
                      sharedOAuthManager:[[DBDesktopOAuthManager alloc] initWithAppKey:appKey]
                         transportClient:nil];
}

+ (void)setupWithAppKeyDesktop:(NSString *)appKey transportClient:(DBTransportClient *)transportClient {
  [DropboxClientsManager setupWithAppKey:appKey
                      sharedOAuthManager:[[DBDesktopOAuthManager alloc] initWithAppKey:appKey]
                         transportClient:transportClient];
}

+ (void)setupWithTeamAppKeyDesktop:(NSString *)appKey {
  [DropboxClientsManager setupWithTeamAppKey:appKey
                          sharedOAuthManager:[[DBDesktopOAuthManager alloc] initWithAppKey:appKey]
                             transportClient:nil];
}

+ (void)setupWithTeamAppKeyDesktop:(NSString *)appKey transportClient:(DBTransportClient *)transportClient {
  [DropboxClientsManager setupWithTeamAppKey:appKey
                          sharedOAuthManager:[[DBDesktopOAuthManager alloc] initWithAppKey:appKey]
                             transportClient:transportClient];
}

@end
