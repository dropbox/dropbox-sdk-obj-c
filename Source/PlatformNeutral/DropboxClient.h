#import <Foundation/Foundation.h>
#import "DBXBase.h"

///
/// Dropbox User API Client.
///
/// This is the SDK user's primary interface with the Dropbox API. Routes can be accessed
/// via each "namespace" object in the instance fields of its parent, `DBXBase`.
///
@interface DropboxClient : DBXBase

/// The transport client to use to make all networking requests
@property (nonatomic) DBXTransportClient * _Nonnull transportClient;

///
/// `DropboxClient` convenience constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

///
/// `DropboxClient` convenience constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
/// - parameter memberId: The Dropbox account_id of the team member to perform actions on
/// behalf of. e.g. "dbid:12345678910..."
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken selectUser:(NSString * _Nonnull)selectUser;

///
/// `DropboxClient` full constructor.
///
/// - parameter transportClient: The instance of `DBXTransportClient` to use to make all
/// networking requests. This constructor offers the highlest-level of configurability.
/// `DBXTransportClient` offers a number of different constructors to customize networking
/// settings. Note: access token should be set in `transportClient` directly, rather than
/// passed in to `DropboxClient`.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithTransportClient:(DBXTransportClient * _Nonnull)transportClient;

@end
