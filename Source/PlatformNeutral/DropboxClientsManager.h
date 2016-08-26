#import <Foundation/Foundation.h>
@class DropboxClient;
@class DropboxTeamClient;
@class DBXOAuthResult;

///
/// Dropbox Clients Manager.
///
/// This is a convenience class for the typical single user case. To use this
/// class, see details in the tutorial at:
/// https://www.dropbox.com/developers/documentation/obj-c
///
/// For information on the available API methods, see the documentation for `DropboxClient`.
/// and `DropboxTeamClient`.
///
@interface DropboxClientsManager : NSObject

///
/// Accessor method for `DropboxClient` shared instance.
///
/// - returns: The `DropboxClient` shared instance.
///
+ (DropboxClient * _Nullable)authorizedClient;

///
/// Mutator method for `DropboxClient` shared instance.
///
/// - parameter client: The updated reference to the `DropboxClient` shared
/// instance.
///
+ (void)authorizedClient:(DropboxClient * _Nullable)client;

///
/// Accessor method for `DropboxTeamClient` shared instance.
///
/// - returns: The `DropboxTeamClient` shared instance.
///
+ (DropboxTeamClient * _Nullable)authorizedTeamClient;

///
/// Mutator method for `DropboxTeamClient` shared instance.
///
/// - parameter client: The updated reference to the `DropboxTeamClient` shared
/// instance.
///
+ (void)authorizedTeamClient:(DropboxTeamClient * _Nullable)client;

///
/// Handles launching the SDK with a redirect URL from an external source.
/// Used after OAuth authentication has completed. A `DropboxClient` instance
/// is initialized and the response access token is saved in the `DBXKeychain`
/// class.
///
/// - parameter url: The auth redirect URL which relaunches the SDK.
///
/// - returns: The `DBXOAuthResult` result from the authorization attempt.
///
+ (DBXOAuthResult * _Nullable)handleRedirectURL:(NSURL * _Nonnull)url;

///
/// Handles launching the SDK with a redirect URL from an external source.
/// Used after OAuth authentication has completed. A `DropboxTeamClient` instance
/// is initialized and the response access token is saved in the `DBXKeychain`
/// class.
///
/// - parameter url: The auth redirect URL which relaunches the SDK.
///
/// - returns: The `DBXOAuthResult` result from the authorization attempt.
///
+ (DBXOAuthResult * _Nullable)handleRedirectURLTeam:(NSURL * _Nonnull)url;

///
/// "Unlinks" the active user / team client (or both) and clears all stored
/// access tokens in `DBXKeychain`.
///
+ (void)unlinkClients;

@end
