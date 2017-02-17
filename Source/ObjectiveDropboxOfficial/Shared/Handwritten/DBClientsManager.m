///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBClientsManager.h"
#import "DBOAuth.h"
#import "DBOAuthResult.h"
#import "DBTeamClient.h"
#import "DBTransportDefaultClient.h"
#import "DBTransportDefaultConfig.h"
#import "DBUserClient.h"

@implementation DBClientsManager

static DBTransportDefaultConfig *currentTransportConfig;

/// An authorized client. This will be set to `nil` if unlinked.
static DBUserClient *authorizedClient;

/// An authorized team client. This will be set to `nil` if unlinked.
static DBTeamClient *authorizedTeamClient;

+ (NSString *)appKey {
  return currentTransportConfig.appKey;
}

+ (DBTransportDefaultConfig *)transportConfig {
  return currentTransportConfig;
}

+ (void)setTransportConfig:(DBTransportDefaultConfig *)transportConfig {
  currentTransportConfig = transportConfig;
}

+ (DBUserClient *)authorizedClient {
  return authorizedClient;
}

+ (void)setAuthorizedClient:(DBUserClient *)client {
  authorizedClient = client;
}

+ (DBTeamClient *)authorizedTeamClient {
  return authorizedTeamClient;
}

+ (void)setAuthorizedTeamClient:(DBTeamClient *)client {
  authorizedTeamClient = client;
}

+ (void)setupWithOAuthManager:(DBOAuthManager *)oAuthManager
              transportConfig:(DBTransportDefaultConfig *)transportConfig {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [DBOAuthManager setSharedOAuthManager:oAuthManager];
  [[self class] setTransportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  [[self class] setupAuthorizedClient:accessToken];
}

+ (void)setupWithOAuthManagerMultiUser:(DBOAuthManager *)oAuthManager
                       transportConfig:(DBTransportDefaultConfig *)transportConfig
                              tokenUid:(NSString *)tokenUid {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [DBOAuthManager setSharedOAuthManager:oAuthManager];
  [[self class] setTransportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  [[self class] setupAuthorizedClient:accessToken];
}

+ (void)setupWithOAuthManagerTeam:(DBOAuthManager *)oAuthManager
                  transportConfig:(DBTransportDefaultConfig *)transportConfig {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [DBOAuthManager setSharedOAuthManager:oAuthManager];
  [[self class] setTransportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  [[self class] setupAuthorizedTeamClient:accessToken];
}

+ (void)setupWithOAuthManagerTeamMultiUser:(DBOAuthManager *)oAuthManager
                           transportConfig:(DBTransportDefaultConfig *)transportConfig
                                  tokenUid:(NSString *)tokenUid {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  [DBOAuthManager setSharedOAuthManager:oAuthManager];
  [[self class] setTransportConfig:transportConfig];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  [[self class] setupAuthorizedTeamClient:accessToken];
}

+ (BOOL)reauthorizeClient:(NSString *)tokenUid {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  if (accessToken) {
    [[self class] setupAuthorizedClient:accessToken];
    return YES;
  }

  return NO;
}

+ (BOOL)reauthorizeTeamClient:(NSString *)tokenUid {
  NSAssert(![DBOAuthManager sharedOAuthManager], @"Only call `[DBClientsManager setupWith...]` once");

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  if (accessToken) {
    [[self class] setupAuthorizedTeamClient:accessToken];
    return YES;
  }

  return NO;
}

+ (void)setupAuthorizedClient:(DBAccessToken *)accessToken {
  if (accessToken) {
    DBTransportDefaultClient *transportClient =
        [[DBTransportDefaultClient alloc] initWithAccessToken:accessToken.accessToken
                                              transportConfig:[DBClientsManager transportConfig]];
    authorizedClient = [[DBUserClient alloc] initWithTransportClient:transportClient];
  }
}

+ (void)setupAuthorizedTeamClient:(DBAccessToken *)accessToken {
  if (accessToken) {
    DBTransportDefaultClient *transportClient =
        [[DBTransportDefaultClient alloc] initWithAccessToken:accessToken.accessToken
                                              transportConfig:[DBClientsManager transportConfig]];
    authorizedTeamClient = [[DBTeamClient alloc] initWithTransportClient:transportClient];
  }
}

+ (DBOAuthResult *)handleRedirectURL:(NSURL *)url {
  NSAssert([DBOAuthManager sharedOAuthManager],
           @"Call the appropriate `[DBClientsManager setupWith...]` before calling this method");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    NSString *accessToken = result.accessToken.accessToken;
    if (authorizedClient) {
      [authorizedClient updateAccessToken:accessToken];
    } else {
      DBUserClient *authorizedClient =
          [[DBUserClient alloc] initWithAccessToken:accessToken transportConfig:[DBClientsManager transportConfig]];
      [DBClientsManager setAuthorizedClient:authorizedClient];
    }
  }

  return result;
}

+ (DBOAuthResult *)handleRedirectURLTeam:(NSURL *)url {
  NSAssert([DBOAuthManager sharedOAuthManager],
           @"Call the appropriate `[DBClientsManager setupWith...]` before calling this method");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    NSString *accessToken = result.accessToken.accessToken;
    if (authorizedTeamClient) {
      [authorizedTeamClient updateAccessToken:accessToken];
    } else {
      DBTeamClient *authorizedTeamClient =
          [[DBTeamClient alloc] initWithAccessToken:accessToken transportConfig:[DBClientsManager transportConfig]];
      [DBClientsManager setAuthorizedTeamClient:authorizedTeamClient];
    }
  }

  return result;
}

+ (void)unlinkAndResetClients {
  if ([DBOAuthManager sharedOAuthManager]) {
    [[DBOAuthManager sharedOAuthManager] clearStoredAccessTokens];
    [[self class] resetClients];
  }
}

+ (void)resetClients {
  [DBClientsManager setAuthorizedClient:nil];
  [DBClientsManager setAuthorizedTeamClient:nil];
}

@end
