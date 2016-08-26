#import <Foundation/Foundation.h>
#import "DBXBaseTeam.h"

///
/// Dropbox Business (Team) API Client.
///
/// This is the SDK user's primary interface with the Dropbox Business (Team) API.
/// Routes can be accessed via each "namespace" object in the instance fields of
/// its parent, `DBXBase`.
///
@interface DropboxTeamClient : DBXBaseTeam

/// The transport client to use to make all networking requests
@property (nonatomic) DBXTransportClient * _Nonnull transportClient;

/// The Dropbox OAuth2 access token used to make requests.
@property (nonatomic) NSString * _Nullable accessToken;

///
/// `DropboxTeamClient` convenience constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

///
/// `DropboxTeamClient` full constructor.
///
/// - parameter transportClient: The instance of `DBXTransportClient` to use to make all
/// networking requests. This constructor offers the highlest-level of configurability.
/// `DBXTransportClient` offers a number of different constructors to customize networking
/// settings. Note: access token should be set in `transportClient` directly, rather than
/// passed in to `DropboxTeamClient`.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithTransportClient:(DBXTransportClient * _Nonnull)transportClient;

///
/// Returns a `DropboxClient` instance that can be used to make API calls on behalf of the
/// designated team member. Note: app must have "TeamMemberFileAccess" permissions to use
/// this method.
///
/// - parameter memberId: The Dropbox account_id of the team member to perform actions on
/// behalf of. e.g. "dbid:12345678910..."
///
/// - returns: An initialized instance.
///
- (DropboxClient * _Nonnull)asMember:(NSString * _Nonnull)memberId;

@end
