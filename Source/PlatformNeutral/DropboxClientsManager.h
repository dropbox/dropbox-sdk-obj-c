///
/// This is a convenience class for the typical single user case. To use this
/// class, see details in the tutorial at:
/// https://www.dropbox.com/developers/documentation/obj-c
///
/// For information on the available API methods, see the documentation for DropboxClient
///

#import <Foundation/Foundation.h>
@class DropboxClient;
@class DropboxTeamClient;
@class DbxOAuthResult;

@interface DropboxClientsManager : NSObject

+ (DropboxClient * _Nullable)authorizedClient;

+ (void)authorizedClient:(DropboxClient * _Nullable)client;

+ (DropboxTeamClient * _Nullable)authorizedTeamClient;

+ (void)authorizedTeamClient:(DropboxTeamClient * _Nullable)client;

/// Handle a redirect and automatically initialize the client and save the token.
+ (DbxOAuthResult * _Nullable)handleRedirectURL:(NSURL * _Nonnull)url;

/// Handle a redirect and automatically initialize the team client and save the token.
+ (DbxOAuthResult * _Nullable)handleRedirectURLTeam:(NSURL * _Nonnull)url;

/// Unlink the user.
+ (void)unlinkClient;

@end
