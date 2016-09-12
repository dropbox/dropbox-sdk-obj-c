///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBOAuth.h"
#import "DBOAuthResult.h"
#import "DropboxClient.h"
#import "DropboxClientsManager.h"
#import "DropboxTeamClient.h"

@implementation DropboxClientsManager

/// An authorized client. This will be set to `nil` if unlinked.
static DropboxClient *authorizedClient;

/// An authorized team client. This will be set to `nil` if unlinked.
static DropboxTeamClient *authorizedTeamClient;

+ (DropboxClient *)authorizedClient {
  return authorizedClient;
}

+ (void)authorizedClient:(DropboxClient *)client {
  authorizedClient = client;
}

+ (DropboxTeamClient *)authorizedTeamClient {
  return authorizedTeamClient;
}

+ (void)authorizedTeamClient:(DropboxTeamClient *)client {
  authorizedTeamClient = client;
}

+ (void)setupWithAppKey:(NSString *)appKey
     sharedOAuthManager:(DBOAuthManager *)sharedOAuthManager
        transportClient:(DBTransportClient *)transportClient {
  NSAssert([DBOAuthManager sharedOAuthManager] == nil,
           @"Only call `DropboxManager.setupWithAppKey` or `DropboxManager.setupWithTeamAppKey` once");
  [DBOAuthManager sharedOAuthManager:sharedOAuthManager];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  if (accessToken) {
    if (transportClient) {
      transportClient.accessToken = accessToken.accessToken;
      authorizedClient = [[DropboxClient alloc] initWithTransportClient:transportClient];
    } else {
      authorizedClient = [[DropboxClient alloc] initWithAccessToken:accessToken.accessToken];
    }
  } else {
    if (transportClient) {
      authorizedClient = [[DropboxClient alloc] initWithTransportClient:transportClient];
    }
  }
}

+ (void)setupWithTeamAppKey:(NSString *)appKey
         sharedOAuthManager:(DBOAuthManager *)sharedOAuthManager
            transportClient:(DBTransportClient *)transportClient {
  NSAssert([DBOAuthManager sharedOAuthManager] == nil,
           @"Only call `DropboxManager.setupWithAppKey` or `DropboxManager.setupWithTeamAppKey` once");
  [DBOAuthManager sharedOAuthManager:sharedOAuthManager];

  DBAccessToken *accessToken = [[DBOAuthManager sharedOAuthManager] getFirstAccessToken];
  if (accessToken) {
    if (transportClient) {
      transportClient.accessToken = accessToken.accessToken;
      authorizedTeamClient = [[DropboxTeamClient alloc] initWithTransportClient:transportClient];
    } else {
      authorizedTeamClient = [[DropboxTeamClient alloc] initWithAccessToken:accessToken.accessToken];
    }
  } else {
    if (transportClient) {
      authorizedTeamClient = [[DropboxTeamClient alloc] initWithTransportClient:transportClient];
    }
  }
}

+ (DBOAuthResult *)handleRedirectURL:(NSURL *)url {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithAppKey` before calling this method");
  NSAssert([DropboxClientsManager authorizedClient] == nil, @"Dropbox user client is already authorized");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    if (authorizedClient) {
      authorizedClient.transportClient.accessToken = result.accessToken.accessToken;
    } else {
      [DropboxClientsManager
          authorizedClient:[[DropboxClient alloc] initWithAccessToken:result.accessToken.accessToken]];
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
           @"Call `Dropbox.setupWithTeamAppKey` before calling this method");
  NSAssert([DropboxClientsManager authorizedClient] == nil, @"Dropbox user client is already authorized");

  DBOAuthResult *result = [[DBOAuthManager sharedOAuthManager] handleRedirectURL:url];

  if ([result isSuccess]) {
    if (authorizedTeamClient) {
      authorizedTeamClient.transportClient.accessToken = result.accessToken.accessToken;
    } else {
      [DropboxClientsManager
          authorizedTeamClient:[[DropboxTeamClient alloc] initWithAccessToken:result.accessToken.accessToken]];
    }
  } else if ([result isCancel]) {
    return result;
  } else if ([result isError]) {
    return result;
  }

  return nil;
}

+ (void)unlinkClients {
  NSAssert([DBOAuthManager sharedOAuthManager] != nil,
           @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
  if ([DropboxClientsManager authorizedClient] == nil && [DropboxClientsManager authorizedTeamClient] == nil) {
    // already unlinked
    return;
  }

  [[DBOAuthManager sharedOAuthManager] clearStoredAccessTokens];
  [DropboxClientsManager authorizedClient:nil];
  [DropboxClientsManager authorizedTeamClient:nil];
}

@end
