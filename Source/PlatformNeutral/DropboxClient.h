///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBBase.h"
#import "DBTransportClient.h"
#import <Foundation/Foundation.h>

///
/// Dropbox User API Client.
///
/// This is the SDK user's primary interface with the Dropbox API. Routes can be accessed
/// via each "namespace" object in the instance fields of its parent, `DBBase`. To see a
/// full list of the User API endpoints available, please visit:
/// https://www.dropbox.com/developers/documentation/http/documentation.
///
@interface DropboxClient : DBBase

/// The transport client to use to make all networking requests
@property(nonatomic) DBTransportClient * _Nonnull transportClient;

///
/// DropboxClient convenience constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

///
/// DropboxClient convenience constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
/// @param memberId The Dropbox account_id of the team member to perform actions on
/// behalf of. e.g. "dbid:12345678910..."
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken selectUser:(NSString * _Nonnull)selectUser;

///
/// DropboxClient full constructor.
///
/// @note Access token should be set in transportClient directly, rather than
/// passed in to DropboxClient directly..
///
/// @param transportClient The instance of DBTransportClient to use to make all
/// networking requests. This constructor offers the highlest-level of configurability.
/// DBTransportClient offers a number of different constructors to customize networking
/// settings.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithTransportClient:(DBTransportClient * _Nonnull)transportClient;

@end
