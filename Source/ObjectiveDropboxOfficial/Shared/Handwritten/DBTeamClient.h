///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBTeamBaseClient.h"
#import "DBTransportDefaultClient.h"

@class DBUserClient;

///
/// Dropbox Business (Team) API Client.
///
/// This is the SDK user's primary interface with the Dropbox Business (Team) API.
/// Routes can be accessed via each "namespace" object in the instance fields of
/// its parent, `DBBase`. To see a full list of the Business (Team) API endpoints
/// available, please visit:
/// https://www.dropbox.com/developers/documentation/http/teams.
///
@interface DBTeamClient : DBTeamBaseClient

///
/// Convenience constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

///
/// Full constructor.
///
/// @note Access token should be set in `transportClient` directly, rather than
/// passed in to `DBTeamClient` directly.
///
/// @param transportClient The instance of `DBTransportDefaultClient` used to make all
/// networking requests. This constructor offers the highlest-level of configurability.
/// `DBTransportDefaultClient` offers a number of different constructors to customize networking
/// settings.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithTransportClient:(DBTransportDefaultClient * _Nonnull)transportClient;

///
/// Returns a `DBUserClient` instance that can be used to make API calls on behalf of the
/// designated team member.
///
/// @note App must have "TeamMemberFileAccess" permissions to use
/// this method.
///
/// @param memberId The Dropbox `account_id` of the team member to perform actions on
/// behalf of. e.g. "dbid:12345678910..."
///
/// @return An initialized instance.
///
- (DBUserClient * _Nonnull)asMember:(NSString * _Nonnull)memberId;

///
/// Update transport client access token.
///
/// @param accessToken The updated access token with which to make API calls.
///
- (void)updateAccessToken:(NSString * _Nonnull)accessToken;

///
/// Whether the client is authorized.
///
/// @return Whether the current client has a non-nil access token.
///
- (BOOL)isAuthorized;

@end
