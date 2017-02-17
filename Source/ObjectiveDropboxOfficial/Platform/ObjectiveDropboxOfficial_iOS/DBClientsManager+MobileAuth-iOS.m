///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <UIKit/UIKit.h>

#import "DBClientsManager+Protected.h"
#import "DBClientsManager.h"
#import "DBOAuth.h"
#import "DBOAuthMobile-iOS.h"
#import "DBTransportDefaultConfig.h"

@implementation DBClientsManager (MobileAuth)

+ (void)authorizeFromController:(UIApplication *)sharedApplication
                     controller:(UIViewController *)controller
                        openURL:(void (^_Nonnull)(NSURL *))openURL
                    browserAuth:(BOOL)browserAuth {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
  DBMobileSharedApplication *sharedMobileApplication =
      [[DBMobileSharedApplication alloc] initWithSharedApplication:sharedApplication
                                                        controller:controller
                                                           openURL:openURL];
  [[DBOAuthManager sharedOAuthManager] authorizeFromSharedApplication:sharedMobileApplication browserAuth:browserAuth];
}

+ (void)setupWithAppKey:(NSString *)appKey {
  [[self class] setupWithTransportConfig:[[DBTransportDefaultConfig alloc] initWithAppKey:appKey]];
}

+ (void)setupWithTransportConfig:(DBTransportDefaultConfig *)transportConfig {
  [[self class] setupWithOAuthManager:[[DBMobileOAuthManager alloc] initWithAppKey:transportConfig.appKey]
                      transportConfig:transportConfig];
}

+ (void)setupWithAppKeyMultiUser:(NSString *)appKey tokenUid:(NSString *)tokenUid {
  DBTransportDefaultConfig *transportConfig = [[DBTransportDefaultConfig alloc] initWithAppKey:appKey];
  [[self class] setupWithOAuthManagerMultiUser:[[DBMobileOAuthManager alloc] initWithAppKey:transportConfig.appKey]
                               transportConfig:transportConfig
                                      tokenUid:tokenUid];
}

+ (void)setupWithTransportConfigMultiUser:(DBTransportDefaultConfig *)transportConfig tokenUid:(NSString *)tokenUid {
  [[self class] setupWithOAuthManagerMultiUser:[[DBMobileOAuthManager alloc] initWithAppKey:transportConfig.appKey]
                               transportConfig:transportConfig
                                      tokenUid:tokenUid];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey {
  [[self class] setupWithTeamTransportConfig:[[DBTransportDefaultConfig alloc] initWithAppKey:appKey]];
}

+ (void)setupWithTeamTransportConfig:(DBTransportDefaultConfig *)transportConfig {
  [[self class] setupWithOAuthManagerTeam:[[DBMobileOAuthManager alloc] initWithAppKey:transportConfig.appKey]
                          transportConfig:transportConfig];
}

+ (void)setupWithTeamAppKeyMultiUser:(NSString *)appKey tokenUid:(NSString *)tokenUid {
  DBTransportDefaultConfig *transportConfig = [[DBTransportDefaultConfig alloc] initWithAppKey:appKey];
  [[self class] setupWithOAuthManagerTeamMultiUser:[[DBMobileOAuthManager alloc] initWithAppKey:transportConfig.appKey]
                                   transportConfig:transportConfig
                                          tokenUid:tokenUid];
}

+ (void)setupWithTeamTransportConfigMultiUser:(DBTransportDefaultConfig *)transportConfig
                                     tokenUid:(NSString *)tokenUid {
  [[self class] setupWithOAuthManagerTeamMultiUser:[[DBMobileOAuthManager alloc] initWithAppKey:transportConfig.appKey]
                                   transportConfig:transportConfig
                                          tokenUid:tokenUid];
}

@end
