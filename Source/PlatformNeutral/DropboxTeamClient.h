///
/// The client for the Business API. Call routes using the namespaces inside this object (inherited from parent).
///

#import <Foundation/Foundation.h>
#import "DbxBaseTeam.h"

@class DropboxTransportClient;

@interface DropboxTeamClient : DbxBaseTeam

- (nonnull instancetype)init:(DropboxTransportClient * _Nonnull)dropboxTransportClient;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

- (DropboxClient * _Nonnull)asMember:(NSString * _Nonnull)memberId;

@property (nonatomic) DropboxTransportClient * _Nonnull dropboxTransportClient;
@property (nonatomic) NSString * _Nullable accessToken;

@end
