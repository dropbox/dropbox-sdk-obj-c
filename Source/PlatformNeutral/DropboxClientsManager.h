///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>
@class DropboxClient;
@class DropboxTeamClient;
@class DBOAuthResult;

///
/// Dropbox Clients Manager.
///
/// This is a convenience class for the typical single user case.
///
/// To use this class, see details in the tutorial at:
/// https://www.dropbox.com/developers/documentation/objective-c
///
@interface DropboxClientsManager : NSObject

///
/// Accessor method for DropboxClient shared instance.
///
/// @return The DropboxClient shared instance.
///
+ (DropboxClient * _Nullable)authorizedClient;

///
/// Mutator method for DropboxClient shared instance.
///
/// @param client The updated reference to the DropboxClient shared
/// instance.
///
+ (void)authorizedClient:(DropboxClient * _Nullable)client;

///
/// Accessor method for DropboxTeamClient shared instance.
///
/// @return The DropboxTeamClient shared instance.
///
+ (DropboxTeamClient * _Nullable)authorizedTeamClient;

///
/// Mutator method for DropboxTeamClient shared instance.
///
/// @param client The updated reference to the DropboxTeamClient shared
/// instance.
///
+ (void)authorizedTeamClient:(DropboxTeamClient * _Nullable)client;

///
/// Handles launching the SDK with a redirect URL from an external source.
///
/// Used after OAuth authentication has completed. A DropboxClient instance
/// is initialized and the response access token is saved in the DBKeychain
/// class.
///
/// @param url The auth redirect URL which relaunches the SDK.
///
/// @return The DBOAuthResult result from the authorization attempt.
///
+ (DBOAuthResult * _Nullable)handleRedirectURL:(NSURL * _Nonnull)url;

///
/// Handles launching the SDK with a redirect URL from an external source.
///
/// Used after OAuth authentication has completed. A DropboxTeamClient instance
/// is initialized and the response access token is saved in the DBKeychain
/// class.
///
/// @param url The auth redirect URL which relaunches the SDK.
///
/// @return The DBOAuthResult result from the authorization attempt.
///
+ (DBOAuthResult * _Nullable)handleRedirectURLTeam:(NSURL * _Nonnull)url;

///
/// "Unlinks" the active user / team client (or both) and clears all stored
/// access tokens in DBKeychain.
///
+ (void)unlinkClients;

@end
