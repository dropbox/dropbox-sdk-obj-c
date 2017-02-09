///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <UIKit/UIKit.h>

#import "DBClientsManager+Protected.h"
#import "DBClientsManager.h"
#import "DBOAuth.h"
#import "DBOAuthMobile-iOS.h"
#import "DBTransportDefaultClient.h"

@implementation DBClientsManager (MobileAuth)

+ (void)authorizeFromController:(UIApplication *)sharedApplication
                     controller:(UIViewController *)controller
                        openURL:(void (^_Nonnull)(NSURL *))openURL
                    browserAuth:(BOOL)browserAuth {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
  DBMobileSharedApplication *sharedMobileApplication =
      [[DBMobileSharedApplication alloc] init:sharedApplication controller:controller openURL:openURL];
  [[DBOAuthManager sharedOAuthManager] authorizeFromSharedApplication:sharedMobileApplication browserAuth:browserAuth];
}

+ (void)setupWithAppKey:(NSString *)appKey {
  [[self class] setAppKey:appKey];
  [[self class] setupWithAppKey:appKey transportClient:nil];
}

+ (void)setupWithAppKey:(NSString *)appKey transportClient:(DBTransportDefaultClient *)transportClient {
  [[self class] setAppKey:appKey];
  [[self class] setupWithOAuthManager:[[DBMobileOAuthManager alloc] initWithAppKey:appKey]
                      transportClient:transportClient];
}

+ (void)setupWithAppKeyMultiUser:(NSString *)appKey
                 transportClient:(DBTransportDefaultClient *)transportClient
                        tokenUid:(NSString *)tokenUid {
  [[self class] setAppKey:appKey];
  [[self class] setupWithOAuthManagerMultiUser:[[DBMobileOAuthManager alloc] initWithAppKey:appKey]
                               transportClient:transportClient
                                      tokenUid:tokenUid];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey {
  [[self class] setAppKey:appKey];
  [[self class] setupWithTeamAppKey:appKey transportClient:nil];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey transportClient:(DBTransportDefaultClient *)transportClient {
  [[self class] setAppKey:appKey];
  [[self class] setupWithOAuthManagerTeam:[[DBMobileOAuthManager alloc] initWithAppKey:appKey]
                          transportClient:transportClient];
}

+ (void)setupWithTeamAppKeyMultiUser:(NSString *)appKey
                     transportClient:(DBTransportDefaultClient *)transportClient
                            tokenUid:(NSString *)tokenUid {
  [[self class] setAppKey:appKey];
  [[self class] setupWithOAuthManagerMultiUserTeam:[[DBMobileOAuthManager alloc] initWithAppKey:appKey]
                                   transportClient:transportClient
                                          tokenUid:tokenUid];
}

@end
