///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBClientsManager.h"
#import "DBOAuth.h"
#import "DBOAuthResult.h"
#import "DBTeamClient.h"
#import "DBUserClient.h"

@implementation DBClientsManager

/// An authorized client. This will be set to `nil` if unlinked.
static DBUserClient *authorizedClient;

/// An authorized team client. This will be set to `nil` if unlinked.
static DBTeamClient *authorizedTeamClient;

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
              transportClient:(DBTransportDefaultClient *)transportClient {
  NSAssert([DBOAuthManager sharedOAuthManager] == nil,
           @"Only call `[DBClientsManager setupWithAppKey]` or `[DBClientsManager setupWithTeamAppKey]` once");
  [DBOAuthManager sharedOAuthManager:oAuthManager];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  [[self class] setupAuthorizedClient:accessToken transportClient:transportClient];
}

+ (void)setupWithOAuthManagerMultiUser:(DBOAuthManager *)oAuthManager
                       transportClient:(DBTransportDefaultClient *)transportClient
                              tokenUid:(NSString *)tokenUid {
  NSAssert([DBOAuthManager sharedOAuthManager] == nil, @"Only call `[DBClientsManager setupWithAppKeyMultiUser]` "
                                                       @"or `[DBClientsManager setupWithTeamAppKeyMultiUser]` "
                                                       @"once");
  [DBOAuthManager sharedOAuthManager:oAuthManager];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  [[self class] setupAuthorizedClient:accessToken transportClient:transportClient];
}

+ (void)setupWithOAuthManagerTeam:(DBOAuthManager *)oAuthManager
                  transportClient:(DBTransportDefaultClient *)transportClient {
  NSAssert([DBOAuthManager sharedOAuthManager] == nil,
           @"Only call `[DBClientsManager setupWithAppKey]` or `[DBClientsManager setupWithTeamAppKey]` once");
  [DBOAuthManager sharedOAuthManager:oAuthManager];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  [[self class] setupAuthorizedTeamClient:accessToken transportClient:transportClient];
}

+ (void)setupWithOAuthManagerMultiUserTeam:(DBOAuthManager *)oAuthManager
                           transportClient:(DBTransportDefaultClient *)transportClient
                                  tokenUid:(NSString *)tokenUid {
  NSAssert([DBOAuthManager sharedOAuthManager] == nil, @"Only call `[DBClientsManager setupWithAppKeyMultiUser]` "
                                                       @"or `[DBClientsManager setupWithTeamAppKeyMultiUser]` "
                                                       @"once");
  [DBOAuthManager sharedOAuthManager:oAuthManager];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  [[self class] setupAuthorizedTeamClient:accessToken transportClient:transportClient];
}

+ (BOOL)reauthorizeClient:(NSString *)tokenUid {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `[DBClientsManager setupWithAppKey]` before calling this method");

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  if (accessToken) {
    [[self class] setupAuthorizedClient:accessToken transportClient:nil];
    return YES;
  }

  return NO;
}

+ (BOOL)reauthorizeTeamClient:(NSString *)tokenUid {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `[DBClientsManager setupWithTeamAppKey]` before calling this method");

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getAccessToken:tokenUid];
  if (accessToken) {
    [[self class] setupAuthorizedTeamClient:accessToken transportClient:nil];
    return YES;
  }

  return NO;
}

+ (void)setupAuthorizedClient:(DBAccessToken *)accessToken transportClient:(DBTransportDefaultClient *)transportClient {
  if (accessToken) {
    if (transportClient) {
      transportClient.accessToken = accessToken.accessToken;
      authorizedClient = [[DBUserClient alloc] initWithTransportClient:transportClient];
    } else {
      authorizedClient = [[DBUserClient alloc] initWithAccessToken:accessToken.accessToken];
    }
  } else {
    if (transportClient) {
      authorizedClient = [[DBUserClient alloc] initWithTransportClient:transportClient];
    }
  }
}

+ (void)setupAuthorizedTeamClient:(DBAccessToken *)accessToken
                  transportClient:(DBTransportDefaultClient *)transportClient {
  if (accessToken) {
    if (transportClient) {
      transportClient.accessToken = accessToken.accessToken;
      authorizedTeamClient = [[DBTeamClient alloc] initWithTransportClient:transportClient];
    } else {
      authorizedTeamClient = [[DBTeamClient alloc] initWithAccessToken:accessToken.accessToken];
    }
  } else {
    if (transportClient) {
      authorizedTeamClient = [[DBTeamClient alloc] initWithTransportClient:transportClient];
    }
  }
}

+ (DBOAuthResult *)handleRedirectURL:(NSURL *)url {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `[DBClientsManager setupWithAppKey]` before calling this method");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    if (authorizedClient) {
      [authorizedClient updateAccessToken:result.accessToken.accessToken];
    } else {
      [DBClientsManager setAuthorizedClient:[[DBUserClient alloc] initWithAccessToken:result.accessToken.accessToken]];
    }
  } else if ([result isCancel]) {
    return result;
  } else if ([result isError]) {
    return result;
  }

  return result;
}

+ (DBOAuthResult *)handleRedirectURLTeam:(NSURL *)url {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `[DBClientsManager setupWithTeamAppKey]` before calling this method");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    if (authorizedTeamClient) {
      [authorizedClient updateAccessToken:result.accessToken.accessToken];
    } else {
      [DBClientsManager
          setAuthorizedTeamClient:[[DBTeamClient alloc] initWithAccessToken:result.accessToken.accessToken]];
    }
    return result;
  } else if ([result isCancel]) {
    return result;
  } else if ([result isError]) {
    return result;
  }

  return nil;
}

+ (void)unlinkClients {
  if ([DBOAuthManager sharedOAuthManager]) {
    [[DBOAuthManager sharedOAuthManager] clearStoredAccessTokens];
    [[self class] resetClients];
  }
}

+ (void)resetClients {
  if ([DBClientsManager authorizedClient] == nil && [DBClientsManager authorizedTeamClient] == nil) {
    // already unlinked
    return;
  }

  [DBClientsManager setAuthorizedClient:nil];
  [DBClientsManager setAuthorizedTeamClient:nil];
}

@end
