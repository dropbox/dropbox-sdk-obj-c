///
/// This is a convenience class for the typical single user case. To use this
/// class, see details in the tutorial at:
/// https://www.dropbox.com/developers/documentation/obj-c
///
/// For information on the available API methods, see the documentation for DropboxClient
///

#import "DbxOAuth.h"
#import "DbxOAuthResult.h"
#import "DropboxClient.h"
#import "DropboxTeamClient.h"
#import "DropboxClientsManager.h"

@implementation DropboxClientsManager

/// An authorized client. This will be set to nil if unlinked.
static DropboxClient *authorizedClient;

/// An authorized team client. This will be set to nil if unlinked.
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

+ (void)setupWithAppKey:(NSString *)appKey sharedOAuthManager:(DbxOAuthManager *)sharedOAuthManager {
    NSAssert([DbxOAuthManager sharedOAuthManager] == nil, @"Only call `DropboxManager.setupWithAppKey` or `DropboxManager.setupWithTeamAppKey` once");
    [DbxOAuthManager sharedOAuthManager:sharedOAuthManager];
    
    DbxAccessToken *accessToken = [[DbxOAuthManager sharedOAuthManager] getFirstAccessToken];
    if (accessToken) {
        authorizedClient = [[DropboxClient alloc] initWithAccessToken:accessToken.accessToken];
    }
}

+ (void)setupWithTeamAppKey:(NSString *)appKey sharedOAuthManager:(DbxOAuthManager *)sharedOAuthManager {
    NSAssert([DbxOAuthManager sharedOAuthManager] == nil, @"Only call `DropboxManager.setupWithAppKey` or `DropboxManager.setupWithTeamAppKey` once");
    [DbxOAuthManager sharedOAuthManager:sharedOAuthManager];
    
    DbxAccessToken *accessToken = [[DbxOAuthManager sharedOAuthManager] getFirstAccessToken];
    if (accessToken) {
        authorizedTeamClient = [[DropboxTeamClient alloc] initWithAccessToken:accessToken.accessToken];
    }
}

+ (DbxOAuthResult *)handleRedirectURL:(NSURL *)url {
    NSAssert([DbxOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithAppKey` before calling this method");
    NSAssert([DropboxClientsManager authorizedClient] == nil, @"Dropbox user client is already authorized");
    
    DbxOAuthResult *result = [[DbxOAuthManager sharedOAuthManager] handleRedirectURL:url];
    
    if ([result isSuccess]) {
        [DropboxClientsManager authorizedClient:[[DropboxClient alloc] initWithAccessToken:result.accessToken.accessToken]];
    } else if ([result isCancel]) {
        return result;
    } else if ([result isError]) {
        return result;
    }
    
    return result;
}

+ (DbxOAuthResult *)handleRedirectURLTeam:(NSURL *)url {
    NSAssert([DbxOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithTeamAppKey` before calling this method");
    NSAssert([DropboxClientsManager authorizedClient] == nil, @"Dropbox user client is already authorized");
    
    DbxOAuthResult *result = [[DbxOAuthManager sharedOAuthManager] handleRedirectURL:url];
    
    if ([result isSuccess]) {
        [DropboxClientsManager authorizedTeamClient:[[DropboxTeamClient alloc] initWithAccessToken:result.accessToken.accessToken]];
    } else if ([result isCancel]) {
        return result;
    } else if ([result isError]) {
        return result;
    }
    
    return nil;
}

+ (void)unlinkClient {
    NSAssert([DbxOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
    if ([DropboxClientsManager authorizedClient] == nil && [DropboxClientsManager authorizedTeamClient] == nil) {
        // already unlinked
        return;
    }
    
    [[DbxOAuthManager sharedOAuthManager] clearStoredAccessTokens];
    [DropboxClientsManager authorizedClient:nil];
    [DropboxClientsManager authorizedTeamClient:nil];
}

@end
